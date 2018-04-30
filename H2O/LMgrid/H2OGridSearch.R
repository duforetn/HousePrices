#Create the datasets
source('CreateSplitData.R')

lambdaGrid = 10**(-5:-1)
alphaGrid = seq(from = 0, to = 1, by= .05)

glm_params = list(lambda = lambdaGrid, alpha = alphaGrid)

glm_grid = h2o.grid("glm", x=x, y=y, training_frame = h2oTrainDataSet, hyper_params = glm_params, nfolds = 5, seed = 1, grid_id = 'myGrid')

gridPerf = h2o.getGrid(grid_id = 'myGrid')

LinearModel = h2o.getModel(gridPerf@model_ids[[1]])

predictions <- h2o.predict(LinearModel, newdata=h2oValidDataSet)
y_test = matrix(h2oValidDataSet[y])
y_pred = matrix(predictions$predict)
validRMSE = sqrt(mean((y_test - y_pred)**2))
plot(y_pred, y_test)

# stop
h2o.shutdown()
