## ---------------------------
##
## File name: simple_split.R
##
## Purpose of file: divide main dataset into training and validating
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
##    in:
##      - dt_in
##      - p_training=.8
##      - index_colClass
##      - random_seed=123
##    out:
##      - list_split
## By default random seed fixed at 123 value
##
## ---------------------------


split <- function(dt_in,
                  p_training=.8,
                  index_colClass=ncol(dt_in),
                  random_seed=123){
  library(caret)
  
  #division, by default 80 training, 20 validating
  dt_in[,index_colClass] <- as.factor(dt_in[,index_colClass])
  set.seed(as.numeric(random_seed))#dt_in[,index_colClass]
  tr_index <- createDataPartition(dt_in[,index_colClass],
                                  p = p_training,
                                  list = FALSE,
                                  times = 1)
  
  df_tr <- dt_in[tr_index,]
  df_vl <- dt_in[-tr_index,]
  
  df_tr[,index_colClass] <- as.numeric(as.character(df_tr[,index_colClass]))
  df_vl[,index_colClass] <- as.numeric(as.character(df_vl[,index_colClass]))
  
  list_split <- list()
  list_split[[1]] <- df_tr
  list_split[[2]] <- df_vl
  
  return(list_split)
}





