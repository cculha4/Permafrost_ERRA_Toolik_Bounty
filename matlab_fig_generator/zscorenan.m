function zscore_x = zscorenan(x)
zscore_x = (x - nanmean(x))/nanstd(x);