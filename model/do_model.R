## ---------------------------
##
## File name: do_model.R
##
## Purpose of file: call to libraries and functions in order to train a model, currently just C5.0
##
## Author: Pedro Del Pozo Jiménez
##
## Date Created: 2019-09-23
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
##    Currently, just C5.0 is used, in future versions other algorithms may be added
##
## ---------------------------


do_model <- function(dt_tr, dt_complete_factors, with_cost_mat=TRUE, n_trials=1){
  file.sources = list.files(c("./model/functs"), 
                            pattern="*.R$", full.names=TRUE, 
                            ignore.case=TRUE)
  sapply(file.sources,source,.GlobalEnv)
  
  
  #if more libraries are added, other ways to select functions will be used
  model_res <- call_c50(dt_tr = dt_tr, dt_complete_factors = dt_complete_factors, with_cost_mat=with_cost_mat,n_trials)
  
  return(model_res)
}


