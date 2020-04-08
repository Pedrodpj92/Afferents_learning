## ---------------------------
##
## Fiile name: Excel2List.R
##
## Purpose of file: function for read several excel sheets and introduce them in a list
##
## Author: Pedro Del Pozo Jiménez
##
## Date Created: 2019-09-20
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

excel2list <- function(path_in,neurons_name,neurons_involved){
  
  library(readxl)
  
  result_list <- list()
  
  for(i in 1:length(neurons_involved)){
    
    suppressMessages(dt_sheet <- read_excel(path = path_in,
                                            col_names = FALSE, sheet = neurons_involved[[i]]))
    
    if(nrow(dt_sheet)==0){
      dt_sheet <- data.frame(matrix(ncol = 2, nrow = 0))
    }
    
    colnames(dt_sheet) <- c("t",neurons_name[[i]])
    if(nrow(dt_sheet)>0){
      dt_sheet <- round(dt_sheet,5)
    }
    result_list[[i]] <- dt_sheet
  }
  result_list[sapply(result_list, is.null)] <- NULL
  
  return(result_list)
}


