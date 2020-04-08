## ---------------------------
##
## File name: draft_individual_parallel_coordinates.R
##
## Purpose of file: just a prototype, see notes and comments please
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
##  - generate plot for individual results 
##  - this code is in early development, it is not included in recursive workflow
##    - and it is not recommended execute it if you have not read it and understand it
##    - In next updates this code will be refactored and improved in many points,
##    - for example, wrap it as a function
##
## ---------------------------

library(plotly)

#following file does not exits in repository,
#if you wish and find problems, write us an email or wait for new updates
#you can create a similar one if you get some individual results
#columns:
# Name: label of a neuron
# MCC_C1: first vector of mcc values (C1 was the previous name for "high" uncertainty)
# MCC_C2: C2 --> medium uncertainty
# MCC_C3: C3 --> low uncertainty
# Tipo: (type) what kind of neuron is respect the reference neuron (mono, bi, tri, hinibitoria, external)
# Tipo_id: codified type in integer number (1, 2, 3, 4, 5)
dt_indiv <- read.csv(file = "./plots_maker/tmp_data_individual_parallel_coordinates.csv",
                     sep = "\t")

dt_indiv$X <- NULL
dt_indiv$X.1 <- NULL

dt_indiv$MCC_C1 <- dt_indiv$MCC_C1*100
dt_indiv$MCC_C2 <- dt_indiv$MCC_C2*100
dt_indiv$MCC_C3 <- dt_indiv$MCC_C3*100

# dt_indiv <- dt_indiv[dt_indiv$Tipo!="mono",]

# dt_indiv <- dt_indiv[dt_indiv$Tipo!="inhibitoria",]

dt_indiv$Name_id <- as.numeric(gsub("U","",dt_indiv$Name))



# dt_indiv2 <- dt_indiv[dt_indiv$Tipo!="externa",]
# fig <- dt_indiv2 %>% plot_ly(type = 'parcoords',
#                             # line = list(color = ~Tipo,
#                             #             colorscale = list(c(0,'blue'),
#                             #                               c(0.25,'yellow'),
#                             #                               c(0.5,'coral'),
#                             #                               c(0.75,'green'),
#                             #                               c(1,'orange'))),
#                             line = list(color = dt_indiv2$Tipo_id,
#                                         colorscale = list(c(0,'rgb(154,205,50)'),
#                                                           c(0.25,'rgb(70,130,180)'),
#                                                           c(0.5,'rgb(255,69,0)'),
#                                                           c(0.75,'rgb(255,160,122)'),
#                                                           c(1,'rgb(240,230,140)'))),
#                             dimensions = list(
#                               list(range = c(1,80),
#                                    tickvals = c(1:80),
#                                    ticktext = as.data.frame(table(dt_indiv2$Name))$Var1,
#                                    label = 'Unidades', values = dt_indiv2$Name),
#                               list(range = c(0,0.55),
#                                    label = 'MCC C1', values = dt_indiv2$MCC_C1),
#                               list(range = c(0,0.55),
#                                    label = 'MCC C2', values = dt_indiv2$MCC_C2),
#                               list(range = c(0,0.55),
#                                    label = 'MCC C3', values = dt_indiv2$MCC_C3)
#                             )
# )
# 
# fig



fig <- dt_indiv %>% plot_ly(type = 'parcoords',
                            # line = list(color = ~Tipo,
                            #             colorscale = list(c(0,'blue'),
                            #                               c(0.25,'yellow'),
                            #                               c(0.5,'coral'),
                            #                               c(0.75,'green'),
                            #                               c(1,'orange'))),
                            # line = list(color = dt_indiv$Tipo_id,
                            #             colorscale = list(
                            #               c(0,'rgb(154,205,50)'),
                            #               c(0.25,'rgb(70,130,180)'),
                            #               c(0.5,'rgb(255,69,0)'),
                            #               c(0.75,'rgb(255,160,122)'),
                            #               c(1,'rgb(240,230,140)'))
                            # line = list(color = dt_indiv$Tipo_id,
                            #             width = 3,
                            #             colorscale = list(
                            #               c(0,'rgb(255,10,10)'),
                            #               c(0.25,'rgb(255,150,0)'),
                            #               c(0.5,'rgb(30,200,30)'),
                            #               c(0.75,'rgb(90,20,200)'),
                            #               c(1,'rgb(20,20,20)'))
                            line = list(color = dt_indiv$Tipo_id,
                                        width = 3,
                                        colorscale = list(
                                          c(0,'rgb(70,240,70)'),
                                          c(0.25,'rgb(240,30,30)'),
                                          c(0.5,'rgb(0,0,0)'),
                                          c(0.75,'rgb(30,255,255)'),
                                          c(1,'rgb(170,170,170)'))
                            ),
                            dimensions = list(
                              # list(range = c(80,1),
                              #      tickvals = c(1:80),
                              #      # ticktext = as.data.frame(table(dt_indiv$Name))$Var1,
                              #      # ticktext = dt_indiv$Name_id,
                              #      label = 'Unidades', values = dt_indiv$Name_id),
                              list(range = c(0,55),
                                   # tickvals = c(0,20,55),
                                   label = 'C1', values = dt_indiv$MCC_C1),
                              list(range = c(0,55),
                                   label = 'C2', values = dt_indiv$MCC_C2),
                              list(range = c(0,55),
                                   label = 'C3', values = dt_indiv$MCC_C3)
                            )
)

fig








# oritinal example
# https://plotly.com/r/parallel-coordinates-plot/
# df <- read.csv("https://raw.githubusercontent.com/bcdunbar/datasets/master/iris.csv")
# fig <- df %>% plot_ly(type = 'parcoords',
#                       line = list(color = ~species_id,
#                                   colorscale = list(c(0,'red'),c(0.5,'green'),c(1,'blue'))),
#                       dimensions = list(
#                         list(range = c(2,4.5),
#                              label = 'Sepal Width', values = ~sepal_width),
#                         list(range = c(4,8),
#                              constraintrange = c(5,6),
#                              label = 'Sepal Length', values = ~sepal_length),
#                         list(range = c(0,2.5),
#                              label = 'Petal Width', values = ~petal_width),
#                         list(range = c(1,7),
#                              label = 'Petal Length', values = ~petal_length)
#                       )
# )
# 
# fig



