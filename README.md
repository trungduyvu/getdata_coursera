Following are each of the required steps and how the script achieve them

Step 1: Merges the training and the test sets to create one data set.
====

The script reads the following files for both test & train data

1. x
2. y
3. subject

It also reads features.txt and labels.txt

After those files are read, the script will merge test & train dataset using rbind on x, y and subjects. We also add the column names to the final x using data loaded from features.txt

Step 2: Extracts only the measurements on the mean and standard deviation for each measurement. 
===

The script run sapply on the loaded features to find all the index of features whose names have mean() or std(). The list of index are then use to select a subset of columns from combined x and assign to a tidy_1 variable

Step 3: Uses descriptive activity names to name the activities in the data set
===

To match value in y to one of the label (numberred 1-6), the script run sapply on y and for each y, it'll try to find 
and return a label whose id matches the current value of y. The return value of sapply is then assign to new activity column of tidy_1 dataset 

Step 4: Appropriately labels the data set with descriptive variable names. 
===

The column name as specified by features.txt aren't well formed, e.g. they have special character - (), so we again run sapply on the column names and use gsub to remove () and -. The result is then assigned by to colnames(x)

Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
===

We will use ddply function from plyr package for this step. Because other than the 2 columns we're trying to group by, e.g. activiy and subject, the rest of the dataset is numeric, we can use numcolwise(mean) to apply mean function to all numeric column.