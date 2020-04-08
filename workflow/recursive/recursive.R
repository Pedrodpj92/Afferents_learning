## ---------------------------
##
## File name: recursive.R
##
## Purpose of file: do analysis recursively and structure them in a tree graph
##
## Author: Pedro Del Pozo Jiménez
##
## Date Created: 2019-11-05
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
## 
## ---------------------------


recursive <- function(config_data_id, random_seed=123){
  
  #IMPORTANT, add "if-required" installation for libraries
  library(data.tree)
  library(stringr)
  
  source("./workflow/recursive/do_analysis_tree_func.R")
  source("./loader/loader.R")
  
  global_counter <- 0
  
  
  dt_res <- data.frame()
  if(loader(data_id=config_data_id)==-1){
    message("Error: data_id not found. Please, check configuration files...")
    return(dt_res)
  }
  
  cat("_______________________________\n")
  cat("running main_tree_neurons.R ...\n")
  cat("_______________________________\n")
  cat("------------------------------\n")
  cat(paste0("Data input at: ",root$analysis[["path_units_pos"]],"\n"))
  cat(paste0("and ",root$analysis[["path_units_neg"]],"\n"))
  cat(paste0("Afferent used: ",root$analysis[["afferent_className"]],"\n"))
  cat(paste0("Number of afferent spikes: ",root$analysis[["afferent_spikesNumber"]],"\n"))
  cat("------------------------------\n")
  
  return_value <- do_analysis_tree_func(root, random_seed = random_seed)
  
  # dt_res <- ToDataFrameTree(root,"n_neurons","n_neurons_C5.0", 
  #                              "total_recall",
  #                              "precision_snap", "F1w_total_recall",
  #                              "precision_completo","f1_completo", 
  #                              "mcc_snap", "mcc_completo",
  #                              "list_neurons_C5.0")
  
  dt_res <- ToDataFrameTree(root,"n_neurons",
                            "n_neurons_C5.0",
                            "list_neurons_C5.0",
                            "precision_completo",
                            "total_recall",
                            "mcc_completo")
  colnames(dt_res)[5:7] <- c("precision","recall","mcc")
  
  return(dt_res)
}

