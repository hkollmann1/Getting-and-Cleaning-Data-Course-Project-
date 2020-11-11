library(data.table)
library(reshape2)
features <-read.table("./data/UCI HAR Dataset/features.txt",header = FALSE, col.names = c("index","featureNames"))
activitys_labels <-read.table("./data/UCI HAR Dataset/activity_labels.txt",header = FALSE,col.names = c("classLabels","activityName"))
featureswanted <- grep("(mean|std)\\(\\)", features[,"featureNames"])
measurements <- features[featureswanted,"featureNames"]
measurements <- gsub('[()]','',measurements)



activitys_train <-read.table("./data/UCI HAR Dataset/train/y_train.txt",header = FALSE, col.names = "Activity")
subjects_train<- read.table("./data/UCI HAR Dataset/train/subject_train.txt",header = FALSE, col.names = "SubjectNum")
features_train <-read.table("./data/UCI HAR Dataset/train/X_train.txt",header = FALSE)[,featureswanted]
data.table :: setnames(features_train,colnames(features_train), measurements)
train<-cbind(subjects_train,activitys_train,features_train)

features_test <-read.table("./data/UCI HAR Dataset/test/X_test.txt",header = FALSE)[,featureswanted]
data.table :: setnames(features_test,colnames(features_test), measurements)
activitys_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt",header = FALSE, col.names = "Activity")
subjects_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt",header = FALSE, col.names = "SubjectNum")
test<-cbind(subjects_test,activitys_test,features_test)


## Question 1: Merges the training and the test sets to create one data set.
## Question 2:Extracts only the measurements on the mean and standard deviation for each measurement.

comb <- rbind(test,train)

##Question 3: Uses descriptive activity names to name the activities in the data set
comb[["Activity"]] <- factor(comb[,"Activity"], levels = activityLabels[["classLabels"]], labels = activityLabels[["activityName"]])
comb[["SubjectNum"]] <- as.factor(comb[,"SubjectNum"])

##Question 4: Appropriately labels the data set with descriptive variable names.
comb <- reshape2::melt(data = comb, id = c("SubjectNum", "Activity"))
comb <- reshape2::dcast(data = comb, SubjectNum + Activity ~ variable, fun.aggregate = mean)

##Question 5:From the data set in step 4, creates a second, independent tidy data set
##with the average of each variable for each activity and each subject.
data.table::fwrite(x = comb, file = "tidyData.txt", quote = FALSE)