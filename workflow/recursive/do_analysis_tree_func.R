## ---------------------------
##
## File name: do_analysis_tree_func.R
##
## Purpose of file: wrapper recursive function for recursive.R. May be used in other calls
##
## Author: Pedro Del Pozo Jiménez
##
## Date Created: 2019-11-05
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
##   
##   
## ---------------------------


library(data.tree)
library(reproducible)
library(compare)
file.sources = list.files(c("./preprocess",
                            "./model",
                            "./predict",
                            "./evaluate",
                            "./auxiliary_functs"), 
                          pattern="*.R$", full.names=TRUE, 
                          ignore.case=TRUE)
sapply(file.sources,source,.GlobalEnv)
# source("./auxiliary_functs/list2dt_metrics.R")

prepare_node <- function(tree_node, father_node){
  #father_node, hierarchy
  tree_node$analysis <- Copy(father_node$analysis)
  tree_node$analysis[["is_done"]] <- FALSE
  # tree_node$analysis[["afferent_className"]] #same as father
  # tree_node$analysis[["afferent_spikesNumber"]]
  # tree_node$analysis[["path_units_pos"]]
  # tree_node$analysis[["path_units_neg"]]
  
  tree_node$analysis[["names_units_pos"]] <- c()#reset, later will be added
  tree_node$analysis[["names_units_neg"]] <- c()
  
  tree_node$analysis[["index_units_pos"]] <- c()
  tree_node$analysis[["index_units_neg"]] <- c()
  
  tree_node$analysis[["level"]] <- as.numeric(father_node$level)+1 #child will be "father's level + 1"
  
  if(exists("global_counter")){
    global_counter <<- global_counter+1
    tree_node$analysis[["global_counter"]] <- global_counter
    #equilvalent to "$name"
    tree_node$analysis[["id"]] <- paste0(tree_node$analysis[["level"]],".",tree_node$analysis[["global_counter"]])
  }
  
  tree_node$analysis[["n_neurons"]] <- NA #depends on the experiment, ncol - class_col - t (time)
  tree_node$n_neurons <- NA
  tree_node$analysis[["n_neurons_C5.0"]] <- 0 #by default, loaded later with C5.0 fitted model
  tree_node$list_neurons_C5.0 <- NA
  tree_node$n_neurons_C5.0 <- NA
  tree_node$analysis[["preprocess_list"]] <- list()
  tree_node$analysis[["fitted_model"]] <- NA #later will be filled
  tree_node$analysis[["predictions_list"]] <- list()
  tree_node$analysis[["evaluation_list"]] <- list() 
  tree_node$analysis[["mat_conf_list_all"]] <- list() #full confusionMatrix object
  tree_node$analysis[["mat_conf_list_short"]] <- list() #just ""interesting"" metrics for out studies
  tree_node$analysis[["dt_metrics"]] <- data.frame()
  tree_node$total_recall <- NA
  tree_node$F1w_total_recall <- NA
  tree_node$precision_completo <- NA
  tree_node$precision_snap <- NA
  # tree_node$f1_snap <- NA
  tree_node$f1_completo <- NA
  tree_node$mcc_snap <- NA
  tree_node$mcc_completo <- NA
  tree_node$analysis[["dt_C50_imp"]] <- data.frame() #data frame generated by c5imp function
  
  tree_node$analysis[["threshold_metric"]] <- 100.00 #by default, there is no threshold
  # tree_node$analysis[["threshold_metric"]] <- 1.00 #by default, there is no threshold
}


do_analysis_tree_func <- function(tree_node,random_seed=123,do_recursive=TRUE,n_trials=1){
  #container list
  analysis <- tree_node$analysis
  
  #two main actions:
  #current analysis:
  # preprocess
  # model
  # predictions
  # evaluation
  # whatever...
  #split neurons and call for children (with ""most"" important neurons and ""less"" ones)
  #load general data from father into each child
  #do calls for each one
  
  #change this maximum if you have an incredible huge amount of neurons in your input
  if(analysis[["level"]]>50){
    warning("breaking possible infinite recursion at level 50, watch out the code and/or the data used")
    stop("stopping...")
    return(-1)
  }
  
  
  list_preprocess <- tryCatch({
    do_preprocess(path_neurons = analysis[["path_neurons"]],
                  path_afferents= analysis[["path_afferents"]],
                  index_afferent=analysis[["index_afferent"]],
                  path_in_pos =  analysis[["path_units_pos"]],
                  neurons_name_pos = analysis[["names_units_pos"]],
                  neurons_involved_pos = analysis[["index_units_pos"]],
                  path_in_neg = analysis[["path_units_neg"]],
                  neurons_name_neg = analysis[["names_units_neg"]],
                  neurons_involved_neg = analysis[["index_units_neg"]],
                  afferent_name = analysis[["afferent_className"]],
                  saveData=FALSE,
                  n_spikes_afferent = analysis[["afferent_spikesNumber"]],
                  random_seed = random_seed)
    
    
  },
  error=function(cond){
    message("data could not be preprocessed")
    message(paste0("may not be suitable data in node with id ",tree_node$name, " parent: ", tree_node$parent$name))
    message("may not there be spikes in any unit neuron?")
    message(cond)
    message("\n")
    return(NULL)
  }
  )
  if(is.null(list_preprocess)){
    return(NULL)
  }
  
  tree_node$analysis[["preprocess_list"]] <- list_preprocess
  
  dt_completo <- list_preprocess[[1]]
  dt_snap <- list_preprocess[[2]]
  df_tr <- list_preprocess[[3]]
  df_vl <- list_preprocess[[4]]
  
  checking_bal_data <- check_balance(dt = dt_snap, node = tree_node)
  tree_node$balanced_data <- checking_bal_data[[1]]
  tree_node$n_pos <- checking_bal_data[[2]]
  tree_node$n_neg <- checking_bal_data[[3]]
  
  fitted_model <- do_model(dt_tr = df_tr,
                           dt_complete_factors = dt_completo,
                           with_cost_mat = TRUE, n_trials = n_trials)
  tree_node$analysis[["fitted_model"]] <- fitted_model
  print(summary(fitted_model))
  
  list_predictions <- do_predict(fitted_model, list_preprocess)
  tree_node$analysis[["predictions_list"]] <- list_predictions
  
  list_evaluated <- do_evaluation(list_in = list_predictions,total_n = tree_node$analysis[["afferent_spikesNumber"]]) # DEPENDS ON Rx!
  tree_node$analysis[["evaluation_list"]] <- list_evaluated
  
  dt_metrics <- list2dt_metrics(list_evaluated,TRUE)
  tree_node$analysis[["dt_metrics"]] <- dt_metrics
  
  list_all_confMat <- list()
  for(iterator in 1:length(list_evaluated)){
    
    list_all_confMat[[names(list_evaluated)[iterator]]] <- list_evaluated[[iterator]]$confMat
  }
  tree_node$analysis[["mat_conf_list"]] <- list_all_confMat
  
  
  list_just_cf <- list()
  for(iterator in 1:length(list_all_confMat)){
    element <- list_all_confMat[[iterator]][["confMat"]][["table"]]
    element_dt <- data.frame(element[,1])
    element_dt <- cbind(element_dt,element[,2])
    element_dt <- cbind(c("0","1"),element_dt)
    
    colnames(element_dt) <- c("pred\\orig","0","1")
    rownames(element_dt) <- c("0","1")
    list_just_cf[[names(list_all_confMat)[iterator]]] <- element_dt
  }
  tree_node$analysis[["mat_conf_list_short"]] <- list_just_cf
  
  
  #TRY-CATCH FOR ERRORS LIKE "MODEL RESPONSES NO ALWAYS"
  importancia_C50 <- tryCatch({
    tree_node$analysis[["dt_C50_imp"]] <- C5imp(fitted_model)
    # C5imp(fitted_model)
    
  },
  error=function(cond){
    message("no model fitted with this data input")
    message(paste0("problems in node with id ",tree_node$name, " parent: ", tree_node$parent$name))
    message(cond)
    message("\n")
    return(NULL)
  }
  )
  
  if(!is.null(importancia_C50)){
    
    importancia_C50_pos <- rownames(importancia_C50)[1:length(importancia_C50[importancia_C50$Overall>0,])]
    
    if(length(importancia_C50_pos)<nrow(importancia_C50)){
      importancia_C50_neg <- rownames(importancia_C50)[(length(importancia_C50[importancia_C50$Overall>0,])+1):nrow(importancia_C50)]
    }
    else{
      importancia_C50_neg <- NA
    }
    tree_node$analysis[["n_neurons_C5.0"]] <- length(importancia_C50_pos)
    tree_node$list_neurons_C5.0 <- paste0(importancia_C50_pos,collapse = ", ")
    tree_node$n_neurons_C5.0 <- length(importancia_C50_pos)
    
    
    cat("###########\n")
    print(tree_node$analysis[["id"]])
    cat(paste0("neurons at input: ",tree_node$analysis[["n_neurons"]],"\n"))
    cat(paste0("neurons used for modeling: ",tree_node$analysis[["n_neurons_C5.0"]],"\n"))
    cat("metrics: \n")
    print(dt_metrics[,c("dataset","accuracy","precision","recall","mcc")])
    cat("confusion matrix of snap dataset: \n")
    print(list_just_cf[["snap"]])
    cat("c5imp: \n")
    print(importancia_C50)
    cat("----------\n")
    
    
    
    analysis[["is_done"]] <- TRUE
    
    #CAREFULL, AD-HOC FOR EACH CASE, WE SELECT RECALL2/TOTAL_RECALL IN SNAP DATASET, BUT COULD BE WHAT YOU CONSIDERED BETTER
    dt_tmp_metrics <- tree_node$analysis[["dt_metrics"]]
    threshold_metric <- dt_tmp_metrics[2,"recall2"] #for still calling to next child analysis or not, later
    # tree_node$total_recall <- round(as.numeric(threshold_metric)*100,3)
    # tree_node$total_recall <- round(as.numeric(threshold_metric),3)
    tree_node$total_recall <- as.numeric(threshold_metric)
    # tree_node$F1w_total_recall <- round(as.numeric(dt_tmp_metrics[2,"f1score2"])*100,3)
    # tree_node$F1w_total_recall <- round(as.numeric(dt_tmp_metrics[2,"f1score2"]),3)
    tree_node$F1w_total_recall <- as.numeric(dt_tmp_metrics[2,"f1score2"])
    
    
    # tree_node$precision_snap <- round(as.numeric(dt_tmp_metrics[2,"precision"])*100,3)
    # # tree_node$f1_snap <- round(as.numeric(dt_tmp_metrics[2,"f1score2"])*100,3)
    # tree_node$precision_snap <- round(as.numeric(dt_tmp_metrics[2,"precision"]),3)
    tree_node$precision_snap <- as.numeric(dt_tmp_metrics[2,"precision"])
    # tree_node$f1_snap <- round(as.numeric(dt_tmp_metrics[2,"f1score2"]),3)
    
    # tree_node$precision_completo <- round(as.numeric(dt_tmp_metrics[1,"precision"])*100,3)
    # tree_node$f1_completo <- round(as.numeric(dt_tmp_metrics[1,"f1score2"])*100,3)
    # tree_node$precision_completo <- round(as.numeric(dt_tmp_metrics[1,"precision"]),3)
    # tree_node$f1_completo <- round(as.numeric(dt_tmp_metrics[1,"f1score2"]),3)
    tree_node$precision_completo <- as.numeric(dt_tmp_metrics[1,"precision"])
    tree_node$f1_completo <- as.numeric(dt_tmp_metrics[1,"f1score2"])
    
    # tree_node$mcc_snap <- round(as.numeric(dt_tmp_metrics[2,"mcc"])*100,3)
    # tree_node$mcc_completo <- round(as.numeric(dt_tmp_metrics[1,"mcc"])*100,3)
    # tree_node$mcc_snap <- round(as.numeric(dt_tmp_metrics[2,"mcc"]),3)
    # tree_node$mcc_completo <- round(as.numeric(dt_tmp_metrics[1,"mcc"]),3)
    tree_node$mcc_snap <- as.numeric(dt_tmp_metrics[2,"mcc"])
    tree_node$mcc_completo <- as.numeric(dt_tmp_metrics[1,"mcc"])
    
    
    tree_node$analysis[["threshold_metric"]] <- threshold_metric
    
    #if there are more than 5 neurons used (better neurons) and nothing at other side (worse neurons), divide between 2 groups: top half and bottom half
    
    #special case, just 5 neurons in "good neurons" and nothing in "bad neurons" split 2 best neurons and 3 worst
    
    if(length(importancia_C50_neg)==1){
      if(is.na(importancia_C50_neg)){
        if(length(importancia_C50_pos)>5){ #get half top rank and half bottom rank
          if(length(importancia_C50_pos)%%2==0){
            importancia_C50_neg <- importancia_C50_pos[c((length(importancia_C50_pos)/2+1):length(importancia_C50_pos))]
            importancia_C50_pos <- importancia_C50_pos[c(1:(length(importancia_C50_pos)/2))]
          } else if(length(importancia_C50_pos)%%2==1){
            importancia_C50_neg <- importancia_C50_pos[c((length(importancia_C50_pos)/2+1.5):length(importancia_C50_pos))]
            importancia_C50_pos <- importancia_C50_pos[c(1:(length(importancia_C50_pos)/2+0.5))]
          } else{
            stop("this path should not be go down")
          }
          #next lines could be used similar as previous case, but... we may alter what to do in those specific cases
        } else if(length(importancia_C50_pos)==5){
          importancia_C50_neg <- importancia_C50_pos[c(3,4,5)]
          importancia_C50_pos <- importancia_C50_pos[c(1,2)] #for instance, we decided 3 neurons for "better choice" instead of 2
        } else if(length(importancia_C50_pos)==4){ #in case of 4, 2 and 2
          importancia_C50_neg <- importancia_C50_pos[c(3,4)]
          importancia_C50_pos <- importancia_C50_pos[c(1,2)]
        } else if(length(importancia_C50_pos)==3){
          importancia_C50_neg <- importancia_C50_pos[c(2,3)]
          importancia_C50_pos <- importancia_C50_pos[c(1)]
        } else if(length(importancia_C50_pos)==2){ #in case of 2, 1 and 1
          importancia_C50_neg <- importancia_C50_pos[c(2)]
          importancia_C50_pos <- importancia_C50_pos[c(1)]
        }
      }
    }
    
    #no more children if current node has less than 1 input neurons (units)
    if(tree_node$analysis[["n_neurons"]]>=1){
      # current_level <- tree_node$analysis[["level"]]
      # next_level <- current_level+1
      # if(threshold_metric>0.05){#continue just when current analysis is still worth
      if(threshold_metric>0){ #off, in future versions maybe can be a input parameter or something like that
        importancia_C50_pos <- importancia_C50_pos[order(importancia_C50_pos)]
        
        better_child <- tree_node$AddChild(paste0((as.numeric(tree_node$level)+1),".",(global_counter+1)))
        saved_better_child_name <- paste0((as.numeric(tree_node$level)+1),".",(global_counter+1))
        prepare_node(better_child,tree_node)
        better_child$analysis[["names_units_pos"]] <- importancia_C50_pos
        better_child$analysis[["names_units_neg"]] <- c(importancia_C50_pos,better_child$analysis[["afferent_className"]])
        better_child$analysis[["n_neurons"]] <- length(importancia_C50_pos)
        better_child$n_neurons <- length(importancia_C50_pos)
        
        
        # neurons_ranking <- dt_name_index[match(dt_neurons_ranking$Name, dt_name_index$name),2]
        ##now, dependency with config_loader function, but at least we can use the labels (names) of neurons that we wish 
        index_tmp <- dt_name_index[match(importancia_C50_pos, dt_name_index$name),2]
        ##old, dependencies with labels and indexes
        # index_tmp <- gsub('U','',importancia_C50_pos)
        # index_tmp <- as.integer(index_tmp)
        better_child$analysis[["index_units_pos"]] <- index_tmp
        #dependency with the neurons used, if it is a subset, the index will not correspond with the afferent index
        # indexClass <- tree_node$analysis[["index_units_neg"]][length(tree_node$analysis[["index_units_neg"]])]
        indexClass <- tree_node$analysis[["n_neurons_total"]]+1
        better_child$analysis[["index_units_neg"]] <- c(index_tmp,indexClass)
        
        if(!tree_node$isRoot){
          #comparing for remove a child with the exactly same results, which means that are the same analysis
          comparison <- compare(tree_node$parent$analysis[["dt_metrics"]],
                                tree_node$analysis[["dt_metrics"]],allowAll=TRUE)
          aux_bool <- !comparison$result
        } else{
          aux_bool <-TRUE
        }
        
        if(better_child$analysis[["n_neurons"]]>=1 & aux_bool){
          cat("~~~~~\n")
          cat(paste0("printing better child from node ",tree_node$analysis[["id"]],"\n"))
          cat("Names:\n")
          print(better_child$analysis[["names_units_pos"]])
          # cat("indexes:\n")
          # print(better_child$analysis[["index_units_pos"]])
          cat("~~~~~\n")
          
          cat("running better child...\n")
          if(do_recursive){
            do_analysis_tree_func(tree_node = better_child,random_seed = random_seed)
          }
          
          #comparing for remove a child with the exactly same results, which means that are the same analysis
          comparison <- compare(better_child$analysis[["dt_metrics"]],
                                tree_node$analysis[["dt_metrics"]],allowAll=TRUE)
          
          if(comparison$result & !tree_node$isRoot){
            cat(paste0("removing better child, id: ", saved_better_child_name,"\n"))
            cat(paste0("cause: same metrics or duplicated leaf reached \n"))
            tree_node$RemoveChild(saved_better_child_name)
            global_counter <<- global_counter-1
          }
        } else{
          cat(paste0("removing better child, id: ", saved_better_child_name,"\n"))
          cat(paste0("cause: same metrics or duplicated leaf reached \n"))
          tree_node$RemoveChild(saved_better_child_name)
          global_counter <<- global_counter-1
        }
        
        if(length(importancia_C50_neg)>=1 & !is.na(importancia_C50_neg[1])){
          
          worse_child <- tree_node$AddChild(paste0((as.numeric(tree_node$level)+1),".",(global_counter+1)))
          saved_worse_child_name <- paste0((as.numeric(tree_node$level)+1),".",(global_counter+1))
          prepare_node(worse_child,tree_node)
          
          importancia_C50_neg <- importancia_C50_neg[order(importancia_C50_neg)]
          
          worse_child$analysis[["names_units_pos"]] <- importancia_C50_neg
          worse_child$analysis[["names_units_neg"]] <- c(importancia_C50_neg,worse_child$analysis[["afferent_className"]])
          worse_child$analysis[["n_neurons"]] <- length(importancia_C50_neg)
          worse_child$n_neurons <- length(importancia_C50_neg)
          
          
          
          # neurons_ranking <- dt_name_index[match(dt_neurons_ranking$Name, dt_name_index$name),2]
          ##now, dependency with config_loader function, but at least we can use the labels (names) of neurons that we wish 
          index_tmp <- dt_name_index[match(importancia_C50_neg, dt_name_index$name),2]
          ##old, dependencies with labels and indexes
          # index_tmp <- gsub('U','',importancia_C50_neg)
          # index_tmp <- as.integer(index_tmp)
          
          worse_child$analysis[["index_units_pos"]] <- index_tmp
          # indexClass <- tree_node$analysis[["index_units_neg"]][length(tree_node$analysis[["index_units_neg"]])]
          indexClass <- tree_node$analysis[["n_neurons_total"]]+1
          worse_child$analysis[["index_units_neg"]] <- c(index_tmp,indexClass)
          
          if(!tree_node$isRoot){
            #comparing for remove a child with the exactly same results, which means that are the same analysis
            comparison <- compare(tree_node$parent$analysis[["dt_metrics"]],
                                  tree_node$analysis[["dt_metrics"]],allowAll=TRUE)
            aux_bool <- !comparison$result
          } else{
            aux_bool <-TRUE
          }
          
          if(worse_child$analysis[["n_neurons"]]>=1 & aux_bool){
            cat("~~~~~\n")
            cat(paste0("printing worse child from node ",tree_node$analysis[["id"]],"\n"))
            cat("Names:\n")
            print(worse_child$analysis[["names_units_pos"]])
            # cat("indexes:\n")
            # print(worse_child$analysis[["index_units_pos"]])
            cat("~~~~~\n")
            
            
            cat("running worse child...\n")
            if(do_recursive){
              do_analysis_tree_func(tree_node = worse_child,random_seed = random_seed)
            }
            #comparing for remove a child with the exactly same results, which means that are the same analysis
            comparison <- compare(better_child$analysis[["dt_metrics"]],
                                  tree_node$analysis[["dt_metrics"]],allowAll=TRUE)
            
            if(comparison$result & !tree_node$isRoot){
              # cat(paste0("removing child ", saved_worse_child_name,"\n"))
              cat(paste0("removing worse child, id: ", saved_worse_child_name,"\n"))
              cat(paste0("cause: same metrics or duplicated leaf reached \n"))
              tree_node$RemoveChild(saved_worse_child_name)
              global_counter <<- global_counter-1
            }
            
          } else{
            # cat(paste0("removing child ", saved_worse_child_name,"\n"))
            cat(paste0("removing worse child, id: ", saved_worse_child_name,"\n"))
            cat(paste0("cause: same metrics or duplicated leaf reached\n"))
            tree_node$RemoveChild(saved_worse_child_name)
            global_counter <<- global_counter-1
            
          }
        }
      }
    } else{
      print(paste0("threshold reached, no more children from this node, id: ", tree_node$name))
    }
  }
  
  return(0)
}





