library(dplyr)

fname <- "course_proj.zip"

# Check if the file name exists and download file
if (!file.exists(fname)){
  URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(URL, destfile = fname, method = "curl")
}

# unzip file
unzip(fname)

# load data
