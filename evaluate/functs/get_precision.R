## ---------------------------
##
## File name: get_precision.R
##
## Purpose of file: obtain precision from a confusion matrix object
##
## Author: Pedro Del Pozo Jiménez
##
## Date Created: 2019-09-24
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
##      - table_in
##    out:
##      - pre_out
##
## ---------------------------


get_precision <- function(table_in){
  # library(caret)
  TP <- table_in[2,2]
  TN <- table_in[1,1]
  FP <- table_in[2,1]
  FN <- table_in[1,2]
  
  pre_out <- (TP)/(TP+FP)
  return(pre_out)
}






