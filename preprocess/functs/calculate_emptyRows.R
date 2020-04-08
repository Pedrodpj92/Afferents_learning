## ---------------------------
##
## File name: calculate_emptyRows.R
##
## Purpose of file: with a n rows input and a time (in seconds),
##                  returns how many rows should be added in order to preserve a similar distribution as
##                  recorded data.
##
## Author: Pedro Del Pozo Jiménez
##
## Date Created: 2019-11-19
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
##   - by default, 1800 seconds (30 mins)
##   - by default, each case (interval) is 0.05 seconds
##   - n_rows should be the amoun of negative and positive cases
##
## ---------------------------

calculate_emptyRows <- function(exp_duration=1808.00, case_duration=0.05, n_rows){
  
  total_cases <- exp_duration/case_duration
  result <- total_cases - n_rows
  
  return(result)
}



