####################################################################################################
### Week 4 Assignment
### R_Camara
####################################################################################################

library('data.table')
library('reshape2')
library('stringr')
library('plyr')
library('sqldf')

####################################################################################################
##  Setup working directory and set working directory for dataset
####################################################################################################

working.location <- "C:/Users/ramou/Documents/COURSERA TRAINING/Rama_practice"  ## Root Project Location
data.dir <- file.path(working.location, "data")           ## Data Location
data.set <- file.path(data.dir, "UCI HAR Dataset")        ## Unziped Data Location
dir.create(data.dir, showWarnings = FALSE)                ## Create the data dir if missing
setwd(working.location)                                   ## Set working dir to root location

####################################################################################################
## GET DATA: Set get_data to 0 to use exsisting data or 1 to download and uncompress the data
####################################################################################################

get_data <- 0    

if (get_data == 1) {
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
  data.file <- file.path(data.dir, "data.zip")
  download.file(url, data.file)
  unzip(zipfile=data.file, exdir = data.dir)
}

####################################################################################################
## Set the working location to that of the dataset
####################################################################################################

setwd(data.set)

####################################################################################################
## Creating an R script called run_analysis.R that does the follwing:
##  1) Merges the training and the test sets to create one data set.
##  2) Extracts only the measurements on the mean and standard deviation for each measurement.
##  3) Uses descriptive activity names to name the activities in the data set
##  4) Appropriately labels the data set with descriptive variable names.
##  5) From the data set in step 4, creates a second, independent tidy data set with the average 
##     of each variable for each activity and each subject.
####################################################################################################

## Load the datasets

data.Activity.Test  <- read.table("./test/Y_test.txt", header = FALSE)
data.Activity.Train <- read.table("./train/Y_train.txt", header = FALSE)

data.Subject.Train  <- read.table("./train/subject_train.txt", header = FALSE)
data.Subject.Test   <- read.table("./test/subject_test.txt", header = FALSE)

data.Features.Test  <- read.table("./test/X_test.txt", header = FALSE)
data.Features.Train <- read.table("./train/X_train.txt",header = FALSE)

data.Features.Names <- read.table("./features.txt",header=FALSE)

####################################################################################################
## Step 1: Merge the test & training datasets
####################################################################################################
data.Subject <- rbind(data.Subject.Train, data.Subject.Test)
data.Activity<- rbind(data.Activity.Train, data.Activity.Test)
data.Features<- rbind(data.Features.Train, data.Features.Test)

## Unload the old datasets from memory and retain only the merged datasets
rm(data.Subject.Train, data.Subject.Test, 
   data.Activity.Train, data.Activity.Test, 
   data.Features.Train, data.Features.Test)

names(data.Subject) <- c("subject")
names(data.Activity) <- c("activity")

## Remove the punctuation in the column names and uppercase Mean & Std them (Rules for tidy Dataset Step #3)
data.Features.Names$V2 <- str_replace_all(data.Features.Names$V2, "[[:punct:]]", "")
data.Features.Names$V2 <- str_replace_all(data.Features.Names$V2, "mean", "Mean")
data.Features.Names$V2 <- str_replace_all(data.Features.Names$V2, "std", "Std")

## Apply the names to the columns of the data.Features dataset
names(data.Features) <- data.Features.Names$V2

## Merge the datasets into one dataset
data.Combine <- cbind(data.Subject, data.Activity)
Data <- cbind(data.Features, data.Combine)

## Data should contain 10299 obs of 563 variables; this is too many for the project scope
## str(Data)
## summary(Data)

####################################################################################################
## Step 2: Extract only the measurements for mean and std deviation and subset the data
####################################################################################################

sub.data.Features.Names <- data.Features.Names$V2[grep("Mean|Std", data.Features.Names$V2)]

selected.Names <- c(as.character(sub.data.Features.Names), "subject", "activity")
Data <- subset(Data, select=selected.Names)

## Data should now only contain 10299 obs of 81 variables and only means and std
## str(Data)
## summary(Data)

####################################################################################################
## Step 3: Uses descriptive activity names to name the activities in the data set
####################################################################################################

## Get the activity descriptive names
al <- read.table("./activity_labels.txt",header = FALSE)

## Give the activties full labels using SQLDF package to merge the datasets on the numeric identifier
Data <- sqldf("select  * 
              from  Data, al 
              where al.V1 = Data.activity") 

## Remove redundant columns
Data$activity <- NULL
Data$V1 <- NULL

####################################################################################################
## Step 4: Appropriately labels the data set with descriptive variable names
####################################################################################################

### Change the case for activity and subject from lowercae to uppercase
names(Data)[names(Data)=="V2"] <- "Activity"
names(Data)[names(Data)=="subject"] <- "Subject"

### Rename the columns to have more descriptive variables which is better for melted dataset
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))



####################################################################################################
##  Setp 5: From the data set in step 4, create a second independent tidy data set with the average 
##  of each variable for each activity and each subject
####################################################################################################

Data2 <- aggregate(. ~Subject + Activity, Data, mean)
Data2 <- Data2[order(Data2$Subject,Data2$Activity),]

Data2 <- melt(Data2, id = c("Subject", "Activity"))
colnames(Data2) <- c("Subject", "Activity", "Measure", "Mean")


setwd(working.location)    
write.table(Data, file = "mergeddata.txt", row.name=FALSE)
write.table(Data2, file = "tidydata.txt", row.name=FALSE)



