
library(plyr)
# download and unzip the data file
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
download.file(URL, filename, method="curl")
unzip(filename)

# read activity and feature file.
activit_label_file<- read.table("C:\\Users\\Devender\\Documents\\project\\UCI HAR Dataset\\activity_labels.txt")
activit_label_file[,2] <- as.character(activit_label_file[,2])
features_file <- read.table("C:\\Users\\Devender\\Documents\\project\\UCI HAR Dataset\\features.txt")
features_file[,2] <- as.character(features_file[,2])

# find the position of mean and std in feature file
features_pos <- grep(".*mean.|.*std.",features_file[,2])
features_name <- features_file[features_pos,2]

# refining the data
features_name <- gsub("-mean","Mean",features_name)
features_name <- gsub("-std","Std",features_name)
features_name <- gsub("[()]","",features_name)
features_name <- gsub("-","",features_name)

# Reading the train files and combining file
train_file <- read.table("C:\\Users\\Devender\\Documents\\project\\UCI HAR Dataset\\train\\X_train.txt")[features_pos]
train_act <- read.table("C:\\Users\\Devender\\Documents\\project\\UCI HAR Dataset\\train\\Y_train.txt")
train_sub <- read.table("C:\\Users\\Devender\\Documents\\project\\UCI HAR Dataset\\train\\subject_train.txt")
train_com <-cbind(train_sub,train_act,train_file)

# Reading the test files and combining them
test_file <- read.table("C:\\Users\\Devender\\Documents\\project\\UCI HAR Dataset\\test\\X_test.txt")[features_pos]
test_act <- read.table("C:\\Users\\Devender\\Documents\\project\\UCI HAR Dataset\\test\\Y_test.txt")
test_sub <- read.table("C:\\Users\\Devender\\Documents\\project\\UCI HAR Dataset\\test\\subject_test.txt")
test_com <-cbind(test_sub,test_act,test_file)

# Combining the train and test data. Giving names to the data
complete_data <- rbind(train_com,test_com)
colnames(complete_data) <- c("Subject","Activities",features_name)

# Finding mean of the columns based on Subject and activities. Writing the data to mean_data.txt file
mean_data <- ddply(complete_data, .(Subject, Activities), function(x) colMeans(x[, 3:81]))
write.table(mean_data, "mean_data.txt", row.name=FALSE)