## 1)Merges the training and the test sets to create one data set.
## step1   download zip file from website
fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "./projectData_getCleanData.zip")
## step2   unzip data
dir.create("./data")
listZip <- unzip("./data/projectData_getCleanData.zip", exdir = "./data")
## step3   read the training and the test sets 
y_test<-read.table("./data/UCI HAR Dataset/test/y_test.txt")
x_test<-read.table("./data/UCI HAR Dataset/test/X_test.txt" )
x_train<-read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("./data/UCI HAR Dataset/train/y_train.txt" )
subject_train<-read.table("./data/UCI HAR Dataset/train/subject_train.txt")
subject_test<-read.table("./data/UCI HAR Dataset/test/subject_test.txt")
## step4   Merges those sets to create one data set
test_data<-cbind(y_test,subject_test,x_test)
train_data<-cbind(y_train,subject_train,x_train)
fulldata<-rbind(test_data,train_data)

## 2)Extracts only the measurements on the mean and standard deviation for each measurement.
## step1  load feature name into R
featureName <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[,2]
## step2  extract mean and standard deviation of each measurements
featureIndex <- grep(("mean\\(\\)|std\\(\\)"), featureName)
finalData <- fulldata[, c(1, 2, featureIndex+2)]
colnames(finalData) <- c("activity","subject", featureName[featureIndex])

## 3)Uses descriptive activity names to name the activities in the data set.
## step1  read the table of activitynames
activityName<-read.table("./data/UCI HAR Dataset/activity_labels.txt")
## step2  use descriptive name to change
finalData$activity<-factor(finalData$activity,levels = activityName[,1],labels = activityName[,2])

## 4)Appropriately labels the data set with descriptive variable names.
names(finalData) <- gsub("\\()", "", names(finalData))
names(finalData) <- gsub("^t", "time", names(finalData))
names(finalData) <- gsub("^f", "frequence", names(finalData))
names(finalData) <- gsub("-mean", "Mean", names(finalData))
names(finalData) <- gsub("-std", "Std", names(finalData))

## 5)From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(dplyr)
groupData <- finalData %>%
  group_by(subject, activity) %>%
  summarise_each(funs(mean))
write.table(groupData, "./Getting_and_Cleaning_data_Project/step_5_of_the_instructions.txt", row.names = FALSE)
