## ---------------------------
##
## File name: do_preprocess.R
##
## Purpose of file: carry on workflow from read input (spike times in csv) and generate
##      proper files to feed models.
##
## Author: Pedro Del Pozo Jiménez
##
## Date Created: 2019-11-19
##
## Email: pedrodpj92@gmail.com
##
## This file is part of Afferents_learning.
## 
## Afferents_learning is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## Afferents_learning is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.
##
## ---------------------------
##
## Notes:
##
##
## ---------------------------




do_preprocess <- function(path_neurons, path_afferents, index_afferent=1,
                          path_in_pos, neurons_name_pos, neurons_involved_pos,
                          path_in_neg, neurons_name_neg, neurons_involved_neg,
                          path_out=NULL, path_out_snap=NULL, 
                          path_out_tr=NULL, path_out_vl=NULL,
                          afferent_name="R1",
                          saveData=TRUE,
                          n_spikes_afferent=NULL,
                          random_seed=123){
  file.sources = list.files(c("./preprocess/functs"), 
                            pattern="*.R$", full.names=TRUE, 
                            ignore.case=TRUE,recursive = TRUE)
  sapply(file.sources,source,.GlobalEnv) 
  
  #deprecated funcionality currently. In next versions, a module with saving data as main task will be implemented
  if(is.null(path_out) |is.null(path_out_snap) |
     is.null(path_out_tr) |is.null(path_out_vl)){
    saveData <- FALSE
  }
  
  
  
  if(!(file.exists(path_in_pos) & file.exists(path_in_neg))){ #only compute excel files first time
    cat(paste0(">> Excel files not found, executing correlations...","\n"))
    t2e_res <- times2Excel(path_neurons = path_neurons,
                           path_afferents = path_afferents,
                           index_choosen_afferent = index_afferent,
                           output_pos = path_in_pos,
                           output_neg = path_in_neg)
    max_duration <- t2e_res$time_max
    write.csv(max_duration,paste0(path_neurons,"_maxDuration.csv")) #saving experiment's max duration
  } else{
    cat(paste0(">> Excel files found, skipping correlations...","\n"))
    max_duration <- read.csv(paste0(path_neurons,"_maxDuration.csv"))
    max_duration <- round(max_duration[1,2],5)
  }
  
  
  neurons_list_pos <- excel2list(path_in = path_in_pos,
                                 neurons_name = neurons_name_pos,
                                 neurons_involved = neurons_involved_pos)
  
  dt_out_pos <- serial_preprocess_workflow_1(neurons_list_pos,
                                             is_Positive = TRUE,
                                             afferent_name = afferent_name)
  neurons_list_neg <- excel2list(path_in = path_in_neg,
                                 neurons_name = neurons_name_neg,
                                 neurons_involved = neurons_involved_neg)
  
  dt_out_neg <- serial_preprocess_workflow_1(neurons_list_neg,
                                             is_Positive = FALSE,
                                             afferent_name = afferent_name)
  if(!is.null(n_spikes_afferent)){
    starting_id <- max(unlist(as.numeric(as.character(dt_out_pos[,1])),
                              as.numeric(as.character(dt_out_neg[,1]))))
    
    #empty positive intervals = number of spikes in afferent - number of positive intervals with neural activity
    empty_pos <- 0
    if((n_spikes_afferent-nrow(dt_out_pos))>0){
      empty_pos <- generate_emptyRows(n_rows=(n_spikes_afferent-nrow(dt_out_pos)),
                                      m_columns=(ncol(dt_out_pos)-2),
                                      class_content=1,
                                      start_id=(as.numeric(as.character(starting_id))+1))
      colnames(empty_pos) <- colnames(dt_out_pos)
    }
    else{
      empty_pos <- data.frame()
    }
    #empty negative intervals = experiment duration - number of both negative and positive intervals with activity and empty positive intervals
    amount_empty_neg <- calculate_emptyRows(exp_duration=max_duration, 
                                            n_rows=nrow(dt_out_neg)+nrow(dt_out_pos)+nrow(empty_pos))
    empty_neg <- 0
    if(is.numeric(amount_empty_neg)){
      if(amount_empty_neg>0){
        if(nrow(empty_pos)>0){
          next_id <- as.numeric(as.character(empty_pos[nrow(empty_pos),1]))
        }else{
          next_id <- 0
        }
        
        empty_neg <- generate_emptyRows(n_rows=amount_empty_neg,
                                        m_columns=(ncol(dt_out_neg)-2),
                                        class_content=0,
                                        start_id=(next_id+1))
        colnames(empty_neg) <- colnames(dt_out_neg)
      }
    }
    else{
      amount_empty_neg <- 0.0
      empty_neg <- data.frame()
    }
    
    cat("\n>> adding empty cases:\n")
    cat(paste0("  - positive cases: ", nrow(empty_pos),". Previously, ", nrow(dt_out_pos),"\n"))
    cat(paste0("  - negative cases: ", nrow(empty_neg),". Previously, ", nrow(dt_out_neg),"\n","\n"))
    
    if((n_spikes_afferent-nrow(dt_out_pos))){
      dt_out_pos <- rbind(dt_out_pos,empty_pos)
    }
    if(amount_empty_neg>0){
      dt_out_neg <- rbind(dt_out_neg, empty_neg)
    }
    cat(paste0("  - Now: ",nrow(dt_out_neg)+nrow(dt_out_pos),
               ". Negative cases: ", nrow(dt_out_neg),". Positive cases, ", nrow(dt_out_pos),"\n","\n"))
    
  }
  dt_complete <- rbind(dt_out_pos,dt_out_neg)
  
  
  #balancing data, randomly undersampling negative, by default 1:4 proportion positive vs negative
  if(nrow(dt_out_neg)>(nrow(dt_out_pos)*4)){
    df_snap <- thanos_snap(dt_pos = dt_out_pos, dt_neg = dt_out_neg,
                           amount_Pos = nrow(dt_out_pos),
                           amount_Neg = nrow(dt_out_pos)*4,
                           random_seed = random_seed)
  } else{
    df_snap <- dt_complete
  }
  
  #spliting data, by default, 80% training, 20% validating
  list_split <- split(dt_in = df_snap,
                      p_training = 0.8,
                      index_colClass = ncol(df_snap),
                      random_seed = random_seed)
  df_tr <- list_split[[1]]
  df_vl <- list_split[[2]]
  
  list_out <- list(dt_complete, df_snap, df_tr, df_vl)
  names(list_out) <- c("complete","snap","tr","vl")
  
  
  #saving data, not used in current versions, for future, this will be refactored into
  #its own module which task will be to save data, not just for preprocessing
  if(saveData){
    write.csv(dt_complete, file = path_out,
              row.names=FALSE, na="", fileEncoding = "UTF-8")
    write.csv(df_snap, file = path_out_snap,
              row.names=FALSE, na="", fileEncoding = "UTF-8")
    write.csv(df_tr, file = path_out_tr,
              row.names=FALSE, na="", fileEncoding = "UTF-8")
    write.csv(df_vl, file = path_out_vl,
              row.names=FALSE, na="", fileEncoding = "UTF-8")
  }
  return(list_out)
}




