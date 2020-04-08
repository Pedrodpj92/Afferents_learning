## ---------------------------
##
## File name: main_sim_combinatory.R
##
## Purpose of file: Main program which execute combinatory workflows on several simulation datasets.
##
## Author: Pedro Del Pozo Jiménez
##
## Date Created: 2020-01-20
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
##   - Combinatory process may spend several hours, even days, watch out the warning
##      when program asks you.
##   - Only small subsets can be handle by this workflow because a huge amount of 
##      analysis are needed, as many as combinations of set of neurons can be found
##   - 13 Neurons will need 8192 analysis,
##      but the number can arise to millions using between 20 to 30 neurons
## ---------------------------

source("./workflow/workflow_commander.R")

# sink("./log_dd-mm-yyyy.txt", append=FALSE, split=TRUE)
# sink() #switch off the log and write on output console as always at the end, see the bottom of this file
sink(paste0("./log_main_sim_combinatory",gsub(":","-",gsub(" ", "_",Sys.time())),".txt"), append=FALSE, split=TRUE)

########13M high 1 trial -----
cat("#################\n")
cat("########13M######\n")
cat("#################\n")
cat("~~~~~~~~~~~~\n")
cat("~~~~~high~~~~~\n")
cat("~~~~~~~~~~~~\n")
cat("~~~1_trial~~\n")
cat("~~~~~~~~~~~~\n")
dir.create("./output/combinatory/13M/high/1_trial",recursive = TRUE)
high_13M_1t_results <- workflow_commander(config_data_id = "13M_high",
                                     vec_random_seed = 123,
                                     wf_calls = c("combinatory"),
                                     cut_specific_neurons = TRUE,
                                     path_output_comb_file = "./output/combinatory/13M/high/1_trial/comb_13M_high_1t.csv",
                                     n_trials = 1)
high_13M_1t <- high_13M_1t_results$combinatory
high_13M_1t <- high_13M_1t[order(-high_13M_1t$mcc_complete),]
high_13M_1t <- high_13M_1t[,c(1:4,11,5,7)]
colnames(high_13M_1t) <- c("neurons_set","neurons_set_C50","n_neurons","n_neurons_C50",
                            "precision","recall","mcc")
write.csv(x = high_13M_1t,
      file = "./output/combinatory/13M/high/1_trial/results_13M_high_1t.csv",
      row.names = FALSE,fileEncoding = "UTF-8")

########13M high 5 trials -----
cat("#################\n")
cat("######13M########\n")
cat("#################\n")
cat("~~~~~~~~~~~~\n")
cat("~~~~high~~~~\n")
cat("~~~~~~~~~~~~\n")
cat("~~~5_trial~~\n")
cat("~~~~~~~~~~~~\n")
dir.create("./output/combinatory/13M/high/5_trial",recursive = TRUE)
high_13M_5t_results <- workflow_commander(config_data_id = "13M_high_5t",
                                           vec_random_seed = 123,
                                           wf_calls = c("combinatory"),
                                           cut_specific_neurons = TRUE,
                                           path_output_comb_file = "./output/combinatory/13M/high/5_trial/comb_13M_high_5t.csv",
                                           n_trials = 5)
high_13M_5t <- high_13M_5t_results$combinatory
high_13M_5t <- high_13M_5t[order(-high_13M_5t$mcc_complete),]
high_13M_5t <- high_13M_5t[,c(1:4,11,5,7)]
colnames(high_13M_5t) <- c("neurons_set","neurons_set_C50","n_neurons","n_neurons_C50",
                            "precision","recall","mcc")
write.csv(x = high_13M_5t,
          file = "./output/combinatory/13M/high/5_trial/results_13M_high_5t.csv",
          row.names = FALSE,fileEncoding = "UTF-8")

########13M low 1 trial -----
cat("#################\n")
cat("#######13M#######\n")
cat("#################\n")
cat("~~~~~~~~~~~~\n")
cat("~~~~~low~~~~\n")
cat("~~~~~~~~~~~~\n")
cat("~~~1_trial~~\n")
cat("~~~~~~~~~~~~\n")
dir.create("./output/combinatory/13M/low/1_trial",recursive = TRUE)
low_13M_1t_results <- workflow_commander(config_data_id = "13M_low",
                                           vec_random_seed = 123,
                                           wf_calls = c("combinatory"),
                                           cut_specific_neurons = TRUE,
                                           path_output_comb_file = "./output/combinatory/13M/low/1_trial/comb_13M_low_1t.csv",
                                           n_trials = 1)
low_13M_1t <- low_13M_1t_results$combinatory
low_13M_1t <- low_13M_1t[order(-low_13M_1t$mcc_complete),]
low_13M_1t <- low_13M_1t[,c(1:4,11,5,7)]
colnames(low_13M_1t) <- c("neurons_set","neurons_set_C50","n_neurons","n_neurons_C50",
                            "precision","recall","mcc")
write.csv(x = low_13M_1t,
          file = "./output/combinatory/13M/low/1_trial/results_13M_low_1t.csv",
          row.names = FALSE,fileEncoding = "UTF-8")

########13M low 5 trials -----
cat("#################\n")
cat("######13M########\n")
cat("#################\n")
cat("~~~~~~~~~~~~\n")
cat("~~~~~low~~~~~\n")
cat("~~~~~~~~~~~~\n")
cat("~~~5_trial~~\n")
cat("~~~~~~~~~~~~\n")
dir.create("./output/combinatory/13M/low/5_trial",recursive = TRUE)
low_13M_5t_results <- workflow_commander(config_data_id = "13M_low_5t",
                                           vec_random_seed = 123,
                                           wf_calls = c("combinatory"),
                                           cut_specific_neurons = TRUE,
                                           path_output_comb_file = "./output/combinatory/13M/low/5_trial/comb_13M_low_5t.csv",
                                           n_trials = 5)
low_13M_5t <- low_13M_5t_results$combinatory
low_13M_5t <- low_13M_5t[order(-low_13M_5t$mcc_complete),]
low_13M_5t <- low_13M_5t[,c(1:4,11,5,7)]
colnames(low_13M_5t) <- c("neurons_set","neurons_set_C50","n_neurons","n_neurons_C50",
                            "precision","recall","mcc")
write.csv(x = low_13M_5t,
          file = "./output/combinatory/13M/low/5_trial/results_13M_low_5t.csv",
          row.names = FALSE,fileEncoding = "UTF-8")

########13NM high 1 trial -----
cat("#################\n")
cat("######13NM#######\n")
cat("#################\n")
cat("~~~~~~~~~~~~\n")
cat("~~~~high~~~~\n")
cat("~~~~~~~~~~~~\n")
cat("~~~1_trial~~\n")
cat("~~~~~~~~~~~~\n")
dir.create("./output/combinatory/13NM/high/1_trial",recursive = TRUE)
high_13NM_1t_results <- workflow_commander(config_data_id = "13NM_high",
                                           vec_random_seed = 123,
                                           wf_calls = c("combinatory"),
                                           cut_specific_neurons = TRUE,
                                           path_output_comb_file = "./output/combinatory/13NM/high/1_trial/comb_13NM_high_1t.csv",
                                           n_trials = 1)
high_13NM_1t <- high_13NM_1t_results$combinatory
high_13NM_1t <- high_13NM_1t[order(-high_13NM_1t$mcc_complete),]
high_13NM_1t <- high_13NM_1t[,c(1:4,11,5,7)]
colnames(high_13NM_1t) <- c("neurons_set","neurons_set_C50","n_neurons","n_neurons_C50",
                            "precision","recall","mcc")
write.csv(x = high_13NM_1t,
          file = "./output/combinatory/13NM/high/1_trial/results_13NM_high_1t.csv",
          row.names = FALSE,fileEncoding = "UTF-8")

########13NM low 1 trial-----
cat("#################\n")
cat("######13NM######\n")
cat("#################\n")
cat("~~~~~~~~~~~~\n")
cat("~~~~~low~~~~~\n")
cat("~~~~~~~~~~~~\n")
cat("~~~1_trial~~\n")
cat("~~~~~~~~~~~~\n")
dir.create("./output/combinatory/13NM/low/1_trial",recursive = TRUE)
low_13NM_1t_results <- workflow_commander(config_data_id = "13NM_low",
                                           vec_random_seed = 123,
                                           wf_calls = c("combinatory"),
                                           cut_specific_neurons = TRUE,
                                           path_output_comb_file = "./output/combinatory/13NM/low/1_trial/comb_13NM_low_1t.csv",
                                           n_trials = 1)
low_13NM_1t <- low_13NM_1t_results$combinatory
low_13NM_1t <- low_13NM_1t[order(-low_13NM_1t$mcc_complete),]
low_13NM_1t <- low_13NM_1t[,c(1:4,11,5,7)]
colnames(low_13NM_1t) <- c("neurons_set","neurons_set_C50","n_neurons","n_neurons_C50",
                            "precision","recall","mcc")
write.csv(x = low_13NM_1t,
          file = "./output/combinatory/13NM/low/1_trial/results_13NM_low_1t.csv",
          row.names = FALSE,fileEncoding = "UTF-8")


cat("Ending analysis, saving data in working space in .RData format.....\n")
save.image()
Sys.sleep(10)

sink()


