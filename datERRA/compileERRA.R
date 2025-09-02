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
source("ERRA_v1.0r.R")

#load the data into the script
dat <- fread("vignettes_data.txt", header=TRUE, sep="\t",
na.strings=c("NA",".","","#N/A"))

#set what is precipitation and what is discharge
p <- dat$P_Erlenbach_mm.h
q <- dat$Q_Erlenbach_mm.h
snowfree <- ((dat$month>5)&(dat$month<11))





##Analyzing data
#first analysis is to just get a runoff response distribution, runoff peaks, and 
#comparison of discharge
zz <- ERRA(p=p, q=q, m=144, Qfilter=snowfree, xknots=NULL, dt=1/6, robust = FALSE)
#save the results through this
fileID <- "Erl_10m_simple_"
with(zz, {
  fwrite(RRD, paste0(fileID, "RRD.txt"), sep="\t")
  fwrite(peakstats, paste0(fileID, "peakstats.txt"), sep="\t")
  fwrite(Qcomp, paste0(fileID, "Qcomp.txt"), sep="\t")
})