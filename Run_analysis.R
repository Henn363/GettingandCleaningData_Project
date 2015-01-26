library(dplyr)
library(reshape2)
library("data.table")

#Load Train data for X and Y
X_train <- read.table("./Project/UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./Project/UCI HAR Dataset/train/Y_train.txt")
activity <- read.table("./Project/UCI HAR Dataset/activity_labels.txt")[,2]
subject_train <- read.table("./Project/UCI HAR Dataset/train/subject_train.txt")
names(subject_train) = "subject"

# Load features and create logical vector to subset columns later
features <- read.table("./Project/UCI HAR Dataset/features.txt")[,2]
colnames(X_train) <- features
features_vect <- grepl("mean|std", features)

#Subset Columns that have mean or std in column
X_train <- X_train[,features_vect]

# Load activity data
Y_train[,2] = activity[Y_train[,1]]
names(Y_train) = c("activity_id", "activity_label")


#Bind X & Y training df's by subject
train_data <- cbind(as.data.table(subject_train), Y_train, X_train)

#Load Test data for X and Y
X_test <- read.table("./Project/UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./Project/UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("./Project/UCI HAR Dataset/test/subject_test.txt")
names(subject_test) = "subject"

#Subset Columns that have mean or std in column
colnames(X_test) <- features
X_test <- X_test[,features_vect]

# Load activity labels
Y_test[,2] = activity[Y_test[,1]]
names(Y_test) = c("activity_id", "activity_label")


#Bind X & Y test df's by subject
test_data <- cbind(as.data.table(subject_test), Y_test, X_test)

# Merge test and train data
Combined_df = rbind(test_data, train_data)

#Melt dataframe by id variables. Then cast it and output mean/subject per movement
melt_df <- melt(Combined_df, id.vars = c("subject", "activity_id", "activity_label"), variable.name = "movement", value.name ="movement_value")
tidy_df <- dcast(melt_df, subject + activity_label ~ movement, mean)

write.table(tidy_df, file = "Project_1.txt")
