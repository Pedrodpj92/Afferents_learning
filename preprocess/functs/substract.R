## ---------------------------
##
## File name: subtract.R
##
## Purpose of file: calculates substraction between each column and the first one
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
##    in:
##      - dt_in
##    out:
##      - dt_out
##
##
## ---------------------------


substract <- function(dt_in){
  if(ncol(dt_in)>2){
    dt_out <- apply(dt_in[,2:ncol(dt_in)], 2, function(x){
      return(dt_in[,1]-x)
    })
  }else{ #case for just 1 column
    dt_out <- as.data.frame(dt_in[,1]-dt_in[,2])
  }

  dt_out <- data.frame(cbind(dt_in[,1],dt_out))
  colnames(dt_out) <- colnames(dt_in)
  
  return(dt_out)
}





