## ---------------------------
##
## File name: workflow_commander.R
##
## Purpose of file: handle several workflows in order to execute one or other
##
## Author: Pedro Del Pozo Jiménez
##
## Date Created: 2020-02-11
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


workflow_commander <- function(config_data_id, vec_random_seed=123,
                               wf_calls=c("randomSeeds","combinatory","individual","iterative","recursive"),
                               cut_specific_neurons_comb=FALSE,
                               path_output_comb_file="./workflow/combinatory/combinatory_output.csv",
                               n_trials=1){
  
  
  
  source("./workflow/randomSeeds/randomSeeds.R")
  source("./workflow/combinatory/combinatory.R")
  source("./workflow/individual/individual.R")
  source("./workflow/iterative/iterative.R")
  source("./workflow/recursive/recursive.R")
  
  
  global_counter <<- 0 
  list_results <- list()
  
  # we only need to look and fix parameters first time in this call, for several workflows,
  # we can save temporally a configuration in special .RData and load N times as many as
  # the number of calls in this funcions.
  # For both default load and load from tables
  rustic_semaphore <<- length(wf_calls)
  first_load <<- TRUE
  # data structure to harvest parameters, later will be used to save those parameters as "current configuration"
  config_list <<- list()
  
  
  if("randomSeeds" %in% wf_calls){
    global_counter <- 0
    cat(paste0("_________________________________________________________________\n"))
    cat(paste0("Running base process. Starting preprocess in 10 seconds..........\n"))
    cat(paste0("_________________________________________________________________\n"))
    Sys.sleep(10)
    list_results[["randomSeeds"]] <- randomSeeds(config_data_id = config_data_id, vec_random_seed = vec_random_seed)
  }
  
  
  if("individual" %in% wf_calls){
    global_counter <- 0
    cat(paste0("_________________________________________________________________\n"))
    cat(paste0("Running individual workflow. Starting preprocess in 10 seconds...\n"))
    cat(paste0("_________________________________________________________________\n"))
    Sys.sleep(10)
    list_results[["individual"]] <- individual(config_data_id = config_data_id, random_seed = vec_random_seed[1])
  }
  
  if("iterative" %in% wf_calls){
    cat(paste0("_________________________________________________________________\n"))
    cat(paste0("Running iterative workflow. Starting preprocess in 10 seconds....\n"))
    cat(paste0("_________________________________________________________________\n"))
    Sys.sleep(10)
    list_results[["iterative"]] <- iterative(config_data_id = config_data_id, random_seed = vec_random_seed[1])
  }
  
  if("recursive" %in% wf_calls){
    global_counter <- 0
    cat(paste0("_________________________________________________________________\n"))
    cat(paste0("Running recursive workflow. Starting preprocess in 10 seconds....\n"))
    cat(paste0("_________________________________________________________________\n"))
    Sys.sleep(10)
    list_results[["recursive"]] <- recursive(config_data_id = config_data_id, random_seed = vec_random_seed[1])
  }
  
  if("combinatory" %in% wf_calls){
    cat(paste0("_________________________________________________________________\n"))
    cat(paste0("Running combinatory workflow. Starting preprocess in 10 seconds..\n"))
    cat(paste0("_________________________________________________________________\n"))
    Sys.sleep(10)
    list_results[["combinatory"]] <- combinatory(config_data_id = config_data_id,
                                                 cut_specific_neurons = cut_specific_neurons_comb,
                                                 path_output_file = path_output_comb_file,
                                                 n_trials = n_trials)
  }
  
  return(list_results)
}
