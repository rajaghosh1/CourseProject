library(data.table)
library(dplyr)
library(tidyr)

#this function takes 2 parameters
# activity_data : a vector containing the activity_ids
# activity_label : a data frame, with activity labels in 2nd column
#returns the activity labels corresponding to activity data as a
#data.frame

convert_to_activities <- function(activity_data, activity_label) {
  activity_vector <- activity_data[,1]
  x <- activity_label[activity_vector, 2]
  df <- data.frame(x)
  colnames(df)[1] = "Activity"
  df
}

#this function takes 2 parameters
# x_data : the readings for each feature
# feature_data : the feature labels
#returns those columns that are mean or std

filter_mean_sd <- function(x_data, feature_data) {
  colnames(x_data) <- feature_data[,2]
  x_data[c(grep("mean|std", names(x_data), value=TRUE))]
}

merge_data <- function(x_data, subject_data, activity_data) {
  merged <- cbind(subject_data, activity_data, x_data)
  colnames(merged)[1] <- "SubjectID"
  merged
}

merge_test_train <- function(dataDir = ".") {
  
  #load the activity_labels
  fileName  <- paste(dataDir, "activity_labels.txt", sep = "/")
  message("loading activity labels from file ", fileName)
  activity_labels <- read.table(fileName)

  #load the activity_ids for train
  fileName  <- paste(dataDir, "train", "y_train.txt", sep = "/")
  message("loading training activities from file ", fileName)
  activities <- read.table(fileName)  
  
  message("converting training activities to labels")
  activity_train <- convert_to_activities(activities, activity_labels)

  #load the activity_ids for test
  fileName  <- paste(dataDir, "test", "y_test.txt", sep = "/")
  message("loading test activities from file ", fileName)
  activities <- read.table(fileName)  
  
  message("converting test activities to labels")
  activity_test <- convert_to_activities(activities, activity_labels)

  #load the feature names
  fileName  <- paste(dataDir, "features.txt", sep = "/")
  message("loading feature names from file ", fileName)
  features <- read.table(fileName)  #load the y_train
  
  #load the x_test
  fileName  <- paste(dataDir, "test", "x_test.txt", sep = "/")
  message("loading test data from file ", fileName)
  data <- read.table(fileName)

  #filter the x_test
  message("filtering mean and sd column from test data ")
  filter_x_test <- filter_mean_sd(data, features)

  #load the x_train
  fileName  <- paste(dataDir, "train", "x_train.txt", sep = "/")
  message("loading training data from file ", fileName)
  data <- read.table(fileName)

  #filter the x_train  
  message("filtering mean and sd column from training data ")
  filter_x_train <- filter_mean_sd(data, features)
  
  #load the subject_train
  fileName  <- paste(dataDir, "train", "subject_train.txt", sep = "/")
  message("loading training subject data from file ", fileName)
  subject_train <- read.table(fileName)
  
  #load the subject_test
  fileName  <- paste(dataDir, "test", "subject_test.txt", sep = "/")
  message("loading test subject data from file ", fileName)
  subject_test <- read.table(fileName)
    
  #merge the data
  message("merging test data...")
  merged_test_data <- merge_data(filter_x_test, subject_test, activity_test)
  message("merging train data...")
  merged_train_data <- merge_data(filter_x_train, subject_train, activity_train)

  #merge the rows
  message("merging test and train data...")
  merged <- rbind(merged_test_data, merged_train_data)
  merged
}

get_tidy_data <- function(dataDir = ".") {
  merged <- merge_test_train(dataDir)
  message("gathering merged data...")
  gathered <- gather(merged, ValueType, Value, -(SubjectID:Activity))
  gathered_tbl <- tbl_dt(gathered)
  message("grouping gathered data...")
  grouped_gathered_tbl <- group_by(gathered, SubjectID, Activity, ValueType)
  message("summarizing grouped data...")
  summarise(grouped_gathered_tbl, MeanValue = mean(Value))
}

run_analysis <- function(dataDir = ".", outputFile = "TidyData.txt") {
  tidy_data <- get_tidy_data(dataDir)
  message("writing tidy data to ", outputFile)
  write.table(tidy_data, outputFile, row.names = FALSE)
}