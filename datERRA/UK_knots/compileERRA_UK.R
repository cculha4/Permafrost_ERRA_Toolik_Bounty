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
source("ERRA_v1.0u.R")

#load the data into the script
dat <- fread("UK/UK_synthesized_data.txt", header=TRUE, sep=",",
             na.strings=c("NA",".","","#N/A","NaN"))

#set what is precipitation and what is discharge
p <- dat$P
q <- dat$Q
Temp <-dat$airtemp
snowfree <- ((dat$month>4)&(dat$month<11)&(Temp>4))
heating <- ((dat$month>4)&(dat$month<8))
cooling <- ((dat$month>9)&(dat$month<12))




##Analyzing data
#first analysis is to just get a runoff response distribution, runoff peaks, and 
#comparison of discharge
zz <- ERRA(p=p, q=q, m=100, Qfilter=snowfree, agg=1,  xknot_type = "even", xknots=c(6,50), dt=1, robust = TRUE)
#save the results through this
fileID <- "UK_knots/1hr_simple_"
with(zz, {
  fwrite(RRD, paste0(fileID, "RRD.txt"), sep="\t")
  fwrite(SRF, paste0(fileID, "SRF.txt"), sep="\t")
  fwrite(wtd_avg_SRF, paste0(fileID, "SRF_wtd_avg.txt"), sep="\t")
  fwrite(peakstats, paste0(fileID, "peakstats.txt"), sep="\t")
  fwrite(Qcomp, paste0(fileID, "Qcomp.txt"), sep="\t")
})

