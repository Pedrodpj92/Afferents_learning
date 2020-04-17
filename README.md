# Afferents Learning

Welcome to the repository of Afferents Learning, a system based in machine learning which predicts functional connectivity within neural circuits with unknown connections by analyzing spike trains. Currently, the core uses [C5.0](https://github.com/topepo/C5.0) package and the entire system is written in R.
This software has been developed in the context of the work “Discovering effective connectivity in neural circuits: analysis based on machine learning methodology”, which is not published yet. Proper reference will be provided by the time the paper is finally published.
## Table of contents
  * [Installation](#installation)
  * [How it works](#how-it-works)
    * [About Biological concepts](#about-biological-concepts)
    * [Summary](#summary)
    * [Workflows](#workflows)
  * [Tutorial](#tutorial)
    * [Using configuration by questionnaire](#using-configuration-by-questionnaire)
    * [Using configuration by sheets](#using-configuration-by-sheets)
  * [Configuration parameters](#configuration-parameters)
  * [Examples](#examples)
  * [Contact and authors](#contact-and-authors)
  * [License](#license)


## Installation
Download and install [R](https://cran.r-project.org/). The system was developed under R version 3.6.3 (2020-02-29). [RStudio](https://rstudio.com/products/rstudio/download/) is not mandatory, but highly recommended.

Then, run packages_installer.R, this should install dependencies.
  * [caret](https://cran.r-project.org/web/packages/caret/index.html)
  * [C5.0](https://cran.r-project.org/web/packages/C50/index.html)
  * [data.tree](https://cran.r-project.org/web/packages/data.tree/index.html)
  * [readxl](https://cran.r-project.org/web/packages/readxl/index.html)
  * [openxlsx](https://cran.r-project.org/web/packages/openxlsx/index.html)
  * [plotly](https://cran.r-project.org/web/packages/plotly/index.html)
  * [reproducible](https://cran.r-project.org/web/packages/reproducible/index.html)
  * [compare](https://cran.r-project.org/web/packages/compare/index.html)


## How it works
In this section we explain briefly some biological concepts in order to clarify the aim of this development. Then, how the system works to execute an analysis and after that, in Tutorial section, how can it be used following two different ways.

Afferents Learning is based in a Data Mining development, so we may highlight **some main steps such as Data Preparation, Modeling or Evaluation**. If you wish to explore more details deeply, we recommend [CRISP-DM](https://en.wikipedia.org/wiki/Cross-industry_standard_process_for_data_mining) and the [step-by-step data mining guide](https://www.the-modeling-agency.com/crisp-dm.pdf).

### About Biological concepts
Our current research is focused in the neural circuits located in the dorsal horn of the spinal cord controlling the phenomenon known as primary afferent depolarization and dorsal root reflexes. 
Primary afferents constitute the first element in the nociceptive system. In normal conditions, these neurons are activated when a noxious stimulus reaches the body and they conduct this information from the periphery to the dorsal horn of the spinal cord, so they act as the input element of the circuit. 
However, the primary afferents can be activated centrally by local spinal cord neurons, triggering an antidromic flux of information which can elicit certain physio-pathological processes in peripheral tissue such as neurogenic inflammation or allodynia. In this context, primary afferents act as the output element of the circuit, and this is the context in which we are studying them.
We want to identify the spinal neurons responsible for eliciting the primary afferent backfiring, relying on spike trains recorded from spinal cord neurons and primary afferents in electrophysiological experiments.
However, we consider that this concept can be generalized and the software may be useful to evaluate functional connectivity in any other neural circuit.  

### Summary
**This system uses spike times (in seconds) as input in csv format**. We need two files, one for neurons (Ux in columns) and other for afferents (Rx in columns). In these files, each column contain the spike times (in seconds) for one neuron/afferent. We can find data used in examples in ./data folder similar to following screenshots. Notice "NaN" (Not a Number) values not all the neurons have the same number of spike times but we use table format as input.  Cells of the same row needn't be related. These files cointain NaN instead of "NA" (Not Available for R) because they were generated in MATLAB. 
![units_screenshot](/readme_images/units_example_screenshot.PNG)
![afferents_screenshot](/readme_images/afferents_example_screenshot.PNG)

**Data Preparation** is carried by preprocess module. First we calculate time correlations to obtain positive and negative intervals (further information available in the publication) that will be stored in Excel files as intermediate data. Then, we transform data to something similar to this hypothetical example:

![preprocess_example](/readme_images/preprocess_example.PNG)

Details about this module will be revealed in following updates in its own readme. By now, we only need to know that the right column (R) is the afferent (class or target) and it indicates if there has been an afferent spike or not in any time interval. The left column (t) is a time identifier and the remaining columns (Ux) represent neurons (features or variables) and they store categorical data about the presence or absence of a spike in that specific interval, and the temporal position the spike or spikes occupy in the interval.

In the module called model, used for **Modeling**, C5.0 trains a model using preprocessed data. We chose this algorithm because it belongs to the decision tree family and we wanted to know the rules created to take a decision. It also supports tasks about the selection of most relevant neurons in the dataset.

In evaluate module for **Evaluation**, we use metrics in order to check the quality of the trained model and the data used. Mainly, we focus on MCC (Matthews Correlation Coefficient), precision and recall.

As we told for preprocess module, there are other tasks and implementation details which will be explained in each appropriate readme in following updates.

The analysis can be performed in workflows, designed for different purposes. They are explained in following section.

### Workflows
In order to improve and validate results beyond the direct application of C5.0, we designed several protocols or workflows where the system adopts different procedures. More details than explained below will be extended in workflow readme for next updates.

#### RandomSeeds
The most similar behaviour to the direct application of the algorithm. This workflow uses a vector of integers as random seeds. It will run the analysis as many times as the length of the vector. Then, the system calculates the mean, the standard deviation (SD) and the standard error of the mean (SEM) for each metric.

#### Individual
In this process, the system will train as many models as neurons are contained in the configuration. The output is a table with metrics per neuron, so we can achieve a ratio about how related is each neuron with the afferent. In file metrics_per_neuron.csv located in ./config_parameters folder are saved results for supporting iterative workflow, explained later.

#### Combinatory
This is the heaviest process. It is not recommended if you are in a hurry because the time invested can involve hours or even days. This workflow train as many models as possible combinations of neurons in the dataset. For 13 neurons, for example, 8192 analysis must be carried. Thus, this workflow is not recommended for large numbers of neurons. The goal is to detect the group of neurons that better predicts the primary afferent behaviour.

#### Iterative
As combinatory process can be a waste of computational resources and even not finish in a comprehensive period of time, we present a couple of alternatives. The first one, iterative workflow, is supported by the idea that neurons with best individual metrics will be contained in groups with best metrics. Individual analysis must be carried for a set of neurons before executing this type of workflow. There will be as many analysis as the number of neurons with individual MCC greater than 0. Starting with every neuron with this condition (MCC>0), the workflow removes the worst neuron pointed by the lowest individual MCC in each iteration or step.

#### Recursive
An alternative to iterative workflow. This process relies its strength in how C5.0 uses neurons in generated trees or models. Starting with the whole set of neurons, a first execution defines two groups of neurons under C5.0 criteria. The first group contains those neurons that the model uses to build rules and decisions. The second group contains neurons not used by the model. If the model uses every single neuron in the current analysis, then, the process is forced to place the most used neurons in the first group (top half) and the remaining in the second group (bottom half). For each formed group, a new analysis is carried again. The process is repeated until the group is formed by only one neuron or when the system is not able to fit a model.



## Tutorial
The system has several **parameters** that can be set, such as where **input files** are, the **number of afferents spikes** taken into account or **what neurons should be used** by the system. The full list can be found in [Configuration parameters](#configuration-parameters) section. We define _specific configuration_ as the set of values for each parameter in order to run properly the system.
We present two ways to set those parameters and the type of workflow used.


### Using configuration by questionnaire
In this way, we only need to execute **_main_default.R_** file. Then, **a process will start and the command line will ask to the user about parameters**. It is simpler than configuration by sheets, but we can only use one configuration per run and in each new execution the program will ask again about parameters and workflows. As the process is leaded by its own execution, not more explanations are needed here, but a few considerations must be done:
  * If selection files windows are closed without selecting a file, RStudio should be reset for a proper run next time.
  * Input files should be in a folder inside project directory.
  * Check that the working directory is the same as the project directory.
  * Using this way, every neuron contained in a dataset will be used.
  * If you find any error, doubt, or you have any suggestion, please, write us. This will help to improve the system.
  * Result files, will be stored in ./output folder.
  * Persistent intermediate data with correlations named dt_pos.xlsx and dt_neg.xlsx, are also stored in ./output folder. If you run again main_default.R with different data these intermediate files should be removed from the folder. However, if you want to analyze the same data set, we recommend keeping these files in order to save time and prevent the correlations from executing again.
  * We found some problems in some PC with Windows using RStudio about permissions when directories are created. Run RStudio as administrator or grant permissions properly.
  
### Using configuration by sheets
One of the advantages of this way of use is that we can run several configurations on analysis of different data sets at once and we only need to run the main script with one click when parameters are properly set. However, it may be complex at first and may take time to familiarize with the process. For this reason we presented the previous configuration by questionnaire.

In ./config_parameters folder can be found 3 files in csv format:
  * config_parameters_general.csv
  * config_parameters_in_paths.csv
  * config_parameters_neurons.csv

You have to fill those tables in order to set a specific configuration. They work as 3 _related tables_. We considered the use of a data base, in future versions can be updated, but editing csv files is faster and do not require that the user knows how operate with a data base.

Notice the parameter "data_id". This will identify a specific configuration. The word "default" is reserved and should not be used for this way.

Currently, the tables are filled with parameters used in examples. Every field is required excepting "description" and "notes".

**config_parameters_general.csv**: Some general parameters such as the amount of neurons used or the index of the afferent/target neuron in input files. In this file there should be only one row per specific configuration, so elements in data_id column must not be repeated.

**config_parameters_in_paths.csv**: Stores variables about input and intermediate data location. Notice that paths are relative to the project folder. The system is not tested using complete paths so we cannot ensure a proper working. Make sure that "path_id" column does not contain repeated elements inside this field.

**config_parameters_neurons.csv**: This file has information about the neurons used. In this case, "data_id" elements can be repeated as many times as the number of used neurons for its specific configuration. For example, "experimental_dataset" uses 13 neurons, so 13 occurrences with this identifier should appear in this file.

We recommend exploring [Examples](#examples) section in order to understand better several cases of how to fill these parameters.

When every parameter is set **we need to adapt our own main script file**. **Copy** the file **_main_template_copyme.R_** and adapt it to your configuration. Inside the file you will find comments about how to edit this code.

Make sure that the working directory is the same as the directory project. Use [getwd() and setwd()](https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/getwd) for this task.


## Configuration parameters

We grouped configuration parameters depending on the configuration file where they can be found. No parameter should be unfilled, except "description" and "notes", which are optional.

#### config_parameters_general.csv
  * _data_id_: Identifier of a specific configuration. It must be **unique** in this file. The word "default" is reserved and should not be used.
  * _path_id_: This variable works as a [foregin key](https://en.wikipedia.org/wiki/Foreign_key) to relate information about input data, which is stored in config_parameters_in_paths.csv. This variable can have repeated values in this general table.
  * _index_in_afferent_: Points the column selected in afferents input file (See config_parameters_in_paths.csv).
  * _aff_className_: The label assigned to the column class, just ornamental.
  * _aff_spNumber_: The number of spikes fired by the analyzed target.
  * _n_trials_: The number of trials for boosting used to train a C5.0 model ( [see C5.0 documentation](https://cran.r-project.org/web/packages/C50/C50.pdf) ).
  * _isSubset_: This parameter determines if the configuration uses the whole set of neurons or just a part of it. For example, if our neurons input file has 80 neurons but we only want to use 13 of them. Values are TRUE or FALSE.
  * _n_neurons_used_: The number of neurons involved in the configuration.
  * _n_neurons_total_: The total amount of neurons in the input neuron file. This number should be the same as _n_neurons_used_ if _isSubset_ if FALSE.
  * _description_: Not read by the system, just to help the user about details concerning each configuration. **If it is not empty in a row, should be surrounded by quotes (" ")**
  * _notes_: Not read by the system, just to help the user about the execution or any question that must be taken into account. As description, must be surrounded by quotes. 

#### config_parameters_in_paths.csv
An input folder should exist before running the system.
  * _path_id_: Identifier of input files. Each occurrence must be unique in this file. In general configuration there is a variable which works as foreign key and points to the rows matched in this file.
  * _path_in_neurons_: Relative path to neurons file in csv format.
  * _path_in_afferents_: Relative path to afferents file in csv format.
  * _path_in_pos_: Relative path to positive cases obtained as intermediate file, which stores correlations between the target (used as trigger) and neurons. It is generated by the system and remains after execution. It is recomended to not delete this file if many configurations and runs are carried out for the same neurons file, so correlations only need to be calculated once. The extension of the format should be .xlsx.
  * _path_in_neg_: Quite similar to path_in_pos, but this file stores negative cases, intervals of time where there are not afferent spikes.

#### config_parameters_neurons.csv
  * _data_id_: These parameters relate each neuron with its configuration, so the content of each cell should exist in config_parameters_general.csv file. In this case, elements of this parameter do not need to be unique because the most common situation is that a configuration contains more than one neuron.
  * _neurons_name_pos_: Label or name assigned to each neuron. It is highly recommend that each name matches with the name of related column in input files.
  * _neurons_involved_pos_: Index of each neuron in each sheet for _path_in_pos_ Excel file.
  * _isComb_: Logical value (TRUE/FALSE), indicates if a neuron will be used in the combinatory workflow for its related configuration.



## Examples
In the project folder (./) we can find main scripts which constitute 
several cases of use. Involved datasets has two different origins. The first one is a simulation designed by [Izhikevich](https://www.izhikevich.org/publications/spnet.pdf) and later modified by [Ito et al.](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3216957/). We slightly modified the code and adjusted simulation parameters in order to generate 3 different levels of noise or uncertainty (code will be provided as supplementary material in the related publication). The second one is an original recording from an experiment in our laboratory, obtained from a mice in vitro spinal cord. Details of both simulated and experimental data will be released in future updates.

The next list contains those cases that we used to test the system. Inside each one you can find a wider description:
  * _main_sim_meansPlusIndividuals.R_: RandomSeeds and Individual workflows executed on diverse sets and subsets of simulated neurons with variable degrees of uncertainty.
  * _main_sim_combinatory.R_: Combinatory workflows carried out on small subsets of simulated neurons in different conditions. This process can take an extended period of time, so we do not recommend executing this file if you cannot let the computer working several days.
  * _main_sim_rec_and_iter.R_: Recursive and Iterative workflows on large sets of simulated neurons.
  * _main_experiment.R_: Workflows and executions for experimental dataset (excepting combinatory).
  * _main_experiment_combinatory.R_: Combinatory workflow to use with experimental dataset. We separated this from the rest of workflows of the experiment because of the long time needed to be performed.

Results are saved in ./output directory. Explore each main program in order to see exact folders.

## Contact and authors
#### About development and computational field
  * Pedro del Pozo Jiménez - pedrodpj92@gmail.com

#### About datasets and biological field
  * Javier de Lucas Romero - JavierdeLucas7@hotmail.com

#### About Neurobiology of Pain research group
  * Jose A. Lopez García - josea.lopez@uah.es 

## License
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

[GPLv3](https://choosealicense.com/licenses/gpl-3.0/)
