# Analyzing-Starbucks-Coffee-Customers-Experience-Using-R
I collected data from a Starbucks Coffee Customer survey and conduct some insightful analysis to understand how to improve customer engagement and profitability. 

I first started with cleaning the data. I removed all the rows with null values in it. Then I removed the impossible values from the dataset.
In order to understand to understand how many points the customers have given to Recommendation, i.e how likely they are to recommend Starbucks to other, I created a visualization using bar graph.

REGRESSION ANALYSIS:
I ran a regression model using 'profit' as a dependent variable and 'satisfaction','recommend' & 'income' as the three independent variables.
The R squared statistic is high and the p value is low for each variable, the performed regression analysis does a good job at predicting the average monthly profits of each customer. 
Here, R2 value = 0.9058, i.e. the model accounts for 90.58% of the variation in Profits that is explained by the three predictor values. 
The p-value is less than 0.01 for each individual predictor variable which indicates they are very significant in their effect on the Y variable Profit. 
The p-value is much less than 0.05, we reject the null hypothesis that β = 0. 
Thus, we can conclude that there is a significant relationship between the variables in the linear regression model of the data set.

DUMMY VARIABLE REGRESSION ANALYSIS:
Further, I created dummy variables for satisfaction and again ran a regression model to understand whether failing to meet customers’ expectations has a bigger effect on profits than does exceeding customer expectations. Results of that are included in the code.

MULTIPLE REGRESSION ANALYSIS:
Here, I divided the dataset into test and train dataset. 
Then, I ran a multiple regression on the training sample using "recommend" as the dependent variable and X1 – X22 as the 22 independent variables. This will help determine which are the variables with significant impact on the prediction of "recommend".
From this model we know that the variables X6, X11, X17, X18 and X21 are not significant.
Then I used the trained regression model to predict recommendation responses for test sample.
The R squared value for the training dataset is 0.3548 and that of testing dataset is 0.2944. 

VARIABLE SELECTION USING FORWARD SELECTION:
To improve the accuracy of the prediciton, I did a FORWARD SELECTION on all variables. After forward selection X6,X17,X18 are removed.
The R2 of the forward selection model is 0.3543 or 35.43%. The R2 of the full model (with all 22 variables) is 0.3547 or 35.47%.
The R2 went down by 0.0004 or 0.04%. Since the R2 went down only by 0.04%, the dropped variables really don’t matter. 
Thus we can conclude, even if we include these variables in our calculation, they won’t impact/hamper our calculation by great number.

CLUSTERING USING K-MEANS ANALYSIS:
I used the NbClust procedure to determine the optimal number of segments (clusters). According to the Majority Rule, the best number of clusters is 2. 
Then, I performed K-mean analysis. From this we can determine that the most satisfied segment with the highest average ratings (the highest cluster center values for X1 – X22) is segment/cluster 1 with average rating of 4.043. 

From this analysis we can gather which are the variables which have a higher impact on Starbucks being recommende to other customers. Acting on increasing rating for those variables will improve profitability for the company. Further, using K-means clustering we can segment the customers based on the average ratings. 
