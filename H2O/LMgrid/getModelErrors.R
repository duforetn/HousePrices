#Error per model
model_errors_valid = matrix(0, nrow(h2oValidDataSet), length(gridPerf@model_ids))
for (model in 1:length(gridPerf@model_ids)) {
   model_predictions <- as.matrix(h2o.predict(h2o.getModel(gridPerf@model_ids[[model]]), newdata=h2oValidDataSet))
   model_errors_valid[, model] <- (y_test[, 1] - model_predictions)**2
   validRMSE = sqrt(mean((y_test - model_predictions)**2))
   plot(model_predictions, y_test[, 1], main = validRMSE)
   abline(0, 1)
}

#xcross error per model
model_errors = matrix(0, nrow(h2oTrainDataSet), length(gridPerf@model_ids))
source('getKFoldErrors.R')
for (model in 1:length(gridPerf@model_ids)) {
   y_train = as.matrix(h2oTrainDataSet[, y])
   model_errors[, model] <- getKFoldErrors(h2o.getModel(gridPerf@model_ids[[model]]), y_train, 5)**2
}

#select K models based on Kflod
K = 50
best_model = apply(model_errors, 1, which.min)
models_tokeep= as.numeric(names(sort(table(best_model), decreasing=TRUE)[1:K]))

#select K models based on valid
best_model_valid = apply(model_errors_valid, 1, which.min)
models_tokeep_valid = as.numeric(names(sort(table(best_model_valid), decreasing=TRUE)[1:K]))


# Ensemble
model_list = NULL
for (model in models_tokeep) model_list <- c(model_list, h2o.getModel(gridPerf@model_ids[[model]]))
ensemble_model = h2o.stackedEnsemble(x=x, y=y, training_frame = h2oTrainDataSet, base_models = model_list, metalearner_algorithm = "drf")

ensemble_predictions = as.matrix(h2o.predict(ensemble_model, newdata=h2oValidDataSet))
ensembleRMSE = sqrt(mean((y_test[, 1] - ensemble_predictions[, 1])**2))
ensembleRMSLE = sqrt(mean((log(ensemble_predictions[, 1] + 1) - log(y_test[, 1] + 1))**2))
x11(); plot(ensemble_predictions, y_test[, 1], main = c(ensembleRMSE, ensembleRMSLE))
abline(0, 1)

