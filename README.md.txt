=================================================
README file describing the run_analysis.R script
functionality
=================================================

Overview
=========

The run_analysis.R script takes as parameter a directory name where the HAR dataset
resides. If no parameter is given it defaults to the current directory.

It outputs a data frame with the following columns
	+ SubjectID : the id of the subject (1-30)
	+ Activity : the activity name, one of:
		* WALKING
		* WALKING_UPSTAIRS
		* WALKING_DOWNSTAIRS
		* SITTING
		* STANDING
		* LAYING
	+ ValueType : the type of the observation (the observations ONLY includes the
		calculated mean and standard deviation of the observations in the HAR
		dataset -- e.g. tBodyAcc-mean()-X, tBodyAcc-mean()-Y, tBodyAccJerk-std()-X,
		tBodyAccJerk-std()-Y etc)
	+ MeanValue : the average of the corresponding ValueType for the {SubjectID, Activity}
		combination

Steps performed in converting from raw data
============================================

A. Filter the mean and std columns for the train data (train/X_train.txt) as follow :
	1. Use the features names (features.txt) as the column names for the data
	2. Create a data frame containing only the columns having the string "mean" and "std" in
	the names

B. Convert the activity ids for the training (train/y_train.txt) into corresponding activity names
   (activity_labels.txt) with a column name "Activity"

C. Set the column name of the subject train data (train/subject_train.txt) as "SubjectID". 

D. Column bind the data frames from C,B,A together. This gives the merged dataset for training

E. Repeat steps A-D for the test data.

F. Row bind the 2 data frames created in steps D and E. This gives the merged dataset for the all the
   data. At this point the data frame has the following columns
	1. SubjectID : rows contain ids (1-30) of subject
	2. Activity : rows contain activity labels (WALKING, SITTING etc)
	3. 79 columns named for the observation (e.g. fBodyAcc-mean()-X) : rows contain the values

G. Generate the tidy data set from the data table in F as follow
	1. Use gather (in tidyr) to collapse into 4 columns - SubjectID, Activity, ValueType, Value
	2. convert the data frame into a data table using tbl_dt (from data.table)
	3. group the data table by {SubjectID, Activity, ValueType}
	4. summarise the grouped table with an aggegation column called MeanValue = mean(Value)