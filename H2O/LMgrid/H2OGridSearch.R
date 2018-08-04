#Create the datasets
source('CreateSplitData.R')

lambdaGrid = 10**(-5:-1)
alphaGrid = seq(from = 0, to = 1, by= .05)

glm_params = list(lambda = lambdaGrid, alpha = alphaGrid)

glm_grid = h2o.grid("glm", x=x, y=y, training_frame = h2oTrainDataSet, hyper_params = glm_params, nfolds = 5, seed = 1, grid_id = 'myGrid', keep_cross_validation_predictions = TRUE)

gridPerf = h2o.getGrid(grid_id = 'myGrid')

LinearModel = h2o.getModel(gridPerf@model_ids[[1]])

nModels = length(gridPerf@model_ids)
predictions <- h2o.predict(LinearModel, newdata=h2oValidDataSet)
y_test = matrix(h2oValidDataSet[y])
y_pred = matrix(predictions$predict)
validRMSE = sqrt(mean((y_test[, 1] - y_pred[, 1])**2))
plot(y_pred, y_test, main = validRMSE)
abline(0, 1)

# stop
#h2o.shutdown()
#png('xval_RMSE_models60.png')
#tmp <- NULL
#for (i in 1:105) tmp <- c(tmp, h2o.getModel(gridPerf@model_ids[[i]])@model$cross_validation_metrics@metrics$RMSE)
#plot(tmp, main = "x-validation RMSE", ylab = 'RMSE', xlab = 'grid model indexes', pch = 15, col = 'blue', cex = .4)
#points(col = 2, models_tokeep[1:10], tmp[models_tokeep[1:10]], )
#lines(col = 'blue', tmp)
#legend('topl', legend = c("top 10 selected models"), col = c(2), pch = 1)
#dev.off()
#if ok
#points(models_tokeep[1:10], tmp[models_tokeep[1:10]], col = 2	)
