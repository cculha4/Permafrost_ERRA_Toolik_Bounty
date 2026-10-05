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
source("ERRA_v1.03x.R")

#load the data into the script
dat <- fread("CB_thawingdepth_disturbed/CB_thawingdepth_dist_hourly.txt", header=TRUE, sep=",",
na.strings=c("NA",".","","#N/A","NaN"))

#set what is precipitation and what is discharge
p <- dat$P
q <- dat$Q
Temp <-dat$airtemp
snowfree <- ((dat$month>6)&(dat$month<11))
heating <- ((dat$month>4)&(dat$month<8))
cooling <- ((dat$month>9)&(dat$month<12))
Temp <-dat$airtemp
dZ <- dat$dZ
dw <- dat$dw30
Z <- dat$ThawDept
filter_here <- ((dat$month>5)&(dat$month<9))



##Analyzing data
#first analysis is to just get a runoff response distribution, runoff peaks, and 
#comparison of discharge cbind(p, dw)
zz <- ERRA(p=ifelse((Temp>-0.5), p, 0), q=q, m=5,  Qfilter=filter_here,agg = 24, xknots=NULL, dt=1/24, robust = FALSE)
#save the results through this
fileID <- "CB_dist/Rresults/1hr_simple_"
with(zz, {
  fwrite(RRD, paste0(fileID, "RRD.txt"), sep="\t")
  fwrite(peakstats, paste0(fileID, "peakstats.txt"), sep="\t")
  fwrite(Qcomp, paste0(fileID, "Qcomp.txt"), sep="\t")
})


