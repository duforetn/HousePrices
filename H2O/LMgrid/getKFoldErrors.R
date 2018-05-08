getKFoldErrors <- function(Model, y, nfolds) {

	#retrieve the xval predictions as  a dataframe
	for (cv in 1:nfolds) 
		y = y - as.matrix(h2o.getFrame(Model@model[["cross_validation_predictions"]][cv][[1]][2]$name))
	y
}
