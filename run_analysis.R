
#Read in feature names
featurenames = read.table("features.txt")

#Read in the training dataset
trainlabels = read.table("y_train.txt")
trainsubjects = read.table("subject_train.txt")
train = read.table("training.txt", col.names=featurenames$V2)
train["Subject"] = trainsubjects
train["Activity"] = trainlabels

#Read in the test dataset
testlabels = read.table("y_test.txt")
testsubjects = read.table("subject_test.txt")
test = read.table("testing.txt", col.names=featurenames$V2)
test["Subject"] = testsubjects
test["Activity"] = testlabels

#Consolidate the dataframes
comb = rbind(train, test)

#Keep only the columns that contain std or mean
comb1 = comb[grep(c("std"),names(comb))]
comb2 = comb[grep(c("mean"),names(comb))]
comb = cbind(comb$Subject, comb$Activity, comb1, comb2)
comb = rename(comb, c("comb$Subject"="Subject", "comb$Activity"="Activity"))

#Clean up all previous variables
remove(featurenames, trainlabels, trainsubjects, train, testlabels,
       testsubjects,test, comb1, comb2)

#Replace activity numbers with label names
ind = comb$Activity == 1
comb$Activity[ind] = "WALKING"
ind = comb$Activity == 2
comb$Activity[ind] = "WALKING_UPSTAIRS"
ind = comb$Activity == 3
comb$Activity[ind] = "WALKING_DOWNSTAIRS"
ind = comb$Activity == 4
comb$Activity[ind] = "SITTING"
ind = comb$Activity == 5
comb$Activity[ind] = "STANDING"
ind = comb$Activity == 6
comb$Activity[ind] = "LAYING"
remove(ind)

#Find all unique values for Subject
uSubject = unique(comb$Subject)
numSub = length(uSubject)

#Find all unique values for Activity
uActivity = unique(comb$Activity)
numAct = length(uActivity)

#Build new tidy data frame for averages
final = data.frame(matrix(NA, nrow=(numSub*numAct), ncol=length(comb)))
#Read out the column names from comb
columnnames = colnames(comb)
colnames(final) = columnnames
remove(columnnames)

#Append featurenames to the final data frame

#Loop through subjects
for (i in 1:numSub){

  #Find all entries with the current subject
  subind = comb$Subject == i

  for (j in 1:numAct) {

    #Find all rows with current activity, combine with subject
    actind = comb$Activity == uActivity[j]
    subactind = subind + actind
    subactind = subactind == 2

    #Set number of record
    numrec = (((i-1) * 6) + j)

    #Populate first two columns
    final[numrec,1] = i
    final[numrec,2] = uActivity[j]

    #Calculate average across rows for that activity
    for (k in 3:81){
      final[numrec,k] = mean(comb[subactind,k])
    }
  }
}

#Clean up variables
remove(actind, comb, i, j, k, numAct, numSub, numrec, subactind,
       subind, uActivity, uSubject)

#Write out tidy dataset
write.table(final, file="run_analysis_output.txt", row.names = FALSE)

#Read table back in to check on tidiness
finalcheck = read.table("run_analysis_output.txt")

