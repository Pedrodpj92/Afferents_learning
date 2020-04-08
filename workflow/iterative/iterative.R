## ---------------------------
##
## File name: iterative.R
##
## Purpose of file: to do several analysis, removing a "worse" neuron in each one following a input ranking
##
## Author: Pedro Del Pozo Jiménez
##
## Date Created: 2019-11-29
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


iterative <- function(config_data_id,id_exp=NULL, random_seed=123){
  
  source("./do_analysis.R")
  source("./loader/loader.R")
  source("./workflow/individual/found_individuals.R")
  
  dt_res <- data.frame()
  
  ##seting initial parameters
  # source(config_data_id)
  if(loader(data_id=config_data_id)==-1){
    message("Error: data_id not found. Please, check configuration files...")
    return(dt_res)
  }
  
  if(!found_individuals("./config_parameters/metrics_per_neuron.csv", config_data_id)){
    message("Error: data_id not found in metrics per neuron file. Please, check and run individual analysis first")
    return(dt_res)
  }
  
  
  if(!is.null(id_exp)){
    id_experiment <- id_exp
  } else {
    id_experiment <- config_data_id
  }
  
  #loading master ranking file...
  master_rank_file <- read.csv(file = "./config_parameters/metrics_per_neuron.csv",stringsAsFactors = FALSE)
  
  
  criteria <- "MCC"
  
  dt_neurons_ranking <<- master_rank_file[master_rank_file$data_id==id_experiment,]
  dt_neurons_ranking <<- dt_neurons_ranking[order(-dt_neurons_ranking[,criteria]),]
  dt_neurons_ranking <<- dt_neurons_ranking[dt_neurons_ranking$MCC>0,]
  
  dt_name_index <<- data.frame(name = neurons_name_pos, index = neurons_involved_pos)
  neurons_ranking <<- dt_name_index[match(dt_neurons_ranking$Name, dt_name_index$name),2]
  neurons_ranking_name <<- as.character(dt_name_index[match(dt_neurons_ranking$Name, dt_name_index$name),1])
  
  # neurons_ranking <- as.character(dt_neurons_ranking$Name) #IMPORTANTE CAMBIAR
  # neurons_ranking <- gsub("U","",neurons_ranking)
  # neurons_ranking <- as.numeric(neurons_ranking)
  #con esto ya tenemos lo mismo que en neurons_ranking, el "2" era para comparar, quitar después
  #removing_preliminar_units se calcularán como todas aquellas neuronas que no estén en neurons_ranking
  #pero sí en neurons_involved_pos,
  #lo otro es igual que en el source, poner antes de este código
  
  
  # removing_preliminar_units2 <- c()
  removing_preliminar_units2 <- neurons_involved_pos[!(neurons_involved_pos %in% neurons_ranking)]
  # 
  neurons_involved_pos <- neurons_involved_pos[!(neurons_involved_pos %in% removing_preliminar_units2)]
  neurons_involved_neg <- neurons_involved_neg[!(neurons_involved_neg %in% removing_preliminar_units2)]
  # 
  # #old version with high dependencies on index and names, bugs in subsets...
  # aux_neurons_name_pos <- neurons_name_pos[neurons_involved_pos]
  # aux_neurons_name_neg <- neurons_name_neg[neurons_involved_neg]
  # aux_neurons_name_pos <- neurons_name_pos
  # aux_neurons_name_neg <- neurons_name_neg
  removing_preliminar_units2_names <- neurons_name_pos[!(neurons_name_pos %in% neurons_ranking_name)]
  aux_neurons_name_pos <- neurons_name_pos[!(neurons_name_pos %in% removing_preliminar_units2_names)]
  aux_neurons_name_neg <- neurons_name_neg[!(neurons_name_neg %in% removing_preliminar_units2_names)]
  
  resultados <- list()
  
  # print(dt_neurons_ranking[dt_neurons_ranking$MCC<=0,])
  # print("mayor")
  # print(dt_neurons_ranking[dt_neurons_ranking$MCC>0,])
  removing_preliminar_units <- master_rank_file[master_rank_file$MCC<=0.0
                                                & master_rank_file$data_id==id_experiment,]
  # removing_preliminar_units <- c(removing_preliminar_units,removing_preliminar_units2)
  # removing_preliminar_units <- unique(removing_preliminar_units)
  # print(removing_preliminar_units)
  if(nrow(removing_preliminar_units)>0){
    # print(paste0("deleting neurons: "))
    # print(removing_preliminar_units)
    # current_neuron_remove <- paste0(neurons_name_pos[!(neurons_name_pos %in% removing_preliminar_units$Name)],collapse = ", ")
    current_neuron_remove_name <- paste0(neurons_name_pos[neurons_name_pos %in% removing_preliminar_units$Name],collapse = ", ")
    first_remove <- current_neuron_remove_name
    print("first remove: ")
    print(first_remove)
  } else{
    current_neuron_remove_name <- ""
    first_remove <- ""
  }
  
  
  
  
  for(i in length(neurons_ranking):1){
    
    print("////////////////////////////////////")
    print(paste0("/ Running analysis with ",i," neurons ","/"))
    print("////////////////////////////////////")
    
    print_pos_neu <- paste0(aux_neurons_name_pos,collapse = ", ")
    print(paste0("Let's use the following neurons: ",print_pos_neu))
    print(paste0(neurons_involved_pos, collapse = ", "))
    print("negative...")
    print_neg_neu <- paste0(aux_neurons_name_neg,collapse = ", ")
    print(paste0("Let's use the following neurons: ",print_neg_neu))
    print(paste0(neurons_involved_neg, collapse = ", "))
    
    
    
    resultados[[i]] <- do_analysis(path_neurons = path_in_neurons,
                                   path_afferents = path_in_afferents,
                                   index_afferent = index_in_afferent,
                                   path_units_pos = path_in_pos,
                                   names_units_pos = aux_neurons_name_pos,
                                   index_units_pos = neurons_involved_pos,
                                   path_units_neg = path_in_neg,
                                   names_units_neg = aux_neurons_name_neg,
                                   index_units_neg = neurons_involved_neg,
                                   afferent_className = aff_className,
                                   afferent_spikesNumber = aff_spNumber,
                                   random_seed = random_seed)
    
    # resultados[[i]]$removed_neuron <- neurons_name_pos[current_neuron_remove]
    resultados[[i]]$removed_neuron <- current_neuron_remove_name
    resultados[[i]]$remain_neuron <- print_pos_neu
    
    resultados[[i]]$rank_VI <- C5imp(resultados[[i]]$fitted_model)
    
    # list_rank_VI[[j]] <- root$analysis$dt_C50_imp
    
    current_neuron_remove <- neurons_ranking[i]
    current_neuron_remove_name <- neurons_ranking_name[i]
    
    # if(neurons_ranking[i]>9){
    #   print(paste0(">> Removing the neuron U",neurons_ranking[i]))
    # } else { #just stetic purposes
    #   print(paste0(">> Removing the neuron U0",neurons_ranking[i]))
    # }
    
    print(paste0(">> Removing the neuron ",current_neuron_remove_name))
    
    neurons_involved_pos <- neurons_involved_pos[!(neurons_involved_pos %in% current_neuron_remove)]
    neurons_involved_neg <- neurons_involved_neg[!(neurons_involved_neg %in% current_neuron_remove)]
    # aux_neurons_name_pos <- neurons_name_pos[neurons_involved_pos]
    # aux_neurons_name_neg <- neurons_name_neg[neurons_involved_neg]
    aux_neurons_name_pos <- aux_neurons_name_pos[!(aux_neurons_name_pos %in% current_neuron_remove_name)]
    aux_neurons_name_neg <- aux_neurons_name_neg[!(aux_neurons_name_neg %in% current_neuron_remove_name)]
    
  }
  
  
  get_all_recall2 <- c()
  get_all_presSnap <- c()
  get_all_f1Snap <- c()
  get_all_presComp <- c()
  get_all_f1Comp <- c()
  get_all_mccSnap <- c()
  get_all_mccCompleto <- c()
  #removed_neuron
  # get_neuron_removed_names <- c("nothing")
  get_neuron_removed_names <- c()
  get_neuron_remain_names <- c()
  
  get_neuron_rank_VI <- c()
  
  for(i in length(resultados):1){
    #total recall
    aux_recall2 <- resultados[[i]]$dt_metrics[[2,"recall2"]]
    get_all_recall2 <- c(get_all_recall2,aux_recall2)
    
    #precision snap
    aux_presSnap <- resultados[[i]]$dt_metrics[[2,"precision"]]
    get_all_presSnap <- c(get_all_presSnap,aux_presSnap)
    
    #f1 snap
    aux_f1Snap <- resultados[[i]]$dt_metrics[[2,"f1score2"]]
    get_all_f1Snap <- c(get_all_f1Snap,aux_f1Snap)
    
    #precision complete
    aux_presComp <- resultados[[i]]$dt_metrics[[1,"precision"]]
    get_all_presComp <- c(get_all_presComp,aux_presComp)
    
    #f1 complete
    aux_f1Comp <- resultados[[i]]$dt_metrics[[1,"f1score2"]]
    get_all_f1Comp <- c(get_all_f1Comp,aux_f1Comp)
    
    #mcc snap
    aux_mccSnap <- resultados[[i]]$dt_metrics[[2,"mcc"]]
    get_all_mccSnap <- c(get_all_mccSnap,aux_mccSnap)
    
    #mcc_completo
    aux_mccCompleto <- resultados[[i]]$dt_metrics[[1,"mcc"]]
    get_all_mccCompleto <- c(get_all_mccCompleto,aux_mccCompleto)
    
    aux_neuron_removed_names <- resultados[[i]]$removed_neuron
    get_neuron_removed_names <- c(get_neuron_removed_names,aux_neuron_removed_names)
    
    aux_neuron_remain_names <- resultados[[i]]$remain_neuron
    get_neuron_remain_names <- c(get_neuron_remain_names,aux_neuron_remain_names)
    
    aux_neuron_rank_VI <- resultados[[i]]$rank_VI
    get_neuron_rank_VI <- c(get_neuron_rank_VI, paste0(rownames(aux_neuron_rank_VI)[1:length(aux_neuron_rank_VI[aux_neuron_rank_VI$Overall>0,])],
                                                       collapse = ", "))
  }
  
  cantidad_neuronas <- length(neurons_ranking):1
  
  
  get_all_recall2 <- as.numeric(get_all_recall2)
  # get_all_recall2 <- round(x = get_all_recall2*100,digits = 2)
  # get_all_recall2 <- round(x = get_all_recall2,digits = 2)
  
  get_all_presSnap <- as.numeric(get_all_presSnap)
  # get_all_presSnap <- round(x = get_all_presSnap*100,digits = 2)
  # get_all_presSnap <- round(x = get_all_presSnap,digits = 2)
  
  get_all_f1Snap <- as.numeric(get_all_f1Snap)
  # get_all_f1Snap <- round(x = get_all_f1Snap*100,digits = 2)
  # get_all_f1Snap <- round(x = get_all_f1Snap,digits = 2)
  
  get_all_presComp <- as.numeric(get_all_presComp)
  # get_all_presComp <- round(x = get_all_presComp*100,digits = 2)
  # get_all_presComp <- round(x = get_all_presComp,digits = 2)
  
  get_all_f1Comp <- as.numeric(get_all_f1Comp)
  # get_all_f1Comp <- round(x = get_all_f1Comp*100,digits = 2)
  # get_all_f1Comp <- round(x = get_all_f1Comp,digits = 2)
  
  get_all_mccSnap <- as.numeric(get_all_mccSnap)
  # get_all_mccSnap <- round(x = get_all_mccSnap*100,digits = 2)
  # get_all_mccSnap <- round(x = get_all_mccSnap,digits = 2)
  
  get_all_mccCompleto <- as.numeric(get_all_mccCompleto)
  # get_all_mccCompleto <- round(x = get_all_mccCompleto*100,digits = 2)
  # get_all_mccCompleto <- round(x = get_all_mccCompleto,digits = 2)
  
  
  get_neuron_removed_names <- as.character(get_neuron_removed_names)
  get_neuron_remain_names <- as.character(get_neuron_remain_names)
  
  
  
  # library(plotly)
  # plot_data <- data.frame(cantidad_neuronas,
  #                               get_neuron_removed_names,get_neuron_remain_names,
  #                               get_neuron_rank_VI,
  #                               get_all_recall2,
  #                               get_all_presSnap,get_all_f1Snap,
  #                               get_all_presComp,get_all_f1Comp,
  #                               get_all_mccSnap, get_all_mccCompleto,
  #                               stringsAsFactors = FALSE)
  # p <- plot_ly(plot_data, x = ~cantidad_neuronas, 
  #              # y = ~get_all_recall2,
  #              # y = ~total_recall,
  #              # y = ~`precision completa`,
  #              # y = ~`mcc reducida`,
  #              y = ~`mcc completa`,
  #              text = ~paste0("removed unit: ",get_neuron_removed_names),
  #              # size = ~get_all_f1Snap,
  #              type = 'scatter', mode = 'lines+markers') %>%
  #   layout(yaxis = list(range = c(0, 90)))
  # p
  
  # write.table(plot_data, "clipboard", sep="\t", row.names=FALSE)
  
  
  
  
  resultados_data <- data.frame(cantidad_neuronas,
                                get_neuron_removed_names,get_neuron_remain_names,
                                get_neuron_rank_VI,
                                get_all_presComp,
                                get_all_recall2,
                                get_all_mccCompleto,
                                stringsAsFactors = FALSE)
  
  resultados_data[1,2] <- first_remove
  # plot_data[2,2] <- paste0(neurons_name_pos[c(4,7,9,10,19,24,26)],collapse = ", ")
  
  
  
  # colnames(resultados_data) <- c("Cantidad neuronas","Eliminadas","Remanentes",
  #                                "ranking_VI",
  #                                "total_recall",
  #                                "precision reducida","f1 reducida",
  #                                "precision completa","f1 completa",
  #                                "mcc reducida", "mcc completa")
  
  # colnames(resultados_data) <- c("Cantidad neuronas","Eliminadas","Remanentes",
  #                                "ranking_VI",
  #                                "precision",
  #                                "recall",
  #                                "mcc")
  colnames(resultados_data) <- c("n_neurons",
                                 "removed",
                                 "remaining",
                                 "ranking_VI",
                                 "precision",
                                 "recall",
                                 "mcc")
  
  
  return(resultados_data)
}


