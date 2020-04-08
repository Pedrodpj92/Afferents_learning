## ---------------------------
##
## File name: serial_preprocess_workflow_1.R
##
## Purpose of file: wrap several functions as abstractive level between functions and module
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



serial_preprocess_workflow_1 <- function(list_in, is_Positive = TRUE, afferent_name = "R1"){
  
  dt_garthered <- gather(list_in)
  dt_subtracted <- substract(dt_garthered)
  dt_cleaned <- clean(dt_subtracted)
  dt_categorized <- categorize(dt_cleaned,is_Positive, afferent_name)
  dt_flatten <- flatten(dt_categorized,is_Positive, afferent_name)
  
  dt_out <- dt_flatten
  return(dt_out)
}




