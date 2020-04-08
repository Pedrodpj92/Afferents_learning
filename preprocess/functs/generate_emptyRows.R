## ---------------------------
##
## File name: generate_emptyRows.R
##
## Purpose of file: generate n rows with m+2 columns
##                  (with a value class column at the end and a id (t) at the start). 
##
## Author: Pedro Del Pozo Jiménez
##
## Date Created: 2019-11-19
##
## Email: pedrodpj92@gmail.com
##
## This file is part of Afferents_Learning.
## 
## Afferents_Learning is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## Afferents_Learning is distributed in the hope that it will be useful,
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



generate_emptyRows <- function(n_rows, m_columns, class_content="0", start_id=1.0){
  
  result <- as.data.frame(matrix("0",n_rows, m_columns),stringsAsFactors = FALSE)
  id_col <- seq(from = start_id,to = start_id+n_rows-1)
  class_col <- rep(class_content,n_rows)
  
  result <- cbind(as.factor(id_col),result,class_col)
  return(result)
}

