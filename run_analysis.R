library(data.table)

data_train <- read.table("data/train//X_train.txt", header=FALSE)
data_test <- read.table("data/test/X_test.txt", header=FALSE)
data_merge <- rbind(data_train, data_test)

# Read the column names from features.txt
colnames <- as.character(read.table("data/features.txt")[, 2])
colnames(data_merge) <- colnames
mean_or_std <- grepl("mean\\(\\)", colnames) | grepl("std\\(\\)", colnames)
data_extract <- data_merge[, mean_or_std]

label_train <- read.table("data/train//y_train.txt", header=FALSE)
label_test <- read.table("data/test/y_test.txt", header=FALSE)
label_merge <- rbind(label_train, label_test)
colnames(label_merge) <- "acitivity_id"
labelnames <- read.table("data/activity_labels.txt", 
                         col.names=c("acitivity_id", "label"))
label_merge <- merge(label_merge, labelnames)
data_extract <- data.table(data_extract)
data_extract[, activity := label_merge$label]
