DilutionCurve <- read.csv("../../data/SRM/2017-09-05_Dilution-Curve-Results.csv", na.strings = "#N/A", stringsAsFactors = FALSE)
DilutionCurve.G <- DilutionCurve[grepl("-G", DilutionCurve$Replicate),] #remove data from oyster run
DilutionCurve.G.noPRTC <- DilutionCurve.G[!grepl("PRTC peptides", DilutionCurve.G$Protein.Name),]
DilutionCurve.G.noPRTC$Transition <- paste(DilutionCurve.G.noPRTC$Peptide.Sequence, DilutionCurve.G.noPRTC$Fragment.Ion, sep="-")
DC.transitions <- unique(DilutionCurve.G.noPRTC$Transition)
DC.transitions <- as.factor(DC.transitions)
DilutionCurve.G.noPRTC$Transition <- as.factor(DilutionCurve.G.noPRTC$Transition)
DC.D1G <- subset(DilutionCurve.G.noPRTC, Replicate=="D1-G")

# Add a column with the value measured in D1-G for each transition
for (i in 1:length(DC.transitions)) {
  DilutionCurve.G.noPRTC[which(DilutionCurve.G.noPRTC$Transition %in% DC.transitions[i]),"D1.value"] <- DC.D1G[which(DC.D1G$Transition %in% DC.transitions[i]), "Area"]
}

DilutionCurve.G.noPRTC$Act.Ratio <- DilutionCurve.G.noPRTC$Area/DilutionCurve.G.noPRTC$D1.value #Calculate the ratio for each transition/dilution sample, relative to D1-G
DilutionCurve.G.noPRTC$Replicate <- gsub("-G", "", DilutionCurve.G.noPRTC$Replicate)
DilutionCurve.G.noPRTC$Replicate <- as.numeric(gsub("D", "", DilutionCurve.G.noPRTC$Replicate))

DilutionCurve.G.noPRTC$Pred.Ratio <- NA
DilutionCurve.G.noPRTC[which(DilutionCurve.G.noPRTC$Replicate %in% "1"),]["Pred.Ratio"] <- 1 #D1-G had the lowest concentration of protein
DilutionCurve.G.noPRTC[which(DilutionCurve.G.noPRTC$Replicate %in% "2"),]["Pred.Ratio"] <- 1.3 #D2-G should have 1.3x more protein than D1-G ...
DilutionCurve.G.noPRTC[which(DilutionCurve.G.noPRTC$Replicate %in% "3"),]["Pred.Ratio"] <- 2
DilutionCurve.G.noPRTC[which(DilutionCurve.G.noPRTC$Replicate %in% "4"),]["Pred.Ratio"] <- 4
DilutionCurve.G.noPRTC[which(DilutionCurve.G.noPRTC$Replicate %in% "5"),]["Pred.Ratio"] <- 6
DilutionCurve.G.noPRTC[which(DilutionCurve.G.noPRTC$Replicate %in% "6"),]["Pred.Ratio"] <- 8
DilutionCurve.G.noPRTC[which(DilutionCurve.G.noPRTC$Replicate %in% "7"),]["Pred.Ratio"] <- 8.7
DilutionCurve.G.noPRTC[which(DilutionCurve.G.noPRTC$Replicate %in% "8"),]["Pred.Ratio"] <- 9 # ... D8-G should have 9x more protein than D1-G

DC.transition.results <- setNames(data.frame(matrix(ncol = 4, nrow = 0)), c("Transition", "Intercept", "Coefficient", "Adj.R.Squared"))
for (i in 1:length(DC.transitions)) {
  DC.transition.lm <- lm(Act.Ratio ~ Pred.Ratio, data=subset(DilutionCurve.G.noPRTC, Transition==DC.transitions[i]))
  plot(Act.Ratio ~ Pred.Ratio, data=subset(DilutionCurve.G.noPRTC, Transition==DC.transitions[i]), main=paste("Dilution Curve: ", DC.transitions[i]))
  abline(DC.transition.lm$coefficients[1], DC.transition.lm$coefficients[2])
  DC.transition.results[i,"Transition"] <- as.character(DC.transitions[i])
  DC.transition.results[i,"Intercept"] <- DC.transition.lm$coefficients[1]
  DC.transition.results[i,"Coefficient"] <- DC.transition.lm$coefficients[2]
  DC.transition.results[i,"Adj.R.Squared"] <- summary(DC.transition.lm)$adj.r.squared
  legend("bottomright", inset=0.05, bty="n", legend=paste("R2-adjusted: ", format(summary(DC.transition.lm)$adj.r.squared, digits=4), "\nCoefficient", format(DC.transition.lm$coefficients[2], digits=4)))
}

DC.transition.bad <- DilutionCurve.G.noPRTC[which(DilutionCurve.G.noPRTC$Transition %in% DC.transition.results[which(DC.transition.results$Coefficient < 0.2 | DC.transition.results$Coefficient > 1.5 | DC.transition.results$Adj.R.Squared < 0.7),"Transition"]),]
unique(DC.transition.bad[,c("Protein.Name", "Peptide.Sequence", "Fragment.Ion")])

p.Dilution.Curve <- plot_ly(data = DilutionCurve.G.noPRTC, x = ~Pred.Ratio, y = ~Act.Ratio, type="scatter", mode="lines", color=~Peptide.Sequence, hovertext=~Protein.Name) %>%  #generate plotly plot
  layout(title="Dilution Curve",
         yaxis = list(title = 'Actual'),
         xaxis = list(title = 'Predicted'))
htmlwidgets::saveWidget(as_widget(p.Dilution.Curve), "~/Documents/Roberts Lab/Paper-DNR-Geoduck-Proteomics/analyses/SRM/Dilution-Curve-Transitions.html")
