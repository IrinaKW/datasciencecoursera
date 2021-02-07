# run_analysis.R
# Irina White
# Getting and Cleaning Data/ Coursera
# February 2021


#PART 1
#Merges the training and the test sets to create one data set.

#Load already installed packages

library(dplyr)
library(tidyr)

#Download zip file into the temporary folder 

zip_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
temp <- tempfile()
download.file(zip_url, temp, method = "libcurl", mode = "wb")


#List names of all files in the zip file

all_files<-unzip(zipfile = temp, list = TRUE)
all_files$Name

#Download data from the required text files
#1. Reading test data

xtestf<-unzip(zipfile=temp, files='UCI HAR Dataset/test/X_test.txt')
xtest<-read.table(xtestf,header = FALSE)

ytestf<-unzip(zipfile=temp, files='UCI HAR Dataset/test/y_test.txt')
ytest<-read.table(ytestf,header = FALSE)

sbjtestf<-unzip(zipfile=temp, files='UCI HAR Dataset/test/subject_test.txt')
sbjtest<-read.table(sbjtestf,header = FALSE)


#2. Reading training data

xtrainf<-unzip(zipfile=temp, files='UCI HAR Dataset/train/X_train.txt')
xtrain<-read.table(xtrainf,header = FALSE)

ytrainf<-unzip(zipfile=temp, files='UCI HAR Dataset/train/y_train.txt')
ytrain<-read.table(ytrainf,header = FALSE)

sbjtrainf<-unzip(zipfile=temp, files='UCI HAR Dataset/train/subject_train.txt')
sbjtrain<-read.table(sbjtrainf,header = FALSE)


#3. Reading features and labels

featuresf<-unzip(zipfile=temp, files='UCI HAR Dataset/features.txt')
features<-read.table(featuresf,header = FALSE)

aclabelsf<-unzip(zipfile=temp, files='UCI HAR Dataset/activity_labels.txt')
aclabels<-read.table(aclabelsf,header = FALSE)

#delete temp folder

unlink(temp)

#delete unnecessary values

rm(list=c('aclabelsf','featuresf','sbjtestf','sbjtrainf','xtestf','xtrainf','ytestf','ytrainf','temp'))


#Rename columns for each Data sets
#This is  partially PART 4
#Appropriately label the data set with descriptive variable names

colnames(xtest) = features[,2]
colnames(ytest) = "activity type"
colnames(sbjtest) = "subjectId"
colnames(xtrain) = features[,2]
colnames(ytrain) = "activity type"
colnames(sbjtrain) = "subjectId"
colnames(aclabels) <- c('activity type','activity description')


#Merge test data
test_data = cbind(sbjtest,ytest, xtest)

#Merge train data by columns
train_data = cbind(sbjtrain, ytrain, xtrain)


#Merge test and train data frames together as rows
mydata<-rbind(test_data,train_data)


#Remove unnecessary data
rm(list=c('sbjtest','sbjtrain','xtest','ytest','xtrain','ytrain'))


#PART 2
#Extracts only the measurements of the mean and st. deviation for each measurement. 

#Select required columns
cols<-colnames(mydata)
cols<-c(cols[1],cols[2],cols[grep("mean..|std...", cols)])

#Subset the total data set to sleect only the mean and std measurements
MeanStDev<-mydata[,cols]



#PART 3
#Uses descriptive activity names to name the activities in the data set

activitydf = merge(MeanStDev, aclabels, by='activity type', all.x=TRUE)

#PART 4
#Appropriately label the data set with descriptive variable names

names(MeanStDev)<-gsub("Acc", "Accelerometer", names(MeanStDev))
names(MeanStDev)<-gsub("Gyro", "Gyroscope", names(MeanStDev))
names(MeanStDev)<-gsub("BodyBody", "Body", names(MeanStDev))
names(MeanStDev)<-gsub("Mag", "Magnitude", names(MeanStDev))
names(MeanStDev)<-gsub("^t", "Time", names(MeanStDev))
names(MeanStDev)<-gsub("^f", "Frequency", names(MeanStDev))
names(MeanStDev)<-gsub("tBody", "TimeBody", names(MeanStDev))
names(MeanStDev)<-gsub("-mean()", "Mean", names(MeanStDev), ignore.case = TRUE)
names(MeanStDev)<-gsub("-std()", "STD", names(MeanStDev), ignore.case = TRUE)
names(MeanStDev)<-gsub("-freq()", "Frequency", names(MeanStDev), ignore.case = TRUE)
names(MeanStDev)<-gsub("angle", "Angle", names(MeanStDev))
names(MeanStDev)<-gsub("gravity", "Gravity", names(MeanStDev))


#PART 5
#From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject.


result<-aggregate(MeanStDev[, 3:length(MeanStDev)], list(MeanStDev$subjectId,MeanStDev$`activity type`), FUN=mean)

#write the result into the local file
write.table(result, file = "tidydata.txt",row.name=FALSE)
