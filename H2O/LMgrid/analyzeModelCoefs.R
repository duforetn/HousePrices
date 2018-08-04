#Design matrix of coefficients
allModelsCoef <- NULL
for (m in gridPerf@model_ids) {
	allModelsCoef <- rbind(allModelsCoef, h2o.getModel(m)@model$coefficients)
}

corMatrix = cor(t(allModelsCoef))
#Plots 
models_kept = rep(FALSE, nModels)
models_kept[models_tokeep][1:5] = TRUE
PCA = prcomp(corMatrix)
pdf('PCs_models.pdf', height=1000, width = 1500)
par(mfrow = c(1, 2))
plot(-PCA$rotation[, 1:2], 
	pch = ifelse(models_kept, 15, 16),
	col = ifelse(models_kept, 2, 1),
	cex = ifelse(models_kept, 1.4, .6))
legend('top', pch = c(15, 16), col = 1:2, legend = c('model', 'top 5 appearing model'))

plot(PCA$rotation[, 3:4], 
        pch = ifelse(models_kept, 15, 16),
        col = ifelse(models_kept, 2, 1),
        cex = ifelse(models_kept, 1.4, .6))
legend('top', pch = c(15, 16), col = 1:2, legend = c('model', 'top 5 appearing model'))
dev.off()
heatmap(corMatrix, RowSideColors=ifelse(models_kept, "2", "1"), ColSideColors=ifelse(models_kept, "2", "1"))
