#Error per model
model_errors = matrix(0, nrow(h2oValidDataSet), length(gridPerf@model_ids))
for (model in 1:length(gridPerf@model_ids)) {
   model_predictions <- as.matrix(h2o.predict(h2o.getModel(gridPerf@model_ids[[model]]), newdata=h2oValidDataSet))
   model_errors[, model] <- (y_test[, 1] - model_predictions)**2
   validRMSE = sqrt(mean((y_test - model_predictions)**2))
   plot(model_predictions, y_test[, 1], main = validRMSE)
   abline(0, 1)
}

#select K models
K = 10
best_model = apply(model_errors, 1, which.min)
models_tokeep= as.numeric(names(sort(table(best_model), decreasing=TRUE)[1:K]))

# Ensemble
model_list = NULL
for (model in models_tokeep) model_list <- c(model_list, h2o.getModel(gridPerf@model_ids[[model]]))
ensemble_model = h2o.stackedEnsemble(x=x, y=y, training_frame = h2oTrainDataSet, base_models = model_list, metalearner_algorithm = "drf")

ensemble_predictions = as.matrix(h2o.predict(ensemble_model, newdata=h2oValidDataSet))
ensembleRMSE = sqrt(mean((y_test[, 1] - ensemble_predictions)**2))
plot(ensemble_predictions, y_test[, 1], main = ensembleRMSE)
abline(0, 1)

