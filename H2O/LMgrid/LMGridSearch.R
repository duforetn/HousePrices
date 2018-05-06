#Create the datasets
source('CreateSplitData.R')

lambdaGrid = 10**(-5:-1)
alphaGrid = seq(from = 0, to = 1, by= .05)

nIter = 30
GridResult = NULL

for (iter in 1:nIter) {
lambdaValue = 10**(runif(1, -5, 0))#sample(size = 1, lambdaGrid)
alphaValue = runif(1, 0,1) #sample(size = 1, alphaGrid)

LinearModel <- h2o.glm(family='gaussian', x=x, y=y, training_frame=h2oTrainDataSet, nfolds = 2, seed = 1, keep_cross_validation_predictions = TRUE, lambda = lambdaValue, alpha = alphaValue)

LinearModel10 <- h2o.glm(family='gaussian', x=x, y=y, training_frame=h2oTrainDataSet, nfolds = 10, seed = 1, keep_cross_validation_predictions = TRUE, lambda = lambdaValue, alpha = alphaValue)

CVrmse = as.numeric(LinearModel@model$cross_validation_metrics_summary['rmse', 1])
CV10rmse = as.numeric(LinearModel10@model$cross_validation_metrics_summary['rmse', 1])

predictions <- h2o.predict(LinearModel, newdata=h2oValidDataSet)
y_test = matrix(h2oValidDataSet[y])
y_pred = matrix(predictions$predict)
validRMSE = sqrt(mean((y_test - y_pred)**2))

GridResult <- rbind(GridResult, c(log10(lambdaValue), alphaValue, CVrmse, CV10rmse, validRMSE))

}

#plot
library(fields)
myFit <- Krig(GridResult[, 1:2], GridResult[, 5])
myFit2 <- Krig(GridResult[, 1:2], GridResult[, 4])
myFit3 <- Krig(GridResult[, 1:2], GridResult[, 3])
surface(myFit)
surface(myFit2)

# stop
h2o.shutdown()
