## ---------------------------
##
## File name: main_rec_and_iter.R
##
## Purpose of file: Main program which execute Recursive and Iterative workflows on several simulation datasets.
##
## Author: Pedro Del Pozo Jiménez
##
## Date Created: 2020-02-14
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

# sink("./log_dd-mm-yyyy.txt", append=FALSE, split=TRUE)
# sink() #switch off the log and write on output console as always at the end, see the bottom of this file
sink(paste0("./log_main_sim_rec_and_iter_",gsub(":","-",gsub(" ", "_",Sys.time())),".txt"), append=FALSE, split=TRUE)


########80M -----
cat("#################\n")
cat("#######80M#######\n")
cat("#################\n")
cat("~~~~~~~~~~~~\n")
cat("~~~~~high~~~\n")
cat("~~~~~~~~~~~~\n")
dir.create("./output/80M/high",recursive = TRUE)
high_80M <- workflow_commander(config_data_id = "80M_high",
                             vec_random_seed = c(1:30)+100,
                             wf_calls = c("iterative","recursive"))
high_80M_iterative <- low_80M$iterative
high_80M_recursive <- low_80M$recursive

write.csv(x = high_80M_iterative,
          file = paste0("./output/80M/high/dt_iterative.csv"),
          row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = high_80M_recursive,
          file = paste0("./output/80M/high/dt_recursive.csv"),
          row.names = FALSE,fileEncoding = "UTF-8")


cat("~~~~~~~~~~~~\n")
cat("~~~~~low~~~~\n")
cat("~~~~~~~~~~~~\n")
dir.create("./output/80M/low",recursive = TRUE)
low_80M <- workflow_commander(config_data_id = "80M_low",
                               vec_random_seed = c(1:30)+100,
                               wf_calls = c("iterative","recursive"))
low_80M_iterative <- low_80M$iterative
low_80M_recursive <- low_80M$recursive

write.csv(x = low_80M_iterative,
          file = paste0("./output/80M/low/dt_iterative.csv"),
          row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = low_80M_recursive,
          file = paste0("./output/80M/low/dt_recursive.csv"),
          row.names = FALSE,fileEncoding = "UTF-8")


###ending analysis -----
cat("Ending analysis, saving data in working space in .RData format.....\n")
save.image()
Sys.sleep(10)

sink()
