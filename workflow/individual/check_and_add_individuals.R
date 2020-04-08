## ---------------------------
##
## File name: check_and_add_individuals.R
##
## Purpose of file: add new individual results if no data_id matched
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



check_and_add_individuals <- function(data_id, path_metrics_per_neuron, dt_individuals){
  source("./workflow/individual/found_individuals.R")
  
  
  if(found_individuals(path_metrics_per_neuron, data_id)){
    return(-1) #there are metrics added in file, so there is not needed to add again
  }
  
  dt_individuals[is.na(dt_individuals)] <- 0.0
  dt_individuals <- cbind(rep(data_id,nrow(dt_individuals)),dt_individuals)
  
  write.table(x = dt_individuals, file = path_metrics_per_neuron, append = TRUE,
              col.names = FALSE, row.names = FALSE, sep = ",",
              fileEncoding = "UTF-8")
  
  
  return(0)
}








