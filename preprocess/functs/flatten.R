## ---------------------------
##
## File name: flatten.R
##
## Purpose of file: Obtain real study cases, shrinking rows by time in actual cases
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


flatten <- function(dt_in, is_Positive=TRUE, afferent_name="R1"){

  dt_flat <- dt_in
  colnames(dt_flat)[ncol(dt_flat)] <- c("R_tmp") #temporal afferent to more "understandable" code, accessing this column with $ in several operations
  
  if(!is_Positive){
    dt_flat[is.na(dt_flat$R_tmp),]$R_tmp <- 0
  }
  
  #quite important, removing NA
  dt_flat <- data.frame(lapply(dt_flat, as.character), stringsAsFactors=FALSE)
  dt_flat[is.na(dt_flat)] <- ""
  
  dt_flat_agg1 <- aggregate(dt_flat,
                            by = list(dt_flat$t),
                            FUN = toString)
  
  dt_flat_agg1$t <- NULL
  colnames(dt_flat_agg1)[1] <- "t"
  
  #this would be able to condense in less intructions, this is aimed for clarify operations
  dt_flat_agg1 <- as.data.frame(apply(dt_flat_agg1, 2, function(x) gsub(',', '', x)),stringsAsFactors=FALSE)
  dt_flat_agg1 <- as.data.frame(apply(dt_flat_agg1, 2, function(x) gsub(' ', '', x)),stringsAsFactors=FALSE)
  dt_flat_agg1 <- as.data.frame(apply(dt_flat_agg1, 2, function(x) gsub("^$|^ $", "0", x)))
  
  dt_flat_agg1$R_tmp <- as.numeric(as.character(dt_flat_agg1$R_tmp))
  dt_flat_agg1[dt_flat_agg1$R_tmp > 0,]$R_tmp <- 1
  
  if(!is_Positive){
    dt_flat_agg1 <- dt_flat_agg1[dt_flat_agg1$R_tmp == 0,] #remove ones in negative cases
  }
  
  colnames(dt_flat_agg1)[ncol(dt_flat_agg1)] <- c(afferent_name)
  
  dt_out <- dt_flat_agg1
  
  return(dt_out)
}









