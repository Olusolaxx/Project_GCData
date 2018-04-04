# Getting and Cleaning Data Coursera Peer-graded Assignment
# Olusola Afuwape

library(reshape2)

# Set working directory
# Download file from the link

dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dataZipFile <- "UCI HAR Dataset.zip"

if (!file.exists(dataZipFile)) {
  download.file(dataUrl, dataZipFile, mode = "wb")
}

#unzip downloaded file
dataFile <- "UCI HAR Dataset"
if (!file.exists(dataFile)) {
  unzip(dataZipFile)
}


# Load features dataset
features <- read.table(file.path(dataFile,"features.txt"))
features[, 2] <- as.character(features[, 2])

#Load activity_labels dataset
activities <- read.table(file.path(dataFile, "activity_labels.txt"))
activities[, 2] <- as.character(features[, 2])

# Extract the mean and standard deviation for each measurement
columns <- grep(".*mean.*|.*std.*", features[, 2])
cols <- features[columns, 2]
cols = gsub("-mean", "Mean", cols)
cols = gsub("-std", "Std", cols)
cols <- gsub("[-()]", "", cols)

# Load test datasets
testSubjects <- read.table(file.path(dataFile, "test", "subject_test.txt"))
testValues <- read.table(file.path(dataFile, "test", "X_test.txt"))[columns]
testActivities <- read.table(file.path(dataFile, "test", "y_test.txt"))
testValues <- cbind(testSubjects, testActivities, testValues)

#Load training datasets
trainingSubjects <- read.table(file.path(dataFile, "train", "subject_train.txt"))
trainingValues <- read.table(file.path(dataFile, "train", "X_train.txt"))[columns]
trainingActivities <- read.table(file.path(dataFile, "train", "y_train.txt"))
trainingValues <- cbind(trainingSubjects, trainingActivities, trainingValues)

# Merge test and train datasets
humanActivityRecognition <- rbind(trainingValues, testValues)
colnames(humanActivityRecognition) <- c("subject", "activity", cols)

#Use descriptive names for activity
humanActivityRecognition$activity <- factor(humanActivityRecognition$activity, levels = activities[, 1], labels = activities[, 2])
humanActivityRecognition$subject <- as.factor(humanActivityRecognition$subject)

humanActivityRecognitionMelt <- melt(humanActivityRecognition, id = c("subject", "activity"))
humanActivityRecognitionMeans <- dcast(humanActivityRecognitionMelt, subject + activity ~ variable, mean)

# Write tidy data to file
write.table(humanActivityRecognitionMeans, "tidyData.txt", row.names = FALSE, quote = FALSE)





