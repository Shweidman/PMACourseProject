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

fileUrl <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
download.file(fileUrl,destfile="testingPML.csv")

data <- read.csv("trainingPML.csv",)
validation <- read.csv("testingPML.csv")

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
dim(training1); dim(testing)
```

You can also embed plots, for example:

```{r, echo=FALSE}
plot(cars)
```

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
