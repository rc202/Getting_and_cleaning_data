# Week 4 Assignment Code Book for Human Activity Recognition Using Smartphones Dataset
## Ramatoulie Camara 

## Input Dataset Description

Experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

### For each subject a mean of the variable are provided

* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
* Triaxial Angular velocity from the gyroscope. 
* A 561-feature vector with time and frequency domain variables. 
* Its activity label. 
* An identifier of the subject who carried out the experiment.

### Output Tidy Data Set Description

* Subject - 1-30 depending on who the participent was
* Activity - WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
* Variable - Name of the input variable for the subject
* Mean - Average of all the input variables for that Subject and Activity


##Packages used in run_analysis.r

library('reshape2')

library('stringr')

library('plyr')

library('sqldf')

### Source Data 

Downloads either the following file https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip or uses an exsisting downloaded dataset. 
 
## Steps 
* Loads the datasets & labels
* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement.
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive variable names.
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### Loads the datasets 

Gets the datasets then rbinds them to create merged test & training datasets, unloads the old datasets from memory and retain only the merged datasets

### 1. Merges the training and the test sets to create one data set.

Names the subject and the activity datasets to have the right headings

names(data.Subject) <- c("subject")
names(data.Activity) <- c("activity")

Removes the punctuation in the column names and formats Mean & Std them before relabeling the columns in the dataset

Apply the names to the columns of the data.features dataset, then cbind the subject and activity columns

Resulting dataset should contain 10299 obs of 563 variables this is too many for the project scope

### 2. Extract only the measurements for mean and std deviation and subset the data

sub.data.Features.Names<-data.Features.Names$V2[grep("Mean|Std", data.Features.Names$V2)]

selected.Names <- c(as.character(sub.data.Features.Names), "subject", "activity")
Data <- subset( Data, select=selected.Names)

Data should now only contain 10299 obs of 81 variables only means and std

### 3. Uses descriptive activity names to name the activities in the data set

Load the Activity labels and use the sqldf package to join the names on the numeric identifier into the dataset and then use NULL assignment to remove redundant columns.

### 4. Appropriately labels the data set with descriptive variable names.

Rename the columns for Activity and Subject to be consistant, Rename the columns for the variables to have more descriptive names better for melted dataset used later.

###  5. Tidy Dataset

From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Use the aggrigate function to create a mean for each of the measurments, then melt the dataset to be more usable turning each measurement into a variable.






