## ---------------------------
##
## File name: randomSeeds.R
##
## Purpose of file: run the same analysis with different seeds in order to compare
##                how thanos' snap (random undersampling) and data partitioning affects the results
##
## Author: Pedro Del Pozo Jiménez
##
## Date Created: 2020-01-14
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


randomSeeds <- function(config_data_id, vec_random_seed=123){
  
  
  library(data.tree)
  library(stringr)
  #this works with do_analysis_tree_func instead of do_analysis for exploring
  #the advantages of use data.tree structures and how it may ease some implementation parts
  source("./workflow/recursive/do_analysis_tree_func.R")
  source("./loader/loader.R")
  
  list_seed <- list()
  root_list <- list()
  aux_dt_explorer <- list()
  aux_dt_collector <- list()
  list_rank_VI <- list()
  list_cf_short <- list()
  
  resultados_list <- list()
  
  
  if(loader(data_id=config_data_id)==-1){
    message("Error: data_id not found. Please, check configuration files...")
    return(resultados_list)
  }
  
  
  for(j in 1:length(vec_random_seed)){
    
    saved_root <- Clone(root)
    
    random_seed <- vec_random_seed[j]
    
    cat(paste0("using seed ", random_seed,"\n"))
    cat("_______________________________\n")
    cat("running main_tree_neurons.R ...\n")
    cat("_______________________________\n")
    cat("------------------------------\n")
    cat(paste0("Data input at: ",saved_root$analysis[["path_units_pos"]],"\n"))
    cat(paste0("and ",saved_root$analysis[["path_units_neg"]],"\n"))
    cat(paste0("Afferent used: ",saved_root$analysis[["afferent_className"]],"\n"))
    cat(paste0("Number of afferent spikes: ",saved_root$analysis[["afferent_spikesNumber"]],"\n"))
    cat("------------------------------\n")
    
    return_value <- do_analysis_tree_func(tree_node = saved_root,random_seed = random_seed,do_recursive=FALSE,
                                          n_trials=n_trials)
    
    
    aux_dt_explorer[[j]] <- ToDataFrameTree(saved_root,"n_neurons","n_neurons_C5.0", 
                                            "total_recall","precision_snap", "F1w_total_recall",
                                            "precision_completo","f1_completo", "list_neurons_C5.0")
    
    
    aux_dt_collector[[j]] <- saved_root$analysis$dt_metrics[,c("precision","recall","mcc")]
    aux_dt_collector[[j]]$precision <- as.numeric(aux_dt_collector[[j]]$precision)
    aux_dt_collector[[j]]$recall <- as.numeric(aux_dt_collector[[j]]$recall)
    aux_dt_collector[[j]]$mcc <- as.numeric(aux_dt_collector[[j]]$mcc)
    
    aux_dt_collector[[j]][is.na(aux_dt_collector[[j]])] <- 0.0
    
    list_rank_VI[[j]] <- saved_root$analysis$dt_C50_imp
    list_cf_short[[j]] <- saved_root$analysis$mat_conf_list_short
    
    
    just_leaves <- Traverse(saved_root, filterFun = isLeaf)
    
    #just test exploration, ignore it
    # aux_dt_collector <- ToDataFrameTree(just_leaves,"n_neurons","n_neurons_C5.0", 
    #                               "total_recall","precision_snap", "F1w_total_recall",
    #                               "precision_completo","f1_completo", "list_neurons_C5.0")
    
    dt_leaves <- data.frame()
    col_names <- c()
    for(i in 1:length(just_leaves)){
      aux_element <- just_leaves[[i]]
      aux_neu_name <- aux_element$list_neurons_C5.0
      aux_row <- c(aux_element$total_recall,
                   aux_element$precision_snap,
                   aux_element$F1w_total_recall,
                   aux_element$precision_completo,
                   aux_element$f1_completo,
                   aux_element$mcc_snap,
                   aux_element$mcc_completo)
      
      col_names <- c(col_names,aux_neu_name)
      dt_leaves <- rbind(dt_leaves,aux_row)
    }
    
    dt_leaves <- cbind(col_names,dt_leaves)
    colnames(dt_leaves) <- c("neu_name","total_recall",
                             "precision_snap","f1_snap",
                             "precision_completo","f1_completo",
                             "mcc_snap","mcc_completo")
    
    dt_leaves <- na.omit(dt_leaves)
    
    
    all_neurons <- as.data.frame(saved_root$analysis[["names_units_pos"]])
    colnames(all_neurons) <- c("neu_name")
    
    dt_all_neurons <-data.frame()
    dt_all_neurons <- merge(x = all_neurons,y = dt_leaves,by="neu_name",all.x = TRUE)
    
    #adding all neurons info
    # aux_element <- saved_root
    # aux_neu_name <- c("all")
    aux_root_row <- data.frame(t(c(saved_root$total_recall,
                                   saved_root$precision_snap,
                                   saved_root$F1w_total_recall,
                                   saved_root$precision_completo,
                                   saved_root$f1_completo,
                                   saved_root$mcc_snap,
                                   saved_root$mcc_completo)))
    aux_root_row <- cbind("all",aux_root_row)
    colnames(aux_root_row) <- colnames(dt_all_neurons)
    
    dt_all_neurons <- rbind(aux_root_row,dt_all_neurons)
    dt_all_neurons$neu_name <- as.character(dt_all_neurons$neu_name)
    
    
    list_seed[[j]] <- dt_all_neurons
    root_list[[j]] <- Clone(saved_root)
    
    
  }
  
  #later will use all_neurons
  dt_recall <- data.frame(dt_all_neurons[,1])
  colnames(dt_recall) <- c("neu_name")
  dt_precision_snap <- data.frame(dt_all_neurons[,1])
  colnames(dt_precision_snap) <- c("neu_name")
  dt_f1_snap <- data.frame(dt_all_neurons[,1])
  colnames(dt_f1_snap) <- c("neu_name")
  dt_precision_completo <- data.frame(dt_all_neurons[,1])
  colnames(dt_precision_completo) <- c("neu_name")
  dt_f1_completo <- data.frame(dt_all_neurons[,1])
  colnames(dt_f1_completo) <- c("neu_name")
  
  dt_mcc_snap <- data.frame(dt_all_neurons[,1])
  colnames(dt_mcc_snap) <- c("neu_name")
  dt_mcc_completo <- data.frame(dt_all_neurons[,1])
  colnames(dt_mcc_completo) <- c("neu_name")
  
  for(i in 1:length(list_seed)){
    dt_aux <- list_seed[[i]]
    
    #watch out the indexes
    dt_recall <- cbind(dt_recall,dt_aux[,2])
    dt_precision_snap <- cbind(dt_precision_snap,dt_aux[,3])
    dt_f1_snap <- cbind(dt_f1_snap,dt_aux[,4])
    dt_precision_completo <- cbind(dt_precision_completo,dt_aux[,5])
    dt_f1_completo <- cbind(dt_f1_completo,dt_aux[,6])
    
    dt_mcc_snap <- cbind(dt_mcc_snap,dt_aux[,7])
    dt_mcc_completo <- cbind(dt_mcc_completo,dt_aux[,8])
  }
  # dt_recall <- cbind(all_neurons,dt_recall)
  # dt_precision_snap <- cbind(all_neurons,dt_precision_snap)
  # dt_f1_snap <- cbind(all_neurons,dt_f1_snap)
  # dt_precision_completo <- cbind(all_neurons,dt_precision_completo)
  # dt_f1_completo <- cbind(all_neurons,dt_f1_completo)
  
  colnames(dt_recall) <- c("neurons",as.character(vec_random_seed))
  colnames(dt_precision_snap) <- c("neurons",as.character(vec_random_seed))
  colnames(dt_f1_snap) <- c("neurons",as.character(vec_random_seed))
  colnames(dt_precision_completo) <- c("neurons",as.character(vec_random_seed))
  colnames(dt_f1_completo) <- c("neurons",as.character(vec_random_seed))
  
  colnames(dt_mcc_snap) <- c("neurons",as.character(vec_random_seed))
  colnames(dt_mcc_completo) <- c("neurons",as.character(vec_random_seed))
  
  
  round_df <- function(x, digits) {
    # round all numeric variables
    # x: data frame 
    # digits: number of digits to round
    numeric_columns <- sapply(x, mode) == 'numeric'
    x[numeric_columns] <-  round(x[numeric_columns], digits)
    x
  }
  # round_df(data, 3)
  
  dt_tmp <- dt_mcc_completo
  
  # dt_tmp[,2:ncol(dt_tmp)] <- 100*dt_tmp[,2:ncol(dt_tmp)]
  # dt_tmp[,2:ncol(dt_tmp)] <- round_df(dt_tmp[,2:ncol(dt_tmp)],3)
  
  
  #auxiliary functions...... may be should be moved to auxiliary_func in future versions?
  calculate_mean_matrix <- function(list_DT){
    large.list <- list_DT
    vec <- unlist(large.list, use.names = FALSE)
    DIM <- dim(large.list[[1]])
    n <- length(large.list)
    
    list.mean <- tapply(vec, rep(1:prod(DIM),times = n), mean)
    attr(list.mean, "dim") <- DIM
    list.mean <- as.data.frame(list.mean)
    
    return(list.mean)
  }
  
  calculate_sd_matrix <- function(list_DT){
    large.list <- list_DT
    vec <- unlist(large.list, use.names = FALSE)
    DIM <- dim(large.list[[1]])
    n <- length(large.list)
    
    list.sd <- tapply(vec, rep(1:prod(DIM),times = n), sd)
    attr(list.sd, "dim") <- DIM
    list.sd <- as.data.frame(list.sd)
    
    return(list.sd)
  }
  
  calculate_sem_matrix <- function(list_DT){
    large.list <- list_DT
    vec <- unlist(large.list, use.names = FALSE)
    DIM <- dim(large.list[[1]])
    n <- length(large.list)
    
    list.sem <- tapply(vec, rep(1:prod(DIM),times = n), function(x){sd(x)/sqrt(length(x))})
    attr(list.sem, "dim") <- DIM
    list.sem <- as.data.frame(list.sem)
    
    return(list.sem)
  }
  
  vec_names <- saved_root$analysis$dt_metrics$dataset
  
  mean_resultados <- calculate_mean_matrix(aux_dt_collector)
  mean_resultados <- cbind(vec_names,mean_resultados)
  colnames(mean_resultados) <- c("subset","Precision","Recall","MCC")
  
  sd_resultados <- calculate_sd_matrix(aux_dt_collector)
  sd_resultados <- cbind(vec_names,sd_resultados)
  colnames(sd_resultados) <- c("subset","Precision","Recall","MCC")
  
  sem_resultados <- calculate_sem_matrix(aux_dt_collector)
  sem_resultados <- cbind(vec_names,sem_resultados)
  colnames(sem_resultados) <- c("subset","Precision","Recall","MCC")
  
  
  # mean_resultados[is.na(mean_resultados)] <- 0.0
  # sd_resultados[is.na(sd_resultados)] <- 0.0
  # sem_resultados[is.na(sem_resultados)] <- 0.0
  
  
  resultados_list[["mean"]] <- mean_resultados
  resultados_list[["sd"]] <- sd_resultados
  resultados_list[["sem"]] <- sem_resultados
  
  resultados_list[["seeds"]] <- aux_dt_collector
  resultados_list[["rank_VI"]] <- list_rank_VI
  resultados_list[["confusion_matrix"]] <- list_cf_short
  
  return(resultados_list)
  
}


