# Afferents Learning

Welcome to the repository of Afferents Learning, a system based in machine learning which predicts afferent spikes and detects what neurons are related. Currently, the core uses [C5.0](https://github.com/topepo/C5.0) package and the entire system is written in R.

## Table of contents
  * [Installation](#installation)
  * [How it works](#how-it-works)
    * [About Biological concepts](about-biological-concepts)
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
In this section we will explain (as briefly as we can) some biological concepts in order to clarify the aim of this development. Then, how the system works to execute an analysis and after that, in Tutorial section, how the user can use it following two different ways.

Afferents Learning is based in a Data Mining development, so we may highlight **some main steps such as Data Preparation, Modeling or Evaluation**. If you wish to explore more details deeply, we recommend [CRISP-DM](https://en.wikipedia.org/wiki/Cross-industry_standard_process_for_data_mining) and the [step-by-step data mining guide](https://www.the-modeling-agency.com/crisp-dm.pdf).

### About Biological concepts
Under construction...

### Summary
**This system uses spike neuron times (in seconds) as input in csv format**. We need two files, one for neurons (Ux in columns) and other for afferents (Rx in columns). We can found data used in examples in ./data folder. Similar to following screenshots. Notice "NaN" (Not a Number) values because neurons have not the same number of spike times but we use table format as input. Those files has NaN instead of "NA" (Not Available for R) because files' origin is MATLAB. Cells of the same row needn't be related. Each column stores every spike time of its neuron/afferent.
![units_screenshot](/readme_images/units_example_screenshot.PNG)
![afferents_screenshot](/readme_images/afferents_example_screenshot.PNG)

**Data Preparation** is carried by preprocess module. First we calculate time correlations and store it in Excel format as intermediate data. Then, we transform data to something similar to this hypothetical example:
![preprocess_example](/readme_images/preprocess_example.PNG)

Details about this module will be revealed in following updates in its own readme. By now, we only need to know that the right column (R) is the afferent (class or target) and it indicates if there is afferent spike or not in an interval of time, the left column (t) is an identifier and the remaining columns (Ux) are neurons (features or variables) and they keep categorical data which meaning is the time among neuron spike and a trigger (the ocurrence or not of afferent spike).

In the module called model, used for **Modeling**, C5.0 trains a model using preprocessed data. We chose this algorithm because it belongs to decision tree family and we prioritize that models can explain why take a decision. It also supports tasks about the selection of most relevant neurons in the dataset.

In evaluate module for **Evaluation**, we use metrics in order to check the quality of the trained model and the data used. Mainly, we focus on MCC (Matthews Correlation Coefficient), precision and recall.

As we told for preprocess module, there are other tasks and implementation details which will be explained in each appropiate readme in following updates.

The analysis can be used in workflows, designed for different purposes. They are explained in following section.

### Workflows
In order to improve and validate results beyond the direct application of C5.0, we design several protocols or workflows where the system adopts different procedures. More details than explained bellow will be extended in workflow readme for next updates.

#### RandomSeeds
The most similar behaviour as the direct application of the algorithm. This workflow can use a vector of integers in order to use it as random seeds. It will run the analysis as many times as the length of the vector. Then, the system calculates the mean, the standard deviation (SD) and the standard error of the mean (SEM) for each metric.

#### Individual
In this process, the system will train as many models as neurons are used in the configuration. The output is a table with metrics per neuron, so we can achieve a ratio about how related is each neuron with the afferent. In file metrics_per_neuron.csv placed in ./config_parameters folder are saved results for support iterative workflow, explained later.

#### Combinatory
This is the most heavy process. It is nor recommended if you are in a hurry because the time invested can be involve from minutes to hours or even days. This workflow train as many models as combinations of neurons are in the dataset configuration. For 13 neurons, for example, 8192 analysis must be carried. Thus, this workflow is not recommended for large number of neurons. The goal is to achieve what are the best neurons involved in the afferent behaviour.

#### Iterative
Because combinatory process can waste computational resources and even can not finish in a comprehensive period of time, we present a couple of alternatives. The first one, iterative workflow, is supported by the idea of neurons with the best individual metrics will achieve the best metrics as a group. So individual analysis must be carried for a configuration before execute this type of workflow. There will be as many analysis as the number of neurons with individual MCC greater than 0. Starting with every neuron with this condition (MCC>0), the workflow removes the worst neuron pointed by the lowest individual MCC in each iteration or step.

#### Recursive
An alternative to iterative workflow. This process relies its strength in how C5.0 uses neurons in generated tree or models. Starting with the whole set of neurons, a first execution defines two groups of neurons under C5.0 criteria. The first group contains those neurons that the model uses to build rules and decisions. The second group conteins neurons not used by the model. If the model uses every single neuron in the current analysis, then, the process is forced to place the most used neurons in first group (top half) and the remaing in the second group (bottom half). For each formed group, a new analysis is carried again. The process is repeated until an analysis arrives to a single neuron or the system is not able to fit a model.



## Tutorial
The system has several **parameters** that can be setted such as where **input files** are, the **number of afferents spikes** taken into account or **what neurons should be used** by the system. The full list can be found in [Configuration parameters](#configuration-parameters) section. We define _specific configuration_ as the set of values for each parameter in order to run properly the system.
We present two ways to set those parameters and the type of workflow used.


### Using configuration by questionnaire
In this way, we only need to execute **_main_default.R_** file. Then, **a process will start and the command line will ask to the user about parameters**. It is simpler than configuration by sheets, but we can only use one configuration per run and in each new execution the program will ask again about parameters and workflows. As the process is leaded by its own execution, not more explanations are needed here, but a few considerations must be done:
  * If selection files windows are closed without selecting a file, RStudio may should be reset for a proper run next time.
  * Input files should be in a folder inside project directory, as configuration_parameters_in_path previous explanation. Input files placed out of the directory project.
  * Check that the working directory is the same as the project directory, as explained in the other way of using.
  * Using this way, every neuron of a dataset will be used.
  * If you find any error, doubt, or you have any suggestion, please, write us. This will help to improve the system.
  * Persistent intermediate data with correlations, as well as results, are stored in ./output folder. Remember to move firstly those intermediate files if you run again main_default.R and chose different input files. If you run again main_default.R but with the same input files, the system can reuse intermediate files in order to save some time.
  * We found problems in some PC with Windows using RStudio about permisions when directories are created. Run RStudio as administrator or grant permisions properly.
  
### Using configuration by sheets
One of the advantages of this way of use is that we can run several configurations at once and we only need to run a main script with one click when parameters are setted. However, it may be complex at first and may spend time until we familiarize ourselves with the process. For this reason we presented the previous configuration by questionnaire.

In ./config_parameters folder can be found 3 files in csv format:
  * config_parameters_general.csv
  * config_parameters_in_paths.csv
  * config_parameters_neurons.csv

We have to fill those tables in order to set an specific configuration. They work as a 3 _related tables_. We considered the use of a data base, in future versions can be updated, but editting csv files are faster and not require that the user knows how operate with a data base.

Notice the parameter "data_id". This will be the one who identify an specific configuration. The word "default" is reserved and should not be used for this way.

Currently tables are filled with parameters used in examples. Every field is required excepts "description" and "notes".

**config_parameters_general.csv**: Some general parameters such as the amount of neurons used or the index of the afferent target in input files. In this file we should have only one row per specific configuration, so elements in data_id column must not be repeated.

**config_parameters_in_paths.csv**: Stores variables about input and intermediate data locations. Notice that paths are relative from the project folder. The system are not tested using complete paths so we can not ensure a proper working. Be sure that "path_id" column does not contains repeated elements inside this field.

**config_parameters_neurons.csv**: This file has information about neurons used. In this case, "data_id" elements can be repeated as many times as the number of used neurons for its specific configuration. "experimental_dataset" for example uses 13 neurons, so 13 occurrences with this identifier should appear in this file.

We recommend explore [Examples](#examples) section in order to understand better several cases of how to fill those parameters.

When every parameter is setted **we need to adapt our own main script file**. **Copy** the file **_main_template_copyme.R_** and adapt with your configuration. Inside the file you will find comments about how manage this code.

Be sure that the working directory is the same as the directory project. Use [getwd() and setwd()](https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/getwd) for this task.


## Configuration parameters

We group those parameters depending on the configuration file where we can find them. No parameter should be unfilled, except "description" and "notes", which are optionals.

#### config_parameters_general.csv
  * _data_id_: Identifier of an specific configuration. It must be **unique** in this file. The word "default" is reserved and should not be used.
  * _path_id_: This variable works as a [foregin key](https://en.wikipedia.org/wiki/Foreign_key) to relate information about input data, which information is stored in config_parameters_in_paths.csv. This variable can has repeated values in this general table.
  * _index_in_afferent_: Points the column selected in afferents input file (See config_parameters_in_paths.csv).
  * _aff_className_: The label assigned to the column class, just ornamental.
  * _aff_spNumber_: The number of spikes produced by analyzed afferent.
  * _n_trials_: The number of trials for boosting used for train a C5.0 model ( [see C5.0 documentation](https://cran.r-project.org/web/packages/C50/C50.pdf) ).
  * _isSubset_: This parameters points if the configuration uses the whole set of neurons or part of it. For example, if our neurons input file has 80 neurons, but we only wish to use 13 of them. Values are TRUE or FALSE.
  * _n_neurons_used_: The number of neurons involved in the configuration.
  * _n_neurons_total_: The total amount of neurons in the input neuron file. This number should be the same as _n_nuerons_used_ if _isSubset_ if FALSE.
  * _description_: Not readed by the system, just for help to the user about details for each configuration. **If it is not empty in a row, should be surrounded by quotes (" ")**
  * _notes_: Not readed by the system, just for help to the user about the execution or any question that must be taken into account. As description, must be surrounded by quotes. 

#### config_parameters_in_paths.csv
Any input folder should exist before we run the system.
  * _path_id_: Identifier of input files. Each occurrence must be unique in this file. In general configuration there is a variable which works as foreign key and points to the rows matched in this file.
  * _path_in_neurons_: Relative path to neurons file in csv format.
  * _path_in_afferents_: Relative path to afferents file in csv format.
  * _path_in_pos_: Relative path to positive cases obtained as intermediate file, which stores correlations between selected afferent as trigger and neurons. It is generated by the system and remains after execution. It is recomended to not delete this file if many configurations and runs are carried for the same neurons file, so correlations only need to be calculated one time. The extension of the format should be .xlsx.
  * _path_in_neg_: Quite similar to path_in_pos, but this file stores negative cases, intervals of time where there are not afferent spikes.

#### config_parameters_neurons.csv
  * _data_id_: This parameters relate each neuron with its configuration, so the content of each cell should exist in general file. For this case, elements of this parameter do not need to be unique because the most common situation is that a configuration contains more than one neuron.
  * _neurons_name_pos_: Label or name asiggned for a neuron. It is highly recommend that each name matchs with the name of related column in input files.
  * _neurons_involved_pos_: Index of each neuron in each sheet for _path_in_pos_ Excel file.
  * _isComb_: Logical value (TRUE/FALSE), points if a neuron is used or not in combinatory workflow for its related configuration.



## Examples
In the proyect folder (./) we find main scripts which constitute 
several cases of use. Involved datasets has two different origins. The first one is a simulation designed by [Izhikevich](https://www.izhikevich.org/publications/spnet.pdf) and later modified by [Ito et al.](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3216957/). We adjusted simulation parameters in order to generate 3 different levels of noise or uncertainty. The second one is a record from an experiment in our laboratory from a mice spinal cord. Details of both simulated and experimental data will be relased in future updates.

The next list contains those cases that we used to test the system. Inside each one we can find a wider description:
  * _main_sim_meansPlusIndividuals.R_: RandomSeeds and Individual workflows executed on diverse sets and subsets of simulated neurons with variable degrees of uncertainty.
  * _main_sim_combinatory.R_: Combinatory workflows carried on small subsets of simulated neurons in different conditions. This process can take an extended period of time, so we do not recommend execute this file if you can not lend the computer working some days.
  * _main_sim_rec_and_iter.R_: Recursive and Iterative workflows on large sets of simulated neurons.
  * _main_experiment.R_: Workflows and executions for experimental dataset (excepts combinatory).
  * _main_experiment_combinatory.R_: Combinatory workflow to use with experimental dataset. We separated this with the rest of workflows for the experiment because the long time needed to be performed.

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