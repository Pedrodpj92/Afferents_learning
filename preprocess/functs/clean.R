## ---------------------------
##
## File name: clean.R
##
## Purpose of file: remove data that excess time event duration (currently 50 ms)
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


clean <- function(dt_in){
  #watch out, first event should start after 0.05 time or will not be properly cleaned
  if(ncol(dt_in)>2){
    result <- apply(dt_in[,2:ncol(dt_in)],c(1,2),function(x){
      if(x>0.05){
        return(NA)
      }else{
        return(x)
      }
    })
  }else{#if-elseshould not be needed using just 1 unit, but it's ok for cover other strange cases
    result <- dt_in[,2]
    result[result>0.05] <- NA
  }
  
  dt_out <- data.frame(cbind(dt_in[,1],result))
  colnames(dt_out) <- colnames(dt_in)
  return(dt_out)
}



