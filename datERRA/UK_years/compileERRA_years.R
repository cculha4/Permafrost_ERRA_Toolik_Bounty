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
setwd("~/Documents/git_research/Permafrost_ERRA/Permafrost_ERRA/datERRA/")
rm(list=ls())
source("ERRA_v1.03x.R")

#load the data into the script
dat <- fread("UK/UK_synthesized_data.txt", header=TRUE, sep=",",
na.strings=c("NA",".","","#N/A","NaN"))

#set what is precipitation and what is discharge
p <- dat$P
q <- dat$Q
snowfree <- ((dat$month>6)&(dat$month<11))
heating <- ((dat$month>4)&(dat$month<8))
cooling <- ((dat$month>9)&(dat$month<12))
Temp <-dat$airtemp


for (year in c(2003, 2005, 2007:2017)){
  time_year <- ((dat$years==year)&(dat$month>=6)&(dat$month<9)&Temp>2)
  fileID <- paste0("UK_years/Rresults/1hr_simple_",year,"_")
  print(fileID)
  ##Analyzing data
  #first analysis is to just get a runoff response distribution, runoff peaks, and 
  #comparison of discharge
  zz <- ERRA(p=p, q=q, agg=4, m=15,Qfilter=time_year, xknots=NULL, dt=1, robust = TRUE)
  #save the results through this
  
  with(zz, {
    fwrite(RRD, paste0(fileID, "RRD.txt"), sep="\t")
    fwrite(peakstats, paste0(fileID, "peakstats.txt"), sep="\t")
    fwrite(Qcomp, paste0(fileID, "Qcomp.txt"), sep="\t")
  })
}





