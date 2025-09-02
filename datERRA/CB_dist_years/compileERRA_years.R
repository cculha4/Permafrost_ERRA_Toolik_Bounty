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
dat <- fread("/Users/cansu/Documents/GitHub/Permafrost_ERRA/rawdata/CB_thawingdepth_dist_hourly.txt", header=TRUE, sep=",",
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
years <- dat$years



for (year in c( 2009, 2012, 2014, 2016, 2017)){
  time_year <- ((dat$years==year)&(dat$month>=6)&(dat$month<10)&Temp>4)
  time_year[is.na(time_year)] <- FALSE
  fileID <- paste0("CB_dist_years/Rresults/1hr_simple_",year,"_")
  print(fileID)
  ##Analyzing data
  #first analysis is to just get a runoff response distribution, runoff peaks, and 
  #comparison of discharge
  zz <- ERRA(p=cbind(p, dw), q=q, m=30, agg = 1, Qfilter=time_year, xknots=NULL, dt=1, robust = FALSE)
  #save the results through this
  
  with(zz, {
    fwrite(RRD, paste0(fileID, "RRD.txt"), sep="\t")
    fwrite(peakstats, paste0(fileID, "peakstats.txt"), sep="\t")
    fwrite(Qcomp, paste0(fileID, "Qcomp.txt"), sep="\t")
  })
}





