## ---------------------------
##
## File name: default_loader.R
##
## Purpose of file: load initial parameters interacting with the user, alternative way of config_loader
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

default_loader <- function(data_id){
  library(tcltk)
  source("./auxiliary_functs/calculate_afferent_spNumber.R")
  source("./loader/save_config_list.R")
  
  #there are some requisites written in Spanish, if you need clarification, write us,
  #in following updates will be updated to English if it is not clear and many people ask for it
  
  data_id_check <<- data_id
  data_id <<- data_id
  path_id <<- "./output"
  
  # El sistema pregunta al usuario por la ubicación de los archivos 
  # de neuronas y aferentes (por separado)
  # path_in_neurons <<- file.choose(new = FALSE) #this returns an error in case of user cancel the action
  # path_in_neurons <<- tk_choose.files(caption = "Choose neurons file")
  # path_in_afferents <<- tk_choose.files(caption = "Choose afferents file")
  cat("\nplease, select neurons file...")
  path_in_neurons <<- file.choose(new = FALSE)
  cat("\nplease, select afferents file...")
  path_in_afferents <<- file.choose(new = FALSE)
  
  
  path_in_pos <<- paste0(path_id,"/dt_pos.xlsx")
  path_in_neg <<- paste0(path_id,"/dt_neg.xlsx")
  
  # prueba <- read.csv(file = path_in_neurons, na.strings = "NaN")
  # prueba2 <- read.csv(file = path_in_afferents, na.strings = "NaN")
  
  # Pregunta al usuario por la aferente concreta que quiere usar
  # (índice numérico del archivo de aferentes)
  index_in_afferent <<- readline(prompt = "Write the index (number of column) where is placed the desired afferent in its file\n\n>>>")
  index_in_afferent <<- as.numeric(index_in_afferent)
  aff_className <<- readline(prompt = "Write how you wish to call your afferent, its name or label class\n\n>>>")
  
  # Calcula automáticamente el número de disparos de la aferente
  # llamar a funcion que lo calcule, parámetros de entrada el archivo de aferentes y el índice
  aff_spNumber <<- calculate_afferent_spNumber(path_in_afferents,index_in_afferent)
  
  # Pregunta al usuario por el número de trials (árboles de C5.0) (este paso es subceptible a borrarse y que siempre use solo 1 arbol)
  n_trials <<- 1
  
  
  # El sistema usará siempre todas las neuronas del archivo de neuronas y no se podrán elegir
  tmp_units <- read.csv(path_in_neurons)
  neurons_name_pos <<- colnames(tmp_units)
  neurons_involved_pos <<- c(1:length(neurons_name_pos))
  neurons_name_neg <<- colnames(tmp_units)
  neurons_name_neg <<- c(neurons_name_neg,aff_className)
  neurons_involved_neg <<- c(neurons_involved_pos,length(neurons_involved_pos)+1)
  tmp_units <- NULL
  
  n_neurons <<- length(neurons_name_pos)
  isSubset <<- FALSE
  n_neurons_used <<- n_neurons
  n_neurons_total <<- n_neurons
  
  neurons_name_pos_comb <<- neurons_name_pos
  neurons_involved_pos_comb <<- neurons_involved_pos
  neurons_name_neg_comb <<- neurons_name_neg
  neurons_involved_neg_comb <<- neurons_involved_neg
  
  dt_name_index <<- data.frame(name = neurons_name_pos, index = neurons_involved_pos)
  
  global_counter <<- 0
  
  removing_preliminar_units <<-c()
  
  # Carpeta de "output" por defecto para la salida de archivos, donde irán tanto los de correlaciones como los resultados de métricas
  dir.create(path = path_id)
  
  
  ##setting up grapth structure for randomSeeds and recursive workflow
  root <<- Node$new(data_id)
  root$analysis <- list()
  root$analysis[["is_done"]] <- FALSE
  root$analysis[["afferent_className"]] <- aff_className
  root$analysis[["afferent_spikesNumber"]] <- aff_spNumber
  root$analysis[["path_neurons"]] <- path_in_neurons
  root$analysis[["path_afferents"]] <- path_in_afferents
  root$analysis[["index_afferent"]] <- index_in_afferent
  root$analysis[["path_units_pos"]] <- path_in_pos
  root$analysis[["path_units_neg"]] <- path_in_neg
  root$analysis[["names_units_pos"]] <- neurons_name_pos
  root$analysis[["names_units_neg"]] <- neurons_name_neg
  root$analysis[["index_units_pos"]] <- neurons_involved_pos
  root$analysis[["index_units_neg"]] <- neurons_involved_neg
  root$analysis[["n_neurons_total"]] <- n_neurons_total
  global_counter <- global_counter+1
  root$analysis[["global_counter"]] <- global_counter
  root$analysis[["level"]] <- root$level #child will be "father's level + 1"
  root$analysis[["id"]] <- paste0(root$analysis[["global_counter"]],".",root$analysis[["level"]])
  root$analysis[["n_neurons"]] <- n_neurons 
  root$n_neurons <- n_neurons
  root$analysis[["n_neurons_C5.0"]] <- 0 #by default, loaded later with C5.0 fitted model
  root$n_neurons_C5.0 <- NA
  root$analysis[["preprocess_list"]] <- list()
  root$analysis[["fitted_model"]] <- NA #later will be filled
  root$analysis[["predictions_list"]] <- list()
  root$analysis[["evaluation_list"]] <- list() 
  root$analysis[["mat_conf_list_all"]] <- list() #full confusionMatrix object
  root$analysis[["mat_conf_list_short"]] <- list() #just ""interesting"" metrics for out studies
  root$analysis[["dt_metrics"]] <- data.frame()
  root$total_recall <- NA
  root$F1w_total_recall <- NA
  root$analysis[["dt_C50_imp"]] <- data.frame() #data frame generated by c5imp function
  
  
  save_config_list()
  
  return(0)
}


