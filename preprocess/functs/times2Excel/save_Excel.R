## ---------------------------
##
## File name: save_Excel.R
##
## Purpose of file: using openxlsx, write an excel for a list of twins vectors (times correlated)
##
## Author: Pedro Del Pozo Jiménez
##
## Date Created: 2020-01-30
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


save_Excel <- function(list_input, path_output = "./output_default.xlsx"){
  
  library(openxlsx)
  
  excel_object <- createWorkbook()
  options("openxlsx.numFmt" = "0.00000")
  
  
  for(i in 1:length(list_input)){
    aux_dt <- as.data.frame(list_input[[i]])
    addWorksheet(excel_object, sheetName = i)
    
    if(nrow(aux_dt)>0){
      writeData(excel_object, sheet = i, aux_dt,
                startCol = "A", startRow = 2,
                colNames=FALSE,rowNames = FALSE)
    }
  }
  
  saveWorkbook(excel_object, path_output, overwrite = TRUE)
  
  return(excel_object)
}





