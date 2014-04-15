Peer Assessments Project <Getting and Cleaning Data> Course
========================================================
    
# Set workspace. 

if(getwd()!="/Users/nanli/Documents/Code/R/datasciencecoursera/data")
{
    setwd("/Users/nanli/Documents/Code/R/datasciencecoursera/data")
}

# From the features.txt file, we have all the 561 feature names. According to the requirement, we need to extract only the measurements on the mean 
# and standard deviation for each measurement. So we read the feature.txt table, and try to filter out those features and save them into featuresToExtract object
featureNames <- read.table("features.txt")
featuresToExtract2 <- with(featureNames, featureNames[grepl("mean",V2) | grepl("std",V2),])
featuresToExtract$V2 <- gsub("()","",featuresToExtract$V2,fixed=TRUE)
featuresToExtract$V2 <- gsub("-",".",featuresToExtract$V2,fixed=TRUE)


## read and parse the training data files 
subject_train <- read.table("subject_train.txt")
x_train <- read.table("X_train.txt")
x_train_extracted <- x_train[,featuresToExtract$V1] # extract only mean and std features
names(x_train_extracted) <- featuresToExtract$V2 # assign the feature names
y_train <- read.table("y_train.txt")

trainingSet <- cbind(subject_train, rep("TRAIN",nrow(subject_train)), y_train,x_train_extracted) # bind data
colnames(trainingSet)[1] <- "subject"
colnames(trainingSet)[2] <- "data.type"
colnames(trainingSet)[3] <- "activity"


## do the same thing for the testing data files
subject_test <- read.table("subject_test.txt")
x_test <- read.table("X_test.txt")
x_test_extracted <- x_test[,featuresToExtract$V1]
names(x_test_extracted) <- featuresToExtract$V2 
y_test <- read.table("y_test.txt")

testingSet <- cbind(subject_test, rep("TEST",nrow(subject_test)), y_test,x_test_extracted)
colnames(testingSet)[1] <- "subject"
colnames(testingSet)[2] <- "data.type"
colnames(testingSet)[3] <- "activity"



## Combine trainning and test data frames

tidy1 <- rbind(trainingSet,testingSet)
tidy1$activity <- as.factor(tidy1$activity)
levels(tidy1$activity) <- c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")

## Q5 requires us to create a second, independent tidy data set with the average of each avriable for each activity and each subject
## this can be achieved with aggregate function
tidy2 <- aggregate(tidy1[,-c(1:3)], by=list(factor(tidy1$subject),factor(tidy1$activity), factor(tidy1$data.type)),mean)


## save the data as csv files, but we uploaded them in txt. The coursera uploading platform does not support csv.
write.csv(tidy1,"tidy1.csv")
write.csv(tidy2,"tidy2.csv")

