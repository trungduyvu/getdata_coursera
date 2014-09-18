# first, read all the relevant files
train_x <- read.csv('train//X_train.txt', header=FALSE, sep="")
train_y <- read.csv('train//y_train.txt', header=FALSE, sep="")
train_subjects <- read.csv('train//subject_train.txt', header=FALSE, sep="")
test_x <- read.csv('test/X_test.txt', header=FALSE, sep="")
test_y <- read.csv('test/y_test.txt', header=FALSE, sep="")
test_subjects <- read.csv('test//subject_test.txt', header=FALSE, sep="")
labels <- read.csv('activity_labels.txt', header=FALSE, sep="", col.names=c("id", "label"))

# STEP 1: Merge train & test dataset
x <- rbind(train_x, test_x)
y <- rbind(train_y, test_y)
subjects <- rbind(train_subjects, test_subjects)

# let's name those columns. This is STEP 4, but it's easy to do it here
features <- read.csv('features.txt', header=FALSE, sep="")
colnames(x) <- features[, 2]

# STEP 2: go through features, find those that have std & mean in their name and
# use that to subset x
# we use regular expression and search for mean() or std() (the parantheseses are 
# required, ortherwise we'd include incorrect variables)
# sapply returns a logical vector where TRUE mean to includes that column and vice
# versa. Use that to subset x
tidy_1 <- x[, sapply(seq(features[,2]), function(f) {grepl("(mean|std)\\(\\)", features[f, 2])})]


# STEP 3: Convert y into labels
# we use labels[labels$id==<REQUIRED Y LABEL>, ] to ensure that even if the labels
# wasn't sorted from 1-6, we'd still get correct data
tidy_1$activity <- sapply(seq(y[, 1]), function(f) {labels[labels$id==y[f, ], 2]})

# STEP 4: Strip - & () from variable names
colnames(tidy_1) <- sapply(colnames(tidy_1), function(f) { gsub("(\\(\\)|\\-)", "", f)})

# STEP 5:
# append subject to tidy_1
tidy_1$subject <- subjects$V1

# use plyr to create aggregate dataset
library(plyr)
# numcolwise with mean function as param will run mean on all numeric column
tidy_2 <- ddply(tidy_1, c("activity", "subject"), numcolwise(mean))

write.table(tidy_2, "tidy_2.txt", row.name=FALSE, sep="")
