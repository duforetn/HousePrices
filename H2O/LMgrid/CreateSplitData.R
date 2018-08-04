library(h2o)

h2o.removeAll()
fileName = "data.csv"
path = '../../data/preprocessed/'
#fileName = '../data/kaggle_version/train.csv'
#path = ''
# init
h2o.init(nthreads = 2)

h2oDataSet <- h2o.importFile(paste(path, fileName, sep = ''))

x = colnames(h2oDataSet)[2:80]
y = "SalePrice"

# Create a split
n = nrow(h2oDataSet)
trainingSample = sort(sample(1:n, round(n*trainProportion), replace = FALSE))
validationSample = (1:n)[-trainingSample]

h2oTrainDataSet <- h2oDataSet[trainingSample, ]
h2oValidDataSet <- h2oDataSet[validationSample, ]

