## ---------------------------
##
## File name: individual.R
##
## Purpose of file: 
##
## Author: Pedro Del Pozo Jiménez
##
## Date Created: 2019-11-15
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





individual <- function(config_data_id, random_seed=123){
  
  source("./do_analysis.R")
  source("./loader/loader.R")
  source("./workflow/individual/check_and_add_individuals.R")
  
  resultados <- list()
  col_neuron <- c()
  dt_res <- data.frame()
  
  # source(config_path_file)
  if(loader(data_id=config_data_id)==-1){
    message("Error: data_id not found. Please, check configuration files...")
    return(dt_res)
  }
  
  # model_list <<- list()
  
  # error_analysis_counter <- 0
  
  for(i in 1:length(neurons_involved_pos)){
  # for(i in neurons_involved_pos){
  # for(i in 1:5){
    
    indv_neurons_name_pos <- neurons_name_pos[i]
    indv_neurons_involved_pos <- neurons_involved_pos[i]
    
    indv_neurons_name_neg <- c(neurons_name_neg[i],
                               neurons_name_neg[length(neurons_name_neg)])
    indv_neurons_involved_neg <- c(neurons_involved_neg[i],
                                   neurons_involved_neg[length(neurons_involved_neg)])
    
    
    cat("###############################################################################\n")
    cat("Let's calculate individual analysis for neuron: ")
    cat(indv_neurons_name_pos)
    cat("\n at position: ")
    cat(indv_neurons_involved_pos)
    cat("\n###############################################################################\n")
    cat("about negatives... \n")
    cat(indv_neurons_name_neg)
    cat("\n at position: ")
    cat(indv_neurons_involved_neg)
    cat("\n###############################################################################\n")

    
    
    
    resultados[[i]] <-  do_analysis(path_neurons = path_in_neurons,
                                    path_afferents = path_in_afferents,
                                    index_afferent = index_in_afferent,
                                    path_units_pos = path_in_pos,
                                    names_units_pos = indv_neurons_name_pos,
                                    index_units_pos = indv_neurons_involved_pos,
                                    path_units_neg = path_in_neg,
                                    names_units_neg = indv_neurons_name_neg,
                                    index_units_neg = indv_neurons_involved_neg,
                                    afferent_className = aff_className,
                                    afferent_spikesNumber = aff_spNumber,
                                    random_seed = random_seed)
    
    col_neuron <- c(col_neuron,indv_neurons_name_pos)
    
    # model_list[[paste0(indv_neurons_name_pos,collapse = ", ")]] <<- resultados[[i]][["fitted_model"]]
    
    aux_dataRow <- tryCatch({
      c(as.numeric(resultados[[i]]$dt_metrics[1,3]),
        as.numeric(resultados[[i]]$dt_metrics[1,4]),
        as.numeric(resultados[[i]]$dt_metrics[1,8]))
      
      
    },
    error=function(cond){
      message("dt_metrics not accesible")
      message("model not fitted or data cannot be prepared")
      message(cond)
      message("\n")
      aux_dataRow <- c(0.0,
                       0.0,
                       0.0)
    }
    )
    
    
    
    
    # if(length(resultados)==i){
    #   aux_dataRow <- c(as.numeric(resultados[[i]]$dt_metrics[1,3]),
    #                    as.numeric(resultados[[i]]$dt_metrics[1,4]),
    #                    as.numeric(resultados[[i]]$dt_metrics[1,8]))
    #   
    # } else{
    #   error_analysis_counter <- error_analysis_counter+1
    #   aux_dataRow <- c(0.0,
    #                    0.0,
    #                    0.0)
    # }
    dt_res <- rbind(dt_res,aux_dataRow)
  }
  
  dt_res <- cbind(col_neuron,dt_res)
  colnames(dt_res) <- c("Name","Precision","Recall","MCC")
  
  dt_res <- dt_res[order(-dt_res$MCC),]
  
  
  check_and_add_individuals(config_data_id,
                            "./config_parameters/metrics_per_neuron.csv",
                            dt_res)
  
  
  return(dt_res)
}