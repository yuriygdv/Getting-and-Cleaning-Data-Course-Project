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
After loading the necessary packages and setting the working directory, I read-in and merges the training and the test sets to create one data set called *merged_data*:

```{r}
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt", stringsAsFactors = FALSE)
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt", stringsAsFactors = FALSE)
merged_data <- rbind(test_data, train_data)
```

**STEP 2**  
In this step I extracts only the measurements on the mean and standard deviation for each measurement. These are the variables that containg "mean()" and "std() strings in their names. To accomplish this, I read-in the data on the 561 variable names and use them to rename the *merged_data* dataframe:

```{r}
var_names <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
names(merged_data) <- var_names$V2

```
Then I subset *merged_data* to choose only columns which names contain "mean()"" OR "std()":

```{r}
merged_data_sub <- merged_data[ , grep("mean()|std()", names(merged_data))]
```

At this time in the process, I've (1) created one data set by merging the training and the test sets, (2) extracted only the measurements on the mean and standard deviation for each measurement, and (3) given the data set descriptive labels (part of STEP 4). Hovewer, the data set is still missing the varibales on test subjects and activities. 

**STEP 3**
In this step I add the variables that identify test subjects (the total of 30 subjects) and test activities (the total of 6 activities) to the data set, after which I give activities descriptive lables from the activity_labels.txt ("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING").

First read-in and merge the data (variable) that identify activities for both the *test* and *train* data sets:

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
In the previous steps, I've created three data frames including (1) for measurements on the 79 required variables (2) for activities with descriptive labels, and (3) for subject IDs. The three dataframes have already been labeled with descriptive varibale names, so in this step I am mersging the three data frames in one tidy dataframe called *tidy_data*:

```{r}
tidy_data <- cbind(merged_subjects, descr_activity_names, merged_data_sub )
```

**STEP 5**
The final step requires to create an independent tidy data set with the average of each variable for each activity and each subject and save it in a .txt file.


```{r}
tidy_data2 <- tidy_data %>%
                    group_by(SubjectID, Activity) %>%
                    summarize_all(mean)
```                    


Saving the final dataset in a file called *tidy_data_set.txt*:

```{r}
write.table(tidy_data2, file = "tidy_data_set.txt", row.names = FALSE)
```






















