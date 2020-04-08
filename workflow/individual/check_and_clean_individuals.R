## ---------------------------
##
## File name: check_and_clean_individuals.R
##
## Purpose of file: Remove results in metrics_per_neuron file with data_id coincidence as key
##                    Needed in case of "default" way (data_id=="default"),
##                    because each run different data may be used.
##                    So... individual analysis ought to be done and saved before iterative.
##
## Author: Pedro Del Pozo Jiménez
##
## Date Created: 2020-03-17
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

check_and_clean_individuals <- function(data_id, path_metrics_per_neuron){
  source("./workflow/individual/found_individuals.R")
  
  if(!found_individuals(path_metrics_per_neuron, data_id)){
    return(-1) #there are not metrics with this data_id added in file, so there is not needed to remove
  }
  
  master_rank_file <- read.csv(file = path_metrics_per_neuron,stringsAsFactors = FALSE)
  
  dt_neurons_keeping <- master_rank_file[master_rank_file$data_id!=data_id,]
  
  #notice the diference with the write.table found in check_and_add_individuals.R
  write.table(x = dt_neurons_keeping, file = path_metrics_per_neuron, append = FALSE,
              col.names = TRUE, row.names = FALSE, sep = ",",
              fileEncoding = "UTF-8")
  
  return(0)
}



