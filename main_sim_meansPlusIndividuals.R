## ---------------------------
##
## File name: main_sim_meansPlus_individuals.R
##
## Purpose of file: Main program which execute RandomSeeds and Invididual workflows on several simulation datasets.
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
##  - High / medium / low are reference about the amount of noise or uncertainty
##    for a simulation.
##  - 80M --> dataset with 80 neurons, every available neuron
##  - 80NM --> as the previous one, but removing monosynaptic neurons.
##  - 40R --> 40 neruons related to the same circuit and connected with the reference neuron (with the role of afferent)
##  - 40NR --> The remaining neurons, from a disconected subcircuit in correspondence of the reference neuron
##  - 13M --> Selection of 13 neurons of several types of connection on the reference neuron:
##      > 3 monosynaptic
##      > 3 bisynaptic
##      > 3 trisynaptic
##      > 4 external
##  - 13NM --> Selection of 13 neurons, similar to previous one, but without monosynaptic
##      > 4 bisynaptic
##      > 4 trisynaptic
##      > 5 external
##
## ---------------------------


source("./workflow/workflow_commander.R")

# sink("./log_dd-mm-yyyy.txt", append=FALSE, split=TRUE)
# sink() #switch off the log and write on output console as always at the end, see the bottom of this file
sink(paste0("./log_main_sim_meansPlusIndividuals_",gsub(":","-",gsub(" ", "_",Sys.time())),".txt"), append=FALSE, split=TRUE)


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
                               wf_calls = c("randomSeeds","individual"))
high_80M_mean <- high_80M$randomSeeds$mean
high_80M_sd <- high_80M$randomSeeds$sd
high_80M_sem <- high_80M$randomSeeds$sem
high_80M_individual <- high_80M$individual
write.csv(x = high_80M_mean,file = "./output/80M/high/mean.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = high_80M_sd,file = "./output/80M/high/sd.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = high_80M_sem,file = "./output/80M/high/sem.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = high_80M_individual,file = "./output/80M/high/individual.csv",row.names = FALSE,fileEncoding = "UTF-8")

cat("~~~~~~~~~~~~\n")
cat("~~~medium~~~\n")
cat("~~~~~~~~~~~~\n")
dir.create("./output/80M/medium",recursive = TRUE)
medium_80M <- workflow_commander(config_data_id = "80M_medium",
                                 vec_random_seed = c(1:30)+100,
                                 wf_calls = c("randomSeeds","individual"))
medium_80M_mean <- medium_80M$randomSeeds$mean
medium_80M_sd <- medium_80M$randomSeeds$sd
medium_80M_sem <- medium_80M$randomSeeds$sem
medium_80M_individual <- medium_80M$individual
write.csv(x = medium_80M_mean,file = "./output/80M/medium/mean.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = medium_80M_sd,file = "./output/80M/medium/sd.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = medium_80M_sem,file = "./output/80M/medium/sem.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = medium_80M_individual,file = "./output/80M/medium/individual.csv",row.names = FALSE,fileEncoding = "UTF-8")

cat("~~~~~~~~~~~~\n")
cat("~~~~~low~~~~\n")
cat("~~~~~~~~~~~~\n")
dir.create("./output/80M/low",recursive = TRUE)
low_80M <- workflow_commander(config_data_id = "80M_low",
                              vec_random_seed = c(1:30)+100,
                              wf_calls = c("randomSeeds","individual"))
low_80M_mean <- low_80M$randomSeeds$mean
low_80M_sd <- low_80M$randomSeeds$sd
low_80M_sem <- low_80M$randomSeeds$sem
low_80M_individual <- low_80M$individual
write.csv(x = low_80M_mean,file = "./output/80M/low/mean.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = low_80M_sd,file = "./output/80M/low/sd.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = low_80M_sem,file = "./output/80M/low/sem.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = low_80M_individual,file = "./output/80M/low/individual.csv",row.names = FALSE,fileEncoding = "UTF-8")


########80NM -----
cat("#################\n")
cat("#######80NM#######\n")
cat("#################\n")
cat("~~~~~~~~~~~~\n")
cat("~~~~~high~~~\n")
cat("~~~~~~~~~~~~\n")
dir.create("./output/80NM/high",recursive = TRUE)
high_80NM <- workflow_commander(config_data_id = "80NM_high",
                                vec_random_seed = c(1:30)+100,
                                wf_calls = c("randomSeeds","individual"))
high_80NM_mean <- high_80NM$randomSeeds$mean
high_80NM_sd <- high_80NM$randomSeeds$sd
high_80NM_sem <- high_80NM$randomSeeds$sem
high_80NM_individual <- high_80NM$individual
write.csv(x = high_80NM_mean,file = "./output/80NM/high/mean.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = high_80NM_sd,file = "./output/80NM/high/sd.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = high_80NM_sem,file = "./output/80NM/high/sem.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = high_80NM_individual,file = "./output/80NM/high/individual.csv",row.names = FALSE,fileEncoding = "UTF-8")

cat("~~~~~~~~~~~~\n")
cat("~~~medium~~~\n")
cat("~~~~~~~~~~~~\n")
dir.create("./output/80NM/medium",recursive = TRUE)
medium_80NM <- workflow_commander(config_data_id = "80NM_medium",
                                  vec_random_seed = c(1:30)+100,
                                  wf_calls = c("randomSeeds","individual"))
medium_80NM_mean <- medium_80NM$randomSeeds$mean
medium_80NM_sd <- medium_80NM$randomSeeds$sd
medium_80NM_sem <- medium_80NM$randomSeeds$sem
medium_80NM_individual <- medium_80NM$individual
write.csv(x = medium_80NM_mean,file = "./output/80NM/medium/mean.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = medium_80NM_sd,file = "./output/80NM/medium/sd.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = medium_80NM_sem,file = "./output/80NM/medium/sem.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = medium_80NM_individual,file = "./output/80NM/medium/individual.csv",row.names = FALSE,fileEncoding = "UTF-8")

cat("~~~~~~~~~~~~\n")
cat("~~~~~low~~~~\n")
cat("~~~~~~~~~~~~\n")
dir.create("./output/80NM/low",recursive = TRUE)
low_80NM <- workflow_commander(config_data_id = "80NM_low",
                               vec_random_seed = c(1:30)+100,
                               wf_calls = c("randomSeeds","individual"))
low_80NM_mean <- low_80NM$randomSeeds$mean
low_80NM_sd <- low_80NM$randomSeeds$sd
low_80NM_sem <- low_80NM$randomSeeds$sem
low_80NM_individual <- low_80NM$individual
write.csv(x = low_80NM_mean,file = "./output/80NM/low/mean.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = low_80NM_sd,file = "./output/80NM/low/sd.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = low_80NM_sem,file = "./output/80NM/low/sem.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = low_80NM_individual,file = "./output/80NM/low/individual.csv",row.names = FALSE,fileEncoding = "UTF-8")


########40R -----
cat("#################\n")
cat("#######40R######\n")
cat("#################\n")
cat("~~~~~~~~~~~~\n")
cat("~~~~~high~~~\n")
cat("~~~~~~~~~~~~\n")
dir.create("./output/40R/high",recursive = TRUE)
high_40R <- workflow_commander(config_data_id = "40R_high",
                               vec_random_seed = c(1:30)+100,
                               wf_calls = c("randomSeeds","individual"))
high_40R_mean <- high_40R$randomSeeds$mean
high_40R_sd <- high_40R$randomSeeds$sd
high_40R_sem <- high_40R$randomSeeds$sem
high_40R_individual <- high_40R$individual
write.csv(x = high_40R_mean,file = "./output/40R/high/mean.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = high_40R_sd,file = "./output/40R/high/sd.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = high_40R_sem,file = "./output/40R/high/sem.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = high_40R_individual,file = "./output/40R/high/individual.csv",row.names = FALSE,fileEncoding = "UTF-8")

cat("~~~~~~~~~~~~\n")
cat("~~~medium~~~\n")
cat("~~~~~~~~~~~~\n")
dir.create("./output/40R/medium",recursive = TRUE)
medium_40R <- workflow_commander(config_data_id = "40R_medium",
                                 vec_random_seed = c(1:30)+100,
                                 wf_calls = c("randomSeeds","individual"))
medium_40R_mean <- medium_40R$randomSeeds$mean
medium_40R_sd <- medium_40R$randomSeeds$sd
medium_40R_sem <- medium_40R$randomSeeds$sem
medium_40R_individual <- medium_40R$individual
write.csv(x = medium_40R_mean,file = "./output/40R/medium/mean.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = medium_40R_sd,file = "./output/40R/medium/sd.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = medium_40R_sem,file = "./output/40R/medium/sem.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = medium_40R_individual,file = "./output/40R/medium/individual.csv",row.names = FALSE,fileEncoding = "UTF-8")

cat("~~~~~~~~~~~~\n")
cat("~~~~~low~~~~\n")
cat("~~~~~~~~~~~~\n")
dir.create("./output/40R/low",recursive = TRUE)
low_40R <- workflow_commander(config_data_id = "40R_low",
                              vec_random_seed = c(1:30)+100,
                              wf_calls = c("randomSeeds","individual"))
low_40R_mean <- low_40R$randomSeeds$mean
low_40R_sd <- low_40R$randomSeeds$sd
low_40R_sem <- low_40R$randomSeeds$sem
low_40R_individual <- low_40R$individual
write.csv(x = low_40R_mean,file = "./output/40R/low/mean.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = low_40R_sd,file = "./output/40R/low/sd.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = low_40R_sem,file = "./output/40R/low/sem.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = low_40R_individual,file = "./output/40R/low/individual.csv",row.names = FALSE,fileEncoding = "UTF-8")



########40NR -----
cat("#################\n")
cat("######40NR######\n")
cat("#################\n")
cat("~~~~~~~~~~~~\n")
cat("~~~~high~~~~\n")
cat("~~~~~~~~~~~~\n")
dir.create("./output/40NR/high",recursive = TRUE)
high_40NR <- workflow_commander(config_data_id = "40NR_high",
                                vec_random_seed = c(1:30)+100,
                                wf_calls = c("randomSeeds","individual"))
high_40NR_mean <- high_40NR$randomSeeds$mean
high_40NR_sd <- high_40NR$randomSeeds$sd
high_40NR_sem <- high_40NR$randomSeeds$sem
high_40NR_individual <- high_40NR$individual
write.csv(x = high_40NR_mean,file = "./output/40NR/high/mean.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = high_40NR_sd,file = "./output/40NR/high/sd.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = high_40NR_sem,file = "./output/40NR/high/sem.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = high_40NR_individual,file = "./output/40NR/high/individual.csv",row.names = FALSE,fileEncoding = "UTF-8")

cat("~~~~~~~~~~~~\n")
cat("~~~medium~~~\n")
cat("~~~~~~~~~~~~\n")
dir.create("./output/40NR/medium",recursive = TRUE)
medium_40NR <- workflow_commander(config_data_id = "40NR_medium",
                                  vec_random_seed = c(1:30)+100,
                                  wf_calls = c("randomSeeds","individual"))
medium_40NR_mean <- medium_40NR$randomSeeds$mean
medium_40NR_sd <- medium_40NR$randomSeeds$sd
medium_40NR_sem <- medium_40NR$randomSeeds$sem
medium_40NR_individual <- medium_40NR$individual
write.csv(x = medium_40NR_mean,file = "./output/40NR/medium/mean.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = medium_40NR_sd,file = "./output/40NR/medium/sd.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = medium_40NR_sem,file = "./output/40NR/medium/sem.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = medium_40NR_individual,file = "./output/40NR/medium/individual.csv",row.names = FALSE,fileEncoding = "UTF-8")

cat("~~~~~~~~~~~~\n")
cat("~~~~~low~~~~\n")
cat("~~~~~~~~~~~~\n")
dir.create("./output/40NR/low",recursive = TRUE)
low_40NR <- workflow_commander(config_data_id = "40NR_low",
                               vec_random_seed = c(1:30)+100,
                               wf_calls = c("randomSeeds","individual"))
low_40NR_mean <- low_40NR$randomSeeds$mean
low_40NR_sd <- low_40NR$randomSeeds$sd
low_40NR_sem <- low_40NR$randomSeeds$sem
low_40NR_individual <- low_40NR$individual
write.csv(x = low_40NR_mean,file = "./output/40NR/low/mean.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = low_40NR_sd,file = "./output/40NR/low/sd.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = low_40NR_sem,file = "./output/40NR/low/sem.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = low_40NR_individual,file = "./output/40NR/low/individual.csv",row.names = FALSE,fileEncoding = "UTF-8")


########13R -----
cat("#################\n")
cat("#######13M#######\n")
cat("#################\n")
cat("~~~~~~~~~~~~\n")
cat("~~~~high~~~~\n")
cat("~~~~~~~~~~~~\n")
dir.create("./output/13M/high",recursive = TRUE)
high_13M <- workflow_commander(config_data_id = "13M_high",
                               vec_random_seed = c(1:30)+100,
                               wf_calls = c("randomSeeds","individual"))
high_13M_mean <- high_13M$randomSeeds$mean
high_13M_sd <- high_13M$randomSeeds$sd
high_13M_sem <- high_13M$randomSeeds$sem
high_13M_individual <- high_13M$individual
write.csv(x = high_13M_mean,file = "./output/13M/high/mean.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = high_13M_sd,file = "./output/13M/high/sd.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = high_13M_sem,file = "./output/13M/high/sem.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = high_13M_individual,file = "./output/13M/high/individual.csv",row.names = FALSE,fileEncoding = "UTF-8")

cat("~~~~~~~~~~~~\n")
cat("~~~medium~~~\n")
cat("~~~~~~~~~~~~\n")
dir.create("./output/13M/medium",recursive = TRUE)
medium_13M <- workflow_commander(config_data_id = "13M_medium",
                                 vec_random_seed = c(1:30)+100,
                                 wf_calls = c("randomSeeds","individual"))
medium_13M_mean <- medium_13M$randomSeeds$mean
medium_13M_sd <- medium_13M$randomSeeds$sd
medium_13M_sem <- medium_13M$randomSeeds$sem
medium_13M_individual <- medium_13M$individual
write.csv(x = medium_13M_mean,file = "./output/13M/medium/mean.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = medium_13M_sd,file = "./output/13M/medium/sd.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = medium_13M_sem,file = "./output/13M/medium/sem.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = medium_13M_individual,file = "./output/13M/medium/individual.csv",row.names = FALSE,fileEncoding = "UTF-8")

cat("~~~~~~~~~~~~\n")
cat("~~~~~low~~~~\n")
cat("~~~~~~~~~~~~\n")
dir.create("./output/13M/low",recursive = TRUE)
low_13M <- workflow_commander(config_data_id = "13M_low",
                              vec_random_seed = c(1:30)+100,
                              wf_calls = c("randomSeeds","individual"))
low_13M_mean <- low_13M$randomSeeds$mean
low_13M_sd <- low_13M$randomSeeds$sd
low_13M_sem <- low_13M$randomSeeds$sem
low_13M_individual <- low_13M$individual
write.csv(x = low_13M_mean,file = "./output/13M/low/mean.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = low_13M_sd,file = "./output/13M/low/sd.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = low_13M_sem,file = "./output/13M/low/sem.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = low_13M_individual,file = "./output/13M/low/individual.csv",row.names = FALSE,fileEncoding = "UTF-8")



########13NM -----
cat("#################\n")
cat("######13NM#######\n")
cat("#################\n")
cat("~~~~~~~~~~~~\n")
cat("~~~~high~~~~\n")
cat("~~~~~~~~~~~~\n")
dir.create("./output/13NM/high",recursive = TRUE)
high_13NM <- workflow_commander(config_data_id = "13NM_high",
                                vec_random_seed = c(1:30)+100,
                                wf_calls = c("randomSeeds","individual"))
high_13NM_mean <- high_13NM$randomSeeds$mean
high_13NM_sd <- high_13NM$randomSeeds$sd
high_13NM_sem <- high_13NM$randomSeeds$sem
high_13NM_individual <- high_13NM$individual
write.csv(x = high_13NM_mean,file = "./output/13NM/high/mean.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = high_13NM_sd,file = "./output/13NM/high/sd.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = high_13NM_sem,file = "./output/13NM/high/sem.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = high_13NM_individual,file = "./output/13NM/high/individual.csv",row.names = FALSE,fileEncoding = "UTF-8")

cat("~~~~~~~~~~~~\n")
cat("~~~medium~~~\n")
cat("~~~~~~~~~~~~\n")
dir.create("./output/13NM/medium",recursive = TRUE)
medium_13NM <- workflow_commander(config_data_id = "13NM_medium",
                                  vec_random_seed = c(1:30)+100,
                                  wf_calls = c("randomSeeds","individual"))
medium_13NM_mean <- medium_13NM$randomSeeds$mean
medium_13NM_sd <- medium_13NM$randomSeeds$sd
medium_13NM_sem <- medium_13NM$randomSeeds$sem
medium_13NM_individual <- medium_13NM$individual
write.csv(x = medium_13NM_mean,file = "./output/13NM/medium/mean.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = medium_13NM_sd,file = "./output/13NM/medium/sd.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = medium_13NM_sem,file = "./output/13NM/medium/sem.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = medium_13NM_individual,file = "./output/13NM/medium/individual.csv",row.names = FALSE,fileEncoding = "UTF-8")

cat("~~~~~~~~~~~~\n")
cat("~~~~~low~~~~\n")
cat("~~~~~~~~~~~~\n")
dir.create("./output/13NM/low",recursive = TRUE)
low_13NM <- workflow_commander(config_data_id = "13NM_low",
                               vec_random_seed = c(1:30)+100,
                               wf_calls = c("randomSeeds","individual"))
low_13NM_mean <- low_13NM$randomSeeds$mean
low_13NM_sd <- low_13NM$randomSeeds$sd
low_13NM_sem <- low_13NM$randomSeeds$sem
low_13NM_individual <- low_13NM$individual
write.csv(x = low_13NM_mean,file = "./output/13NM/low/mean.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = low_13NM_sd,file = "./output/13NM/low/sd.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = low_13NM_sem,file = "./output/13NM/low/sem.csv",row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = low_13NM_individual,file = "./output/13NM/low/individual.csv",row.names = FALSE,fileEncoding = "UTF-8")



###ending analysis -----
cat("Ending analysis, saving data in working space in .RData format.....\n")
save.image()
Sys.sleep(10)

sink()


