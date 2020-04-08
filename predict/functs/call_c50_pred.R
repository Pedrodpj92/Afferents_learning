## ---------------------------
##
## File name: call_c50_pred.R
##
## Purpose of file: predict class from data using a C5.0 model
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
##      - model_in
##      - dt_in
##    out:
##      - dt_out
##
## ---------------------------

call_c50_pred <- function(model_in,dt_in){
  library(C50)
  dt_pred <- as.data.frame(predict(model_in,newdata=dt_in))
  colnames(dt_pred) <- c("pred")
  
  dt_out <- cbind(dt_in,dt_pred)
  return(dt_out)
}



