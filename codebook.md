# Week 4 Assignment Code Book for Human Activity Recognition Using Smartphones Dataset
## R_Camara 

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

* Subject - 1-30 depending on who the participant was
* Activity - WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
* Variable - Name of the input variable for the subject
* Mean - Average of all the input variables for that Subject and Activity


##Packages used in run_analysis.R

library('reshape2')

library('stringr')

library('plyr')

library('sqldf')

### Source Data 

Downloads either the following file https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip or uses an existing downloaded dataset. 
 
## Steps 
* Loads the datasets & labels.
* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement.
* Uses descriptive activity names to name the activities in the data set.
* Appropriately labels the data set with descriptive variable names.
* From the data set in step 4, creates a second independent tidy data set with the average of each variable for each activity and each subject.

### Loading the datasets 

Gets the datasets then rbinds them to create merged test & training data sets, unloads the old datasets from memory and retain only the merged datasets.

### 1. Mergeing the training and the test sets to create one data set

Names the subject and the activity data sets to have the right headings.

names(data.Subject) <- c("subject")
names(data.Activity) <- c("activity")

Removes the punctuation in the column names and formats Mean & Std before relabelling the columns in the data set.

Apply the names to the columns of the data.features data set, then cbind the subject and activity columns.

Resulting dataset should contain 10299 observations with 563 variables.

### 2. Extracting only the measurements for mean and std and subset the data

Use grep to subset list of selected names

selected.Names <- c(as.character(sub.data.Features.Names), "subject", "activity")
Data <- subset( Data, select=selected.Names)

Data should now only contain 10299 observations of 81 variables with only means and std

### 3. Using descriptive activity names to name the activities in the data set

Loads the Activity labels and use the sqldf package to join the names on the numeric identifier into the dataset and then uses NULL assignment to remove redundant columns.

### 4. Appropriately labelling the data set with descriptive variable names

Renames the columns for Activity and Subject to be consistent, Renames the columns for the variables to have more descriptive names which is better for melted data set used later.

### 5. Tidying the data set

From the data set in step 4, creates a second independent tidy data set with the average of each variable for each activity and each subject.

Uses the aggregate function to create a mean for each of the measurements, then melts the data set to be more usable turning each measurement into a variable.






