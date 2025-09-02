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
dat <- fread("UK/UK_synthesized_data.txt", header=TRUE, sep=",",
             na.strings=c("NA",".","","#N/A","NaN"))

#set what is precipitation and what is discharge
p <- dat$P
q <- dat$Q
Temp <-dat$airtemp
snowfree <- ((dat$month>4)&(dat$month<11))
snowfree[is.na(snowfree)] <- FALSE
heating <- ((dat$month>4)&(dat$month<8))
cooling <- ((dat$month>9)&(dat$month<12))

lagQ_split <- list(
  crit = list(q) ,
  crit_label = "lagQ" ,
  crit_lag = 1,
  breakpts = list(c(37.5, 75)), #, 87.5
  pct_breakpts = TRUE ,
  thresh = 0 ,
  by_bin = TRUE)
#crit_lag = 6

##Analyzing data
#first analysis is to just get a runoff response distribution, runoff peaks, and 
#comparison of discharge
#zz <-ERRA(p=p,q=q,m=200,Qfilter = snowfree,agg=1,dt=1,robust=TRUE)
#zz <- ERRA(p=p, q=q, m=200, Qfilter=snowfree, agg=1,  xknot_type="even", xknots=c(4, 100), dt=1, robust = TRUE, show_top_xknot = TRUE)
zz <- ERRA(p=ifelse((Temp>2), p, 0), q=q, xknots=c(4,40), xknot_type="even", m=12, h = 3, agg = 10, Qfilter=snowfree, show_top_xknot=TRUE, split_params=lagQ_split, robust = TRUE )
#save the results through this
fileID <- "UK_knots_antecedent/Rresults/1hr_simple_"
with(zz, {
  fwrite(NRF, paste0(fileID, "RRD.txt"), sep="\t")
  fwrite(NRF, paste0(fileID, "NRF.txt"), sep="\t")
  fwrite(peakstats, paste0(fileID, "peakstats.txt"), sep="\t")
  fwrite(knot_peakstats, paste0(fileID, "knot_peakstats.txt"), sep="\t")
  fwrite(avgRRD_peakstats, paste0(fileID, "avgRRD_peakstats.txt"), sep="\t")
})

