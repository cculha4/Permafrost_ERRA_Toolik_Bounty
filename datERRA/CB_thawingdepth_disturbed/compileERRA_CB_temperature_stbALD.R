#Welcome to the compiler developed by Cansu Culha. It linearly follows the "quick
#introduction to ERRA.pdf"



#Loading the library
library(data.table)
library(dplyr) 
library(Matrix)
library(matrixStats)
library(Rcpp)
library(caTools)




#set the library and the code
setwd("~/Documents/GitHub/Permafrost_ERRA/datERRA/")
rm(list=ls())
source("ERRA_v1.0.R")

#load the data into the script
dat <- fread("CB_thawingdepth_disturbed/CB_thawingdepth_dist_hourly.txt", header=TRUE, sep=",",
na.strings=c("NA",".","","#N/A","NaN"))

#set what is precipitation and what is discharge
p <- dat$P
q <- dat$Q
Temp <-dat$airtemp
month <-dat$months
snowfree <- ((month>6)&(month<11))
heating <- ((month>4)&(month<8))
cooling <- ((month>9)&(month<12))
Temp <-dat$airtemp
dZ <- dat$dZ
dw <- dat$dw30
Z <- dat$ThawDept
years <- dat$years
filter_here <- ((month>5)&(month<9)&(Temp>=0)&(years>2011))



##Analyzing data
#first analysis is to just get a runoff response distribution, runoff peaks, and 
#comparison of discharge
zz <- ERRA(p=cbind(p, dw), q=q, m=10, Qfilter=filter_here, agg = 2, xknots=NULL, dt=1, robust = TRUE)
#save the results through this
fileID <- "CB_thawingdepth_disturbed/Rresults_stbALD/1hr_simple_"
with(zz, {
  fwrite(RRD, paste0(fileID, "RRD.txt"), sep="\t")
  fwrite(peakstats, paste0(fileID, "peakstats.txt"), sep="\t")
  fwrite(Qcomp, paste0(fileID, "Qcomp.txt"), sep="\t")
})


