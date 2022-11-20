
'# PROLOG   ################################################################'   

'# PROJECT: GEOSPATIAL NETWORKS: SPECIAL TOPICS SSSI 2021  #'   
'# PURPOSE: STREET GRIDS TO NETWORKS #'   
'# DIR:     Box/Systems Science for Social Impact/SNA #'   
'# DATA:     #'   
'# AUTHOR:  TODD COMBS #'   
'# CREATED: JUL 8 2021 #'   
'# LATEST:  JUL 8 2021 #'   
'# NOTES:   #'

'# PROLOG   ###############################################################'  

# libraries

# need to install? Remove # for any 
# that you have not previously installed
# and run
# install.packages('magrittr')
# install.packages('tidyverse')
# install.packages('dodgr')
# install.packages('osmplotr')
# install.packages('sf')


library(magrittr) # for pipes
library(tidyverse) # for data management
library(dodgr) # for street maps and networks
library(osmplotr) # for plotting osm data
library(sf) # for working with shapefile


# get city shapefile of streets from osmdata
lgvn <- dodgr_streetnet("lagavulin uk")

# look at map
map <- osm_basemap (lgvn, bg = "gray95") %>%
  add_osm_objects (lgvn, col = "gray5") %>%
  add_axes () %>%
  print_osm_map () 
map

# apply weights for distances between intersections for foot traffic
# and travel times
graph <- weight_streetnet (lgvn, wt_profile = "foot")

class(graph)
class(lgvn)

# contract graph (remove redundant edges)
grc <- dodgr_contract_graph (graph)

# check number of components in network
table(grc$component)

# just look at largest component
grc <- grc[grc$component==1,]

# get distances between all nodes (intersections)
from <- grc$from_id
to <- grc$to_id

paths <- dodgr_dists(grc, from=from,to=to)

# shortest paths

# get hops from the first node to the third
spaths <- dodgr_paths(grc, from=from,to=to)

sp2<- spaths[[1]][[3]]
sp2


