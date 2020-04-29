## ---------------------------
##
## File name: main_default.R
##
## Purpose of file: alternative way to run analysis when parameters are asked to user instead of load from tables
##
## Author: Pedro Del Pozo Jiménez
##
## Date Created: 2020-03-16
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

source("./workflow/workflow_commander.R")
source("./workflow/individual/check_and_clean_individuals.R")

cat("############################################################################\n")
cat("#Welcome to Afferents_learning system, this is the assistant user procedure#\n")
cat("#                            ~main_default.R~                              #\n")
cat("############################################################################\n\n")
Sys.sleep(2)
cat("The system will ask you about parameter configuration, such as the type of analysis (workflow) or input data that you wish to use\n")
Sys.sleep(1)
cat("If you have any problem or suggestion, please, send us an email to pedrodpj92@gmail.com\n")
readline(prompt = "\nPress \"INTRO\" key to continue...\n")


# Pregunta al usuario por un "prefijo" que se añadirá a los archivos de resultados generados. (Ej.: "test25" --> test25_individuales.csv)

prefix_files <- readline(prompt = "Write a prefix that will be placed at the begining of output files' names\n For example: \"test_25\" -> \"test_25_individuals.csv\" \n>>>")
seeds_used <- readline(prompt = "Please, select a seed for random selections (any integer that you wish, for example, 123)\n>>>")
seeds_used <- as.integer(seeds_used)

add_randomSeeds <- readline(prompt = "Do you wish to run the \'30 times\' base case with different seeds? [Y/n]\n>>>")
add_iterative <- readline(prompt = "Do you wish to run the iterative workflow? [Y/n]\n>>>")
add_recursive <- readline(prompt = "Do you wish to run the recursive workflow? [Y/n]\n>>>")
add_combinatory <- readline(prompt = "Do you wish to run the combinatory workflow? [Y/n]\n>>>")

path_id <- "./output"
check_and_clean_individuals(data_id = "default",path_metrics_per_neuron = "./config_parameters/metrics_per_neuron.csv")

wf_calls_required <- c("randomSeeds","individual")


wf_extra_calls <- c()
if(tolower(add_randomSeeds)=="y"){
  add_randomSeeds <- TRUE
  # wf_extra_calls <- c(wf_extra_calls,"randomSeeds")
  # seeds_used <- c(1:30)+100
  seeds_used <- c(seeds_used,c(2:30)+100)
} else {
  add_randomSeeds <- FALSE
}
if(tolower(add_iterative)=="y"){
  add_iterative <- TRUE
  wf_calls_required <- c(wf_calls_required,"iterative")
} else {
  add_iterative <- FALSE
}
if(tolower(add_recursive)=="y"){
  add_recursive <- TRUE
  wf_calls_required <- c(wf_calls_required,"recursive")
} else {
  add_recursive <- FALSE
}
if(tolower(add_combinatory)=="y"){
  add_combinatory <- TRUE
  wf_calls_required <- c(wf_calls_required,"combinatory")
} else {
  add_combinatory <- FALSE
}



# El sistema realiza por defecto análisis directo e individuales.
# Del resto pregunta al usuario (30 semillas, iterativo, recursivo, combinatoria)

# Las únicas salidas por ahora serán los archivos de correlaciones, las métricas de los análisis solicitados (precisión, recall y mcc) y un guardado de imagen de datos de R (extensión .RData) con el espacio de trabajo, todo en la carpeta output antes mencionada.

# Por ahora el sistema no sacará ninguna gráfica.

# Se podrá optar tanto por esta forma de ejecución descrita como por la ya existente usando las tablas de configuración.

dt_results <- workflow_commander(config_data_id = "default",
                                         vec_random_seed = seeds_used,
                                         wf_calls = wf_calls_required,
                                         path_output_comb_file = "./output/combinatory_tmp.csv",
                                         cut_specific_neurons = TRUE)
dt_results_direct <- dt_results$randomSeeds$seeds[[1]]
dt_results_individual <- dt_results$individual
write.csv(x = dt_results_direct,
          file = paste0(path_id,"/",prefix_files,"_C5.0_base.csv"),
          row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = dt_results_individual,
          file = paste0(path_id,"/",prefix_files,"_individuals.csv"),
          row.names = FALSE,fileEncoding = "UTF-8")

if(add_randomSeeds){
  dt_results_mean <- dt_results$randomSeeds$mean
  dt_results_sd <- dt_results$randomSeeds$sd
  dt_results_sem <- dt_results$randomSeeds$sem
  write.csv(x = dt_results_mean,
            file = paste0(path_id,"/",prefix_files,"_mean.csv"),
            row.names = FALSE,fileEncoding = "UTF-8")
  write.csv(x = dt_results_sd,
            file = paste0(path_id,"/",prefix_files,"_sd.csv"),
            row.names = FALSE,fileEncoding = "UTF-8")
  write.csv(x = dt_results_sem,
            file = paste0(path_id,"/",prefix_files,"_sem.csv"),
            row.names = FALSE,fileEncoding = "UTF-8")
}

if(add_iterative){
  dt_results_iterative <- dt_results$iterative
  write.csv(x = dt_results_iterative,
            file = paste0(path_id,"/",prefix_files,"_iterative.csv"),
            row.names = FALSE,fileEncoding = "UTF-8")
}

if(add_recursive){
  dt_results_recursive <- dt_results$recursive
  write.csv(x = dt_results_recursive,
            file = paste0(path_id,"/",prefix_files,"_recursive.csv"),
            row.names = FALSE,fileEncoding = "UTF-8")
}

if(add_combinatory){
  dt_results_combinatory <- dt_results$combinatory
  dt_results_combinatory <- dt_results_combinatory[order(-dt_results_combinatory$mcc_complete),]
  dt_results_combinatory <- dt_results_combinatory[,c(1:4,11,5,7)]
  colnames(dt_results_combinatory) <- c("neurons_set","neurons_set_C50","n_neurons","n_neurons_C50",
                                            "precision","recall","mcc")
  write.csv(x = dt_results_combinatory,
            file = paste0(path_id,"/",prefix_files,"_combinatory.csv"),
            row.names = FALSE,fileEncoding = "UTF-8")
}

save.image("./output/data_results_default.RData")


