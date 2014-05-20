library(data.table)

# 1. Merges the training and the test sets to create one data set.
# Read train and test data, store into data_merge.
data_train <- read.table("data/train//X_train.txt", header=FALSE)
data_test <- read.table("data/test/X_test.txt", header=FALSE)
data_merge <- rbind(data_train, data_test)
# Read the column names from features.txt, update data_merge.
colnames <- as.character(read.table("data/features.txt")[, 2])
colnames(data_merge) <- colnames


# 2. Extracts only the measurements on the mean and standard deviation
# for each measurement.
# Extract columns with name containing mean() or std(), store in data_extract.
mean_or_std <- grepl("mean\\(\\)", colnames) | grepl("std\\(\\)", colnames)
data_extract <- data_merge[, mean_or_std]


# 3. Uses descriptive activity names to name the activities in the data set.
# Read activity labels in train and test data, store into label_merge.
label_train <- read.table("data/train//y_train.txt", header=FALSE)
label_test <- read.table("data/test/y_test.txt", header=FALSE)
label_merge <- rbind(label_train, label_test)
colnames(label_merge) <- "acitivity_id"
# Read the mapping table from acitivity ids to human-readable labels.
labelnames <- read.table("data/activity_labels.txt",
                         col.names=c("acitivity_id", "label"))
# Left join label_merge and labelnames on acitivity_id, update label_merge.
label_merge <- merge(label_merge, labelnames, all.x=TRUE)


# 4. Appropriately labels the data set with descriptive activity names.
# Convert data_extract into data.table for effieciency and convenience.
data_extract <- data.table(data_extract)
# Update data_extract with acitivity labels.
data_extract[, activity := label_merge$label]
# Write data_extra to local file.
write.table(data_extract, "data_extract.csv", row.names=FALSE)


# 5. Creates a second, independent tidy data set with the average of each
# variable for each activity and each subject.
# First, add subject colum
subject_train <- read.table("data/train/subject_train.txt", header=FALSE)
subject_test <- read.table("data/test//subject_test.txt", header=FALSE)
data_extract[, subject := rbind(subject_train, subject_test)]

# Split data_extract by subject and activity, and calculate variable means.
average <- sapply(split(data_extract,
                        list(data_extract$subject, data_extract$activity),
                        drop=TRUE),
                  function (subset) sapply(subset, mean))
# Transpose the matrix.
average <- t(average)
# Store back the result as a data.table, correcting the NAs in activity output
# by mean function at last step.
average_correct <- data.table(average)
average_correct$activity <- sub("[0-9]+\\.", "", rownames(average))
# Write the result into data_average.csv
write.table(average_correct, "data_average.csv", row.names=FALSE)