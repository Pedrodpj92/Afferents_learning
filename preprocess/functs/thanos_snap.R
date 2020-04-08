## ---------------------------
##
## File name: thanos_snap.R
##
## Purpose of file: Balancing positive and negative cases for the sake of a better training process
##                  ... And yes, it is a MCU reference
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
##      - dt_pos
##      - dt_neg
##      - amount_Pos
##      - amount_Neg
##      - random_seed=123
##    out:
##      - df_snap_out
## By default random seed fixed at 123 value
##
## ---------------------------




thanos_snap <- function(dt_pos,dt_neg,
                        amount_Pos, amount_Neg,
                        random_seed=123){
  library(caret)
  
  if(nrow(dt_neg)>amount_Neg){
    set.seed(random_seed)
    dt_neg_snap <- dt_neg[sample(x = nrow(dt_neg),
                                 size = amount_Neg, replace = FALSE),]
  } else{
    dt_neg_snap <- dt_neg
  }
  
  if(nrow(dt_pos)>amount_Pos){
    set.seed(random_seed)
    dt_pos_snap <- dt_pos[sample(x = nrow(dt_pos),
                                 size = amount_Pos, replace = FALSE),]
  } else{
    dt_pos_snap <- dt_pos
  }
  
  df_snap_out <- rbind(dt_pos_snap,
                       dt_neg_snap)
  
  return(df_snap_out)
}



