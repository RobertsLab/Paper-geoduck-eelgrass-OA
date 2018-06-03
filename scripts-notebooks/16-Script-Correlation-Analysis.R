
# Merge protein data with environmental summary stats 
Master.temp <- data.frame(merge(x=data.melted.plus.pepsum.wide[c("Protein", "Sample", "Sample.Shorthand", "Pep1", "Pep2", "Pep3")], y=EnvSum, by.x = "Sample.Shorthand", by.y = "variable", all.x=TRUE, all.y=TRUE), stringsAsFactors = FALSE)
Master.SRM <- data.frame(merge(x=Growth[c("PRVial", "FShell", "AvgIShell", "Growth")], y=Master.temp, by.x="PRVial", by.y="Sample", all.x=T, all.y=T))

# Reformat dataframe 
Master.SRM[Master.SRM == "NaN"] <- NA #Replace NaN strings with official "NA" designation 
Master.SRM$Region <- as.factor(Master.SRM$Region) #convert environmental stats to numeric
levels(Master.SRM$Protein) <- c(levels(Master.SRM$Protein), "NaK-ATPase") #Replace protein name to remove slash 
Master.SRM$Protein[Master.SRM$Protein == 'Sodium/potassium-transporting'] <- 'NaK-ATPase'
Protein.names.corr <- levels(Master.SRM$Protein)
Protein.names.corr <- Protein.names.corr[-11]
write.csv(file="results/SRM/Master-Data-Joined.csv", Master.SRM)

# Investigating correlation between growth, peptide abundance 
# Note: Pep1 is the most abundant (within a protein), followed by Pep2, then Pep3
plot(Master.SRM[c("Growth", "Pep1", "Pep2", "Pep3")]) # It looks like protein abundance increased with growth 

# Confirmed more interactive plot. 
plot_ly(data=Master.SRM, y=~Pep1, x=~Growth, type="scatter", color=~Protein) %>% 
  layout(title="Peptide against Growth",
         yaxis = list(title = 'Protein Abundance'),
         legend = list(x=.85, y=.95))

# Correlation test by protein 
grow.Pep1.cor <- data.frame(matrix(ncol=4, nrow=0))
colnames(grow.Pep1.cor) <- c("Protein", "Estimate", "Statistic", "P-Value")
# Calculate correlation coefficien and plot peptides against growth for each protein 
for (i in 1:length(Protein.names.corr)) {
  temp1 <- cor.test(~Growth + Pep1, data=Master.SRM[grepl(Protein.names.corr[[i]], Master.SRM$Protein),])
  grow.Pep1.cor[i,"Protein"] <- Protein.names.corr[[i]]
  grow.Pep1.cor[i,"Estimate"] <- temp1$estimate
  grow.Pep1.cor[i,"Statistic"] <- temp1$statistic
  grow.Pep1.cor[i,"P-Value"] <- temp1$p.value
}
write.csv(file="results/SRM/Grow-Abun-Cor-test.csv", grow.Pep1.cor)
grow.Pep1.cor$P.corr <- (grow.Pep1.cor$`P-Value`)*13

# Generate correlation plots between growth & Peptide 1 abundance (most abundant/detected peptide in all proteins) 
for (i in 1:length(Protein.names.corr)) {
  png(paste("results/Correlation-plots/", Protein.names.corr[[i]], "-Grow-Corrplot.png", sep=""), width=700, height=700)
 plot(Master.SRM[grepl(Protein.names.corr[[i]], Master.SRM$Protein),][c("Growth", "Pep1")], main=paste(Protein.names.corr[[i]], "\nPeptide Abundance ~ Growth", sep=""), ylab="Peptide 1 Abundance", xlab="Relative Growth (mm)")
  dev.off()
}

# Investigating correlation between Growth & Environmental parameters: 

# Correlation test by environmental parameters

temp2 <- data.frame(matrix(ncol=5, nrow=0))
colnames(temp2) <- c("Env-Metric", "Env-Stat", "Estimate", "Statistic", "P-Value")
temp4 <- data.frame(matrix(ncol=5, nrow=0))
colnames(temp4) <- c("Env-Metric", "Env-Stat", "Estimate", "Statistic", "P-Value")

# Calculate correlation coefficient and plot peptides against growth for each protein 
for (i in 1:length(Env.parameters)) {
    temp1 <- cor.test(~Growth + Mean, data=Master.SRM[grepl(Env.parameters[[i]], Master.SRM$metric),])
    temp2[i,"Env-Metric"] <- Env.parameters[[i]]
    temp2[i,"Env-Stat"] <- "Mean"
    temp2[i,"Estimate"] <- temp1$estimate
    temp2[i,"Statistic"] <- temp1$statistic
    temp2[i,"P-Value"] <- temp1$p.value
    temp3 <- cor.test(~Growth + sd, data=Master.SRM[grepl(Env.parameters[[i]], Master.SRM$metric),])
    temp4[i,"Env-Metric"] <- Env.parameters[[i]]
    temp4[i,"Env-Stat"] <- "SD"
    temp4[i,"Estimate"] <- temp3$estimate
    temp4[i,"Statistic"] <- temp3$statistic
    temp4[i,"P-Value"] <- temp3$p.value
}
grow.env.cor <- rbind(temp2, temp4)
write.csv(file="results/Environmental/Grow-Env-Cor-test.csv", grow.env.cor)
grow.env.cor$p.adj <- (grow.env.cor$`P-Value`)*8
View(grow.env.cor)

# Generate correlation plots between relative growth mean pH, DO, Temp, Salinity
for (i in 1:length(Env.parameters)) {
  png(paste("results/Correlation-plots/", Env.parameters[[i]], "-Grow-Corrplot.png", sep=""), width=700, height=700)
  plot(Master.SRM[grepl(Env.parameters[[i]], Master.SRM$metric),][c("Mean", "Growth")], main=paste("Growth ~ Mean ", Env.parameters[[i]], sep=""), ylab="Relative Growth (mm)", xlab=paste("Mean ", Env.parameters[[i]], sep=""))
  dev.off()
}

# Generate correlation plots between relative growth & pH, DO, Temp, Salinity
for (i in 1:length(Env.parameters)) {
 png(paste("results/Correlation-plots/", Env.parameters[[i]], "-Grow-Corrplot.png", sep=""), width=700, height=700)
  plot(Master.SRM[grepl(Env.parameters[[i]], Master.SRM$metric),][c("Growth", "SD")], main=paste("Growth ~ ", Env.parameters[[i]], " SD", sep=""), ylab="Relative Growth (mm)", xlab=paste(Env.parameters[[i]], " SD", sep=""))
  dev.off()
}

# Investigating correlation between Peptide Abundance & Environmental parameters: 

# Correlation test of Pep1 by environmental parameters, each protein separately 

temp2 <- data.frame(matrix(ncol=6, nrow=0))
colnames(temp2) <- c("Protein", "Env-Paramter", "Env-Metric", "Estimate", "Statistic", "P-Value")
temp4 <- data.frame(matrix(ncol=6, nrow=0))
colnames(temp4) <- c("Protein", "Env-Paramter", "Env-Metric", "Estimate", "Statistic", "P-Value")
# Calculate correlation coefficien and plot peptides against growth for each protein 
for (j in 1:length(Env.parameters)) {
  for (i in 1:length(Protein.names.corr)) {
    temp1 <- cor.test(~Pep1 + Mean, data=subset(Master.SRM, (metric==Env.parameters[[j]] & Protein==Protein.names.corr[[i]])))
    temp2[i+13*j,"Protein"] <- Protein.names.corr[[i]]
    temp2[i+13*j,"Env-Paramter"] <- Env.parameters[[j]]
    temp2[i+13*j,"Env-Metric"] <- "Mean"
    temp2[i+13*j,"Estimate"] <- temp1$estimate    
    temp2[i+13*j,"Statistic"] <- temp1$statistic
    temp2[i+13*j,"P-Value"] <- temp1$p.value
  }
}

for (j in 1:length(Env.parameters)) {
  for (i in 1:length(Protein.names.corr)) {
    temp3 <- cor.test(~Pep1 + sd, data=subset(Master.SRM, (metric==Env.parameters[[j]] & Protein==Protein.names.corr[[i]])))  
    temp4[i+13*j,"Protein"] <- Protein.names.corr[[i]]
    temp4[i+13*j,"Env-Paramter"] <- Env.parameters[[j]]
    temp4[i+13*j,"Env-Metric"] <- "SD"
    temp4[i+13*j,"Estimate"] <- temp3$estimate    
    temp4[i+13*j,"Statistic"] <- temp3$statistic
    temp4[i+13*j,"P-Value"] <- temp3$p.value
  }
}
env.pep1.cor <- rbind(temp2, temp4)
env.pep1.cor$P.adj <- (env.pep1.cor$`P-Value`)*4
View(env.pep1.cor[-5:-6])

write.csv(file="results/SRM/Pep-Env-Cor-test.csv", env.pep1.cor)

# Generate correlation plots between Mean Environmental Parameters and  Peptide 1 abundance (most abundant/detected peptide in all proteins)  
# Mean pH 
for (i in 1:length(Protein.names.corr)) {
    png(paste("results/Correlation-plots/", Protein.names.corr[[i]], "-Mean-pH-Corrplot.png", sep=""), width=700, height=500)
    plot(subset(Master.SRM, (Protein==Protein.names.corr[[i]] & metric=="pH"))[c("Mean", "Pep1")], main=paste(Protein.names.corr[[i]], " Peptide Abundance ~ ", "\nMean pH", sep=""), ylab="Peptide 1 Abundance", xlab="Mean pH")
    dev.off()
   png(paste("results/Correlation-plots/", Protein.names.corr[[i]], "-pH SD-Corrplot.png", sep=""), width=700, height=500)
    plot(subset(Master.SRM, (Protein==Protein.names.corr[[i]] & metric=="pH"))[c("sd", "Pep1")], main=paste(Protein.names.corr[[i]], " Abundance ~ ", "\npH SD", sep=""), ylab="Peptide 1 Abundance", xlab="Mean pH")
    dev.off()
}

# DO 
for (i in 1:length(Protein.names.corr)) {
  png(paste("results/Correlation-plots/", Protein.names.corr[[i]], "-Mean-DO-Corrplot.png", sep=""), width=700, height=500)
  plot(subset(Master.SRM, (Protein==Protein.names.corr[[i]] & metric=="DO"))[c("Mean", "Pep1")], main=paste(Protein.names.corr[[i]], " Peptide Abundance ~ ", "\nMean DO", sep=""), ylab="Peptide 1 Abundance", xlab="Mean DO")
  dev.off()
  png(paste("results/Correlation-plots/", Protein.names.corr[[i]], "-DO SD-Corrplot.png", sep=""), width=700, height=500)
  plot(subset(Master.SRM, (Protein==Protein.names.corr[[i]] & metric=="DO"))[c("sd", "Pep1")], main=paste(Protein.names.corr[[i]], " Abundance ~ ", "\nDO SD", sep=""), ylab="Peptide 1 Abundance", xlab="Mean DO")
  dev.off()
}

#Temperature 
for (i in 1:length(Protein.names.corr)) {
  png(paste("results/Correlation-plots/", Protein.names.corr[[i]], "-Mean-Temperature-Corrplot.png", sep=""), width=700, height=500)
  plot(subset(Master.SRM, (Protein==Protein.names.corr[[i]] & metric=="Temperature"))[c("Mean", "Pep1")], main=paste(Protein.names.corr[[i]], " Peptide Abundance ~ ", "\nMean Temperature", sep=""), ylab="Peptide 1 Abundance", xlab="Mean Temperature")
  dev.off()
  png(paste("results/Correlation-plots/", Protein.names.corr[[i]], "-Temperature SD-Corrplot.png", sep=""), width=700, height=500)
  plot(subset(Master.SRM, (Protein==Protein.names.corr[[i]] & metric=="Temperature"))[c("sd", "Pep1")], main=paste(Protein.names.corr[[i]], " Abundance ~ ", "\nTemperature SD", sep=""), ylab="Peptide 1 Abundance", xlab="Mean Temperature")
  dev.off()
}

#Salinity 
for (i in 1:length(Protein.names.corr)) {
  png(paste("results/Correlation-plots/", Protein.names.corr[[i]], "-Mean-Salinity-Corrplot.png", sep=""), width=700, height=500)
  plot(subset(Master.SRM, (Protein==Protein.names.corr[[i]] & metric=="Salinity"))[c("Mean", "Pep1")], main=paste(Protein.names.corr[[i]], " Peptide Abundance ~ ", "\nMean Salinity", sep=""), ylab="Peptide 1 Abundance", xlab="Mean Salinity")
  dev.off()
  png(paste("results/Correlation-plots/", Protein.names.corr[[i]], "-Salinity SD-Corrplot.png", sep=""), width=700, height=500)
  plot(subset(Master.SRM, (Protein==Protein.names.corr[[i]] & metric=="Salinity"))[c("sd", "Pep1")], main=paste(Protein.names.corr[[i]], " Abundance ~ ", "\nSalinity SD", sep=""), ylab="Peptide 1 Abundance", xlab="Mean Salinity")
  dev.off()
}
