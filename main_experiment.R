## ---------------------------
##
## File name: main_experiment.R
##
## Purpose of file: run several analysis about the experimental dataset
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
##   
##
## ---------------------------

source("./workflow/workflow_commander.R")
# sink("./log_dd-mm-yyyy.txt", append=FALSE, split=TRUE)
# sink() #switch off the log and write on output console as always at the end, see the bottom of this file
sink(paste0("./log_main_experiment_",gsub(":","-",gsub(" ", "_",Sys.time())),".txt"), append=FALSE, split=TRUE)


cat("~~~~~~~~~~~~\n")
cat("~~~~~EXP~~~~\n")
cat("~~~~~~~~~~~~\n")
dir.create("./output/experiment",recursive = TRUE)
dt_exp <- workflow_commander(config_data_id = "experimental_dataset",
                             vec_random_seed = c(10,1:9,11:30)+100,
                             wf_calls = c("randomSeeds","individual",
                                          "recursive","iterative"))
#30 times repeating
dt_exp_mean <- dt_exp$randomSeeds$mean
write.csv(x = dt_exp_mean,
          file = paste0("./output/experiment/dt_mean.csv"),
          row.names = FALSE,fileEncoding = "UTF-8")
dt_exp_sd <- dt_exp$randomSeeds$sd
write.csv(x = dt_exp_sd,
          file = paste0("./output/experiment/dt_sd.csv"),
          row.names = FALSE,fileEncoding = "UTF-8")
dt_exp_sem <- dt_exp$randomSeeds$sem
write.csv(x = dt_exp_sem,
          file = paste0("./output/experiment/dt_sem.csv"),
          row.names = FALSE,fileEncoding = "UTF-8")

#direct
dt_exp_direct <- dt_exp$randomSeeds$seeds[[1]]
dt_exp_direct <- cbind(name=dt_exp_mean$subset,dt_exp_direct)
write.csv(x = dt_exp_direct,
          file = paste0("./output/experiment/dt_direct.csv"),
          row.names = FALSE,fileEncoding = "UTF-8")

#individual
dt_exp_individual <- dt_exp$individual
write.csv(x = dt_exp_individual,
          file = paste0("./output/experiment/dt_individual.csv"),
          row.names = FALSE,fileEncoding = "UTF-8")


#recursive
dt_exp_recursive <- dt_exp$recursive
write.csv(x = dt_exp_recursive,
          file = paste0("./output/experiment/dt_recursive.csv"),
          row.names = FALSE,fileEncoding = "UTF-8")

#iterative
dt_exp_iterative <- dt_exp$iterative
write.csv(x = dt_exp_iterative,
          file = paste0("./output/experiment/dt_iterative.csv"),
          row.names = FALSE,fileEncoding = "UTF-8")

##This experimental datasets shows a big standard deviation, probably caused by
##some neurons unrelated with the afferent, in order to ensure clear conclusions,
##we run excepcionally 30 times the iterative workflow...

dir.create("./output/experiment/iterative_repetitions",recursive = TRUE)
results_iterative <- list()
vec_seeds <- c(10,1:9,11:30)+100
results_individuals <- workflow_commander(config_data_id = "experimental_dataset",
                                          vec_random_seed = vec_seeds,
                                          wf_calls = c("individual"))
dt_mcc <- data.frame(it=na.omit(
  rev(
    as.character(
      results_individuals$individual[results_individuals$individual$MCC>0.0,c("Name")]
    )
  )
))
dt_precision <- dt_mcc
dt_recall <- dt_mcc


for(i in 1:length(vec_seeds)){
  print("iteration: ")
  print(i)
  results_iterative[[i]] <- workflow_commander(config_data_id = "experimental_dataset",
                                               vec_random_seed = vec_seeds[i],
                                               wf_calls = c("iterative"))
  
  
  dt_mcc <- cbind(dt_mcc,results_iterative[[i]]$iterative$mcc)
  dt_precision <- cbind(dt_precision,results_iterative[[i]]$iterative$precision)
  dt_recall <- cbind(dt_mcc,results_iterative[[i]]$iterative$recall)
  
}

colnames(dt_mcc) <- c("names",paste0("V",as.character(1:30)))
colnames(dt_precision) <- c("names",paste0("V",as.character(1:30)))
colnames(dt_recall) <- c("names",paste0("V",as.character(1:30)))

# mean_mcc <- rowMeans(dt_mcc[,c(2:length(dt_mcc))])
mean_mcc <- apply(dt_mcc[,c(2:length(dt_mcc))],1,mean)
mean_precision <- apply(dt_precision[,c(2:length(dt_precision))],1,mean)
mean_recall <- apply(dt_recall[,c(2:length(dt_recall))],1,mean)

#sem
# function(x){sd(x)/sqrt(length(x))}
sem_mcc <- apply(dt_mcc[,c(2:length(dt_mcc))],1,function(x){sd(x)/sqrt(length(x))})
sem_precision <- apply(dt_precision[,c(2:length(dt_precision))],1,function(x){sd(x)/sqrt(length(x))})
sem_recall <- apply(dt_recall[,c(2:length(dt_recall))],1,function(x){sd(x)/sqrt(length(x))})


print("min")
print(tmp_min <- min(mean_mcc))
print("max")
print(tmp_max <- max(mean_mcc))
plot(c(1:length(mean_mcc)),
     rev(mean_mcc),
     type = 'l',ylim = c(tmp_min-0.05,tmp_max+0.05))

dt_mcc_total <- cbind(dt_mcc, mean_mcc=mean_mcc,
                      sem_mcc=sem_mcc)
dt_precision_total <- cbind(dt_precision, mean_precision=mean_precision,
                            sem_precision=sem_precision)
dt_recall_total <- cbind(dt_recall, mean_recall=mean_recall,
                         sem_recall=sem_recall)

write.csv(x = dt_mcc_total,
          file = paste0("./output/experiment/iterative_repetitions/mcc.csv"),
          row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = dt_precision_total,
          file = paste0("./output/experiment/iterative_repetitions/precision.csv"),
          row.names = FALSE,fileEncoding = "UTF-8")
write.csv(x = dt_recall_total,
          file = paste0("./output/experiment/iterative_repetitions/recall.csv"),
          row.names = FALSE,fileEncoding = "UTF-8")

save.image("./output/experiment/dt_results_experiment.RData")


sink()
