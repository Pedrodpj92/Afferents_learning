## ---------------------------
##
## File name: categorize.R
##
## Purpose of file: change numerical data with the proper catecory in a data frame
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
##    in:
##      - dt_in, is_Positive=TRUE, afferent_name="R1"
##    out:
##      - dt_out
## By default it will consider as positive data_frame, so it will add a column full of ones
##   
##
## ---------------------------



categorize <- function(dt_in, is_Positive=TRUE,afferent_name="R1"){
  #original conditions used in manual preprocess in Excel
  #=SI(Y(B2>0;B2<=0.01);"A";SI(Y(B2>0.01;B2<=0.02);"B";SI(Y(B2>0.02;B2<=0.03);"C";SI(Y(B2>0.03;B2<=0.04);"D";
  
  #afferent column does not appear in possitive cases (added a constant "ones" vector later)
  #cases for more than 1 neuron (unit)
  if((ncol(dt_in)>2 & is_Positive) | (ncol(dt_in)>3 & !is_Positive)){
    #afferent column does not appear in possitive cases (added a constant "ones" vector later)
    if(is_Positive){
      index_col <- 2:ncol(dt_in)
    }else{#In negative cases, afferent column should be processed in a different way
      index_col <- 2:(ncol(dt_in)-1)
    }
    
    resultado <- data.frame(apply(dt_in[,index_col], c(1,2), function(x){
      if(!is.na(x)){
        if(x>=0.000000000 & x<=0.010000000){
          return("A")
        } else if(x>0.010000000 & x <=0.020000000){
          return("B")
        } else if(x>0.020000000 & x <=0.030000000){
          return("C")
        } else if(x>0.030000000 & x <=0.040000000){
          return("D")
        } else if(x>0.040000000 & x <=0.050000000){
          return("E")
        } else{
          return("Limit")
        }
      } else{
        return(NA)
      }
    }))
    
  } else{
    aux_vec <- dt_in[,2]
    resultado <- c()
    #yes, I know, this is not an elegant solution, but it works and I needed to repair this case bug about 1 case unit...
    for(i in 1:length(aux_vec)){
      num_tmp <- aux_vec[i]
      if(!is.na(num_tmp)){
        if(num_tmp>=0.000000000 & num_tmp<=0.010000000){
          current_category <- "A"
        } else if(num_tmp>0.010000000 & num_tmp <=0.020000000){
          current_category <- "B"
        } else if(num_tmp>0.020000000 & num_tmp <=0.030000000){
          current_category <- "C"
        } else if(num_tmp>0.030000000 & num_tmp <=0.040000000){
          current_category <- "D"
        } else if(num_tmp>0.040000000 & num_tmp <=0.050000000){
          current_category <- "E"
        } else{
          current_category <- "Limit"
        }
      } else{
        current_category <- NA
      }
      resultado <- c(resultado,current_category)
    }
    resultado <- as.data.frame(resultado)
  }
  
  if(is_Positive){#add "afferent column" (class column), everything is "1" (positive)
    dt_out <- as.data.frame(cbind(dt_in[,1],resultado,rep(1,nrow(resultado))))
    colnames(dt_out) <- c(colnames(dt_in),afferent_name)
  } else {#add "afferent column", negative cases, the added ones will be "discarted" cases later
    aff_tmp <- dt_in[,ncol(dt_in)]
    aff_tmp[!is.na(aff_tmp)] <- 1
    dt_out <- as.data.frame(cbind(dt_in[,1],resultado,aff_tmp))
    colnames(dt_out) <- colnames(dt_in)
  }
  
  return(dt_out)
}

