## ---------------------------
##
## File name: get_metrics.R
##
## Purpose of file: wrap calls metrics functions
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
##      - metrics_vector; vector with the metrics' names that should be calculated
##    out:
##      - metrics_list_out
##
## ---------------------------

get_metrics <- function(table_in, metrics_vector,total_n=0){
  
  metrics_list_out <- list()
  
  if("accuracy" %in% metrics_vector){
    metrics_list_out[["accuracy"]] <-get_accuracy(table_in)
  }
  if("precision" %in% metrics_vector){
    metrics_list_out[["precision"]] <-get_precision(table_in)
  }
  if("recall" %in% metrics_vector){
    metrics_list_out[["recall"]] <-get_recall(table_in)
  }
  if("f1score" %in% metrics_vector){
    metrics_list_out[["f1score"]] <-get_fscore(table_in)
  }
  if(total_n!=0){
    if("recall2" %in% metrics_vector){
      metrics_list_out[["recall2"]] <-get_recall2(table_in,total_n)
    }
    if("f1score2" %in% metrics_vector){
      metrics_list_out[["f1score2"]] <-get_fscore2(table_in,total_n)
    }
  }
  if("mcc" %in% metrics_vector){
    metrics_list_out[["mcc"]] <-get_MCC(table_in)
  }
  
  return(metrics_list_out)
}

