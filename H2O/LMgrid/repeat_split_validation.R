source('getKFoldErrors.R')

rmse_rep <- NULL
nRep = 10
nK = 20
cat('Best', 2:nK, '\n', file = "results_RMSEK.txt")
for (rep in 1:nRep) {
	source('H2OGridSearch.R')

	#xcross error per model
	model_errors = matrix(0, nrow(h2oTrainDataSet), length(gridPerf@model_ids))
	for (model in 1:length(gridPerf@model_ids)) {
   		y_train = as.matrix(h2oTrainDataSet[, y])
   		model_errors[, model] <- getKFoldErrors(h2o.getModel(gridPerf@model_ids[[model]]), y_train, 5)**2
	}

	#Estimate RMSE for different K values
	rmse_K <- validRMSE
	for (K in 2:nK) {
                best_model = apply(model_errors, 1, which.min)
                models_tokeep= as.numeric(names(sort(table(best_model), decreasing=TRUE)[1:K]))

		model_list = NULL
		for (model in models_tokeep) model_list <- c(model_list, h2o.getModel(gridPerf@model_ids[[model]]))
		ensemble_model = h2o.stackedEnsemble(x=x, y=y, training_frame = h2oTrainDataSet, base_models = model_list, metalearner_algorithm = "drf")

		ensemble_predictions = as.matrix(h2o.predict(ensemble_model, newdata=h2oValidDataSet))
		ensembleRMSE = sqrt(mean((y_test[, 1] - ensemble_predictions[, 1])**2))
		rmse_K <- c(rmse_K, ensembleRMSE)
	}

	# append results
	cat(rmse_K, '\n', file = "results_RMSEK.txt", append = TRUE)

	rmse_rep <- rbind(rmse_rep, rmse_K)
	h2o.removeAll()
}
