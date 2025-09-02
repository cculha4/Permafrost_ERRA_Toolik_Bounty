#Welcome to the script developed by Cansu Culha. It linearly follows the "quick
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
dat <- fread("UK_months/UK_synthesized_data.txt", header=TRUE, sep=",",
             na.strings=c("NA",".","","#N/A","NaN"))

#set what is precipitation and what is discharge
p <- dat$P
q <- dat$Q
snowfree <- ((dat$month>3)&(dat$month<11))
heating <- ((dat$month>4)&(dat$month<8))
cooling <- ((dat$month>9)&(dat$month<12))
Temp <-dat$airtemp
TD <- dat$ThawDepth



brackets <- cbind("June2July","July2August","August")
TillJune <- ((dat$months<6)&(Temp>=2))
June2July <- ((dat$months==6)&(Temp>=2))
July2August <- ((dat$months==7)&(Temp>=2))
August <- ((dat$months>=8)&(dat$months<9)&(Temp>=2))

TDcases <- cbind(June2July,July2August,August)

for (j in 1:3){
  
  fileID <- paste0("UK_months/1hr_simple_",brackets[j],"_")
  print(fileID)
  ##Analyzing data
  #first analysis is to just get a runoff response distribution, runoff peaks, and 
  #comparison of discharge
  zz <- ERRA(p=p, q=q, m=20, Qfilter=TDcases[,j], agg = 10, xknots=NULL, dt=1, robust = TRUE)
  #save the results through this
  
  with(zz, {
    fwrite(RRD, paste0(fileID, "RRD.txt"), sep="\t")
    fwrite(peakstats, paste0(fileID, "peakstats.txt"), sep="\t")
    fwrite(Qcomp, paste0(fileID, "Qcomp.txt"), sep="\t")
  })
}


