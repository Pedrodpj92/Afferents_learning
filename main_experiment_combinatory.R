## ---------------------------
##
## File name: main_experiment_combinatory.R
##
## Purpose of file: run combinatory workflow on the experimental dataset
##
## Author: Pedro Del Pozo Jiménez
##
## Date Created: 2020-03-04
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
##   - this execution has been separated from the rest of workflows due to his large time needed to perform
##
## ---------------------------

source("./workflow/workflow_commander.R")
# sink("./log_dd-mm-yyyy.txt", append=FALSE, split=TRUE)
# sink() #switch off the log and write on output console as always at the end, see the bottom of this file
sink(paste0("./log_main_experiment__combinatory",gsub(":","-",gsub(" ", "_",Sys.time())),".txt"), append=FALSE, split=TRUE)

cat("~~~~~~~~~~~~\n")
cat("~~~~~EXP~~~~\n")
cat("~~~~~~~~~~~~\n")
dt_exp <- workflow_commander(config_data_id = "experimental_dataset",
                             vec_random_seed = c(10,1:9,11:30)+100,
                             wf_calls = c("combinatory"),
                             cut_specific_neurons = TRUE)
dir.create("./output/experiment/combinatory",recursive = TRUE)
dt_exp_combinatory <- dt_exp$combinatory
dt_exp_combinatory <- dt_exp_combinatory[order(-dt_exp_combinatory$mcc_complete),]
dt_exp_combinatory <- dt_exp_combinatory[,c(1:4,11,5,7)]
colnames(dt_exp_combinatory) <- c("neurons_set","neurons_set_C50","n_neurons","n_neurons_C50",
                                      "precision","recall","mcc")
write.csv(x = dt_exp_combinatory,
          file = paste0("./output/experiment/combinatory/dt_combinatory.csv"),
          row.names = FALSE,fileEncoding = "UTF-8")
save.image("./output/experiment/combinatory/dt_results_combinatory_experiment.RData")

sink()
