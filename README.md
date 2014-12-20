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

	+ run_analysis(dataDir = ".", outputFile = "TidyData.txt")
		* dataDir is the directory containing the
		  UCI HAR Dataset (directory containing test/ and 
		  train/ subdirectories)
		* outputFile is the file name to write to
	+ This will process the datasets and create a tidy data file
	  to outputFile
	+ To get the tidy_data witin R (without dumping to the file), call
	  get_tidy_data(dataDir = ".")
	+ See the CodeBook.md for a description of fields for the tidy data)
