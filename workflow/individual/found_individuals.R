## ---------------------------
##
## File name: check_individuals.R
##
## Purpose of file: return true if data_id is found in metrics_per_neuron file
##
## Author: Pedro Del Pozo Jiménez
##
## Date Created: 2020-03-09
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


found_individuals <- function(path_metrics_per_neuron, data_id){
  
  
  master_rank_file <- read.csv(file = path_metrics_per_neuron,stringsAsFactors = FALSE)
  
  dt_neurons_ranking <- master_rank_file[master_rank_file$data_id==data_id,]
  
  if(nrow(dt_neurons_ranking)>0){
    return(TRUE)
  } else{
    return(FALSE)
  }
}


