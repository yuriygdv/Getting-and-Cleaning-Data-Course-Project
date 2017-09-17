# Getting-and-Cleaning-Data-Course-Project
## Getting and Cleaning Human Activity Recognition Using Smartphones Dataset 

In this project, I use the Human Activity Recognition Using Smartphones Dataset provided in several files to create a tidy, ready-for-analysis data set. I will process the following data files from the original data set:

**features.txt**  - variable names (561 names)  
**activity_labels.txt** - activity labels (6 activities)  
  
**TEST DATA**  
**X_test.txt** - main data file (2947 obs. * 561 var.)  
**subject_test.txt** - subject ID [1:30] (2947 obs. * 1 var.)  
**y_test.txt** - test/activity ID [1:6] (2947 obs. * 1 var.)  
  
**TRAIN DATA**  
**X_train.txt** - main data file (2947 obs. * 561 var.)  
**subject_train.txt** - subject ID [1:30] (2947 obs. * 1 var.)  
**y_train.txt** - test/activity ID [1:6] (2947 obs. * 1 var.)  
  

**STEP 1**  
After loading the necessary packages and setting the working directory with the data set, I read-in and merge the training and test sets to create one data set called *merged_data*:

```{r}
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt", stringsAsFactors = FALSE)
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt", stringsAsFactors = FALSE)
merged_data <- rbind(test_data, train_data)
```

**STEP 2**  
In this step I extract only the measurements on the mean and standard deviation for each measurement. These are the variables that contain *"mean()"* and *"std()"* strings in their names. To accomplish this, I read-in the data on the 561 variable names and use them to rename the columns in *merged_data* dataframe:

```{r}
var_names <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
names(merged_data) <- var_names$V2

```
Then I subset *merged_data* to extract only the columns with the names that contain the "mean() OR "std()" strings:

```{r}
merged_data_sub <- merged_data[ , grep("mean()|std()", names(merged_data))]
```
This extracts the 79 variables that contain *"mean()"* OR *"std()"* out of 561 variables in the dataset.

At this point in the process, I've (1) created one data set by merging the training and the test sets, (2) extracted only the measurements on the mean and standard deviation for each measurement, and (3) given the variables in the data set descriptive labels (which is a part of what's required in STEP 4). Hovewer, the data set is still missing the variables (identifiers) on test subjects and activities. 

**STEP 3**  
In this step I add the variables that identify test subjects (the total of 30 subjects) and test activities (the total of 6 activities) to the data set, after which I give activities descriptive lables from the *activity_labels.txt* ("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING").

First I read-in and merge the data (variable) that identify activities for both the *test* and *train* data sets:

```{r}
test_activities <- read.table("./UCI HAR Dataset/test/y_test.txt")
train_activities <- read.table("./UCI HAR Dataset/train/y_train.txt")
merged_activities <- rbind(test_activities, train_activities)
```
The *merged_activities* data contains numeric/integer values 1 to 6, wich need to be replaced with the corresponding activity labels in the final dataset. To do that, I read-in the labels for the six activities, create a dataframe with descriptive labels for the activities called *descr_activity_names* by using the *right_join* function, and name the variable using a descriptive label *"Actitvity"*:

```{r}
activity_labels <-  read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
descr_activity_names <- right_join(activity_labels, merged_activities) %>% select(V2)
names(descr_activity_names) <- "Activity"
```

I also create and name a dataframe called *merged_subjects*, which contains the Subject ID variable:

```{r}
test_subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")
train_subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
merged_subjects <- rbind(test_subjects, train_subjects)
names(merged_subjects) <- "SubjectID"
```

**STEP 4**  
In the previous steps, I've created three data frames including (1) for measurements on the 79 required variables (2) for activities with descriptive labels, and (3) for subject IDs. The three dataframes have already been labeled with descriptive varibale names, so in this step I am just merging the three data frames in one tidy dataframe called *tidy_data*:

```{r}
tidy_data <- cbind(merged_subjects, descr_activity_names, merged_data_sub )
```

**STEP 5**  
The final step requires to create an independent tidy data set with the average of each variable for each activity and each subject and save it in a .txt file. Using the **dplyr** functions **group_by()** and **summarize()**, I group the data by *SubjectID* and *Activity* and summarize all the variables by groups:


```{r}
tidy_data2 <- tidy_data %>%
                    group_by(SubjectID, Activity) %>%
                    summarize_all(mean)
```                    


Saving the final dataset in a file called *tidy_data_set.txt*:

```{r}
write.table(tidy_data2, file = "tidy_data_set.txt", row.names = FALSE)
```

The final data set contains 81 variables and 180 observations (30 sybjects * 6 activities).


## CODEBOOK ##   

There are 81 variables in the final dataset, 79 of which represent measurement summaries and 2 of them are subject and activity identifiers. The following describe the variables:  

1 SubjectID:  Subject identifier. It ranges from 1 to 30.   
2 Activity:  Activity identifier. Includes the following labels: "WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING").    

The following are the estimates of **means** and **standard deviations** of signals (times (t) and frequencies (f)) in the X, Y and Z directions for each subject and activity combination:  

3                tBodyAcc-mean()-X  
4                tBodyAcc-mean()-Y  
5                tBodyAcc-mean()-Z  
6                 tBodyAcc-std()-X  
7                 tBodyAcc-std()-Y  
8                 tBodyAcc-std()-Z  
9             tGravityAcc-mean()-X  
10            tGravityAcc-mean()-Y  
11            tGravityAcc-mean()-Z  
12             tGravityAcc-std()-X  
13             tGravityAcc-std()-Y  
14             tGravityAcc-std()-Z  
15           tBodyAccJerk-mean()-X  
16           tBodyAccJerk-mean()-Y  
17           tBodyAccJerk-mean()-Z  
18            tBodyAccJerk-std()-X  
19            tBodyAccJerk-std()-Y  
20            tBodyAccJerk-std()-Z  
21              tBodyGyro-mean()-X  
22              tBodyGyro-mean()-Y  
23              tBodyGyro-mean()-Z  
24               tBodyGyro-std()-X  
25               tBodyGyro-std()-Y  
26               tBodyGyro-std()-Z  
27          tBodyGyroJerk-mean()-X  
28          tBodyGyroJerk-mean()-Y  
29          tBodyGyroJerk-mean()-Z  
30           tBodyGyroJerk-std()-X  
31           tBodyGyroJerk-std()-Y  
32           tBodyGyroJerk-std()-Z  
33              tBodyAccMag-mean()  
34               tBodyAccMag-std()  
35           tGravityAccMag-mean()   
36            tGravityAccMag-std()  
37          tBodyAccJerkMag-mean()  
38           tBodyAccJerkMag-std()  
39             tBodyGyroMag-mean()  
40              tBodyGyroMag-std()  
41         tBodyGyroJerkMag-mean()  
42          tBodyGyroJerkMag-std()  
43               fBodyAcc-mean()-X  
44               fBodyAcc-mean()-Y  
45               fBodyAcc-mean()-Z  
46                fBodyAcc-std()-X  
47                fBodyAcc-std()-Y  
48                fBodyAcc-std()-Z  
49           fBodyAcc-meanFreq()-X  
50           fBodyAcc-meanFreq()-Y  
51           fBodyAcc-meanFreq()-Z  
52           fBodyAccJerk-mean()-X  
53           fBodyAccJerk-mean()-Y  
54           fBodyAccJerk-mean()-Z  
55            fBodyAccJerk-std()-X  
56            fBodyAccJerk-std()-Y  
57            fBodyAccJerk-std()-Z  
58       fBodyAccJerk-meanFreq()-X  
59       fBodyAccJerk-meanFreq()-Y  
60       fBodyAccJerk-meanFreq()-Z  
61              fBodyGyro-mean()-X  
62              fBodyGyro-mean()-Y  
63              fBodyGyro-mean()-Z  
64               fBodyGyro-std()-X  
65               fBodyGyro-std()-Y  
66               fBodyGyro-std()-Z  
67          fBodyGyro-meanFreq()-X  
68          fBodyGyro-meanFreq()-Y  
69          fBodyGyro-meanFreq()-Z  
70              fBodyAccMag-mean()  
71               fBodyAccMag-std()  
72          fBodyAccMag-meanFreq()  
73      fBodyBodyAccJerkMag-mean()  
74       fBodyBodyAccJerkMag-std()  
75  fBodyBodyAccJerkMag-meanFreq()  
76         fBodyBodyGyroMag-mean()  
77          fBodyBodyGyroMag-std()  
78     fBodyBodyGyroMag-meanFreq()  
79     fBodyBodyGyroJerkMag-mean()  
80      fBodyBodyGyroJerkMag-std()  
81 fBodyBodyGyroJerkMag-meanFreq()  
  
  
  






