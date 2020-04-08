## ---------------------------
##
## File name: config_loader.R
##
## Purpose of file: load initial parameters from configuration tables for run the desired analysis
##
## Author: Pedro Del Pozo Jiménez
##
## Date Created: 2020-03-04
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


config_loader <- function(data_id){
  library(data.tree)
  source("./loader/save_config_list.R")
  
  
  master_config_file <- read.csv("./config_parameters/config_parameters_general.csv",
                                 header = TRUE, stringsAsFactors = FALSE)
  aux_neurons_config_file <- read.csv("./config_parameters/config_parameters_neurons.csv",
                                      header = TRUE, stringsAsFactors = FALSE)
  aux_path_config_file <- read.csv("./config_parameters/config_parameters_in_paths.csv",
                                   header = TRUE, stringsAsFactors = FALSE)
  
  
  data_id_check <<- master_config_file$data_id[master_config_file$data_id==data_id]
  if(length(data_id_check)==0){
    return(-1) #check if data_id not found from parameters
  }
  
  
  
  ##parameters with one value, in general file
  data_id <<- data_id
  index_in_afferent <<- master_config_file$index_in_afferent[master_config_file$data_id==data_id]
  path_id <<- master_config_file$path_id[master_config_file$data_id==data_id]
  aff_className <<- master_config_file$aff_className[master_config_file$data_id==data_id]
  aff_spNumber <<- master_config_file$aff_spNumber[master_config_file$data_id==data_id]
  n_trials <<- master_config_file$n_trials[master_config_file$data_id==data_id]
  # n_trials <<- master_config_file$n_trials[master_config_file$data_id==data_id]
  isSubset <<- master_config_file$isSubset[master_config_file$data_id==data_id]
  n_neurons_used <<- master_config_file$n_neurons_used[master_config_file$data_id==data_id]
  n_neurons_total <<- master_config_file$n_neurons_total[master_config_file$data_id==data_id]
  
  ##parameters with several values inside, for instance, a vector
  
  path_in_neurons <<- aux_path_config_file$path_in_neurons[aux_path_config_file$path_id==path_id]
  path_in_afferents <<- aux_path_config_file$path_in_afferents[aux_path_config_file$path_id==path_id]
  path_in_pos <<- aux_path_config_file$path_in_pos[aux_path_config_file$path_id==path_id]
  path_in_neg <<- aux_path_config_file$path_in_neg[aux_path_config_file$path_id==path_id]
  
  neurons_name_pos <<- aux_neurons_config_file$neurons_name_pos[aux_neurons_config_file$data_id==data_id]
  neurons_involved_pos <<- aux_neurons_config_file$neurons_involved_pos[aux_neurons_config_file$data_id==data_id]
  
  ##parameters calculated from previous ones
  neurons_name_neg <<- c(neurons_name_pos,aff_className)
  
  if(!isSubset){
    neurons_involved_neg <<- c(neurons_involved_pos,length(neurons_involved_pos)+1)
    n_neurons <<- length(neurons_name_pos)
  }  else{
    neurons_involved_neg <<- c(neurons_involved_pos,n_neurons_total+1)
    n_neurons <<- n_neurons_used
  }
  #parameters to handle combinatory workflow in case of use a part of the set of neurons
  neurons_name_pos_comb <<-  aux_neurons_config_file$neurons_name_pos[aux_neurons_config_file$isComb & aux_neurons_config_file$data_id==data_id]
  neurons_involved_pos_comb <<- aux_neurons_config_file$neurons_involved_pos[aux_neurons_config_file$isComb & aux_neurons_config_file$data_id==data_id]
  neurons_name_neg_comb <<- c(neurons_name_pos_comb,aff_className)
  neurons_involved_neg_comb <<- c(neurons_involved_pos_comb,length(neurons_involved_pos_comb)+1)
  
  #this is useful for case where we achieve Variable Importance (C5imp) and we need to recover their indexes
  #search dt_name_index in do_analysis_tree_func for instance
  dt_name_index <<- data.frame(name = neurons_name_pos, index = neurons_involved_pos)
  
  
  global_counter <<- 0
  
  removing_preliminar_units <<-c() #deprecated currently
  
  
  ##setting up grapth structure for randomSeeds and recursive workflow
  root <<- Node$new(data_id)
  root$analysis <- list()
  root$analysis[["is_done"]] <- FALSE
  root$analysis[["afferent_className"]] <- aff_className
  root$analysis[["afferent_spikesNumber"]] <- aff_spNumber
  root$analysis[["path_neurons"]] <- path_in_neurons
  root$analysis[["path_afferents"]] <- path_in_afferents
  root$analysis[["index_afferent"]] <- index_in_afferent
  root$analysis[["path_units_pos"]] <- path_in_pos
  root$analysis[["path_units_neg"]] <- path_in_neg
  root$analysis[["names_units_pos"]] <- neurons_name_pos
  root$analysis[["names_units_neg"]] <- neurons_name_neg
  root$analysis[["index_units_pos"]] <- neurons_involved_pos
  root$analysis[["index_units_neg"]] <- neurons_involved_neg
  root$analysis[["n_neurons_total"]] <- n_neurons_total
  global_counter <- global_counter+1
  root$analysis[["global_counter"]] <- global_counter
  root$analysis[["level"]] <- root$level #child will be "father's level + 1"
  root$analysis[["id"]] <- paste0(root$analysis[["global_counter"]],".",root$analysis[["level"]])
  root$analysis[["n_neurons"]] <- n_neurons 
  root$n_neurons <- n_neurons
  root$analysis[["n_neurons_C5.0"]] <- 0 #by default, loaded later with C5.0 fitted model
  root$n_neurons_C5.0 <- NA
  root$analysis[["preprocess_list"]] <- list()
  root$analysis[["fitted_model"]] <- NA #later will be filled
  root$analysis[["predictions_list"]] <- list()
  root$analysis[["evaluation_list"]] <- list() 
  root$analysis[["mat_conf_list_all"]] <- list() #full confusionMatrix object
  root$analysis[["mat_conf_list_short"]] <- list() #just ""interesting"" metrics for out studies
  root$analysis[["dt_metrics"]] <- data.frame()
  root$total_recall <- NA
  root$F1w_total_recall <- NA
  root$analysis[["dt_C50_imp"]] <- data.frame() #data frame generated by c5imp function
  
  
  save_config_list()
  
  
  
  return(0)
}


