#Read original data sets
trainData = read.csv("UCI HAR Dataset/train/X_train.txt", header = FALSE, sep = "")
testData = read.csv("UCI HAR Dataset/test/X_test.txt", header = FALSE, sep = "")

#Add variable names
features = read.csv("UCI HAR Dataset/features.txt", header = FALSE, sep = "")
names(trainData) = features[,2]
names(testData) = features[,2]

#Add Activity variable
trainActivity = read.csv("UCI HAR Dataset/train/y_train.txt", header = FALSE, sep = "")
trainData$Activity = trainActivity[,1]
testActivity = read.csv("UCI HAR Dataset/test/y_test.txt", header = FALSE, sep = "")
testData$Activity = testActivity[,1]

#Add Subject variable
trainSubject = read.csv("UCI HAR Dataset/train/subject_train.txt", header = FALSE, sep = "")
trainData$Subject = trainSubject[,1]
testSubject = read.csv("UCI HAR Dataset/test/subject_test.txt", header = FALSE, sep = "")
testData$Subject = testSubject[,1]

#Merge train and test data sets and filter desired variables
indexMean = grep("mean\\(\\)", names(testData))
indexStd = grep("std\\(\\)", names(testData))
indexToSelect = sort(c(indexMean, indexStd, 562, 563))
tidyData = rbind(trainData[,indexToSelect], testData[,indexToSelect])

#Make Activity variable more descriptive (code -> text)
tidyData$Activity = as.character(tidyData$Activity)
tidyData$Activity[tidyData$Activity=="1"]="WALKING"
tidyData$Activity[tidyData$Activity=="2"]="WALKING_UPSTAIRS"
tidyData$Activity[tidyData$Activity=="3"]="WALKING_DOWNSTAIRS"
tidyData$Activity[tidyData$Activity=="4"]="SITTING"
tidyData$Activity[tidyData$Activity=="5"]="STANDING"
tidyData$Activity[tidyData$Activity=="6"]="LAYING"

#Summary data set per Activity and Subject
summaryData = aggregate(tidyData[, 1:66], list(tidyData$Activity,tidyData$Subject), mean)
names(summaryData)[1] = "Activity"
names(summaryData)[2] = "Subject"

#Write summary data set to file
write.table(summaryData, "summaryDataSet.txt", row.names = FALSE)
