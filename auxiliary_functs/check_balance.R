## ---------------------------
##
## File name: check_balance.R
##
## Purpose of file: 
##
## Author: Pedro Del Pozo Jiménez
##
## Date Created: 2019-11-20
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


check_balance <- function(dt=NULL, node=NULL){
  #PRECONDITION: class column is at the end of the data frame
  balanced <- TRUE
  if(!is.null(dt)){
    if(is.null(node)){
      node_name <- paste0(" at node ",as.character(node$name))
    } else {
      node_name <- ""
    }
    
    # future extensions, select by parameter the class values for positive and negative (multi-class even?)
    n_pos <- nrow(dt[dt[ncol(dt)]==1,])
    n_neg <- nrow(dt[dt[ncol(dt)]==0,])
    
    cat(paste0(">> Checking balance...\n"))
    cat(paste0(">> There are ",n_neg," negative cases and ",n_pos," positive cases", node_name,"\n"))
    
    #warnings' list:
    if(n_neg==0){
      cat(paste0(">>> There are not negative cases",node_name,"\n"))
      balanced <- FALSE
    }
    if(n_pos==0){
      cat(paste0(">>> There are not positive cases",node_name,"\n"))
      balanced <- FALSE
    }
    if(n_neg<=n_pos){
      cat(paste0(">>> Check manually, there may be too few negative cases","\n"))
      
      balanced <- FALSE
    }
    if(n_neg!=n_pos*4){ #generic case, in future, this "4" may be edited
      cat(paste0(">>> Unbalance data, Thanos needs to check his guantelet...","\n"))
      balanced <- FALSE
    }
  } else {
    warning("no data frame while calling check_balance")
    balanced <- FALSE
  }
  result <- list()
  result[["balanced"]] <- balanced
  result[["n_pos"]] <- n_pos
  result[["n_neg"]] <- n_neg
  return(result)
}



