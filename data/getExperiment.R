
fileName = "train.csv"
data <- read.csv(paste('./', fileName, sep = ""), header = TRUE)

split = sample(nrow(data), x = c(TRUE, FALSE), prob = c(.9, .1), replace = TRUE)

train = subset(data, split == TRUE)
test = subset(data, split == FALSE)

cat(colnames(train), file = 'experiment_purpose/train.txt')
for (i in 1:nrow(train)) { 
    cat('\n', file = 'experiment_purpose/train.txt', append = TRUE)
    cat(as.numeric(train[i, ]), file = 'experiment_purpose/train.txt', append = TRUE)
}

write.csv(train, file = "experiment_purpose/train.csv")

cat(colnames(test), file = 'experiment_purpose/test.txt')
for (i in 1:nrow(test)) { 
    cat('\n', file = 'experiment_purpose/test.txt', append = TRUE)
    cat(as.numeric(test[i, ]), file = 'experiment_purpose/test.txt', append = TRUE)
}
write.csv(test, file = "experiment_purpose/test.csv")

fake_test = test
fake_test["SalePrice"] = runif(nrow(test), 100000, 200000)
cat(colnames(fake_test), file = 'experiment_purpose/fake_test.txt')
for (i in 1:nrow(fake_test)) {
    cat('\n', file = 'experiment_purpose/fake_test.txt', append = TRUE)
    cat(as.numeric(fake_test[i, ]), file = 'experiment_purpose/fake_test.txt', append = TRUE)
}
write.csv(fake_test, file = "experiment_purpose/fake_test.csv")

