library(tidyverse)

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
Sub_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
Sub_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")


variable_names <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# 1. Merge
X_data <- rbind(X_train, X_test)
Y_data <- rbind(Y_train, Y_test)
Sub_total <- rbind(Sub_train, Sub_test)

selected_var <- variable_names[grep("mean\\(\\)|std\\(\\)",
                                    variable_names[,2]),]
X_data <- X_data[,selected_var[,1]]

colnames(Y_data) <- "activity"
Y_data$activitylabel <- factor(Y_data$activity, 
                               labels = as.character(activity_labels[,2]))
activitylabel <- Y_data[,-1]

colnames(X_data) <- variable_names[selected_var[,1],2]

colnames(Sub_total) <- "subject"
total <- cbind(X_data, activitylabel, Sub_total)

total_mean <- total %>% 
              group_by(activitylabel, subject) %>% 
              summarize_each(funs(mean))

write.table(total_mean, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE)
