## ---------------------------
##
## File name: loader.R
##
## Purpose of file: call and coordinate each way of load parameters and configuration
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


loader <- function(data_id){
  source("./loader/config_loader.R")
  source("./loader/default_loader.R")
  source("./loader/reload_config_list.R")
  
  
  if(first_load & rustic_semaphore>0){
    if(data_id=="default"){
      return_value <- default_loader(data_id)
    } else {
      return_value <- config_loader(data_id)
    }
    rustic_semaphore <<- rustic_semaphore-1
    first_load <<- FALSE
    #usar save sobre un objeto de tipo lista que contendrá todas las variables globales
    #en el load solo se carga esa lista y se usa una función auxiliar para devolver los valores
    # save.image(file = "./config_parameters/current_config.RData")
    save(list = "config_list",file = "./config_parameters/current_config.RData")
  } else {
    load(file = "./config_parameters/current_config.RData",envir = .GlobalEnv)
    rustic_semaphore <<- rustic_semaphore-1
    # save.image(file = "./config_parameters/current_config.RData")
    # save(list = "config_list",file = "./config_parameters/current_config.RData") #not necessary I think, parameters won't be modified again
    reload_config_list()
    return_value <- 0 
  }
  
  if(rustic_semaphore<0){
    stop("Bad parameters load, please, check workflow_commander and semaphore situation")
  }
  
  return(return_value)
}




