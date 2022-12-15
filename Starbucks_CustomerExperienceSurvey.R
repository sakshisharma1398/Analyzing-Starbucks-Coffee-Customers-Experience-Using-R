library("readxl")
library(cluster)
library(NbClust)
library(factoextra)
setwd("C:/Users/saksh/Desktop/UC Irvine/Quarter1_Summer/Foundations of Business Analytics/Homework1")
data1 = read.table("starbucksdata.txt",header=T, sep="\t")
attach(data1)
data1 
nrow(data1) #finding number of rows in data frame
ncol(data1) #finding number of columns in data frame

#number of missing values (NA values) for each one of the 27 variables
is.missing <- is.na(data1)*1 #Converts, True to 0 and False to 0
is.missing

colSums(is.missing)#shows the total no.of missing values for each variable
sum(is.missing)#total missing values in data1

#remove all rows with missing values
data2 <- na.omit(data1)
data2
nrow(data2) #finding no. of rows with no missing values

#selecting variables 1 to 22
data3 <- data2[,1:22]
data3

#Removing impossible values. Impossible values are any values that less than 1 or values greater than 5
(data3 > 5 | data3 <1) #for finding impossible values
colSums((data3 > 5 | data3 <1)*1) #converts TRUE to 1, FALSE to 0
sum((data3 > 5|data3 < 1)*1) #total number of impossible values across all variables

#calculating impossible values for all 22 variables
for (i in 1:22){
  print(table(data2[,i])) 
}

data3 > 5 # returns TRUE if the values are greater than 5, and FALSE if less 5
data3[data3 > 5] # this extracts all the values in the data that are in fact greater than 5
data3[data3 > 5] <- 5 # this replaces all of the values greater than 5 with 5
data3

data3 < 1 # returns TRUE if the values are greater than 1, and FALSE if greater than 1
data3[data3 < 1] # this extracts all the values in the data that are less than 1
data3[data3 < 1] <- 1 # this replaces all of the values greater than 1 with 1
data3

table(unlist(data3)) #a frequency count and report the total numbers of 1s, 2s, 3s, 4s, and 5s across all 22 variables AFTER replacement

data2[,23][data2[,23]<0] <- 0 #replacing values in satisfaction less than 0 with 0
data2[,23][data2[,23]>100] <- 100 #replacing values in satisfaction greater than 100 with 100

data2[,24][data2[,24]<0] <- 0 #replacing values in recommend less than 0 with 0
data2[,24][data2[,24]>10] <- 10 #replacing values in recommend greater than 10 with 10

#table(data2[,24]) #counting the number of unique values in recommend
counts <- table(data2[,24])
barplot(counts, main="Rating", xlab="Recommendation")

apply(data2,2,mean) #finding the mean for all 22 variables

#Running a regression model using 'profit' as a dependent variable and 'satis100','recommend'
#& 'income' as the three independent variables
reg1 <- lm(profits ~ satisfaction + recommend + Income)
reg1
summary(reg1)

#The R squared statistic is high and the p value is low for each variable, the performed regression analysis does a good job 
#at predicting the average monthly profits of each customer. 
#Here, R2 value = 0.9058, i.e. the model accounts for 90.58% of the variation in Profits that is explained by the three predictor values. 
#The p-value is less than 0.01 for each individual predictor variable which indicates they are very significant in their effect on the Y variable Profit. 
#The p-value is much less than 0.05, we reject the null hypothesis that β = 0. 
#Thus we can conclude that there is a significant relationship between the variables in the linear regression model of the data set.

#Creating dummy variables for satisfaction and running regression again to understand whether failing to meet customers’ expectations has a bigger effect
#on profits than does exceeding customer expectations
fail <- ifelse(satisfaction<20,1,0)
exceed <- ifelse(satisfaction>80,1,0)

reg2 <-lm(profits ~ fail + exceed + recommend + Income)
reg2
summary(reg2)

sum(fail)
sum(exceed)

#As per the second regression analysis, the magnitude of the dummy coefficients are: -14.06 for FAIL and 2.092 for EXCEED
#Thus, we can observe that the impact on profitability made by customers who have a satisfactory rating under 20 (FAIL)
#is higher than the impact of customers rating above 80(HIGH). 
#On the basis of above analysis, we can conclude that the Senior Management can allocate more resources into determining
#the most common causes of a low satisfactory rating and find ways to eliminate their probability in the future in order to maximize profit. 

#Dividing the data into a training and test sample
K <- 5000
N <- nrow(data2)

train <- as.data.frame(data2[1:K,])
test <- as.data.frame(data2[(K+1):N,])
test.Y <- test[,24]
test.X <- test[,c(1:22)]

#Running a multiple regression on the training sample using “recommend” as the dependent variable
#and X1 – X22 as the 22 independent variables
train.reg <- lm(recommend ~ X1 + X2 + X3 + X4 + X5 + X6 + X7 + X8 + X9 + X10 + X11 + X12 
                + X13 + X14 + X15 + X16 + X17 + X18 + X19 + X20 + X21 + X22, data=train)
summary(train.reg)

#17 variables out of the 22 predictor variables are significant at the 5% level (have a p-value less than 0.05).
#The variables which are NOT significant are X6, X11, X17, X18 and X21

#The R2 value is 0.3548 or 35.48%, which is not significant enough. 
#The value of R^2 tells us that model can predict only 35.48% of the data.

#Using trained regression model to predict recommendation responses for test sample
test_2<-test[,1:22]
test_predict1 <- as.vector(predict(object=train.reg, newdata=test_2))
test_predict1

#The out-of-sample R2 value for test sample is 0.2944 which is worse than the training model.
#The difference in R2 values between the training and test samples is 0.0603 or 6.03%

attach(train) #attaching train dataset 

null.model <- lm(recommend ~ 1)
summary(null.model) 

train2<-train[,1:22]

full.model <- lm(recommend ~ ., data = train2)
summary(full.model)

forward.results <- step(object=null.model, direction="forward", scope=formula(full.model))
summary(forward.results)

#After forward selection, the following variables are dropped: X6,X17,X18.
#The R2 of the forward selection model is 0.3543 or 35.43%.
#The R2 of the full model (with all 22 variables) is 0.3547 or 35.47%.
#The R2 went down by 0.0004 or 0.04%. Since the R2 went down only by 0.04%, the dropped variables really don’t matter. 
#Thus we can conclude, even if we include these variables in our calculation, they won’t impact/hamper our calculation by great number.

#creating a matrix for clustering
X = as.matrix(data2[1:22])
X

#using the NbClust procedure to determine the optimal number of segments (clusters) for X
nb <- NbClust(X, distance="euclidean", min.nc=2, max.nc=10, method="kmeans")
fviz_nbclust(nb)

#According to the Majority Rule, the best number of clusters is 2. 
#running a K-means cluster analysis on X matrix.  
#Here, I set the iter.max to 1000. (the number of times the algorithm will repeat the cluster assignment and moving of centroids.)
#I set the nstart to 100 (represents the number of random data sets used to run the algorithm)
cluster.results = kmeans(x = X, centers = 2, iter.max=1000, nstart=100)
cluster.results
cluster.numbers = cluster.results$cluster
cluster.numbers
segment_sizes = table(cluster.numbers)
segment_sizes

#The most satisfied segment with the highest average ratings (the highest cluster
#center values for X1 – X22) is segment/cluster 1 with average rating of 4.043. 
#The cluster 2 has average rating of 3.281 
t(round(cluster.results$centers,2))
mean(cluster.results$centers[1])
mean(cluster.results$centers[2])

#There is an increase of 2.14 (in terms of average predicted “recommend”) by 
#the “Most Satisfied” segment who are likely to recommend Starbucks.
most_satisfied <- data2[cluster.results$cluster==1, ]
most_satisfied
all_other <- data2[cluster.results$cluster==2, ]
all_other

