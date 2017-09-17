# Getting-and-Cleaning-Data-Course-Project
## Getting and Cleaning Human Activity Recognition Using Smartphones Dataset 

In this project, I use the Human Activity Recognition Using Smartphones Dataset provided in several files to create a tidy, ready-for-analysis data set. I will process the following data files from the original data set:  

**features.txt**  - variable names (561 names)  
**activity_labels.txt** - activity labels (6 activities)  

**TEST DATA**  
**X_test.txt** - main data set (2947 obs. * 561 var.)   
**subject_test.txt** - subject ID [1:30] (2947 obs. * 1 var.)  
**y_test.txt** - test/activity ID [1:6] (2947 obs. * 1 var.)  

**TRAIN DATA**  
**X_train.txt** - main data file (2947 obs. * 561 var.)  
**subject_train.txt** - subject ID [1:30] (2947 obs. * 1 var.)  
**y_train.txt** - test/activity ID [1:6] (2947 obs. * 1 var.)  


After loading the necessary packages and setting the working directory, I read-in and merges the training and the test sets to create one data set. 

```{r}
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt", stringsAsFactors = FALSE)
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt", stringsAsFactors = FALSE)
merged_data <- rbind(test_data, train_data)
```

