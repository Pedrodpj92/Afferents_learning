## ---------------------------
##
## File name: get_MMC.R
##
## Purpose of file: obtain Matthews Correlation Coefficient (MCC) from a confusion matrix object
##
## Author: Pedro Del Pozo Jiménez
##
## Date Created: 2019-11-26
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
##    out:
##      - mmc_out
##
## details in https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5721660/pdf/13040_2017_Article_155.pdf
## help and specification in https://stackoverflow.com/questions/30997876/how-to-obtain-coefficient-for-matthews-correlation-after-running-these-two-lines
##
## ---------------------------


get_MCC <- function(table_in){
  # library(caret)
  TP <- table_in[2,2]
  TN <- table_in[1,1]
  FP <- table_in[2,1]
  FN <- table_in[1,2]
  
  #in this operation, overflows may occur
  # mmc_out <- ((TP*TN)-(FP*FN))/sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN))
  
  #in case of confusion matrix with other "positive" position, be aware with the indexes 
  # TP <- conf_matrix$table[1,1]
  # TN <- conf_matrix$table[2,2]
  # FP <- conf_matrix$table[1,2]
  # FN <- conf_matrix$table[2,1]
  
  mcc_num <- (TP*TN - FP*FN)
  mcc_den <- as.double((TP+FP))*as.double((TP+FN))*as.double((TN+FP))*as.double((TN+FN))
  
  mcc_out <- mcc_num/sqrt(mcc_den)
  
  return(mcc_out)
}






