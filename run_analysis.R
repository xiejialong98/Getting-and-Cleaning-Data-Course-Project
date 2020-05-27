library(dplyr)

# Check if the file name exists and download file
fname <- "course_proj.zip"
if (!file.exists(fname)){
  URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(URL, destfile = fname, method = "curl")
}

# unzip file
unzip(fname)

# load data
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

# merge data
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
merged <- cbind(subject, x, y)

# Extract the measurements on the mean and standard deviation
tidy_data <- select(merged, subject, code, contains("mean"), contains("sd"))
                    
# Replace the codes with corresponding activities
tidy_data$code <- activities[tidy_data$code,2]

# label the data set with descriptive variable names
tidy_data <- rename(tidy_data, "activity"= "code")
names(tidy_data) <- gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data) <- gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data) <- gsub("angle", "Angle", names(tidy_data))
names(tidy_data) <- gsub("Mag", "Magnitude", names(tidy_data))
names(tidy_data) <- gsub("-Freq()", "Frequency", names(tidy_data))
names(tidy_data) <- gsub("BodyBody", "Body", names(tidy_data))
names(tidy_data) <- gsub("^f", "Frequency", names(tidy_data))
names(tidy_data) <- gsub("^t", "Time", names(tidy_data))
names(tidy_data) <- gsub("gravity", "Gravity", names(tidy_data))
names(tidy_data) <- gsub(".mean...", "Mean at ", names(tidy_data))

# write a table for tidy data set with the average of each variable for each activity and each subject
grouped_data <- group_by(tidy_data, activity, subject)
summary_data <- summarize_all(grouped_data, funs(mean))
write.table(summary_data, "summary_data.txt", row.name=FALSE)