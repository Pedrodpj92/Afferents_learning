## ---------------------------
##
## File name: main_template_copyme.R
##
## Purpose of file: basic structure to build main files to run analysis
##
## Author: Pedro Del Pozo Jiménez
##
## Date Created: 2020-04-08
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
##   - Check tutorial section in readme about how fill configuration tables and their parameters
##   - If you are in trouble and are not able to run properly, or need some clarifications,
##      or you have suggestions about improvements, please, write us via email (pedrodpj92@gmail.com)
##
## ---------------------------

#remember be sure that the working directory is in the project folder
#because in many points relative paths are used
#check with getwd() and change with setwd()
source("./workflow/workflow_commander.R")

#this will save a log file, if you don't want to save it, comment the following line and
#the last line with the sink() function at the end of this code
# sink("./log_dd-mm-yyyy.txt", append=FALSE, split=TRUE)
# sink() #if the program did a execution with errors, call this function in order to close the log file
sink(paste0("./log_main_template_changeMyName_",gsub(":","-",gsub(" ", "_",Sys.time())),".txt"), append=FALSE, split=TRUE)

#change where you want your data be saved
dir.create("./output/yourOutputDirectory",recursive = TRUE)

##this is the handler who calls each workflow
##See the main parameters of this function:
# - config_data_id: the identifier that you used in configuration tables.
#                   Do not use the reserved word "default" as id, used for "configuration by user" way
# - vec_random_seed: vector of integers that will be used for set seed.
#                     In this example, there are 30, but you can use the vector that you wish
#                     even, just one number, 123 for example
# - wf_calls: workflows that should be done.
#             Options are: randomSeeds, individual, combinatory, recursive, iterative
#             In this template you start without combinatory because it spend a lot of time,
#             but you can add it if you want to perform a combinatory workflow
#             feel free for adapt for your case.
dt_results <- workflow_commander(config_data_id = "id_template_changeMe", #change the name with the proper data_id that you used
                             vec_random_seed = c(1:30)+100,
                             wf_calls = c("randomSeeds","individual",
                                          "recursive","iterative"))

# you can also call several times to workflow_commander and perform many configurations
# in the same script. See examples for inspire you
# dt_results2 <- workflow_commander(config_data_id = "Other_id_that_you_can_change_here",
#                              vec_random_seed = c(1:30)+100,
#                              wf_calls = c("randomSeeds","individual"))

#dt_results is a list which contains structures of each workflow called,
#you can call each structure by its own name of workflow, as following example
# dt_results$randomSeeds
# or
# dt_results$individual

#inside each object for each workflow result, you can access to information and tables
#explore results and save what you wish
# results_mean <- dt_exp$randomSeeds$mean
# or
# results_rankVI_example <- dt_exp$randomSeeds$rank_VI[[1]]

#in following updates, in each workflow will be appear a description of each object returned by the functions

#you can save each data frame using the following lines, copy and adapt them as you prefer
dt_example_output <- dt_results$randomSeeds$mean
write.csv(x = dt_example_output,
          file = paste0("./output/yourOutputDirectory/dt_mean_example.csv"),
          row.names = FALSE,fileEncoding = "UTF-8")

#remember that you can save the working directory (or some objects) in .RData format
save.image("./output/yourOutputDirectory/results_everythingWhatSystemDid.RData")

sink()


