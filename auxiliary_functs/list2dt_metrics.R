## ---------------------------
##
## File name: list2dt_metrics.R
##
## Purpose of file: Convert several metrics obtained from datasets predictions into one single data frame
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
##      - list_in
##    out:
##      - dt_out
##
## ---------------------------


list2dt_metrics <- function(list_in,withRec2=FALSE){
  list_names <- names(list_in)
  
  #strong dependencies with specific metrics, careful with maintainability!
  if(withRec2){
  dt_evalued_exp <- data.frame(t(c("dt",0.0,0.0,0.0,0.0,0.0,0.0,0.0)),stringsAsFactors = FALSE)
  colnames(dt_evalued_exp) <- c("dataset","accuracy","precision","recall","f1_score","recall2","f1score2","mcc")
  }
  else{
    dt_evalued_exp <- data.frame(t(c("dt",0.0,0.0,0.0,0.0,0.0)),stringsAsFactors = FALSE)
    colnames(dt_evalued_exp) <- c("dataset","accuracy","precision","recall","f1_score","mcc")
  }
  
  dt_evalued_exp$accuracy <- as.numeric(dt_evalued_exp$accuracy)
  dt_evalued_exp$precision <- as.numeric(dt_evalued_exp$precision)
  dt_evalued_exp$recall <- as.numeric(dt_evalued_exp$recall)
  dt_evalued_exp$f1_score <- as.numeric(dt_evalued_exp$f1_score)
  if(withRec2){
    dt_evalued_exp$recall2 <- as.numeric(dt_evalued_exp$recall2)
    dt_evalued_exp$f1score2 <- as.numeric(dt_evalued_exp$f1score2)
  }
  dt_evalued_exp$mcc <- as.numeric(dt_evalued_exp$mcc)
  
  for(dt_name in list_names){
    aux_element <- list_in[[dt_name]]
    
    if(!withRec2){
      dt_evalued_exp <- rbind(dt_evalued_exp,
                              c(dt_name,
                                aux_element$metrics$accuracy,
                                aux_element$metrics$precision,
                                aux_element$metrics$recall,
                                aux_element$metrics$f1score,
                                aux_element$metrics$mcc))
    }
    else{
      dt_evalued_exp <- rbind(dt_evalued_exp,
                              c(dt_name,
                                aux_element$metrics$accuracy,
                                aux_element$metrics$precision,
                                aux_element$metrics$recall,
                                aux_element$metrics$f1score,
                                aux_element$metrics$recall2,
                                aux_element$metrics$f1score2,
                                aux_element$metrics$mcc))
    }

  }
  dt_evalued_exp <- dt_evalued_exp[-1,]
  dt_out <- dt_evalued_exp
  
  return(dt_out)
}





