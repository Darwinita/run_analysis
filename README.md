run_analysis
============

Getting and Cleaning data Course project


---
title       : run_analysis
subtitle    : Getting and Cleaning data Course project
author      : Lorenzo
date        : 06/14/2014

---

###The R script run_analysis is designed to process the files containing data collected from the accelerometers into a tidy data table averaging each variable for each activity and each subject. The script needs to enter/create a dir to store the data files to download. Please, see below a summary of the analysis peformed by the script:

The training and the test sets have been merged to create one data set.
The measurements on the mean and standard deviation have been extracted and considered for further analysis.
The activity labels have been changed to actual descriptive activity names.
Similarly, the measured variable names  have been edited to remove unwanted characters and convert them into descriptive variable names.
A final independent tidy data set with the average of each variable for each activity and each subject is then created and saved into a file tidy_data_out.csv.txt. 

Please, read the comments contained in the script to see the actual steps of the processing of the data.


The data were download here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
You can find a description of the data here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

