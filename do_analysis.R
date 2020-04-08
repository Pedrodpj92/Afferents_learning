## ---------------------------
##
## File name: do_analysis.R
##
## Purpose of file: general analysis, used for example in iterative workflow
##
## Author: Pedro Del Pozo Jiménez
##
## Date Created: 2019-11-21
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
##   this may be moved to a more general directory, cause of may be used in several situations, not just in main_iterative.R
##
## ---------------------------


do_analysis <- function(path_neurons, path_afferents, index_afferent=1,
                        path_units_pos, names_units_pos, index_units_pos,
                        path_units_neg, names_units_neg, index_units_neg,
                        afferent_className, afferent_spikesNumber, 
                        random_seed=123,
                        n_trials=1){
  file.sources = list.files(c("./preprocess",
                              "./model",
                              "./predict",
                              "./evaluate",
                              "./auxiliary_functs"), 
                            pattern="*.R$", full.names=TRUE, 
                            ignore.case=TRUE)
  sapply(file.sources,source,.GlobalEnv)
  source("./auxiliary_functs/list2dt_metrics.R")
  
  analysis <- list()
  cat("###########################\n")
  cat("# Executing preprocess... #\n")
  cat("###########################\n")
  
  list_preprocess <- tryCatch({
    do_preprocess(path_neurons = path_neurons,
                  path_afferents = path_afferents,
                  index_afferent = index_afferent,
                  path_in_pos =  path_units_pos,
                  neurons_name_pos = names_units_pos,
                  neurons_involved_pos = index_units_pos,
                  path_in_neg = path_units_neg,
                  neurons_name_neg = names_units_neg,
                  neurons_involved_neg = index_units_neg,
                  afferent_name = afferent_className,
                  saveData=FALSE,
                  n_spikes_afferent = afferent_spikesNumber,
                  random_seed = random_seed)
    
    
  },
  error=function(cond){
    message("data could not be preprocessed")
    message("may not there be spikes in any unit neuron?")
    message(cond)
    message("\n")
    return(NULL)
  }
  )
  if(is.null(list_preprocess)){
    return(NULL)
  }
  
  analysis[["preprocess_list"]] <- list_preprocess
  
  cat(">> Class distribution per dataset:\n")
  for(i in 1:length(list_preprocess)){
    print(names(list_preprocess)[i])
    print(summary(as.factor(list_preprocess[[i]][,c(ncol(list_preprocess[[i]]))])))
  }
  
  dt_completo <- list_preprocess[[1]]
  dt_snap <- list_preprocess[[2]]
  df_tr <- list_preprocess[[3]]
  df_vl <- list_preprocess[[4]]
  
  checking_bal_data <- check_balance(dt = dt_snap)
  analysis[["balanced_data"]] <- checking_bal_data[[1]]
  analysis[["n_pos"]] <- checking_bal_data[[2]]
  analysis[["n_neg"]] <- checking_bal_data[[3]]
  
  
  cat("##################\n")
  cat("# Training model #\n")
  cat("##################\n")
  fitted_model <- do_model(dt_tr = df_tr,
                           dt_complete_factors = dt_completo,
                           with_cost_mat = TRUE, n_trials = n_trials)
  analysis[["fitted_model"]] <- fitted_model
  cat(">> Summary model:\n")
  print(summary(fitted_model))
  
  list_predictions <- do_predict(fitted_model, list_preprocess)
  analysis[["predictions_list"]] <- list_predictions
  
  
  
  cat("####################################\n")
  cat("# Generating evaluation metrics... #\n")
  cat("####################################\n")
  
  
  list_evaluated <- do_evaluation(list_in = list_predictions,total_n = afferent_spikesNumber) # DEPENDS ON Rx!
  analysis[["evaluation_list"]] <- list_evaluated
  
  dt_metrics <- list2dt_metrics(list_evaluated,TRUE)
  analysis[["dt_metrics"]] <- dt_metrics
  print(dt_metrics[,c("dataset","accuracy","precision","recall","mcc")])
  
  list_all_confMat <- list()
  for(iterator in 1:length(list_evaluated)){
    
    list_all_confMat[[names(list_evaluated)[iterator]]] <- list_evaluated[[iterator]]$confMat
  }
  analysis[["mat_conf_list"]] <- list_all_confMat
  
  
  list_just_cf <- list()
  for(iterator in 1:length(list_all_confMat)){
    element <- list_all_confMat[[iterator]][["confMat"]][["table"]]
    element_dt <- data.frame(element[,1])
    element_dt <- cbind(element_dt,element[,2])
    element_dt <- cbind(c("0","1"),element_dt)
    
    colnames(element_dt) <- c("pred\\orig","0","1")
    rownames(element_dt) <- c("0","1")
    list_just_cf[[names(list_all_confMat)[iterator]]] <- element_dt
    # write.table(element_dt,
    #             file = paste0("./tmpOutput/",
    #                           names(list_all_confMat)[iterator],".csv"),
    #             sep = ";",col.names = TRUE,row.names = FALSE)
  }
  analysis[["mat_conf_list_short"]] <- list_just_cf
  
  return(analysis)
}



