## ---------------------------
##
## File name: do_predict.R
##
## Purpose of file: use a trained model to generate predictions on data (data frame list)
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
##      - list_in
##    out:
##      - list_out
##
## ---------------------------


do_predict <- function(model_in, list_in){
  
  file.sources = list.files(c("./predict/functs"),
                            pattern="*.R$", full.names=TRUE,
                            ignore.case=TRUE)
  sapply(file.sources,source,.GlobalEnv)
  list_out <- list()
  i <- 1
  for(dt in list_in){ ##any type of apply function could be used insted this loop?
    dt_aux <- call_c50_pred(model_in = model_in,dt_in = dt)
    list_out[[i]] <- dt_aux
    i <- i+1
  } 
  names(list_out) <- names(list_in)
  return(list_out)
}








