## ---------------------------
##
## File name: save_config_list.R
##
## Purpose of file: save every global configuration parameters as list, used in loaders functions
##
## Author: Pedro Del Pozo Jiménez
##
## Date Created: 2020-03-16
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

save_config_list <- function(){
  # if "config_list" is not defined, this will rise an error, it is instanced as list() in workflow_commander
  # there is a necessary dependency because this list will be saved in order to recover parameters automatically
  # in each workflow called by just one run of workflow_commander
  # as well as, the rest of global parameters should be instaced firstly in functions such as config_loader or default_loader
  config_list[["data_id_check"]] <<- data_id_check
  config_list[["data_id"]] <<- data_id
  config_list[["index_in_afferent"]] <<- index_in_afferent
  
  config_list[["index_in_afferent"]] <<- index_in_afferent
  config_list[["path_id"]] <<- path_id
  config_list[["aff_className"]] <<- aff_className
  config_list[["aff_spNumber"]] <<- aff_spNumber
  config_list[["n_trials"]] <<- n_trials
  
  config_list[["path_in_neurons"]] <<- path_in_neurons
  config_list[["path_in_afferents"]] <<- path_in_afferents
  config_list[["path_in_pos"]] <<- path_in_pos
  config_list[["path_in_neg"]] <<- path_in_neg
  
  config_list[["neurons_name_pos"]] <<- neurons_name_pos
  config_list[["neurons_involved_pos"]] <<- neurons_involved_pos
  
  config_list[["neurons_name_neg"]] <<- neurons_name_neg
  config_list[["neurons_involved_neg"]] <<- neurons_involved_neg
  config_list[["n_neurons"]] <<- n_neurons
  config_list[["isSubset"]] <<- isSubset
  config_list[["n_neurons_used"]] <<- n_neurons_used
  config_list[["n_neurons_total"]] <<- n_neurons_total
  
  
  config_list[["neurons_name_pos_comb"]] <<- neurons_name_pos_comb
  config_list[["neurons_involved_pos_comb"]] <<- neurons_involved_pos_comb
  config_list[["neurons_name_neg_comb"]] <<- neurons_name_neg_comb
  config_list[["neurons_involved_neg_comb"]] <<- neurons_involved_neg_comb
  
  config_list[["dt_name_index"]] <<- dt_name_index
  config_list[["global_counter"]] <<- global_counter
  config_list[["removing_preliminar_units"]] <<- removing_preliminar_units
  config_list[["root"]] <<- root
}

