library(h2o)

fileName = "train.csv"
data.train <- read.table('../data/experiment_purpose/train.txt', header = TRUE)
data.test <- read.table('../data/experiment_purpose/test.txt', header = TRUE)

# init
h2o.init(nthreads = 2)

train <- h2o.importFile("train.csv")
test <- h2o.importFile("test.csv")
fake_test <- h2o.importFile("fake_test.csv")

x = colnames(data.train)[2:80]
y = "SalePrice"

model <- h2o.deeplearning(   x=x,   y=y,   training_frame=train, validation_frame=train,   distribution="AUTO",   activation="RectifierWithDropout",   hidden=c(256, 64),   input_dropout_ratio=0.002,   sparse=FALSE, l1=0.001, epochs=100)

predictions <- h2o.predict(model, newdata=train)
y_test = matrix(train[y])
y_pred = matrix(predictions$predict)
plot(y_test, y_pred, main = sqrt(mean((log(y_test) - log(y_pred))**2)))
abline(0, 1)

predictions <- h2o.predict(model, newdata=test)
y_test = matrix(test[y])
y_pred = matrix(predictions$predict)
plot(y_test, y_pred, main = sqrt(mean((log(y_test) - log(y_pred))**2)))
abline(0, 1)

predictions <- h2o.predict(model, newdata=fake_test)
y_test = matrix(fake_test[y])
y_pred = matrix(predictions$predict)
plot(y_test, y_pred, main = sqrt(mean((log(y_test) - log(y_pred))**2)))
abline(0, 1)


# stop
h2o.shutdown()
