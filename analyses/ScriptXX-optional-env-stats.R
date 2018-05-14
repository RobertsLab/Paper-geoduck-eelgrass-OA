### Optional statistics on full environmental data sets; not included in paper 

# Check environmental parameters for normality, equal variance between factors 

# Run QQplots to assess environmental data normality 
par(mfrow = c(2, 2))
for (i in 1:length(Env.parameters)) {
  qqnorm(Env.Data.Master.noOuts[which(Env.Data.Master.noOuts$metric %in% Env.parameters[i]),"value"], main = Env.parameters[[i]],
         xlab = "Theoretical Quantiles", ylab = "Parameter Value", plot.it = TRUE)
  qqline(Env.Data.Master.noOuts[which(Env.Data.Master.noOuts$metric %in% Env.parameters[i]),"value"])}

for (i in 1:length(Env.parameters)) {
  hist(Env.Data.Master.noOuts[which(Env.Data.Master.noOuts$metric %in% Env.parameters[i]),"value"], main = Env.parameters[[i]],
       xlab = "Frequency")}

# Make new dataframe to later transform each parameter for normality 
Env.Data.Master.noOuts.tran <- Env.Data.Master.noOuts

# Analysis on QA-d environmental data: 
# - transform 
# - equal variance test / calculate variance ratios between habitats within bays
# - ANOVA nested 2-factor (Bay, Habitat)
# - 2-sample t-test, for each site separately to compare habitats w/n site
# - salinity data is bimodal, will use non-parametric test instead
# Analysis on daily mean & daily variance dataframes: 
# ANOVA nested 2-factor (Bay, Habitat)

# pH data 

Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "pH"),"value"] <- Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "pH"),"value"]^3
hist(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "pH"),"value"], main = "(Daily mean pH^3)", xlab = "Frequency")
bartlett.test(value~variable, data=Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "pH"),]) #unequal variance

# calculating variance differences between habitats within bays 
# Variance ratio for FB-E/FB-B
var(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "pH" & Env.Data.Master.noOuts.tran$variable %in% "FB-E"),]$value)/var(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "pH" & Env.Data.Master.noOuts.tran$variable %in% "FB-B"),]$value)
# Variance ratio for CI-E/CI-B
var(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "pH" & Env.Data.Master.noOuts.tran$variable %in% "CI-E"),]$value)/var(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "pH" & Env.Data.Master.noOuts.tran$variable %in% "CI-B"),]$value)
# Variance ratio for WB-E/WB-B
var(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "pH" & Env.Data.Master.noOuts.tran$variable %in% "WB-E"),]$value)/var(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "pH" & Env.Data.Master.noOuts.tran$variable %in% "WB-B"),]$value)

# nested 2-factor ANOVA to test differences between bays, and habitats within bays. All significantly different (F is very large)
anova(lm(value ~ Bay/Habitat, data=Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "pH"),]))
summary(lm(value ~ Bay/Habitat, data=Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "pH"),])) 

# Estimates from this lm are mean pH values for each location 
summary(lm(value ~ variable-1, data=Env.Data.Master.noOuts[which(Env.Data.Master.noOuts$metric %in% "pH"),])) 

# 2-sample t-test, unequal variance for each bay to test differences between habitats
t.test(value ~ Habitat, data=(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "pH" & Env.Data.Master.noOuts.tran$Bay %in% "FB"),]), var.equal=FALSE)
t.test(value ~ Habitat, data=(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "pH" & Env.Data.Master.noOuts.tran$Bay %in% "CI"),]), var.equal=FALSE)
t.test(value ~ Habitat, data=(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "pH" & Env.Data.Master.noOuts.tran$Bay %in% "WB"),]), var.equal=FALSE)

# Dissolved Oxygen data 

Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "DO"),"value"] <- sqrt(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "DO"),"value"])
hist(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "DO"),"value"], main = "sqrt(DO)", xlab = "Frequency")
bartlett.test(value~variable, data=Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "DO"),]) #unequal variance

# calculating variance differences between habitats within bays 
# Variance ratio for FB-E/FB-B
var(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "DO" & Env.Data.Master.noOuts.tran$variable %in% "FB-E"),]$value)/var(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "DO" & Env.Data.Master.noOuts.tran$variable %in% "FB-B"),]$value)
# Variance ratio for PG-E/PG-B
var(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "DO" & Env.Data.Master.noOuts.tran$variable %in% "CI-E"),]$value)/var(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "DO" & Env.Data.Master.noOuts.tran$variable %in% "CI-B"),]$value)
# Variance ratio for CI-E/CI-B
var(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "DO" & Env.Data.Master.noOuts.tran$variable %in% "CI-E"),]$value)/var(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "DO" & Env.Data.Master.noOuts.tran$variable %in% "CI-B"),]$value)
# Variance ratio for WB-E/WB-B
var(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "DO" & Env.Data.Master.noOuts.tran$variable %in% "WB-E"),]$value)/var(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "DO" & Env.Data.Master.noOuts.tran$variable %in% "WB-B"),]$value)

# nested 2-factor ANOVA to test differences between bays, and habitats within bays. All significantly different (F is very large)
anova(lm(value ~ Bay/Habitat, data=Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "DO"),]))
summary(lm(value ~ Bay/Habitat, data=Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "DO"),])) 

# 2-sample t-test, unequal variance for each bay to test differences between habitats
t.test(value ~ Habitat, data=(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "DO" & Env.Data.Master.noOuts.tran$Bay %in% "FB"),]), var.equal=FALSE)
t.test(value ~ Habitat, data=(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "DO" & Env.Data.Master.noOuts.tran$Bay %in% "PG"),]), var.equal=FALSE)
t.test(value ~ Habitat, data=(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "DO" & Env.Data.Master.noOuts.tran$Bay %in% "CI"),]), var.equal=FALSE)
t.test(value ~ Habitat, data=(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "DO" & Env.Data.Master.noOuts.tran$Bay %in% "WB"),]), var.equal=FALSE)

# Temperature data 

Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "Temperature"),"value"] <- 1/(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "Temperature"),"value"])
hist(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "Temperature"),"value"], main = "1/(Temperature)", xlab = "Frequency")
bartlett.test(value~variable, data=Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "Temperature"),]) #unequal variance

# calculating variance differences between habitats within bays 
# Variance ratio for FB-E/FB-B
var(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "Temperature" & Env.Data.Master.noOuts.tran$variable %in% "FB-E"),]$value)/var(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "Temperature" & Env.Data.Master.noOuts.tran$variable %in% "FB-B"),]$value)
# Variance ratio for PG-E/PG-B
var(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "Temperature" & Env.Data.Master.noOuts.tran$variable %in% "CI-E"),]$value)/var(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "Temperature" & Env.Data.Master.noOuts.tran$variable %in% "CI-B"),]$value)
# Variance ratio for CI-E/CI-B
var(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "Temperature" & Env.Data.Master.noOuts.tran$variable %in% "CI-E"),]$value)/var(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "Temperature" & Env.Data.Master.noOuts.tran$variable %in% "CI-B"),]$value)
# Variance ratio for WB-E/WB-B
var(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "Temperature" & Env.Data.Master.noOuts.tran$variable %in% "WB-E"),]$value)/var(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "Temperature" & Env.Data.Master.noOuts.tran$variable %in% "WB-B"),]$value)

# nested 2-factor ANOVA to test differences between bays, and habitats within bays. All except FB & PGB 
anova(lm(value ~ Bay/Habitat, data=Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "Temperature"),]))
summary(lm(value ~ Bay/Habitat, data=Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "Temperature"),])) 

# Salinity data

# Non-normal distribution (Bimodal, will test untransformed data)
bartlett.test(value~variable, data=Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "Salinity"),]) #unequal variance

# for unequal variance 
ks.test(
  x=Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "Salinity" & Env.Data.Master.noOuts.tran$variable %in% "WB-E"),]$value, 
  y=(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "Salinity" & Env.Data.Master.noOuts.tran$variable %in% "WB-B"),]$value))
ks.test(
  x=Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "Salinity" & Env.Data.Master.noOuts.tran$variable %in% "FB-E"),]$value, 
  y=(Env.Data.Master.noOuts.tran[which(Env.Data.Master.noOuts.tran$metric %in% "Salinity" & Env.Data.Master.noOuts.tran$variable %in% "FB-B"),]$value))

# equal variance, testing between habitats w/n bays 
kruskal.test(value ~ Habitat, data=Env.Data.Master.noOuts[which(Env.Data.Master.noOuts$metric %in% "Salinity" & Env.Data.Master.noOuts$Bay %in% "FB"),]) 
kruskal.test(value ~ Habitat, data=Env.Data.Master.noOuts[which(Env.Data.Master.noOuts$metric %in% "Salinity" & Env.Data.Master.noOuts$Bay %in% "WB"),]) 

# between bays 
kruskal.test(value ~ Bay, data=Env.Data.Master.noOuts[which(Env.Data.Master.noOuts$metric %in% "Salinity"),]) 

