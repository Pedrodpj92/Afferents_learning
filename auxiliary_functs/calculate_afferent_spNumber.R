## ---------------------------
##
## File name: calculate_afferent_spNumber.R
##
## Purpose of file: 
##
## Author: Pedro Del Pozo Jiménez
##
## Date Created: 2020-03-15
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


calculate_afferent_spNumber <- function(path_in,index_in,na_strings = "NaN"){
  dt_afferent <- read.csv(file = path_in, na.strings = na_strings)
  
  afferent <- dt_afferent[,index_in]
  afferent <- c(na.exclude(afferent))
  
  return(length(afferent))
}




