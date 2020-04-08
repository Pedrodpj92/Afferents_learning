## ---------------------------
##
## File name: call_c50.R
##
## Purpose of file: wrap c50 library in order to simplify code in different abstraction levels
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
##
## ---------------------------



#we will use training data, but adding temporally the remainin rows (complete dataset) will prevent to find "unknown" factors in prediction time
call_c50 <- function(dt_tr, dt_complete_factors, with_cost_mat=TRUE, n_trials=1){
  library(C50)
  #removing key column, not used in training
  guarda_t_tr <- dt_tr$t
  guarda_t_complete <- dt_complete_factors$t
  dt_tr$t <- NULL
  dt_complete_factors$t <- NULL
  
  dt_tr[,ncol(dt_tr)] <- as.factor(dt_tr[,ncol(dt_tr)])
  dt_complete_factors[,ncol(dt_complete_factors)] <- as.factor(dt_complete_factors[,ncol(dt_complete_factors)])
  corte <- nrow(dt_tr)
  
  #adding all factors
  cols <- colnames(dt_tr[,1:(ncol(dt_tr)-1)])
  df_total <- rbind(dt_tr,dt_complete_factors)
  df_total[,cols] <- lapply(df_total[,cols], factor)
  
  dt_tr <- df_total[1:corte,]
  
  #for case with one only predictor, may not have name if it is understood as vector and not as data.frame
  dt_trainer <- as.data.frame(dt_tr[, 1:(ncol(dt_tr)-1)] )
  colnames(dt_trainer) <- colnames(dt_tr)[1:(ncol(dt_tr)-1)]
  
  if(!with_cost_mat){
    fit_c50 <- C5.0(x = dt_trainer, y = dt_tr[,ncol(dt_tr)],trials = n_trials)
  } else{
    cost_mat <- matrix(c(0, 1, 3.5, 0), nrow = 2)
    # cost_mat <- matrix(c(0, 1, 1, 0), nrow = 2)
    rownames(cost_mat) <- colnames(cost_mat) <- c("0", "1")
    # cost_mat
    fit_c50 <- C5.0(x = dt_trainer, y = dt_tr[,ncol(dt_tr)],costs = cost_mat,trials = n_trials)
  }
  
  return(fit_c50)
}







