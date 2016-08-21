#CodeBook

##Variables 
        [1] subject - serial number of subjects, ranging from 1 to 30.
        [2] activity - activities subjects participated. Read "activity_labels" to get the full list.
        [3] axialormag - three dimensions of signals or the magnitude of the three. To be specific, they are X, Y, Z and mag (short for magnitude).
        [4] domain - indicating the domain of the the signals, either time or frequency.
        
        other variables are estimated values for different patterns of signals:
        [5] BodyAccMean
        [6] BodyAccStd
        [7] BodyAccJerkMean
        [8] BodyAccJerkStd
        [9] BodyGyroMean
        [10] BodyGyroStd
        [11] BodyGyroJerkMean
        [12] BodyGyroJerkStd
        [13] GravityAccMean
        [14] GravityAccStd
        
        note 1: Mean - mean value estimated from the signals.
        note 2: Std - standard deviation estimated from the signals.

##transformation
        step 1: read tables into R.
        Step 2: combine the tables into one and extract only the columns we need, rename the columns by using information in "features.txt".
        step 3: rename activities in activity column according to "activity_labels.txt".
        step 4: create "axialormag" (=axial or magnitude) column (Containing X, Y, Z and mag). Because X, Y, and Z are three dimensions, and because "Mag" means a magnitude of the three dimensions, they should be values of a dimensional variable rather than variable themselves.
        step 5: create "domain" column (Containing time and frequency). Similar to "axialormag" variable, time and frequency are two domains of signal. After step 5, the required tidy data set will be ready. name the set "tidy_data.csv".
        step 6: create "tidy_data_of_averages.csv", which contains the average of each variable for each activity and each subject.



##Original feature information

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt'