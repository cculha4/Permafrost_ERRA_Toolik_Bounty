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
dat <- fread("~/Documents/GitHub/Permafrost_ERRA/rawdata/CB_thawingdepth_dist_hourly.txt", header=TRUE, sep=",",
na.strings=c("NA",".","","#N/A","NaN"))

#set what is precipitation and what is discharge
p <- dat$P
q <- dat$Q
Temp <-dat$airtemp
snowfree <- ((dat$months>6)&(dat$months<11))
heating <- ((dat$months>4)&(dat$months<8))
cooling <- ((dat$months>9)&(dat$months<12))
Temp <-dat$airtemp
dZ <- dat$dZ
dw <- dat$dw30
Z <- dat$ThawDept
years <- dat$years
filter_here <- ((dat$months>5)&(dat$months<9)&(years>2006)&(years<2012))



##Analyzing data
#first analysis is to just get a runoff response distribution, runoff peaks, and 
#comparison of dischargecbind(p, dw)
zz <- ERRA(p=cbind(ifelse((Temp>-.5), p, 0), dw), q=q, m=10, Qfilter=filter_here, agg = 2, xknots=NULL, dt=1, robust = TRUE)
#save the results through this
fileID <- "Thawing/CB_thawingdepth_disturbed/Rresults_ALD/1hr_simple_"
with(zz, {
  fwrite(RRD, paste0(fileID, "RRD.txt"), sep="\t")
  fwrite(peakstats, paste0(fileID, "peakstats.txt"), sep="\t")
  fwrite(Qcomp, paste0(fileID, "Qcomp.txt"), sep="\t")
})

filter_here <- ((dat$month>5)&(dat$month<9)&(years>2011))

##Analyzing data
#first analysis is to just get a runoff response distribution, runoff peaks, and 
#comparison of discharge cbind(p, dw)
zz <- ERRA(p=cbind(ifelse((Temp>-.5), p, 0), dw), q=q, m=10, Qfilter=filter_here, agg = 2, xknots=NULL, dt=1, robust = TRUE)
#save the results through this
fileID <- "Thawing/CB_thawingdepth_disturbed/Rresults_stbALD/1hr_simple_"
with(zz, {
  fwrite(RRD, paste0(fileID, "RRD.txt"), sep="\t")
  fwrite(peakstats, paste0(fileID, "peakstats.txt"), sep="\t")
  fwrite(Qcomp, paste0(fileID, "Qcomp.txt"), sep="\t")
})


