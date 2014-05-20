getdata-003
===========

Course Project for Getting and Cleaning Data


## Notice
The origin data is already placed in the directory named data.
Make sure to setwd() to current directory.

If the setting is correct, run the run_analysis.R script you will get the following files:

- data_extract.txt extracted the features with names containing either "mean()" or "std()" 
from both the training set and the test set. It's also labeled with human-readable activity.

- data_average.txt contains the same variables as data_extract.txt, plus a column named 
"subject" indicating from whom the data was collected. Unlike data_extract.txt, each row in
this file is the average value, grouped by the specific subject id and activity.
