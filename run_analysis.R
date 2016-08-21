#Getting and Cleaning Data - Assignment
#Step 1: read tables into R.
#Step 2: combine the tables into one and extract only the columns we need, rename the columns.
#step 3: rename activities in activity column.
#step 4: create "axialormag" column. (Containing X, Y, Z, and mag)
#step 5: create "domain" column. (Containing time and frequency)
#step 6: create a new table for averages.

#step 1: read tables into R.

#check if the package has been installed.
check<-function(pkgname){
        if (is.na(match(pkgname,rownames(installed.packages())))) {
                install.packages(pkgname)
        }
}
check("data.table")
check("plyr")
check("dplyr")

library(data.table)
library(plyr)
library(dplyr)


#set working directory.
setwd("./UCI HAR Dataset")


#read necessary tables in current working directory.
labels <- fread("activity_labels.txt")
features <- fread("features.txt", colClasses = "character")


#read necessary tables in "test" directory.
list.files("./test")
test_set <- fread("./test/X_test.txt")
test_label <- fread("./test/y_test.txt")
test_subject <- fread("./test/subject_test.txt")


#read necessary tables in "train" directory.
list.files("./train")
train_set <- fread("./train/X_train.txt")
train_label <- fread("./train/y_train.txt")
train_subject <- fread("./train/subject_train.txt")


#step 2: combine the tables into one and extract only the columns we need, rename the columns.
#bind tables into one named "fullset".
test <- cbind(test_subject, test_label, test_set)
train <- cbind(train_subject, train_label, train_set)
fullset <- rbind(test, train)

#rename the fullset with names in features table.
names(fullset) <- c("subject", "activity", features$V2)

#extract columns with "mean()" or "std()" in their names from fullset.
names <- names(fullset)
subset <-
        fullset[, c(1, 2, grep("mean\\(\\)", names), grep("std\\(\\)", names)), with = FALSE]

#as far as I can see, the names extracted from "features.txt" has some problems according to the "features_info.txt".
#(there are some "...BodyBody...", one of them is duplicated.)
names(subset) <- gsub("BodyBody", "Body", names(subset))

#delete "()" in the names of subset.
names(subset) <- gsub("\\(\\)", "", names(subset))


#step 3: rename activities in activity column.
#Use activity names to name the activity column.
for (i in 1:nrow(labels)) {
        subset$activity <- gsub(labels[[1]][i], labels[[2]][i], subset$activity)
}



#step 4: create "axialormag" column. (Containing X, Y, Z and mag)

#the following codes are hard to describe for me due to my English ability. I suggest you to run them line by line to see what happened.

#all signals are labeled with either three dimensions (X, Y, Z) or magnitude of three dimensions.
#thus they should be the values of "axialormag" variable rather than variables themselves.

#there are sixteen such groups, so create a list of 16 tables, each table contains a pattern of signal along with their dimensions or magnitude of dimensions
#then combine the tables.

#put dimensional columns (i.e. columns with X, Y, or Z in their names) together to make following process more convenient.
subset <- subset[, c(1:17, 23:31, 36:50, 56:64, 18:22, 32:35, 51:55, 65:68), with = F]

#create a list to be the container of the 16 tables.
tblist <- list(NULL)
length(tblist) <- 16

for (i in 1:16) {
        j = 3 * i
        #melt each (X, Y, Z) group in one column.
        tblist[[i]] <-
                melt(subset[, c(1:2, j:(j + 2)), with = F],
                     id.vars = c(1:2),
                     variable.name = "axialormag")
        #rename the "value" column.
        name <- as.character(tblist[[i]][1, 3, with = F][[1]])
        names(tblist[[i]])[4] <- substr(name, 1, nchar(name) - 2)
        #change the value of "axialormag" column to Xs, Ys, and Zs.
        d <- tblist[[i]]$axialormag
        d <- as.character(d)
        tblist[[i]]$axialormag <- substr(d, nchar(d[1]), nchar(d[1]))
        #there are 4 columns in each table, subject, activity, axialormag and value column (e.g. tBodyAcc-mean).
        #The first three columns in eache table are duplicate.We only need the last column of each table except the first table.
        if (i > 1)
                tblist[[i]] <- tblist[[i]][, 4, with = F]
}

#combine the tables in the tblist.
table1_axial <- cbind(tblist[[1]], tblist[[2]])

for (i in 3:16) {
        table1_axial <- cbind(table1_axial, tblist[[i]])
}

#create the table of magnitude of three dimensions.
table1_mag <- subset[, c(1:2, 51:68), with = FALSE]
table1_mag$axialormag<-rep("mag",nrow(table1_mag))
names(table1_mag)<-gsub("Mag","",names(table1_mag))

#combine the tables with and without dimension.
table1 <- rbind(table1_axial, table1_mag, fill = TRUE)
names(table1)



#step 5: create "domain" column. (Containing time and frequency)
#domain type is either time domain signal or frequency domain signal. Thus they should be the values of "domain" variable.

#sort column of table1 according to the names of the columns, in order to conveniently extract time and frequency columns respectively.
table1 <- table1[, order(names(table1)), with = F]

names(table1)

#create a table named table_t which only contains time domain signals of table1.
table2_t <- table1[, c(11, 1, 2, 12:21), with = F]
#create a "domain" column containing "time" in table2_t.
table2_t$domain <- rep("time", nrow(table2_t))
#delete "t" in the names of columns in table2_t.
tnames <- names(table2_t)[4:(ncol(table2_t) - 1)]
names(table2_t)[4:(ncol(table2_t) - 1)] <- substr(tnames, 2, nchar(tnames))

#do the same thing. This time create a table of frequency domain signals.
table2_f <- table1[, c(11, 1:10), with = F]
table2_f$domain <- rep("frequency", nrow(table2_f))
fnames <- names(table2_f)[4:(ncol(table2_f) - 1)]
names(table2_f)[4:(ncol(table2_f) - 1)] <- substr(fnames, 2, nchar(fnames))

#combine the time and frequency tables.
table2 <- rbind(table2_t, table2_f, fill = T)
names(table2)
table2 <- table2[, c(1:3, 14, 4:13), with = F]


names(table2) <- gsub("-m", "M", names(table2))
names(table2) <- gsub("-s", "S", names(table2))

#in my opinion, using lower-case will make the names hard to understand. So I'll leave them here.
write.table(table2,"tidy_data.txt",row.names = F)




#step 6: create a new table for average of each variable for each activity and each subject.
ls <- list(NULL)
for (i in 5:14) {
        temp <- tbl_df(table2[, c(1, 2, i), with = F])
        names(temp)[3] <- "value"
        ls[[(i - 4)]] <- ddply(temp, .(subject, activity), summarize, mean = mean(value, na.rm = T))
        names(ls[[(i - 4)]])[3] <- names(table2)[i]
}
meantable <- join_all(ls)

write.table(meantable,"tidy_data_of_averages.txt",row.names=F)


