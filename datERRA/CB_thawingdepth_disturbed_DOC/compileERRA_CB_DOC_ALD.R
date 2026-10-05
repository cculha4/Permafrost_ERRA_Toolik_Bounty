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
source("ERRA_v1.06.R")

#load the data into the script
dat <- fread("/Users/cansu/Documents/GitHub/Permafrost_ERRA/rawdata/CB_thawingdepth_dist_daily.txt", header=TRUE, sep=",",
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
doc<- dat$DOC
poc<- dat$POC
ssc <- dat$SSC
years <-dat$years
tds <- dat$TDS
qdoc<- dat$DOC*q
qpoc<- dat$POC*q
qssc <- dat$SSC*q
qtds <- dat$TDS*q
years <- dat$years
month <- dat$months


#ALD DOC
filter_here <- ((dat$months>5)&(dat$months<9)&(years>2006)&(years<2012))
filter_here[is.na(filter_here)] <- FALSE
zz <- ERRA(p=ifelse((Temp>-0.5), p, 0), q=qdoc, m=5, Qfilter=filter_here, agg = 1, xknots=NULL, dt=1, robust = FALSE)
#save the results through this
fileID <- "CB_thawingdepth_disturbed_DOC/Rresults_ALD/1hr_simple_DOC_"
with(zz, {
  fwrite(RRD, paste0(fileID, "RRD.txt"), sep="\t")
  fwrite(peakstats, paste0(fileID, "peakstats.txt"), sep="\t")
  fwrite(Qcomp, paste0(fileID, "Qcomp.txt"), sep="\t")
})
rm(zz,filter_here)


#stable ALD DOC
filter_here <- ((month>5)&(month<9)&(years>2011))
filter_here[is.na(filter_here)] <- FALSE
zz <- ERRA(p=ifelse((Temp>-0.5), p, 0), q=qdoc, m=5, Qfilter=filter_here, agg = 1, xknots=NULL, dt=1, robust = FALSE)
#save the results through this
fileID <- "CB_thawingdepth_disturbed_DOC/Rresults_stbALD/1hr_simple_DOC_"
with(zz, {
  fwrite(RRD, paste0(fileID, "RRD.txt"), sep="\t")
  fwrite(peakstats, paste0(fileID, "peakstats.txt"), sep="\t")
  fwrite(Qcomp, paste0(fileID, "Qcomp.txt"), sep="\t")
})
rm(zz,filter_here)

#ALD POC
filter_here <- ((dat$months>5)&(dat$months<9)&(years>2006)&(years<2012))
filter_here[is.na(filter_here)] <- FALSE
zz <- ERRA(p=ifelse((Temp>-0.5), p, 0), q=qpoc, m=5, Qfilter=filter_here, agg = 1, xknots=NULL, dt=1, robust = FALSE)
#save the results through this
fileID <- "CB_thawingdepth_disturbed_DOC/Rresults_ALD/1hr_simple_POC_"
with(zz, {
  fwrite(RRD, paste0(fileID, "RRD.txt"), sep="\t")
  fwrite(peakstats, paste0(fileID, "peakstats.txt"), sep="\t")
  fwrite(Qcomp, paste0(fileID, "Qcomp.txt"), sep="\t")
})
rm(zz,filter_here)

#stable ALD POC
filter_here <- ((month>5)&(month<9)&(years>2011))
filter_here[is.na(filter_here)] <- FALSE
zz <- ERRA(p=ifelse((Temp>-0.5), p, 0), q=qpoc, m=5, Qfilter=filter_here, agg = 1, xknots=NULL, dt=1, robust = FALSE)
#save the results through this
fileID <- "CB_thawingdepth_disturbed_DOC/Rresults_stbALD/1hr_simple_POC_"
with(zz, {
  fwrite(RRD, paste0(fileID, "RRD.txt"), sep="\t")
  fwrite(peakstats, paste0(fileID, "peakstats.txt"), sep="\t")
  fwrite(Qcomp, paste0(fileID, "Qcomp.txt"), sep="\t")
})
rm(zz,filter_here)

#ALD SSC
filter_here <- ((dat$months>5)&(dat$months<9)&(years>2006)&(years<2012))
filter_here[is.na(filter_here)] <- FALSE
zz <- ERRA(p=ifelse((Temp>-0.5), p, 0), q=qssc, m=5, Qfilter=filter_here, agg = 1, xknots=NULL, dt=1, robust = FALSE)
#save the results through this
fileID <- "CB_thawingdepth_disturbed_DOC/Rresults_ALD/1hr_simple_SSC_"
with(zz, {
  fwrite(RRD, paste0(fileID, "RRD.txt"), sep="\t")
  fwrite(peakstats, paste0(fileID, "peakstats.txt"), sep="\t")
  fwrite(Qcomp, paste0(fileID, "Qcomp.txt"), sep="\t")
})
rm(zz,filter_here)

#stable ALD SSC
filter_here <- ((month>5)&(month<9)&(years>2011))
filter_here[is.na(filter_here)] <- FALSE
zz <- ERRA(p=ifelse((Temp>-0.5), p, 0), q=qssc, m=5, Qfilter=filter_here, agg = 1, xknots=NULL, dt=1, robust = FALSE)
#save the results through this
fileID <- "CB_thawingdepth_disturbed_DOC/Rresults_stbALD/1hr_simple_SSC_"
with(zz, {
  fwrite(RRD, paste0(fileID, "RRD.txt"), sep="\t")
  fwrite(peakstats, paste0(fileID, "peakstats.txt"), sep="\t")
  fwrite(Qcomp, paste0(fileID, "Qcomp.txt"), sep="\t")
})

#ALD TDS
filter_here <- ((dat$months>5)&(dat$months<9)&(years>2006)&(years<2012))
filter_here[is.na(filter_here)] <- FALSE
zz <- ERRA(p=ifelse((Temp>-0.5), p, 0), q=qtds, m=5, Qfilter=filter_here, agg = 1, xknots=NULL, dt=1, robust = FALSE)
#save the results through this
fileID <- "CB_thawingdepth_disturbed_DOC/Rresults_ALD/1hr_simple_TDS_"
with(zz, {
  fwrite(RRD, paste0(fileID, "RRD.txt"), sep="\t")
  fwrite(peakstats, paste0(fileID, "peakstats.txt"), sep="\t")
  fwrite(Qcomp, paste0(fileID, "Qcomp.txt"), sep="\t")
})
rm(zz,filter_here)

#stable ALD TDS
filter_here <- ((dat$months>5)&(dat$months<9)&(years>2011))
filter_here[is.na(filter_here)] <- FALSE
zz <- ERRA(p=ifelse((Temp>-0.5), p, 0), q=qtds, m=5, Qfilter=filter_here, agg = 1, xknots=NULL, dt=1, robust = FALSE)
#save the results through this
fileID <- "CB_thawingdepth_disturbed_DOC/Rresults_stbALD/1hr_simple_TDS_"
with(zz, {
  fwrite(RRD, paste0(fileID, "RRD.txt"), sep="\t")
  fwrite(peakstats, paste0(fileID, "peakstats.txt"), sep="\t")
  fwrite(Qcomp, paste0(fileID, "Qcomp.txt"), sep="\t")
})
