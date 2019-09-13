#     gage                                          description        latitude       longitude    drainage_area_sqmi        params
# 11276900            "TUOLUMNE R BL EARLY INTAKE NR MATHER CA"       37°52'54"      119°58'09"                   487           Q,T
# 11276600            "TUOLUMNE R AB EARLY INTAKE NR MATHER CA"       37°52'46"      119°56'46"                   484           Q,T
# 11276500                      "TUOLUMNE R NR HETCH HETCHY CA"       37°56'15"      119°47'50"                   457           Q,T
# 11274790 "TUOLUMNE R A GRAND CYN OF TUOLUMNE AB HETCH HETCHY"       37°55'00"      119°39'32"                   301   Q,T,EC,Turb

library(EGRET)

# List site number IDs
gages <- c(11276900,11276600,11276500,11274790)

# Get Q data
# ----------

QParameterCd <- "00060"     # USGS parameter code for flow; need to set only once

for(i in 1:length(gages)){
  siteNumber <- gages[i]
  StartDate <- ""           # Can be adjusted if necessary
  EndDate <- ""
  Daily <- readNWISDaily(siteNumber, QParameterCd, StartDate, EndDate)
  if(gages[i] == '11274790'){
    outletQ <- Daily
  }
}

INFO <- readNWISInfo(siteNumber = gages[i], parameterCd = QParameterCd)

Tuo
Flow
Q

eList <- as.egret(INFO, Daily, NA, NA)
annualSeries <- makeAnnualSeries(eList)

# Looking at 7-day minimum flows
istat <- 1
localAnnualSeries <- makeAnnualSeries(eList)
qActual <- localAnnualSeries[2, istat, ][!is.na(localAnnualSeries[1, istat, ])]
years   <- localAnnualSeries[1, istat, ][!is.na(localAnnualSeries[1, istat, ])]
png('C:/temp/geohack.git/notebooks/eric/min_flows.png', width=900, height=700, res=130)
  plotFlowSingle(eList, istat = istat, qUnit = 1, showYLabels=FALSE)
  points(years[((years > 2015 & years < 2016) | (years > 2017 & years < 2018))], qActual[((years > 2015 & years < 2016) | (years > 2017 & years < 2018))] * 35.315, pch=16, col='blue', cex=1.5)
  mtext(side=2, expression(paste("Flow, in  ",ft^3," ",s^-1,sep="")), line=3)
dev.off()

# Looking at Annual median flows
istat <- 4
years   <- localAnnualSeries[1, istat, ][!is.na(localAnnualSeries[1, istat, ])]
qActual <- localAnnualSeries[2, istat, ][!is.na(localAnnualSeries[1, istat, ])]
png('C:/temp/geohack.git/notebooks/eric/median_flows.png', width=900, height=700, res=130)
  plotFlowSingle(eList, istat = istat, qUnit = 1, showYLabels=FALSE)
  points(years[((years > 2015 & years < 2016) | (years > 2017 & years < 2018))], qActual[((years > 2015 & years < 2016) | (years > 2017 & years < 2018))] * 35.315, pch=16, col='blue', cex=1.5)
  mtext(side=2, expression(paste("Flow, in  ",ft^3," ",s^-1,sep="")), line=3)
dev.off()

# Looking at Annual mean flows
istat <- 5
years   <- localAnnualSeries[1, istat, ][!is.na(localAnnualSeries[1, istat, ])]
qActual <- localAnnualSeries[2, istat, ][!is.na(localAnnualSeries[1, istat, ])]
png('C:/temp/geohack.git/notebooks/eric/mean_flows.png', width=900, height=700, res=130)
  plotFlowSingle(eList, istat = istat, qUnit = 1, showYLabels=FALSE)
  points(years[((years > 2015 & years < 2016) | (years > 2017 & years < 2018))], qActual[((years > 2015 & years < 2016) | (years > 2017 & years < 2018))] * 35.315, pch=16, col='blue', cex=1.5)
  mtext(side=2, expression(paste("Flow, in  ",ft^3," ",s^-1,sep="")),line=3)
dev.off()

# Looking at Annual 7-day maximum flows
istat <- 6
years   <- localAnnualSeries[1, istat, ][!is.na(localAnnualSeries[1, istat, ])]
qActual <- localAnnualSeries[2, istat, ][!is.na(localAnnualSeries[1, istat, ])]
png('C:/temp/geohack.git/notebooks/eric/max7_flows.png', width=900, height=700, res=130)
  plotFlowSingle(eList, istat = istat, qUnit = 1, showYLabels=FALSE)
  points(years[((years > 2015 & years < 2016) | (years > 2017 & years < 2018))], qActual[((years > 2015 & years < 2016) | (years > 2017 & years < 2018))] * 35.315, pch=16, col='blue', cex=1.5)
  mtext(side=2, expression(paste("Flow, in  ",ft^3," ",s^-1,sep="")),line=3)
dev.off()

# Plot runoff hydrograph
png('C:/temp/geohack.git/notebooks/eric/runoff.png', width=900, height=700, res=130)
  plotQTimeDaily(eList, lwd = 1,qUnit = 1, showYLabels=FALSE)
  mtext(side=2, expression(paste("Flow, in  ",ft^3," ",s^-1,sep="")),line=3)
dev.off()

# Plot total annual flow

png('C:/temp/geohack.git/notebooks/eric/total_annual_flows.png', width=900, height=700, res=130)
  par(mar=c(4,5,0.5,0.5))
  x <- barplot(aggregate((Q * 35.315 * 86400 / 43560) ~ waterYear, data = Daily, 'sum')[,2], ylim=c(0, 700000), yaxt='n', las=1)
  axis(side=2, at=seq(0,7e5,by=1e5), labels=c('0','100,000','200,000','300,000','400,000','500,000','600,000','700,000'), las=1)
  axis(side=1, at=x, labels=seq(2007,2019,by=1), las=2)
  abline(h=0)
  mtext(side=2, expression(paste('Total Outflow,  ',ac%.%ft,sep='')), line=4)
dev.off()


