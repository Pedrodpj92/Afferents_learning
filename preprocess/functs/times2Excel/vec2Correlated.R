## ---------------------------
##
## File name: vec2Correlated.R
##
## Purpose of file: Calculates time coincidences (correlations) between a reference spike times vector (trigger) versus 
##            a list of spike times vector, given an interval with left and right margin respect trigger
##
## Author: Pedro Del Pozo Jiménez
##
## Date Created: 2020-01-29
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

vec2Correlated <- function(neurons_times_list, trigger_times,
                      pre_margin_vector = NULL,
                      post_margin_vector = NULL){ 
  
  if(is.null(pre_margin_vector)){
    pre_margin_vector<- rep(0.05,length(neurons_times_list))
  }
  
  if(is.null(post_margin_vector)){
    post_margin_vector<- rep(0.00,length(neurons_times_list))
  }
  
  
  list_result <- list()
  
  for(i in 1:length(neurons_times_list)){
    analysis_channel <- neurons_times_list[[i]]
    
    left_side <- pre_margin_vector[i]
    right_side <- post_margin_vector[i]
    
    c_trigger <- c()
    c_channel <- c()
    cat(paste0("- searching coincidences on neuron with index: ", i, "\n"))
    
    
    for(n in 1:length(trigger_times)){
      for(m in 1:length(analysis_channel)){
        aux_t_trig <- round(trigger_times[n],5)
        aux_t_chan <- round(analysis_channel[m],5)
        #then add times to vectors results
        if(aux_t_chan >= (aux_t_trig-left_side) & aux_t_chan<=(aux_t_trig+right_side)){
          c_trigger <- c(c_trigger,aux_t_trig)
          c_channel <- c(c_channel,aux_t_chan)
        }
      }
    }
    aux_list <- list()
    aux_list[["trigger"]] <- c_trigger
    aux_list[["channel"]] <- c_channel
    list_result[[i]] <- aux_list
    
  }
  return(list_result)
}






