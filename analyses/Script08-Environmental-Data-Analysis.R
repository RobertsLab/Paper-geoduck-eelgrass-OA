#### Import environmental data, plot all data to inspect for abnormalities 
# ==> Temperature (T)
# ==> Dissolved Oxygen (DO)
# ==> pH (temp-adjusted)
# ==> Salinity
# ==> Tide height (estim. from http://tbone.biol.sc.edu/).

Env.Data <- data.frame(read.csv(file="data/Environmental/EnvData-Master.csv", stringsAsFactors=F, header=T, na.strings = ""))
Env.parameters <- c("pH","DO","Salinity","Temperature")

# pH 
pH.Data <- Env.Data[,c(1,grep("pH\\.", colnames(Env.Data)))]
names(pH.Data) <- c("DateTime", "WB-E", "WB-B", "SK-E", "SK-B", "PG-E", "PG-B", "CI-E", "CI-B", "FB-E", "FB-B")
pH.Data.melted <- melt(pH.Data, id="DateTime")
pH.Data.melted.noNA <- pH.Data.melted[which(!is.na(pH.Data.melted$value)),]
pH.series <- plot_ly(data = pH.Data.melted.noNA, x = ~DateTime, y = ~value, type="scatter", mode="lines", color=~variable, hovertext=~value) %>%  #generate plotly plot
  layout(title="pH across sites (raw data),\n2016 DNR outplant",
         yaxis = list(title = 'pH (total scale)'),
         legend = list(x=.95, y=.95))

# Dissolved Oxygen
DO.Data <- Env.Data[,c(1,grep("do\\.", colnames(Env.Data)))]
DO.Data.noOuts <- DO.Data[which(DO.Data$FBE < 50),] #Remove FBE values over 50
names(DO.Data) <- c("DateTime", "WB-E", "WB-B", "SK-E", "SK-B", "PG-E", "PG-B", "CI-E", "CI-B", "FB-E", "FB-B")
DO.Data.melted <- melt(DO.Data, id="DateTime")
DO.Data.melted.noNA <- DO.Data.melted[which(!is.na(DO.Data.melted$value) & DO.Data.melted$value > 0),]
DO.series <- plot_ly(data = DO.Data.melted.noNA, x = ~DateTime, y = ~value, type="scatter", mode="lines", color=~variable, hovertext=~value) %>%
  layout(title="Dissolved Oxygen across sites (raw data),\n2016 DNR outplant)",
         yaxis = list(title = 'DO (mg/L)'),
         legend = list(x=.95, y=.95))

# Temperature
T.Data <- Env.Data[,c(1,grep("doT", colnames(Env.Data)))]
names(T.Data) <- c("DateTime", "WB-E", "WB-B", "SK-E", "SK-B", "PG-E", "PG-B", "CI-E", "CI-B", "FB-E", "FB-B")
T.Data.melted <- melt(T.Data, id="DateTime")
T.Data.melted.noNA <- T.Data.melted[which(!is.na(T.Data.melted$value)),]
T.series <- plot_ly(data = T.Data.melted.noNA, x = ~DateTime, y = ~value, type="scatter", mode="lines", color=~variable, hovertext=~value) %>%
  layout(title="Temperature across sites (raw data),\n2016 DNR outplant",
         yaxis = list(title = 'Temperature (C)'),
         legend = list(x=.95, y=.95))

# Salinity
S.Data <- Env.Data[,c(1,grep("ctS", colnames(Env.Data)))]
names(S.Data) <- c("DateTime", "CI-B", "CI-E", "FB-B", "FB-E", "PG-E", "SK-E", "SK-B", "WB-B", "WB-E")
S.Data.melted <- melt(S.Data, id="DateTime")
S.Data.melted$value <- as.numeric(levels(S.Data.melted$value))[S.Data.melted$value]
S.Data.melted.noNA <- S.Data.melted[which(!is.na(S.Data.melted$value)),]
S.series <- plot_ly(data = S.Data.melted.noNA, x = ~DateTime, y = ~value, type="scatter", mode="lines", color=~variable, hovertext=~value) %>%
  layout(title="Salinity across sites (raw data),\n2016 DNR outplant",
         yaxis = list(title = 'Salinity'),
         legend = list(x=.95, y=.95))

# Tidal height
Tide.Data <- Env.Data[,c(1,grep("Tide", colnames(Env.Data)))]
names(Tide.Data) <- c("DateTime", "FB", "PG", "CI", "WB")
Tide.Data.melted <- melt(Tide.Data, id="DateTime")
Tide.Data.melted.noNA <- Tide.Data.melted[which(!is.na(Tide.Data.melted$value)),]
Tide.series <- plot_ly(data = Tide.Data.melted.noNA, x = ~DateTime, y = ~value, type="scatter", mode="lines", color=~variable, hovertext=~value) %>%
  layout(title="Tidal height across sites (raw data),\n2016 DNR outplant",
         yaxis = list(title = 'Tidal Height'),
         legend = list(x=.95, y=.95))

# Call Plotly plots:
Tide.series
S.series
DO.series
pH.series

#### Environmental Data QA

# Sampling Dates & estimated tide elevation (to inform exposure)
# ==> Case Inlet: July 19th; cut off env. data at -1.0 - "never fully exposed"
# ==> Willapa Bay: July 20th-22nd (?); cut off env. data at 1.5 - "fully exposed/dry"
# ==> Port Gamble: July 20th-22nd; cut off env. data at 0 - "fully exposed/dry"
# ==> Fidalgo Bay: July 20th-22nd; cut off env. data at -1.25 - "never fully exposed"
# ==> Skokomish: July 22nd 

# Create master melted dataframe with all environmental data
# First, add another column "metric" to each env. data frame
pH.Data.melted.noNA$metric <- c("pH")
T.Data.melted.noNA$metric <- c("Temperature")
DO.Data.melted.noNA$metric <- c("DO")
S.Data.melted.noNA$metric <- c("Salinity")
Tide.Data.melted.noNA$metric <- c("Tide")

# Identify any time points in pH, DO & S that where probes were exposed. NOTE: likely need to update the threshold based on Micah/Alex's input.
Tide.sites <- as.factor(c("FB", "PG", "CI", "WB"))
Tide.exposed <- c(-1.25, 0, -1.0, 1.5) #tide depth at which probes are exposed (estimated)
submerged.times = list()
for (i in 1:length(Tide.sites)) {
  submerged.times[[i]] <- Tide.Data.melted.noNA[which(Tide.Data.melted.noNA$value>=Tide.exposed[i] & Tide.Data.melted.noNA$variable %in% Tide.sites[[i]]), ]
}

# Filter pH, DO & S at time points where probes were exposed
Tide.location <- as.factor(c("FB-B", "FB-E", "PG-B", "PG-E", "CI-B", "CI-E", "WB-B", "WB-E"))
J <- c(1,1,2,2,3,3,4,4)
submerged.data = list()
for (i in 1:length(Tide.location)) {
    submerged.data[[i]] <- rbind(pH.Data.melted.noNA[which(pH.Data.melted.noNA$DateTime %in% submerged.times[[J[i]]]$DateTime & pH.Data.melted.noNA$variable %in% Tide.location[[i]]), ], DO.Data.melted.noNA[which(DO.Data.melted.noNA$DateTime %in% submerged.times[[J[i]]]$DateTime & DO.Data.melted.noNA$variable %in% Tide.location[[i]]), ], S.Data.melted.noNA[which(S.Data.melted.noNA$DateTime %in% submerged.times[[J[i]]]$DateTime & S.Data.melted.noNA$variable %in% Tide.location[[i]]), ])
}

# Combine results from the previous for loop for pH, DO & Salinity, and the Temp and Tide data (unedited) into one master env. data frame (long form)
Env.Data.Master <- do.call(rbind, submerged.data)
Env.Data.Master <- rbind(Env.Data.Master, T.Data.melted.noNA, Tide.Data.melted.noNA) #this is a dataframe with env. data, screened for times when pH, DO & S probes were exposed
Env.Data.Master$metric <- as.factor(Env.Data.Master$metric)

# Remove DO data from FBE after 6/24 @ 08:40:00, as the probe clearly malfunctioned after that time. 
Env.Data.Master <- subset(Env.Data.Master, !(variable=="FB-E" & metric=="DO" & DateTime > "06/24/16 08:40:00"))

# Remove Salinity data where probes exposed / malfunctioned (zero time points, identified via plots)
Env.Data.Master <- subset(Env.Data.Master, !((variable=="CI-E" & metric=="Salinity") | (variable=="FB-B" & metric=="Salinity" & DateTime > "07/03/16 09:50:00") | (variable=="WB-B" & metric=="Salinity" & DateTime > "06/25/16 05:30:00")))

# Identify and remove outliers from pH, DO & Salinity data. Apply Tukey's method of removing outlying values, where values outside the inner fence removed: 
Env.Data.Master.noOuts <- Env.Data.Master

# pH Data
for(i in 1:length(Tide.location)) { #For individual site data
  IQR <- quantile(Env.Data.Master[which(Env.Data.Master$metric %in% "pH" & Env.Data.Master$variable %in% Tide.location[i]),"value"], na.rm=TRUE)[4] - quantile(Env.Data.Master[which(Env.Data.Master$metric %in% "pH" & Env.Data.Master$variable %in% Tide.location[i]),"value"], na.rm=TRUE)[2]
  upperBound <- as.numeric(quantile(Env.Data.Master[which(Env.Data.Master$metric %in% "pH" & Env.Data.Master$variable %in% Tide.location[i]),"value"], na.rm=TRUE)[4] + 1.5*IQR) #calculate upper bound
  lowerBound <- as.numeric(quantile(Env.Data.Master[which(Env.Data.Master$metric %in% "pH" & Env.Data.Master$variable %in% Tide.location[i]),"value"], na.rm=TRUE)[2] - 1.5*IQR) #calculate lower bound
  Env.Data.Master.noOuts[which(Env.Data.Master.noOuts$metric %in% "pH" & Env.Data.Master.noOuts$variable %in% Tide.location[i] & Env.Data.Master.noOuts$value > upperBound), "value"] <- NA #replace values higher than upper bound with NA
  Env.Data.Master.noOuts[which(Env.Data.Master.noOuts$metric %in% "pH" & Env.Data.Master.noOuts$variable %in% Tide.location[i] & Env.Data.Master.noOuts$value < lowerBound), "value"] <- NA #replace values lower than lower bound with NA
}

# DO Data
for(i in 1:length(Tide.location)) { #For individual site data
  IQR <- quantile(Env.Data.Master[which(Env.Data.Master$metric %in% "DO" & Env.Data.Master$variable %in% Tide.location[i]),"value"], na.rm=TRUE)[4] - quantile(Env.Data.Master[which(Env.Data.Master$metric %in% "DO" & Env.Data.Master$variable %in% Tide.location[i]),"value"], na.rm=TRUE)[2]
  upperBound <- as.numeric(quantile(Env.Data.Master[which(Env.Data.Master$metric %in% "DO" & Env.Data.Master$variable %in% Tide.location[i]),"value"], na.rm=TRUE)[4] + 1.5*IQR) #replace values higher than upper bound with NA
  lowerBound <- 0 #DO cannot be less than 0
  Env.Data.Master.noOuts[which(Env.Data.Master.noOuts$metric %in% "DO" & Env.Data.Master.noOuts$variable %in% Tide.location[i] & Env.Data.Master.noOuts$value > upperBound), "value"] <- NA
  Env.Data.Master.noOuts[which(Env.Data.Master.noOuts$metric %in% "DO" & Env.Data.Master.noOuts$variable %in% Tide.location[i] & Env.Data.Master.noOuts$value < lowerBound), "value"] <- NA
}

# Salinity Data
for(i in 1:length(Tide.location)) { #For individual site data
  IQR <- quantile(Env.Data.Master[which(Env.Data.Master$metric %in% "Salinity" & Env.Data.Master$variable %in% Tide.location[i]),"value"], na.rm=TRUE)[4] - quantile(Env.Data.Master[which(Env.Data.Master$metric %in% "Salinity" & Env.Data.Master$variable %in% Tide.location[i]),"value"], na.rm=TRUE)[2]
  upperBound <- as.numeric(quantile(Env.Data.Master[which(Env.Data.Master$metric %in% "Salinity" & Env.Data.Master$variable %in% Tide.location[i]),"value"], na.rm=TRUE)[4] + 1.5*IQR) #calculate upper bound
  lowerBound <- as.numeric(quantile(Env.Data.Master[which(Env.Data.Master$metric %in% "Salinity" & Env.Data.Master$variable %in% Tide.location[i]),"value"], na.rm=TRUE)[2] - 1.5*IQR) #calculate lower bound
  Env.Data.Master.noOuts[which(Env.Data.Master.noOuts$metric %in% "Salinity" & Env.Data.Master.noOuts$variable %in% Tide.location[i] & Env.Data.Master.noOuts$value > upperBound), "value"] <- NA #replace values higher than upper bound with NA
  Env.Data.Master.noOuts[which(Env.Data.Master.noOuts$metric %in% "Salinity" & Env.Data.Master.noOuts$variable %in% Tide.location[i] & Env.Data.Master.noOuts$value < lowerBound), "value"] <- NA #replace values lower than lower bound with NA
}

# Remove the NA entries 
Env.Data.Master.noOuts <- Env.Data.Master.noOuts[which(!is.na(Env.Data.Master.noOuts$value)),]

# Remove SK entries
Env.Data.Master.noOuts <- subset(Env.Data.Master.noOuts, variable!="SK-E")
Env.Data.Master.noOuts <- subset(Env.Data.Master.noOuts, variable!="SK-B")

# Save this outlier-scrubbed dataset as .csv
write.csv(file="results/Environmental/EnvData-Melted-NoOutliers.csv",Env.Data.Master.noOuts, col.names = T, row.names=F)

# Plot the final environmental data sets to be used in analysis 

# ==> pH
pH.series.noOuts <- plot_ly(data = subset(Env.Data.Master.noOuts, metric=="pH"), x = ~DateTime, y = ~value, type="scatter", mode="lines", color=~variable, hovertext=~value) %>%  #generate plotly plot
  layout(title="pH across sites (outliers removed)\n2016 DNR outplant",
         yaxis = list(title = 'pH (total scale)'),
         legend = list(x=.95, y=.95))

Salinity.series.noOuts <- plot_ly(data = subset(Env.Data.Master.noOuts, metric=="Salinity"), x = ~DateTime, y = ~value, type="scatter", mode="lines", color=~variable, hovertext=~value) %>%  #generate plotly plot
  layout(title="Salinity across sites (outliers removed)\n2016 DNR outplant",
         yaxis = list(title = 'Salinity'),
         legend = list(x=.95, y=.95))

DO.series.noOuts <- plot_ly(data = subset(Env.Data.Master.noOuts, metric=="DO"), x = ~DateTime, y = ~value, type="scatter", mode="lines", color=~variable, hovertext=~value) %>%  #generate plotly plot
  layout(title="DO across sites (outliers removed)\n2016 DNR outplant",
         yaxis = list(title = 'Dissolved Oxygen (mg/L)'),
         legend = list(x=.95, y=.95))

Temperature.series.noOuts <- plot_ly(data = subset(Env.Data.Master.noOuts, metric=="Temperature"), x = ~DateTime, y = ~value, type="scatter", mode="lines", color=~variable, hovertext=~value) %>%  #generate plotly plot
  layout(title="Temperature across sites (outliers removed)\n2016 DNR outplant",
         yaxis = list(title = 'Temperature (C)'),
         legend = list(x=.95, y=.95))

pH.series.noOuts
Salinity.series.noOuts
DO.series.noOuts
Temperature.series.noOuts

# Pull summary statistics for each environmental variable by location 
EnvSum <- set_colnames(aggregate(value ~ variable*metric + Bay + Habitat + Region, Env.Data.Master.noOuts, mean), c("variable", "metric", "Bay", "Habitat", "Region", "Mean"))
EnvSum$Median <- aggregate(value ~ variable*metric + Bay + Habitat + Region, Env.Data.Master.noOuts, median)$value
EnvSum$sd <- aggregate(value ~ variable*metric + Bay + Habitat + Region, Env.Data.Master.noOuts, sd)$value
EnvSum$Var <- aggregate(value ~ variable*metric + Bay + Habitat + Region, Env.Data.Master.noOuts, var)$value
EnvSum$Min <- aggregate(value ~ variable*metric + Bay + Habitat + Region, Env.Data.Master.noOuts, min)$value
EnvSum$Max <- aggregate(value ~ variable*metric + Bay + Habitat + Region, Env.Data.Master.noOuts, max)$value

View(t(EnvSum))

# Grand mean, sd, variance values 
aggregate(value ~ metric, Env.Data.Master.noOuts, max)
aggregate(value ~ metric + Habitat , Env.Data.Master.noOuts, mean)
aggregate(value ~ metric + Habitat , Env.Data.Master.noOuts, var)
aggregate(value ~ metric, Env.Data.Master.noOuts, var)
aggregate(value ~ metric + Bay , Env.Data.Master.noOuts, mean)

# Correlation plots between summary stats within enviromental parameters 
pairs(EnvSum[6:11]) # Independent parameters to use: Mean, Var

# ANOVA testing on mean & variance 

# compare means 
e.ANOVA.mean.habitat <- vector("list", length(Env.parameters))
for (i in 1:length(Env.parameters)) {
  temp1 <- anova(lm(Mean ~ Habitat, EnvSum[which(EnvSum$metric %in% Env.parameters[[i]]),]))
  e.ANOVA.mean.habitat[[i]] <- as.data.frame(temp1[,c(1:5)])
  e.ANOVA.mean.habitat[[i]]$metric <- c((Env.parameters[i]))
  e.ANOVA.mean.habitat[[i]]$Response <-  rownames(e.ANOVA.mean.habitat[[i]])
  e.ANOVA.mean.habitat[[i]]$Comparison <-  c("Habitat")
  e.ANOVA.mean.habitat[[i]]$Stat <-  c("Mean")
}
e.ANOVA.mean.bay <- vector("list", length(Env.parameters))
for (i in 1:length(Env.parameters)) {
  temp1 <- anova(lm(Mean ~ Bay, EnvSum[which(EnvSum$metric %in% Env.parameters[[i]]),]))
  e.ANOVA.mean.bay[[i]] <- as.data.frame(temp1[,c(1:5)])
  e.ANOVA.mean.bay[[i]]$metric <- c((Env.parameters[i]))
  e.ANOVA.mean.bay[[i]]$Response <-  rownames(e.ANOVA.mean.bay[[i]])
  e.ANOVA.mean.bay[[i]]$Comparison <-  c("Bay")
  e.ANOVA.mean.bay[[i]]$Stat <-  c("Mean")
}
e.ANOVA.mean.region <- vector("list", length(Env.parameters))
for (i in 1:length(Env.parameters)) {
  temp1 <- anova(lm(Mean ~ Region, EnvSum[which(EnvSum$metric %in% Env.parameters[[i]]),]))
  e.ANOVA.mean.region[[i]] <- as.data.frame(temp1[,c(1:5)])
  e.ANOVA.mean.region[[i]]$metric <- c((Env.parameters[i]))
  e.ANOVA.mean.region[[i]]$Response <-  rownames(e.ANOVA.mean.region[[i]])
  e.ANOVA.mean.region[[i]]$Comparison <-  c("Region")
  e.ANOVA.mean.region[[i]]$Stat <-  c("Mean")
}

# Compare variances 
e.ANOVA.var.habitat <- vector("list", length(Env.parameters))
for (i in 1:length(Env.parameters)) {
  temp1 <- anova(lm(Var ~ Habitat, EnvSum[which(EnvSum$metric %in% Env.parameters[[i]]),]))
  e.ANOVA.var.habitat[[i]] <- as.data.frame(temp1[,c(1:5)])
  e.ANOVA.var.habitat[[i]]$metric <- c((Env.parameters[i]))
  e.ANOVA.var.habitat[[i]]$Response <-  rownames(e.ANOVA.var.habitat[[i]])
  e.ANOVA.var.habitat[[i]]$Comparison <-  c("Habitat")
  e.ANOVA.var.habitat[[i]]$Stat <-  c("Var")
}
e.ANOVA.var.bay <- vector("list", length(Env.parameters))
for (i in 1:length(Env.parameters)) {
  temp1 <- anova(lm(Var ~ Bay, EnvSum[which(EnvSum$metric %in% Env.parameters[[i]]),]))
  e.ANOVA.var.bay[[i]] <- as.data.frame(temp1[,c(1:5)])
  e.ANOVA.var.bay[[i]]$metric <- c((Env.parameters[i]))
  e.ANOVA.var.bay[[i]]$Response <-  rownames(e.ANOVA.var.bay[[i]])
  e.ANOVA.var.bay[[i]]$Comparison <-  c("Bay")
  e.ANOVA.var.bay[[i]]$Stat <-  c("Var")
}
e.ANOVA.var.region <- vector("list", length(Env.parameters))
for (i in 1:length(Env.parameters)) {
  temp1 <- anova(lm(Var ~ Region, EnvSum[which(EnvSum$metric %in% Env.parameters[[i]]),]))
  e.ANOVA.var.region[[i]] <- as.data.frame(temp1[,c(1:5)])
  e.ANOVA.var.region[[i]]$metric <- c((Env.parameters[i]))
  e.ANOVA.var.region[[i]]$Response <-  rownames(e.ANOVA.var.region[[i]])
  e.ANOVA.var.region[[i]]$Comparison <-  c("Region")
  e.ANOVA.var.region[[i]]$Stat <-  c("Var")
}

Env.ANOVA <- do.call("rbind", list(e.ANOVA.mean.habitat, e.ANOVA.mean.bay, e.ANOVA.mean.region, e.ANOVA.var.habitat, e.ANOVA.var.bay, e.ANOVA.var.region))
Env.ANOVA <- do.call(rbind, Env.ANOVA)
Env.ANOVA$P.adj <- (Env.ANOVA$`Pr(>F)`*4)
View(Env.ANOVA)

write.csv(file="results/Environmental/Environmental-ANOVA-Results.csv", Env.ANOVA)

# Generate time-series of daily means, daily variance pH

# Join outlier-scrubbed master environmental dataset with metadata 
metadata <- aggregate(Region ~ Bay + Habitat +Sample.Shorthand, data.melted.plus.pepsum, FUN=unique)
Env.Data.Master.noOuts <- merge(x=Env.Data.Master.noOuts, y=metadata, by.x = "variable", by.y = "Sample.Shorthand", all.x=T, all.y=T)

# convert to date/time and retain as a new field
Env.Data.Master.noOuts$DateTime <- as.POSIXct(strptime(Env.Data.Master.noOuts$DateTime, format="%m/%d/%Y %H:%M:%S", tz=Sys.timezone())) # date in the format: YearMonthDay Hour:Minute

# use dplyr and mutate to add a day column to your data
Env.Data.Master.noOuts_daily <- Env.Data.Master.noOuts %>%
  mutate(Day = as.Date(DateTime, format = "%Y-%m-%d"))

# Calculate daily mean environmental parameters, excluding tidal heigh
Env.Data.Master.noOuts_daily <- as.data.frame(subset(Env.Data.Master.noOuts, !((metric=="Tide")))  %>%
                                                mutate(Day = as.Date(DateTime, format = "%Y-%m-%d")) %>%
                                                group_by(Day, variable, metric, Bay, Habitat, Region) %>% # group by the day column
                                                summarise(daily.mean=mean(value), daily.sd=sd(value), daily.var=var(value)) %>%  
                                                na.omit())

# Assess normality of daily means - pretty good 
par(mfrow = c(2, 2))
for (i in 1:length(Env.parameters)) {
  qqnorm(Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% Env.parameters[i]),"daily.mean"], main = Env.parameters[[i]],
         xlab = "Theoretical Quantiles", ylab = "Daily Mean Parameter Value", plot.it = TRUE)
  qqline(Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% Env.parameters[i]),"daily.mean"])}
for (i in 1:length(Env.parameters)) {
  hist(Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% Env.parameters[i]),"daily.mean"], main = Env.parameters[[i]], xlab = "Frequency")}

# Test differences on daily mean dataframe

# Are daily means different between Bay, Habitats within Bay? 
anova(lm(daily.mean ~ Bay*Habitat, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "pH"),])) #yes
summary(lm(daily.mean ~ Bay*Habitat, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "pH"),])) #yes

anova(lm(daily.mean ~ Bay*Habitat, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "DO"),]))  #yes
summary(lm(daily.mean ~ Bay*Habitat, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "DO"),]))  #yes

anova(lm(daily.mean ~ Bay* Habitat, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "Temperature"),])) #not between habitats
summary(lm(daily.mean ~ Bay* Habitat, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "Temperature"),])) #not between habitats

anova(lm(daily.mean ~ Bay* Habitat, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "Salinity"),]))  #yes 
summary(lm(daily.mean ~ Bay* Habitat, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "Salinity"),]))  #yes


# Assess normality of daily variance - not normal. 
par(mfrow = c(2, 2))
for (i in 1:length(Env.parameters)) {
  qqnorm(Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% Env.parameters[i]),"daily.var"], main = Env.parameters[[i]],
         xlab = "Theoretical Quantiles", ylab = "Daily Mean Parameter Value", plot.it = TRUE)
  qqline(Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% Env.parameters[i]),"daily.var"])}
for (i in 1:length(Env.parameters)) {
  hist(Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% Env.parameters[i]),"daily.var"], main = Env.parameters[[i]], xlab = "Frequency")}

#calculate lambda value to use to transform daily variances  
par(mfrow = c(4, 3))
for (i in 1:length(Env.parameters)) {
  print(Env.parameters[[i]])
  transformTukey(Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% Env.parameters[i]),"daily.var"], plotit=TRUE, statistic = 1) 
}

#Create new column in dataframe with lambda-transformed area data
Env.Data.Master.noOuts_daily$var.lambda <- c(rep("x", times=nrow(Env.Data.Master.noOuts_daily)))

# Transform abundance data via its designated lambda value 
var.lambda <- c(0.05, 0.1, 0.375, -0.15) #pulled from console print-out 
for (i in 1:length(Env.parameters)) {
  Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% Env.parameters[i]),"var.lambda"] <-Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% Env.parameters[i]),"daily.var"]^var.lambda[i]
}

#convert lambda.t values to numeric
Env.Data.Master.noOuts_daily$var.lambda <- as.numeric(Env.Data.Master.noOuts_daily$var.lambda) 

# Confirm normality of transformed daily variance 
par(mfrow = c(2, 2))
for (i in 1:length(Env.parameters)) {
  qqnorm(Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% Env.parameters[i]),"var.lambda"], main = Env.parameters[[i]],
         xlab = "Theoretical Quantiles", ylab = "Daily Mean Parameter Value", plot.it = TRUE)
  qqline(Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% Env.parameters[i]),"var.lambda"])}
for (i in 1:length(Env.parameters)) {
  hist(Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% Env.parameters[i]),"var.lambda"], main = Env.parameters[[i]], xlab = "Frequency")}

# Test differences on daily var (transformed) dataframe

# Are daily means different between Bay, Habitats within Bay? 
anova(lm(var.lambda ~ Bay*Habitat, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "pH"),]))
summary(lm(var.lambda ~ Bay*Habitat, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "pH"),])) #yes

anova(lm(var.lambda ~ Bay*Habitat, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "DO"),]))  #yes
summary(lm(var.lambda ~ Bay*Habitat, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "DO"),]))  #yes

anova(lm(var.lambda ~ Bay* Habitat, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "Temperature"),])) #not between habitats
summary(lm(var.lambda ~ Bay* Habitat, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "Temperature"),])) #not between habitats

anova(lm(var.lambda ~ Bay* Habitat, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "Salinity"),]))  #yes 
summary(lm(var.lambda ~ Bay* Habitat, data=Env.Data.Master.noOuts_daily[which(Env.Data.Master.noOuts_daily$metric %in% "Salinity"),]))  #yes

# Plot daily environmental parameters 
group.colors <- c(WB = "sienna1", CI = "goldenrod1", PG ="steelblue2",  FB = "royalblue3")

# Daily mean pH 

png("results/Environmental/pH-FB-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts_daily, (metric=="pH" & (variable=="FB-E" | variable=="FB-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="royalblue3")  + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank())  + ggtitle("Fidalgo Bay pH") + ylim(6.84, 8.24) + xlim("0016-06-01"," 0016-07-19")
dev.off() 

png("results/Environmental/pH-PG-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts_daily, (metric=="pH" & (variable=="PG-E" | variable=="PG-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="steelblue2")  + scale_linetype_manual(values=c("solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank())  + ggtitle("Port Gamble Bay pH") + ylim(6.84, 8.24) + xlim("0016-06-01"," 0016-07-19")
dev.off()

png("results/Environmental/pH-CI-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts_daily, (metric=="pH" & (variable=="CI-E" | variable=="CI-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="goldenrod1")   + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank())  + ggtitle("Case Inlet pH") + ylim(6.84, 8.24) + xlim("0016-06-01"," 0016-07-19")
dev.off()

png("results/Environmental/pH-WB-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts_daily, (metric=="pH" & (variable=="WB-E" | variable=="WB-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="sienna1")   + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank()) + ggtitle("Willapa Bay pH") + ylim(6.84, 8.24) + xlim("0016-06-01"," 0016-07-19")
dev.off()

# Daily mean DO
png("results/Environmental/DO-FB-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts_daily, (metric=="DO" & (variable=="FB-E" | variable=="FB-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="royalblue3") + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank()) + ggtitle("Fidalgo Bay DO")  + ylim(0, 21) + xlim("0016-06-01"," 0016-07-19")
dev.off()

png("results/Environmental/DO-PG-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts_daily, (metric=="DO" & (variable=="PG-E" | variable=="PG-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="steelblue2")  + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank())  + ggtitle("Port Gamble Bay DO") + ylim(0, 21) + xlim("0016-06-01"," 0016-07-19")
dev.off()

png("results/Environmental/DO-CI-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts_daily, (metric=="DO" & (variable=="CI-E" | variable=="CI-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="goldenrod1")   + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank())  + ggtitle("Case Inlet DO") + ylim(0, 21) + xlim("0016-06-01"," 0016-07-19")
dev.off()

png("results/Environmental/DO-WB-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts_daily, (metric=="DO" & (variable=="WB-E" | variable=="WB-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="sienna1")  + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank()) + ggtitle("Willapa Bay DO") + ylim(0, 21) + xlim("0016-06-01"," 0016-07-19")
dev.off()

# Daily Mean Temperature 
png("results/Environmental/Temp-FB-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts_daily, (metric=="Temperature" & (variable=="FB-E" | variable=="FB-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="royalblue3") + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank()) + ggtitle("Fidalgo Bay Temperature")  + ylim(10, 25) + xlim("0016-06-01"," 0016-07-19")
dev.off()

png("results/Environmental/Temp-PG-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts_daily, (metric=="Temperature" & (variable=="PG-E" | variable=="PG-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="steelblue2")  + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank())  + ggtitle("Port Gamble Bay Temperature") + ylim(10, 25) + xlim("0016-06-01"," 0016-07-19")
dev.off()

png("results/Environmental/Temp-CI-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts_daily, (metric=="Temperature" & (variable=="CI-E" | variable=="CI-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="goldenrod1")   + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank())  + ggtitle("Case Inlet Temperature") + ylim(10, 25) + xlim("0016-06-01"," 0016-07-19")
dev.off()

png("results/Environmental/Temp-WB-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts_daily, (metric=="Temperature" & (variable=="WB-E" | variable=="WB-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="sienna1")  + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank()) + ggtitle("Willapa Bay Temperature") + ylim(10, 25) + xlim("0016-06-01"," 0016-07-19")
dev.off()

# Daily Mean Salinity 
png("results/Environmental/Salinity-FB-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts_daily, (metric=="Salinity" & (variable=="FB-E" | variable=="FB-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="royalblue3") + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank()) + ggtitle("Fidalgo Bay Salinity")  + ylim(25, 45) + xlim("0016-06-01"," 0016-07-19")
dev.off()

png("results/Environmental/Salinity-PG-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts_daily, (metric=="Salinity" & (variable=="PG-E" | variable=="PG-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="steelblue2")  + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank())  + ggtitle("Port Gamble Bay Salinity") + ylim(25, 45) + xlim("0016-06-01"," 0016-07-19")
dev.off()

png("results/Environmental/Salinity-CI-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts_daily, (metric=="Salinity" & (variable=="CI-E" | variable=="CI-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="goldenrod1")   + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank())  + ggtitle("Case Inlet Salinity") + ylim(25, 45) + xlim("0016-06-01"," 0016-07-19")
dev.off()

png("results/Environmental/Salinity-WB-daily-mean.png", width=700, height=700)
ggplot(data=subset(Env.Data.Master.noOuts_daily, (metric=="Salinity" & (variable=="WB-E" | variable=="WB-B"))), aes(x=Day,y=daily.mean,colour=variable,group=variable)) + geom_line(size=2, aes(linetype=variable), color="sienna1")  + scale_linetype_manual(values=c("dashed", "solid")) + geom_ribbon(aes(ymax=daily.mean + daily.sd, ymin=daily.mean-daily.sd, alpha=0.5), colour=NA, fill = "grey70") + theme_light() + theme(plot.title = element_text(size=24, face="bold"), axis.text.y=element_text(size=18, angle=45, face="bold"), axis.text.x=element_text(size=18, face="bold"), axis.title=element_blank(), legend.position = "none", panel.background = element_blank()) + ggtitle("Willapa Bay Salinity") + ylim(25, 45) + xlim("0016-06-01"," 0016-07-19")
dev.off()
