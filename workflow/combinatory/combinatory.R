## ---------------------------
##
## File name: combinatory.R
##
## Purpose of file: apply analysis en each combination of units for any group from 1 to length(units)
##
## Author: Pedro Del Pozo Jiménez
##
## Date Created: 2019-12-04
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
##   - be careful, 4 units imply 15 analysis:
##    > 4 groups from 1 unit, 6 groups from 2 units, 4 groups from 3 units and 1 gruoups from 4 units
##   - BUT, if we would use 28 units (for example), we would do 268.435.455 analysis
##
## ---------------------------


combinatory <- function(config_data_id, cut_specific_neurons=FALSE,
                        path_output_file="./workflow/combinatory/combinatory_output.csv",
                        n_trials=1){
  #FOR SAVING LOGS, comment and uncomment or modify just when needed
  # sink("./main_combinatory/log_combinatory_dd-mm-yyyy.txt", append=FALSE, split=TRUE)
  # sink() #switch off the log and write on output console as always
  
  
  source("./do_analysis.R")
  source("./loader/loader.R")
  if(loader(data_id=config_data_id)==-1){
    message("Error: data_id not found. Please, check configuration files...")
    return(dt_res)
  }
  
  ##See config_parameters files...
  if(cut_specific_neurons){ 
    neurons_name_pos <- neurons_name_pos_comb
    neurons_involved_pos <- neurons_involved_pos_comb
    neurons_name_neg <- neurons_name_neg_comb
    neurons_involved_neg <- neurons_involved_neg_comb
  }
  dt_res <- data.frame()
  
  
  if(length(neurons_name_pos)>14){
    # Si hay más de 14 neuronas y se solicita hacer una combinatoria, el sistema no lo permite, avisa por ser demasiado largo y continua con el resto
    print("llego aqui dentro")
    warning(">>> More than 14 neurons used in combinatory workflow. \n Process aborted. \n Continuing with the remaining operations. \n")
    return(dt_res)
  }
  
  
  for(j in 1:length(neurons_involved_pos)){
    # for(j in 1:1){ # --> fast tests with low number of analysis (combinations)
  # for(j in starting_index:ending_index){ # --> future versions, calls for specific groups
    cat(paste0(">> combination without repetition of ", length(neurons_involved_pos), " using sets of ", j," neurons\n"))
    cat(paste0(">> in total: ", choose(length(neurons_involved_pos),j), " analysis\n"))
    #column == analysis, each column cointains the group of neurons that will be used in next analysis
    current_comb <- combn(x = neurons_name_pos,m = j)
    resultados_current_comb <- list()
    dt_res_current_comb <- data.frame()
    dt_neurons_set <- data.frame()
    dt_neurons_set_C50 <- data.frame()
    for(i in 1:ncol(current_comb)){
      
      aux_neurons_name_pos <- current_comb[,i]
      aux_neurons_involved_pos <- as.numeric(gsub("U","",aux_neurons_name_pos))
      
      aux_neurons_name_neg <- c(current_comb[,i],aff_className)
      aux_neurons_involved_neg <- c(aux_neurons_involved_pos,neurons_involved_neg[length(neurons_involved_neg)])
      
      cat(">> running the combination: ")
      cat(paste0(aux_neurons_name_pos,collapse = ","))
      cat("\n")
      
      
      if(is.null(
        resultados_current_comb[[i]] <- do_analysis(path_neurons = path_in_neurons,
                                                    path_afferents = path_in_afferents,
                                                    index_afferent = index_in_afferent,
                                                    path_units_pos = path_in_pos,
                                                    names_units_pos = aux_neurons_name_pos,
                                                    index_units_pos = aux_neurons_involved_pos,
                                                    path_units_neg = path_in_neg,
                                                    names_units_neg = aux_neurons_name_neg,
                                                    index_units_neg = aux_neurons_involved_neg,
                                                    afferent_className = aff_className,
                                                    afferent_spikesNumber = aff_spNumber,
                                                    n_trials= n_trials))
      ){
        aux_n_neurons <- length(aux_neurons_name_pos)
        aux_n_neurons_C50 <- NA #just clarifying, not needed for accumulative process
        aux_neuron_set_C50 <- ""
        
        aux_row <- c(aux_n_neurons,rep(NA,8))
      } else {
        #row info for each partial table:
        # - input neurons(added at the end)
        # - neurons witch C5.0 uses (added at the end)
        # - number of input neurons 
        # - number of nuerons witch C5.0 uses
        # - total_recall (recall remains the same for both complete dataset and snap data)
        # - mcc_snap
        # - mcc_complete
        # - f1_snap (not used in paper, but in case you wish to observe that)
        # - f1_complete
        # - precision_snap
        # - precision_complete
        
        
        aux_n_neurons <- length(aux_neurons_name_pos)
        
        ranking_c5Imp <- tryCatch({
          C5imp(resultados_current_comb[[i]]$fitted_model)
        },
        error=function(cond){
          message("no model generated")
          message("may not there be spikes in any unit neuron?")
          message(cond)
          message("\n")
          return(NULL)
          # NULL
        }
        )
        
        if(!is.null(ranking_c5Imp)){
          aux_n_neurons_C50 <- length(ranking_c5Imp[ranking_c5Imp$Overall>0,])
          aux_neuron_set_C50 <- rownames(ranking_c5Imp)[1:length(ranking_c5Imp[ranking_c5Imp$Overall>0,])]
        } else{
          aux_n_neurons_C50 <- 0
          aux_neuron_set_C50 <- c("")
        }
        
        #STRONG DEPENDENCY WITH METRICS MODULE
        # total_recall <- resultados_current_comb[[i]]$dt_metrics[1,6] 
        # total_recall <- round(100*as.numeric(total_recall),3)
        # mcc_snap <- resultados_current_comb[[i]]$dt_metrics[2,8]
        # mcc_snap <- round(100*as.numeric(mcc_snap),3)
        # mcc_complete <- resultados_current_comb[[i]]$dt_metrics[1,8]
        # mcc_complete <- round(100*as.numeric(mcc_complete),3)
        # f1_snap <- resultados_current_comb[[i]]$dt_metrics[2,7]
        # f1_snap <- round(100*as.numeric(f1_snap),3)
        # f1_complete <- resultados_current_comb[[i]]$dt_metrics[1,7]
        # f1_complete <- round(100*as.numeric(f1_complete),3)
        # precision_snap <- resultados_current_comb[[i]]$dt_metrics[2,3]
        # precision_snap <- round(100*as.numeric(precision_snap),3)
        # precision_complete <- resultados_current_comb[[i]]$dt_metrics[1,3]
        # precision_complete <- round(100*as.numeric(precision_complete),3)
        
        #max 1, not 100
        total_recall <- resultados_current_comb[[i]]$dt_metrics[1,6] 
        total_recall <- round(as.numeric(total_recall),3)
        mcc_snap <- resultados_current_comb[[i]]$dt_metrics[2,8]
        mcc_snap <- round(as.numeric(mcc_snap),3)
        mcc_complete <- resultados_current_comb[[i]]$dt_metrics[1,8]
        mcc_complete <- round(as.numeric(mcc_complete),3)
        f1_snap <- resultados_current_comb[[i]]$dt_metrics[2,7]
        f1_snap <- round(as.numeric(f1_snap),3)
        f1_complete <- resultados_current_comb[[i]]$dt_metrics[1,7]
        f1_complete <- round(as.numeric(f1_complete),3)
        precision_snap <- resultados_current_comb[[i]]$dt_metrics[2,3]
        precision_snap <- round(as.numeric(precision_snap),3)
        precision_complete <- resultados_current_comb[[i]]$dt_metrics[1,3]
        precision_complete <- round(as.numeric(precision_complete),3)
        
        aux_row <- c(aux_n_neurons,aux_n_neurons_C50,
                     total_recall,
                     mcc_snap,mcc_complete,
                     f1_snap,f1_complete,
                     precision_snap,precision_complete)
        
        #free memory, in case of you need, specially when you start to stack much data and many models
        resultados_current_comb[[i]]$preprocess_list <- NULL
        resultados_current_comb[[i]]$fitted_model <- NULL
        
      }
      aux_neuron_set <- paste0(aux_neurons_name_pos,collapse = ", ")
      dt_neurons_set <- rbind(dt_neurons_set,as.character(aux_neuron_set),stringsAsFactors = FALSE)
      dt_neurons_set_C50 <- rbind(dt_neurons_set_C50,
                                  paste0(as.character(aux_neuron_set_C50),collapse = ", "),
                                  stringsAsFactors = FALSE)
      dt_res_current_comb <- rbind(dt_res_current_comb,aux_row)
      
    }
    
    dt_res_current_comb <- cbind(dt_neurons_set,dt_neurons_set_C50, dt_res_current_comb)
    
    colnames(dt_res_current_comb) <- c("neurons_set","neurons_set_C50",
                                       "n_neurons","n_neurons_C50",
                                       "total_recall",
                                       "mcc_snap","mcc_complete",
                                       "f1_snap","f1_complete",
                                       "precision_snap","precision_complete")
    
    dt_res <- rbind(dt_res,dt_res_current_comb,stringsAsFactors = FALSE)
    #just for testing, or if you do not want to wait to end the process, partial results
    # write.csv(dt_res,
    #           file = paste0(path_output_file,"_partial_comb_",j,".csv"),
    #           row.names=FALSE, na="", fileEncoding = "UTF-8")
    
  }
  write.csv(dt_res, file = path_output_file,
            row.names=FALSE, na="", fileEncoding = "UTF-8")
  # save.image()
  return(dt_res)
  # write.csv(dt_res, file = "./workflow/combinatory/combinatory_output.csv",
  #           row.names=FALSE, na="", fileEncoding = "UTF-8")
  # save.image()
  
  # sink() #switch off the log and write on output console as always
  
}