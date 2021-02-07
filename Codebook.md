Libraries Required
dplyr, tidyr


CodeBook Description
This document contains step-by-step description of the required coding process

##The Data Source

Source data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Description of the dataset from the source website: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Experiment Setting
Instrument: Samsung Galaxy S II
Number: 30 volunteers
Age: 19- 48
Activities: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
Measurements: Using its embedded accelerometer and gyroscope, was captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz.

Data Info: 
manual labeling, randomly partitioned into two sets 30/70.
Data collection: sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

##The data files used form the zipfile: 
'README.txt'
'features_info.txt': info about used features.
'features.txt': List of all features.
'activity_labels.txt': Links the class labels with their activity name.
'train/X_train.txt': Training set.
'train/y_train.txt': Training labels.
'test/X_test.txt': Test set.
'test/y_test.txt': Test labels.


##Transformation with 5 PARTS performed in Source Code "run_analysis.R" 

Part1 Merges the training and the test sets to create one data set. 

Part2 Extracts only the measurements on the mean and standard deviation for each measurement. 

Part3 Uses descriptive activity names to name the activities in the data set.

Part4 Appropriately labels the data set with descriptive variable names. 

Part5 From the data set in Part4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. 