#Getting and Cleaning Data Course Project

This file describes how run_analysis.R script works.

### Set the following variable in the run_analysis.R file
* working.location, assignment directory location "H:/Work/workspaces/r-projects/gcd/week4" 
* data.dir, this is the location where the data will reside under the root location "data" by default
* data.set, this is the unzipped Data Location "UCI HAR Dataset" by default
* get_data, set to 1 if the dataset should be downloaded or 0 to use already downloaded data

### Execute run_analsis.R
After setting the directory variables, execute the script, this will produce the following files in the data.set variable location.

* mergeddata.txt, the complete clean merged dataset
* tidydata.txt, the tidy summary dataset
