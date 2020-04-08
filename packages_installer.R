## ---------------------------
##
## File name: packages_installer.R
##
## Purpose of file: install several libraries required 
##
## Author: code structure copied from https://stackoverflow.com/questions/4090169/elegant-way-to-check-for-missing-packages-and-install-them
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

#code extracted from:
#https://stackoverflow.com/questions/4090169/elegant-way-to-check-for-missing-packages-and-install-them
#modified for our list of dependencies
list.of.packages <- c("caret","C50",
                      "data.tree","readxl",
                      "openxlsx","plotly",
                      "reproducible","compare")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

rm(list=ls())



