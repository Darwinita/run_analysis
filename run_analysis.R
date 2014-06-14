
---
title       : run_analysis
subtitle    : Getting and Cleaning data Course project
author      : Lorenzo
date        : 06/14/2014
---
#Set the working directory in your computer
setwd("/Users/lorenzo/Documents/Johns\ Hopkins\ University\ Data\ Science/Getting_and_Cleaning_Data/Course_Project")

fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
datafilename<-"Course_project.zip"
#Check if the file containing the data is already in your working directory. Otherwise, download it and unzip
if (!file.exists(datafilename)) { 
  download.file(fileURL, destfile = datafilename, method = "curl")
  unzip("Course_project.zip")
}

#Subject files. Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
subject_test_file<-"./UCI\ HAR\ Dataset/test/subject_test.txt"
subject_train_file<-"./UCI\ HAR\ Dataset/train/subject_train.txt"
#Files with actual data set of measurements
X_test_file<-"./UCI\ HAR\ Dataset/test/X_test.txt"
X_train_file<-"./UCI\ HAR\ Dataset/train/X_train.txt"
#Files with data set of activity labels
y_test_file<-"./UCI\ HAR\ Dataset/test/y_test.txt"
y_train_file<-"./UCI\ HAR\ Dataset/train/y_train.txt"

#file with the links of the labels with their activity name.
activity_labels_file<-"./UCI\ HAR\ Dataset/activity_labels.txt"
#file Listing all features..
features_file<-"./UCI\ HAR\ Dataset/features.txt"

#read measurement data files into R data frames
X_test_data<-read.table(X_test_file, dec = " ", header = F, as.is=T, stringsAsFactors=F, strip.white = T, fill = T, blank.lines.skip = T)
X_train_data<-read.table(X_train_file, dec = " ", header = F, as.is=T, stringsAsFactors=F, strip.white = T, fill = T, blank.lines.skip = T)
#merge test and train data sets
data<-rbind(X_test_data,X_train_data)
#read features measured
features_data<-read.table(features_file, header = F )
#select the second column of the features table containing the actual names of features
features_vector<-as.vector(features_data[,2])
#remove unwanted cahracters from features names (,-())
features_vector<-gsub("[,|-|(|)]","",features_vector)
features_vector<-gsub("-","",features_vector)
#Appropriately labels the data set with descriptive variable names. 
#by assigning edited feature names to column names in data table
colnames( data ) <- features_vector
#Extracts only the measurements on the mean and standard deviation for each measurement.
#features containing the strings '[Mm]ean' or 'std' in their labels will be extracted
data<-data[, grep('([Mm]ean|std)', names(data))]
#read activity label data files into R data frames
label_test_data<-read.table(y_test_file, header = F, col.names = "label" )
label_train_data<-read.table(y_train_file, header = F, col.names = "label" )
label_test_vector<-as.vector(label_test_data[,1])
label_train_vector<-as.vector(label_train_data[,1])
#merge test and train activity label data sets
label_vector<-c(label_test_vector, label_train_vector)
#read table file with activity names
activity_labels_data<-read.table(activity_labels_file, header = F )
#select the second column of the features table contiaining the actual names of actvities
label_names_vector<-as.vector(activity_labels_data[,2])
activity<-vector()
#Uses descriptive activity names to name the activities in the data set
#by assigning feature names to column names in label data tables
for( i in label_vector ) {
  activity<-c(activity, label_names_vector[i] )
}

#read subject files into R data frames
subject_test_data<-read.table(subject_test_file, header = F, col.names = "subject" )
subject_train_data<-read.table(subject_train_file, header = F, col.names = "subject" )
#merge test and train subject data sets
subjects<-rbind(subject_test_data,subject_train_data)


#Merges the training and the test sets to create one data set.
merged_data<-cbind(subjects,activity,data)
#Convert the columns containing the actual measurements into numeric to perform statistical analysis on them
merged_data[, c(3:88)] <- sapply(merged_data[, c(3:88)], as.numeric)

#Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
#Install and load the reshape2 package containing tools to reshape the data in a tidy format
install.packages("reshape2")
library(reshape2)
#"melt" data so that each row is a unique id-variable combination, selecting subject and activity as 
#ID variables, and the rest as measurement variables. 
melted_data<-melt(merged_data, id=c("subject", "activity"))
# use the dcast function to reformat the melted data set into a particular
#shape, into a particular data frame, in this case by breaking it down by the subject and activty variables
#and summarizing the measurement variables by their mean
tidy_data<-dcast(melted_data,subject + activity ~ variable, mean, na.rm = T)
#Write the tidy data table to an output file in csv format
write.table(tidy_data, file = "tidy_data_out.csv.txt", append = FALSE, quote = TRUE, sep = ",", row.names = F)
