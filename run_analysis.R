
# Getting and Cleaning Data Coursera Peer-graded Assignment
# Olusola Afuwape

library(dplyr)

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


# Load test datasets
testSubjects <- read.table(file.path(dataFile, "test", "subject_test.txt"))
testValues <- read.table(file.path(dataFile, "test", "X_test.txt"))
testActivities <- read.table(file.path(dataFile, "test", "y_test.txt"))

#Load training datasets
trainingSubjects <- read.table(file.path(dataFile, "train", "subject_train.txt"))
trainingValues <- read.table(file.path(dataFile, "train", "X_train.txt"))
trainingActivities <- read.table(file.path(dataFile, "train", "y_train.txt"))

# Load features dataset
features <- read.table(file.path(dataFile,"features.txt"), as.is = TRUE)

#Load activity_labels dataset
activities <- read.table(file.path(dataFile, "activity_labels.txt"))
colnames(activities) <- c("activityId", "activityName")

# Merge test and train datasets
humanActivityRecognition <- rbind(
  cbind(testSubjects, testValues, testActivities),
  cbind(trainingSubjects, trainingValues, trainingActivities)
)

# Column names
colnames(humanActivityRecognition) <- c("subject", features[, 2], "activity")

# Extract the mean and standard deviation for each measurement
columns <- grep("subject|activity|mean|std", colnames(humanActivityRecognition))
humanActivityRecognition <- humanActivityRecognition[, columns]

#Use descriptive names for activity
humanActivityRecognition$activity <- factor(humanActivityRecognition$activity, levels = activities[, 1], labels = activities[, 2])

# Label with descriptive variable names
cols <- colnames(humanActivityRecognition)

# Remove special characters from column labels
cols <- gsub("[\\(\\)-]", "", cols)

cols <- gsub("^f", "frequencyDomain", cols )
cols <- gsub("^t", "timeDomain", cols)
cols <- gsub("Acc", "Accelerometer", cols)
cols <- gsub("Gyro", "Gyroscope", cols)
cols <- gsub("Mag", "Magnitude", cols)
cols <- gsub("Freq", "Frequency", cols)
cols <- gsub("mean", "Mean", cols)
cols <- gsub("std", "StandardDeviation", cols)

# Remove duplication
cols <- gsub("BodyBody", "Body", cols)

# Replace column names with new names
colnames(humanActivityRecognition) <- cols

# Second independent tidy data with average of each variable

humanActivityRecognitionMeans <- humanActivityRecognition %>%
  group_by(subject, activity) %>%
  overall(funs(mean))

# Write tidy data to file
write.table(humanActivityRecognitionMeans, "tidyData.txt", row.names = FALSE, quote = FALSE)





