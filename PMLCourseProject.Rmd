---
title: "PML Course Project"
output: html_document
---

##Table of Contents:
###1. Summary of Approach
###2. Creating the training and testing sets
###3. Clean the training and testing sets
###4. Create the models
###5. Estimate out-of-sample error
###6. Conclusion

##1. Summary of Approach

I divided the data into a training set, which was a randomly-chosen 70% of the data on which I built the model, and a testing set, the remaining 30% on which I tested the models to determine out-of-sample error.

Within the training set, I divided it into 7 randomly chosen subsets and built a random forest model on each subset. For each exercise, then, I had seven predictions about which class it belonged to. I then chose the most common prediction as the final predicted value of the "classe" variable. Applying this methodology to the test set gave 96.3% accuracy. 

Indeed, when applying this methodology also to the 20 validation cases provided, 19 of the 20 cases were correctly predicted. The methodology allowed me to correctly guess the "classe" value of the incorrect case on my second try, as this case was predicted to be of classe "D" in 4 of the 7 random forests and classe "B" in the other 3. Thus, while I originally had predicted that case to be of classe "D", I correctly guess that it was classe "B" on my second try.

###2. Creating the training and testing sets

Here, I read in the data from the websites provided:

```{r}
library(caret)

setwd("C:/Users/weidse51/Documents/Coursera/Data Science/Practical Machine Learning/Course Project")

fileUrl <- "http://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
download.file(fileUrl,destfile="trainingPML.csv")

fileUrl <- "http://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
download.file(fileUrl,destfile="testingPML.csv")

data <- read.csv("trainingPML.csv",)
validation <- read.csv("testingPML.csv")
```

Now, I divide the data into the training and test sets as described above:

```{r}
set.seed(1)
sample <- runif(nrow(data))

training1 <- data[(sample>0&sample<0.1),]
training2 <- data[(sample>0.1&sample<0.2),]
training3 <- data[(sample>0.2&sample<0.3),]
training4 <- data[(sample>0.3&sample<0.4),]
training5 <- data[(sample>0.4&sample<0.5),]
training6 <- data[(sample>0.5&sample<0.6),]
training7 <- data[(sample>0.6&sample<0.7),]
testing <- data[(sample>0.7),]
```

##3. Clean the training and test sets

I only want to use as predictors in the model those columns which actually exist in the validation dataset, so here I identify which columns are complete in the validation set.

```{r}
completeCols <- unique(
  unlist(
    lapply(as.data.frame(t(validation)), function(x) which(!is.na(x)))))
```

Then I subset the training files so they only contain the complete columns...

```{r}
training1 <- training1[,completeCols]
training2 <- training2[,completeCols]
training3 <- training3[,completeCols]
training4 <- training4[,completeCols]
training5 <- training5[,completeCols]
training6 <- training6[,completeCols]
training7 <- training7[,completeCols]
```

...and further subset out the variables that were merely qualitative (this required running head(training1) and figuring out which columns to subset out; I omit that output here).

```{r}
trainingModel1 <- training1[8:60]
trainingModel2 <- training2[8:60]
trainingModel3 <- training3[8:60]
trainingModel4 <- training4[8:60]
trainingModel5 <- training5[8:60]
trainingModel6 <- training6[8:60]
trainingModel7 <- training7[8:60]
```

Finally, I change the 52 columns in the each training set into numeric variables.

```{r}
for (i in 1:52) {
  trainingModel1[,i] <- as.numeric(as.character(trainingModel1[,i]))
  trainingModel2[,i] <- as.numeric(as.character(trainingModel2[,i]))
  trainingModel3[,i] <- as.numeric(as.character(trainingModel3[,i]))
  trainingModel4[,i] <- as.numeric(as.character(trainingModel4[,i]))
  trainingModel5[,i] <- as.numeric(as.character(trainingModel5[,i]))
  trainingModel6[,i] <- as.numeric(as.character(trainingModel6[,i]))
  trainingModel7[,i] <- as.numeric(as.character(trainingModel7[,i]))}
```

##4. Create the models

```{r}
model1 <- train(classe~ .,data=trainingModel1,method="rf",prox=TRUE)
model2 <- train(classe~ .,data=trainingModel2,method="rf",prox=TRUE)
model3 <- train(classe~ .,data=trainingModel3,method="rf",prox=TRUE)
model4 <- train(classe~ .,data=trainingModel4,method="rf",prox=TRUE)
model5 <- train(classe~ .,data=trainingModel5,method="rf",prox=TRUE)
model6 <- train(classe~ .,data=trainingModel6,method="rf",prox=TRUE)
model7 <- train(classe~ .,data=trainingModel7,method="rf",prox=TRUE)
```

Use the models to create 7 sets of predictions on the testing data.

```{r}
pred1 <- predict(model1,testing)
pred2 <- predict(model2,testing)
pred3 <- predict(model3,testing)
pred4 <- predict(model4,testing)
pred5 <- predict(model5,testing)
pred6 <- predict(model6,testing)
pred7 <- predict(model7,testing)
```

Create a matrix with all of the predictions.

```{r}
classePred <- cbind(data.frame(pred1),
              data.frame(pred2),
              data.frame(pred3),
              data.frame(pred4),
              data.frame(pred5),
              data.frame(pred6),
              data.frame(pred7))
```

Now create a matrix with 
--One row for each observation in the testing dataset.
--Column 1 listing how many times "A" was predicted, column 2 "B" etc.

```{r}
predMatrix <- matrix(0,nrow=nrow(classePred),ncol=5)

for (i in 1:nrow(classePred)) {
  for (j in 1:7) {
    if (classePred[i,j]=="A") {
      predMatrix[i,1] = predMatrix[i,1] + 1
    } else if (classePred[i,j]=="B") {
      predMatrix[i,2] = predMatrix[i,2] + 1
    } else if (classePred[i,j]=="C") {
      predMatrix[i,3] = predMatrix[i,3] + 1
    } else if (classePred[i,j]=="D") {
      predMatrix[i,4] = predMatrix[i,4] + 1
    } else if (classePred[i,j]=="E") {
      predMatrix[i,5] = predMatrix[i,5] + 1
    }
  }
}
```

Now figure out if there are any "ties"--observations for which there is more than one value of classe for which the number of models that predict that that observation is that value of classe is equal to the maximum number of models that predict any value of classe.

```{r}
predMatrixUnam <- rep(NA,nrow(predMatrix))
for (i in 1:nrow(predMatrix)) {predMatrixUnam[i] <- length(which(predMatrix[i,]==max(predMatrix[i,])))}
ties <- which(predMatrixUnam==2)
predMatrix[ties[1],]
```

Finally, create the vector with the "classe" predictions for each observation. For the ties, randomly choose among the classe values that were tied for having the most models predicting them.

```{r}
predictionTesting <- rep(NA,nrow(predMatrix))

for (i in 1:nrow(predMatrix)) {
  if (i %in% ties) {
    maxes <- which(predMatrix[i,]==max(predMatrix[i,]))
    maxChoose <- rbinom(1,1,0.5)+1
    predictionTesting[i] <- maxes[maxChoose]
  } else {
    predictionTesting[i] <- which(predMatrix[i,]==max(predMatrix[i,]))
  }
}
```

##5. Estimate the out-of-sample error.

I estimated the out-of-sample error as follows:

```{r}
summary<-table(predictionTesting,testing$classe)
summary

correct <- 0
incorrect <- 0
for (i in 1:5) {for (j in 1:5)
  if (i==j) {correct <- correct + summary[i,j]}
  else {incorrect <- incorrect + summary[i,j]}
}

accuracy <- correct / (correct + incorrect)
outofSampleError <- 1-accuracy
outofSampleError
```

##6. Conclusion

Applying this same modelling process to the validation set yielded the following predictions.

1. "B"
2. "A"
3. "B"
4. "A"
5. "A"
6. "E"
7. "D"
8. "D"
9. "A"
10. "A" 
11. "B"
12. "C"
13. "B"
14. "A"
15. "E"
16. "E"
17. "A"
18. "B"
19. "B"
20. "B"

19 of these are correct; the prediction for observation 8 was incorrect. In the interest of saving space I haven't shown all of the code, but it turned out that 4 of the 7 models predicted classe "D" for observation 8, and 3 of the 7 predicted classe "B". Thus, I guessed classe "B" for observation 8 on the second guess that Coursera granted me and was correct. This shows an advantage of this methodology: for cases that are "on the border" and are thus misclassified, you can use information calculated during the modelling process to get a "second guess" of what the observation should have been classified as.