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
  activity_labels <- read.table(fileName)

  #load the activity_ids for train
  fileName  <- paste(dataDir, "train", "y_train.txt", sep = "/")
  activities <- read.table(fileName)  
  
  activity_train <- convert_to_activities(activities, activity_labels)

  #load the activity_ids for test
  fileName  <- paste(dataDir, "test", "y_test.txt", sep = "/")
  activities <- read.table(fileName)  
  
  activity_test <- convert_to_activities(activities, activity_labels)

  #load the feature names
  fileName  <- paste(dataDir, "features.txt", sep = "/")
  features <- read.table(fileName)  #load the y_train
  
  #load the x_test
  fileName  <- paste(dataDir, "test", "x_test.txt", sep = "/")
  data <- read.table(fileName)

  #filter the x_test
  filter_x_test <- filter_mean_sd(data, features)

  #load the x_train
  fileName  <- paste(dataDir, "train", "x_train.txt", sep = "/")
  data <- read.table(fileName)

  #filter the x_train  
  filter_x_train <- filter_mean_sd(data, features)
  
  #remove the original x data
  #rm(x_train, x_test, features)

  #load the subject_train
  fileName  <- paste(dataDir, "train", "subject_train.txt", sep = "/")
  subject_train <- read.table(fileName)
  
  #load the subject_test
  fileName  <- paste(dataDir, "test", "subject_test.txt", sep = "/")
  subject_test <- read.table(fileName)
    
  #merge the data
  merged_test_data <- merge_data(filter_x_test, subject_test, activity_test)
  merged_train_data <- merge_data(filter_x_train, subject_train, activity_train)

  #merge the rows
  merged <- rbind(merged_test_data, merged_train_data)
  merged
}

run_analysis <- function(dataDir = ".") {
  merged <- merge_test_train(dataDir)
  gathered <- gather(merged, ValueType, Value, -(SubjectID:Activity))
  gathered_tbl <- tbl_dt(gathered)
  grouped_gathered_tbl <- group_by(gathered, SubjectID, Activity, ValueType)
  summarise(grouped_gathered_tbl, MeanValue = mean(Value))
  
}