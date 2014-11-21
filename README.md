README file for the run_analysis.R script.

The script requires that the following text files out of the "UCI HAR Dataset" folder be placed into the working directory:

features.txt
y_train.txt
subject_train.txt
training.txt (renamed from X_train.txt)
y_test.txt
subject_test.txt 
testing.txt (renamed from X_test.txt)

The script reads in the above text files and goes through the following steps in order to consolidate the data and make it tidier.

Lines 1-16 - text files are read in
Lines 17-30 - data frames are consolidated and only columns containing the characters "std" or "mean" are retained
Lines 31-44 - activity numbers are replaced with the activity names
Lines 45-49 - all unique values for subjects and activities are found
Lines 50-63 - new empty data frame is built and column names are appended
Lines 64-89 - all fields are looped through, averages calculated, and new data frame is populated
Lines 90-98 - variables are cleaned up, data is written out, then read back in as a quality check



