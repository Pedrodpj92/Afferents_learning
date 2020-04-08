## ---------------------------
##
## File name: do_evaluation.R
##
## Purpose of file: obtain metrics and generate reports
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
##      - list_out
##
## ---------------------------


do_evaluation <- function(list_in, total_n=0){
  file.sources = list.files(c("./evaluate/functs"), 
                            pattern="*.R$", full.names=TRUE, 
                            ignore.case=TRUE)
  sapply(file.sources,source,.GlobalEnv)
  
  
  list_out <- list()
  names_list_in <- names(list_in)
  # i <- 1 #not needed now
  for(n in names_list_in){
    dt <- list_in[[n]]
    aux_confMatObj <- get_confMat(dt_in = dt,
                                  index_originalClass = ncol(dt)-1,
                                  index_predictedClass = ncol(dt),
                                  isFactor = TRUE)
    list_out[[n]]$confMat_obj <- aux_confMatObj
    aux_tabla_confMat <- aux_confMatObj[["confMat"]]$table
    if(total_n==0){
      aux_metrics <- get_metrics(aux_tabla_confMat,c("accuracy",
                                                     "precision",
                                                     "recall",
                                                     "f1score",
                                                     "mcc"))
    }else{
      aux_metrics <- get_metrics(aux_tabla_confMat,c("accuracy",
                                                     "precision",
                                                     "recall",
                                                     "f1score",
                                                     "recall2",
                                                     "f1score2",
                                                     "mcc"),total_n)
    }

    list_out[[n]]$metrics <- aux_metrics
    
    # i <- i+1
  }
  
  return(list_out)
}






