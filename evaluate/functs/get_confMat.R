## ---------------------------
##
## File name: get_confMat.R
##
## Purpose of file: obtain confusion matrix from original and predicted data
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
##      - dt_in
##      - index_originalClass
##      - index_predictedClass
##      - positiveClass="1"
##      - isFactor=FALSE
##    out:
##      - list_out; with confMat object and data frame with original (org) and predicted (pred) data
##
## ---------------------------



get_confMat <- function(dt_in, index_originalClass, index_predictedClass,
                       positiveClass="1", isFactor = FALSE){
  library(caret)
  
  
  col_predictedClass <- dt_in[,index_predictedClass]
  col_originalClass <- dt_in[,index_originalClass]
  
  df_pred <- as.data.frame(col_predictedClass)
  colnames(df_pred)[1] <- c("predict")
  df_pred$org <- factor(col_originalClass,levels = c("0","1"))
  if(!isFactor){
    df_pred$prd <- 0
    df_pred[df_pred$predict > 0.5,]$prd <- 1
  }else{
    df_pred$prd <- df_pred$predict
  }
  
  df_pred$prd <- factor(df_pred$prd,levels = c("0","1"))
  # print(str(df_pred))
  confMat <- confusionMatrix(table(df_pred$prd,
                                   df_pred$org),
                             positive=positiveClass)
  
  # print("summary original:")
  # print(summary(as.factor(df_pred$org)))
  # print("summary prediction:")
  # print(summary(as.factor(df_pred$prd)))
  # print("confusion matrix:")
  # print(confMat)
  
  
  list_out <- list()
  list_out[["confMat"]] <- confMat
  list_out[["org_prd"]] <- df_pred[,2:3]
  
  return(list_out)
}



# old function, just for testing legacy workflows 
# confMat_v2 <- function(col_predictedClass,
#                        col_originalClass,
#                        positiveClass="1", isFactor = FALSE){
#   library(caret)
#   
#   df_pred <- as.data.frame(col_predictedClass)
#   colnames(df_pred)[1] <- c("predict")
#   df_pred$org <- factor(col_originalClass,levels = c("0","1"))
#   if(!isFactor){
#     df_pred$prd <- 0
#     df_pred[df_pred$predict > 0.5,]$prd <- 1
#   }else{
#     df_pred$prd <- df_pred$predict
#   }
#   
#   df_pred$prd <- factor(df_pred$prd,levels = c("0","1"))
#   # print(str(df_pred))
#   confMat <- confusionMatrix(table(df_pred$prd,
#                                    df_pred$org),
#                              positive=positiveClass)
#   
#   print("resumen de la clase original:")
#   print(summary(as.factor(df_pred$org)))
#   print("resumen de la prediccion:")
#   print(summary(as.factor(df_pred$prd)))
#   print("resultados de la matriz de confusion")
#   print(confMat)
#   
#   
#   resultado <- list()
#   resultado[[1]] <- confMat
#   resultado[[2]] <- df_pred[,2:3]
#   
#   return(resultado)
# }


