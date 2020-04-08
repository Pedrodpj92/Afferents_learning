## ---------------------------
##
## File name: draft_graph_recursive_analysis.R
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
##    - generate plots for recursive results
##    - this code is in early development, it is not included in recursive workflow
##    - and it is not recommended execute it if you have not read it and understand it
##    - In next updates this code will be refactored and improved in many points,
##    - for example, wrap it as a function
##
## ---------------------------

library(data.tree)
library(plotly)

#this package is not included in common instalation script (packages_installer.R)
#it needs external installation that cannot be done directly in R,
# but you can do yourself visiting if you wish https://github.com/plotly/orca
#it helps to save plots in high quality with several configurations.
# library(orca)


#forget this Spainish stuff, there are notes for us about how to build the plot from the recursive graph
#################################################
#ideas sobre visualizacion.....
#primero, añadir una distribución al grafo, cada nodo deberá tener una posición
#la posición X es el nivel de profundidad del nodo
#la posición Y está calculada dependiendo de cuántos nodos haya, de la siguiente forma:
#recorrer todos los nodos (get) y pasarle una función,
#inicializar contador con leafCount
# si es leaf, asignar el valor del contador y contador--
#una vez asignados los valores a todas las hojas, se le asisgnan a los padres
#el valor de cada padre es el punto medio entre sus hijos (suma de posición de los hijos / número de hijos)
#   (normalmente van a ser 2, pero así lo podemos generalizar por si en algún momento tuviéramos más)
#esto solo se puede calcular cuando se sabe previamente la posición de los hijos, por lo que tendremos que
#pasar varias veces y solo calcular las posiciones por los niveles cuyos hijos ya estén calculados
#   (contador de niveles, while --)
# ya funciona!


###load a .RData which contains an object with recursive results
load("./recursive_example_results.RData")
#you may change "results_recursive" for the object with contains the data
dt_recursive_1 <- results_recursive


add_Y_coord_leaf <- function(node, counter_leaf = NULL){
  if(!is.null(counter_leaf)){
    if(node$isLeaf){
      node$y_coord <- counter_leafCount
      counter_leafCount <<- counter_leafCount-1
    }
  } else {
    stop("please, define counter_leaf")
  }
  return(0)
}

add_Y_coord_parent_perlevel <- function(node,counter_level = NULL){
  if(!is.null(counter_level)){
    # print(paste0("going into level: ",counter_level))
    if(!node$isLeaf & node$level == counter_level){
      # print(paste0("calculating node: ",node$name))
      list_children <- node$children
      aux_accum_y <- 0
      for(i in 1:length(list_children)){
        # print(paste0("visiting child: ",node$children))
        print(paste0("getting child ",list_children[[i]]$name," with Y coordinate: ",list_children[[i]]$y_coord))
        aux_accum_y <- aux_accum_y+list_children[[i]]$y_coord
        # print(aux_accum_y)
      }
      print(aux_accum_y/length(list_children))
      node$y_coord <- aux_accum_y/length(list_children)
    }
  } else {
    stop("please, define counter_level")
  }
  return(0)
}

# add_Y_coord(root)
# add_Y_coord <- function(node){

counter_leafCount <- root$leafCount
counter_level <- root$height
# add_Y_coord_leaf
root$Get(add_Y_coord_leaf, counter_leaf = counter_leafCount)
print(root, "y_coord")

while(counter_level > 0 ){
  print(paste0("adding Y coord at level ",counter_level))
  # add_Y_coord_parent_perlevel
  root$Get(add_Y_coord_parent_perlevel, counter_level = counter_level)
  counter_level <- counter_level-1
}
# return(0)
# }
print(root, "y_coord")

# root$Get(add_Y_coord, node = root)


edge_shapes <- list()
global_counter_i <- 0

#each node just only have one father node, so we can asign one edge per node (except root node)
set_edge_nodes <- function(node, edge_shapes=NULL){
  if(!is.null(edge_shapes)){
    if(!node$isRoot){
      aux_edge_shape = list(
        type = "line",
        # line = list(color = "#030303", width = 0.3),
        line = list(color = "#030303", width = 1),
        
        #quizás con un condicional sería suficiente indicar el modo
        #father coordinates
        x0 = node$parent$level,
        y0 = node$parent$y_coord,
        #child coordinates
        x1 = node$level,
        y1 = node$y_coord
        
        # #para rotar
        # #father coordinates
        # y0 = node$parent$level*(-1), #cuidado con los "-1"
        # x0 = node$parent$y_coord,
        # #child coordinates
        # y1 = node$level*(-1),
        # x1 = node$y_coord
        
        # #dispone las aristas de forma que nodos de mismo tamaño (n_neurons)
        # #tengan el mismo valor para la coordenada X
        # #father coordinates
        # x0 = node$parent$n_neurons,
        # y0 = node$parent$y_coord,
        # #child coordinates
        # x1 = node$n_neurons,
        # y1 = node$y_coord
      )
      # print(aux_edge_shape)
      global_counter_i <<- global_counter_i+1
      edge_shapes[[global_counter_i]] <<- aux_edge_shape
      # print(edge_shapes[[node$name]])
    }
  } else {
    stop("please, define edge_shapes")
  }
  return(0)
}


root$Get(set_edge_nodes, edge_shapes = edge_shapes)


#check x,y coordinates
#NOTE: x_coord == level
plot_data_root <- ToDataFrameTree(root,"n_neurons","n_neurons_C5.0",
                                  "total_recall", "F1w_total_recall",
                                  "mcc_snap", "mcc_completo",
                                  "precision_completo",
                                  "list_neurons_C5.0",
                                  "level","y_coord")

#datos destacados (aparecerán con el número  resaltado)
#si, lo se, MUY AD-HOC, depende de los datos en concreto
#habria que decidir un criterio por el que resaltar si se desease
#de momento, todo esto son solo pruebas
plot_data_root_destacado <- plot_data_root[c(1,2,3,11,12),]

a_destacados <- list(
  x = plot_data_root_destacado$level,
  y = plot_data_root_destacado$y_coord,
  text = plot_data_root_destacado$n_neurons,
  xref = "x",
  yref = "y",
  font = list(color= 'rgb(255,255,255)',
              # family = 'sans serif',
              size = 11),
  showarrow = FALSE#,
  # arrowhead = 7,
  # ax = 20,
  # ay = -40
)


# #para formatear texto reslatado
# t_style <- list(
#   family = "sans serif",
#   size = 14,
#   # color = toRGB("grey50")
#   color = 'rgb(20,20,20')

#other attributes to considerer
# text = vs$label, hoverinfo = "text"
# p <- plot_ly(data = plot_data_root, x = ~level, y = ~y_coord)
p_network <- plot_ly(data = plot_data_root,mode = "markers",
                     x = ~level,
                     # x = ~n_neurons,
                     y = ~y_coord,
                     type = 'scatter',
                     text = paste0("N Input: ",plot_data_root$n_neurons, "\n",
                                   "Relevant (",plot_data_root$n_neurons_C5.0,"): ",plot_data_root$list_neurons_C5.0, "\n",
                                   "\nMCC: ", plot_data_root$mcc_completo,
                                   "\nPrecision: ", plot_data_root$precision_completo,
                                   "\nRecall: ", plot_data_root$total_recall),
                     
                     # colors = list(c(0, "rgb(255,0,0)"), list(1, "rgb(0,0,255)")),
                     marker = list(
                       # size = ~n_neurons*3+5,
                       # size = ~n_neurons+10,
                       # size = ~n_neurons*4+15,
                       # size = ~n_neurons*6+15, #PARA IMAGENES GRANDES
                       size = ~n_neurons*1.2+5,
                       line = list(color = 'rgba(30, 20, 20, .9)',
                                   width = 1.3),
                                   # width = 3),
                       opacity=1.0,
                       # color = ~total_recall,
                       # color = ~mcc_snap,
                       color = ~mcc_completo,
                       # color = ~precision_completo,
                       # colorscale = list(c(0, "rgb(240,20,20)"),
                       #                   # list(0.5, "rgb(20,240,20"),
                       #                   list(1, "rgb(20,20,240)")),
                       # colorscale = list(c(0, "rgb(20,20,240)"),
                       #                   list(1, "rgb(240,20,20)")),
                       # colorscale = "Hot",
                       colorscale = "Rainbow",
                       # cauto=FALSE,
                       # cmax=84.0,
                       # cmin=0.0,
                       # cauto=TRUE,
                       colorbar=list(
                         # title='MCC'#,
                         tittle="",
                         # title='Total Recall'#,
                         # tickangle=90
                         # zauto=FALSE,
                         #para ocultar los valores de la barra
                         tickmode = "array",
                         tickvals = c(1:8),
                         ticktext = rep("",8)
                       )
                     )) 
# %>% #añadiendo el número de neuronas como texto, quizás quede demasiado sobrecargado
# add_text(textfont = t_style, textposition = "top")

# p_network
axisy <- list(title = "",
              tick0 = 0,
              dtick = 1,
              showgrid = FALSE, 
              showticklabels = FALSE, 
              zeroline = FALSE)

# axisx <- list(title = "",
#              tick0 = 0,
#              dtick = 1,
#              showgrid = TRUE,
#              showticklabels = TRUE,
#              zeroline = TRUE,
#              autorange = "reversed")
axisx <- list(title = "",
              tick0 = 0,
              dtick = 1,
              showgrid = FALSE,
              showticklabels = FALSE,
              zeroline = FALSE)

p <- layout(
  p_network,
  # title = 'Dataset simulation - Recursive Analysis',
  title = '',
  shapes = edge_shapes,
  xaxis = axisx,
  yaxis = axisy,
  showlegend = FALSE#,
  # annotations = a_destacados
)
#to see the results in RStudio viewer
p

#please, see orca documentation before use it
# orca(p, "./otros_outputs/plot_grafos/Ejemplos/test2.png")
# orca(p,"./plots_maker/experiment.svg",width = 2000,height = 2000)
# orca(p,"./plots_maker/tmp_recursive.png",width = 2000,height = 2000)
