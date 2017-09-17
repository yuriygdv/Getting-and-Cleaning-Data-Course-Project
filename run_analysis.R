# Getting-and-Cleaning-Data-Course-Project
# Getting and Cleaning Human Activity Recognition Using Smartphones Dataset 

library(dplyr)

setwd("E:/Coursera/DataScience - Johns Hopkins University/03_Getting & Cleaning Data/Project")

#STEP 1: Merges the training and the test sets to create one data set.

test_data <- read.table("./UCI HAR Dataset/test/X_test.txt", stringsAsFactors = FALSE)
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt", stringsAsFactors = FALSE)
merged_data <- rbind(test_data, train_data)

#STEP 2: Extracts only the measurements on the mean and standard deviation for each measurement.

var_names <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
names(merged_data) <- var_names$V2

# Subset of columns which names contain mean() OR std():
merged_data_sub <- merged_data[ , grep("mean()|std()", names(merged_data))]


#3 Uses descriptive activity names to name the activities in the data set

#Read and merge the activities variable for the test and train data sets:
test_activities <- read.table("./UCI HAR Dataset/test/y_test.txt")
train_activities <- read.table("./UCI HAR Dataset/train/y_train.txt")
merged_activities <- rbind(test_activities, train_activities)

#Read the labels for the six activities and create a varible with descriptive labels for the activities:
activity_labels <-  read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
descr_activity_names <- right_join(activity_labels, merged_activities) %>% select(V2)
names(descr_activity_names) <- "Activity"

#Create and Name Subject ID Variable
test_subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")
train_subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
merged_subjects <- rbind(test_subjects, train_subjects)
names(merged_subjects) <- "SubjectID"


#4 Appropriately labels the data set with descriptive variable names.

#merging the three parts with labels in one dataframe:
tidy_data <- cbind(merged_subjects, descr_activity_names, merged_data_sub )


#5 Grouping and summarizing:

tidy_data2 <- tidy_data %>%
                    group_by(SubjectID, Activity) %>%
                    summarize_all(mean)
                    
# Saving the final dataset in the working directory:

write.table(tidy_data2, file = "tidy_data_set.txt", row.names = FALSE)







