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
dat <- fread("/Users/cansu/Documents/GitHub/Permafrost_ERRA/rawdata/CB_thawingdepth_daily.txt", header=TRUE, sep=",",
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
Z <- dat$ThawDepth
doc<- dat$DOC
poc<- dat$POC
ssc <- dat$SSC
tds <- dat$TDS
qdoc<- dat$DOC*q
qpoc<- dat$POC*q
qssc <- dat$SSC*q
qtds <- dat$TDS*q
filter_here <- ((dat$months>5)&(dat$months<9))



##Analyzing data
#first analysis is to just get a runoff response distribution, runoff peaks, and 
#comparison of discharge
rm(zz)
zz <- ERRA(p=cbind(ifelse((Temp>-.5), p, 0), dw), q=qdoc, Qfilter=filter_here,  m=5, agg = 1, xknots=NULL, dt=1, robust = FALSE)
#save the results through this
fileID <- "Thawing/CB_thawingdepth_DOC/Rresults_flux/1hr_simple_DOC_"
with(zz, {
  fwrite(RRD, paste0(fileID, "RRD.txt"), sep="\t")
  fwrite(peakstats, paste0(fileID, "peakstats.txt"), sep="\t")
  fwrite(Qcomp, paste0(fileID, "Qcomp.txt"), sep="\t")
})

rm(zz)
zz <- ERRA(p=cbind(ifelse((Temp>-.5), p, 0), dw), q=qpoc,  Qfilter=filter_here, m=5, agg = 1, xknots=NULL, dt=1, robust = FALSE)
#save the results through this
fileID <- "Thawing/CB_thawingdepth_DOC/Rresults_flux/1hr_simple_POC_"
with(zz, {
  fwrite(RRD, paste0(fileID, "RRD.txt"), sep="\t")
  fwrite(peakstats, paste0(fileID, "peakstats.txt"), sep="\t")
  fwrite(Qcomp, paste0(fileID, "Qcomp.txt"), sep="\t")
})

rm(zz)
zz <- ERRA(p=cbind(ifelse((Temp>-.5), p, 0), dw), q=qssc,  Qfilter=filter_here, m=5, agg = 1, xknots=NULL, dt=1, robust = FALSE)
#save the results through this
fileID <- "Thawing/CB_thawingdepth_DOC/Rresults_flux/1hr_simple_SSC_"
with(zz, {
  fwrite(RRD, paste0(fileID, "RRD.txt"), sep="\t")
  fwrite(peakstats, paste0(fileID, "peakstats.txt"), sep="\t")
  fwrite(Qcomp, paste0(fileID, "Qcomp.txt"), sep="\t")
})

rm(zz)
zz <- ERRA(p=cbind(ifelse((Temp>-.5), p, 0), dw), q=qtds,  Qfilter=filter_here, m=5, agg = 1, xknots=NULL, dt=1, robust = FALSE)
#save the results through this
fileID <- "Thawing/CB_thawingdepth_DOC/Rresults_flux/1hr_simple_TDS_"
with(zz, {
  fwrite(RRD, paste0(fileID, "RRD.txt"), sep="\t")
  fwrite(peakstats, paste0(fileID, "peakstats.txt"), sep="\t")
  fwrite(Qcomp, paste0(fileID, "Qcomp.txt"), sep="\t")
})


