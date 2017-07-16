#
#     run_analysis.R was written to do the following:
#
#   1) Merges the training and the test sets to create one data set.
#
#   2) Extracts only the measurements on the mean and standard deviation 
#       for each measurement.
#
#   3) Uses descriptive activity names to name the activities in the data set
#
#   4) Appropriately labels the data set with descriptive variable names.
#
#   5) From the data set in step 4, creates a second, independent 
#       tidy data set with the average of each variable for each 
#       activity and each subject.

library(reshape2)

  
  # Load activity labels + features
    # Reading features files:
    features <- read.table("d:/dev/p4/dataset/features.txt")
    features[,2] <- as.character(features[,2])
  
    # Reading and loading activity labels:
    activityLabels = read.table("d:/dev/p4/dataset/activity_labels.txt")
    activityLabels[,2] <- as.character(activityLabels[,2])  
  

  # Extract only the data on mean and standard deviation
  featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
  featuresWanted.names <- features[featuresWanted,2]
  featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
  featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
  featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)


  # Read subset based on the featue names with "mean" and "std" in the featuresWanted:
    # test files
    x_test <- read.table("d:/dev/p4/dataset/test/X_test.txt")[featuresWanted]
    y_test <- read.table("d:/dev/p4/dataset/test/Y_test.txt")
    subject_test <- read.table("d:/dev/p4/dataset/test/subject_test.txt")
    mrg_test <- cbind(subject_test, y_test, x_test) 
    #training files:
    x_train <- read.table("d:/dev/p4/dataset/train/X_train.txt")[featuresWanted]
    y_train <- read.table("d:/dev/p4/dataset/train/y_train.txt")
    subject_train <- read.table("d:/dev/p4/dataset/train/subject_train.txt")
    mrg_train <- cbind(subject_train, y_train, x_train)
   
    # merge these babies together
    allData <- rbind(mrg_train, mrg_test)
    # add subject and acitvity column names
    colnames(allData) <- c("subject", "activity", featuresWanted.names)
  
  # turn activities & subjects into factors
  allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
  allData$subject <- as.factor(allData$subject)
  
  allData.melted <- melt(allData, id = c("subject", "activity"))
  allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)
  
  #wite result file out to the working directory
  write.table(allData.mean, "d:/dev/tidy.txt", row.names = FALSE, quote = FALSE)
  