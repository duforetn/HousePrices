
rawDataFile <- 'raw/AmesHousing.txt'
rawData <- read.table(rawDataFile, header = TRUE, sep = '\t')
rawData <- rawData[, colnames(rawData)[-2]]

colnames(rawData) = gsub('[.]', '', colnames(rawData))
colnames(rawData)[1] = "ID"
write.csv(rawData, 'preprocessed/data.csv', row.names=FALSE)
