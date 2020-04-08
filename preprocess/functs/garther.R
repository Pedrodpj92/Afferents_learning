## ---------------------------
##
## File name: garther.R
##
## Purpose of file: process each pair neuron times from a list to generate a ordered data frame 
##
## Author: Pedro Del Pozo Jiménez
##
## Date Created: 2019-09-20
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

gather <- function(neurons_list){
  dt_gatherer <- data.frame(neurons_list[[1]])
  neurons_list[[1]]<-NULL
  
  for(i in neurons_list){
    aux_dt <- data.frame(i)
    aux_na_previous <- rep(NA,nrow(aux_dt))
    aux_na_new <- rep(NA,nrow(dt_gatherer))
    
    new_rows <- data.frame(t=aux_dt[,1])
    
    for(j in 2:length(dt_gatherer)){
      new_rows <- cbind(new_rows, aux_na_previous)
    }
    colnames(new_rows) <- colnames(dt_gatherer)
    dt_gatherer <- rbind(dt_gatherer, new_rows)
    
    
    aux_dt_col <- data.frame(tmp=c(aux_na_new,aux_dt[,2]))
    colnames(aux_dt_col) <- colnames(aux_dt)[2]
    
    dt_gatherer <- cbind(dt_gatherer,aux_dt_col)
  }
  
  
  dt_gatherer[is.na(dt_gatherer)] <- 0
  dt_gatherer <- dt_gatherer[order(dt_gatherer[,1]),]
  
  return(dt_gatherer)
}



