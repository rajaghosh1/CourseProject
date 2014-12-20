======================================================
README file describing the run_analysis.R script usage
======================================================

Prerequisites
==============

The script requires the following packages to be installed

	+ dplyr
	+ tidyr
	+ data.table

Usage
======

	+ Source the script
	+ Go to the directory containing the UCI HAR Dataset
	  (directory containing test/ and train/ subdirectories)
	+ Call run_analysis()
	+ This will process the datasets and create a tidy data file
	  TidyData.txt in the current directory. See the CodeBook.md
	  for a description of fields for the tidy data)
	+ Alternately you can call run_analysis(dataset_dir) with the
	  directory containing the UCI HAR Dataset
	+ If you want to get the tidy_data witin R (without dumping to
	  the file), call either one of the following
		+ tidy_data <- get_tidy_data() # from dataset directory
		+ tidy_data <- get_tidy_data(dataset_dir)