# Claim-Prediction-in-Insurance-Industry #

Predicting Claim frequencies in an Insurance firm

PROJECT OBJECTIVE : 

An Insurance firm providing tour insurance is facing higher claim frequency. The management decides to collect data from the past few years. The task is to make a model which predicts the claim status and provide recommendations to management using CART, RF & ANN and comparing the model's performances in train and test sets.

List of steps involved : 

•	Importing the dataset 
•	Descriptive Statistics and Null value check 
•	Data split into train and test 
•	Building Classification models – CART, Random Forest,  ANN  
•	Evaluating the Performance metrics 
•	Inference 

EXPLORATORY DATA ANALYSIS : 

Insurance dataset contains 3000 observations with 9 predictors and 1 predictand. Claim status is the target variable which is to be predicted. The dataset contains factor, numeric and integer datatypes. No null values are present within the dataset. 

UNIVARIATE ANALYSIS : The nature, distribution and presence of outliers are assessed for each variable through graphs. Refer Business Report for the visualisations.

BIVARIATE ANALYSIS : The predictand is analysed for its pattern with each predictor variables and insights are drawn.

The data split is made in the ratio 70:30 for Train data and Test data. 

MODEL BUILDING :

CART (CLASSIFICATION & REGRESSION TREES) : A decision tree is a supervised learning predictive model that uses a set of binary rules to calculate a target value.  It is used for either classification (categorical target variable) or regression (continuous target variable). 
 
The proportion of “no” and “yes” in the original dataset is 69.2% and 30.8%.For Train data it is 69% and 31%.Likewise for Test data it is 69.7% and 30.3%.The decision tree is generated for the dataset by specifying all the control parameters and at exact cost complexity parameter value, the tree is pruned. 

                                  PRUNED TREE (cp value=0.05) 
                                  
CONFUSION MATRIX :

![image](https://user-images.githubusercontent.com/81927278/185308041-4c2217d1-7552-4f13-9f7e-f1cffd29e61c.png)

![image](https://user-images.githubusercontent.com/81927278/185308138-b75620cb-b3fc-4ca0-8a57-a34c4d194211.png)

![image](https://user-images.githubusercontent.com/81927278/185308770-eaba2c2e-ba53-402c-bdc8-d5d65da8d393.png)

RANDOM FOREST : 

The random forest algorithm works by aggregating the predictions made by multiple decision trees of varying depth. Every decision tree in the forest is trained on a subset of the dataset called the bootstrapped dataset. The portion of samples that were left out during the construction of each decision tree in the forest are referred as Out-Of-Bag (OOB) dataset. 

The proportion of “no” and “yes” in the original dataset is 69.2% and 30.8%.For Train data it is 68.7% and 31.3%.Likewise for Test data it is 70.3% and 29.7%.Random forest model is built on the given Insurance dataset and confusion matrix for Train Test data is generated. The model is fine-tuned by prespecifying the hyper-parameters. 
When the “mtry” value is set between 2-3, the OOB error rate reduces from 22.62% to 21.8%. 

CONFUSION MATRIX : 

![image](https://user-images.githubusercontent.com/81927278/185309709-be095e8d-6787-4166-8de4-c87f4e199111.png)

![image](https://user-images.githubusercontent.com/81927278/185309785-4158676d-5b3b-49bd-a906-0730f9e78422.png)

![image](https://user-images.githubusercontent.com/81927278/185309916-8743c098-73ff-456c-aacd-0e622657f230.png)

ARTIFICIAL NEURAL NETWORKS : 

Artificial neural networks (ANN) is an information passing paradigm that is inspired by the way the biological nervous system such as brain process information. It is composed of large number of highly interconnected processing elements (neurons) working in unison to solve a specific problem. 

For the given Insurance dataset, Artificial neural network model is built to predict the target variable “Claimed”.  
The proportion of “no” and “yes” in the original dataset is 69.2% and 30.8%.For Train data it is 69.4% and 30.6%.Likewise for Test data it is 68.8% and 31.2%.The built ANN model’s hyper-parameters such as learning rate, error function, activation function and number of hidden layers are prespecified. Refer source code.  

The calculated probability scores for the Train data and Test data are assigned appropriately to the binary class “0” and “1”. 

CONFUSION MATRIX :

![image](https://user-images.githubusercontent.com/81927278/185323972-19872783-d380-427f-a8fd-7a4d76d33fba.png)

![image](https://user-images.githubusercontent.com/81927278/185324399-b9f2525f-e410-437b-9c60-291180decaae.png)

![image](https://user-images.githubusercontent.com/81927278/185324849-d1bb7f54-13f0-49da-95ab-918e5074b28b.png)

COMPARISON OF THE BUILT MODELS :

•	The key parameter for the model evaluation is Accuracy. The Accuracy seems to be more or less the same for all the three models. The models have done a decent job of segregating the data points. Lesser the false predictions, more the accuracy. 

•	The Sensitivity is slightly high for a Random Forest model when compared to the CART and ANN models. It is the actual true data points identified by the model as true. 

•	The Specificity for CART and Random Forest is more than the Specificity value of ANN. It is the actual negative data points identified by the model as negative. 

•	The Precision of the CART model is slightly higher, followed by ANN. Random Forest has less Precision value when compared to the other two models. It is the positive data points identified by the model which are really positive. 

•	Now, in comparison to the Confusion Matrix for the three models, the TYPE-1 error for CART model is less when compared to the other models. The TYPE -2 error for the Random Forest model is less than the other two models. 

•	For all the built models the deviations between the Train and Test data is less than 10%.Hence the models are not over-fitted. 

•	The Random Forest has the best performance (best accuracy) among the three models. The percentage deviation between Train and Test data is reasonably under control, suggesting a robust model. 

•	Both CART and ANN has given relatively secondary performance compared to Random Forest. 

•	Overall, Random Forest is the best optimized model because of its best Accuracy percentage and reasonable deviations. 

BUSINESS INSIGHTS & RECOMMENDATIONS : 

•	The Insurance industry is regarded as one of the most competitive and less predictable business spheres. It is instantly related to risk. Its dependency over statistics is predominantly met by the machine learning models. 

•	Though the Insurance company faces higher claims,the provided sample dataset shows the proportion of unclaimed to be more than the proportion of the claimed frequencies.Hence building models on the same makes no difference.Inorder to make better predictions additional observations (data) are needed to be analysed before making any conclusion. 

•	FRAUD DETECTION –The built models for predicting ‘Claim Status’ can be detected for any fraudulent activity, suspicious links, and subtle behavior patterns using sampling method and analyzing them. 

•	PRICE OPTIMIZATION - The algorithms give the insurers the opportunity to adjust the quoted premium dynamically. It helps to increase the customer’s loyalty in long perspective. 

•	RECOMMENDATION ENGINES – The models can be built in such a way that it provides suitable travel offers, choices and preferences to its valuable customers. 

•	Accurate Claim Predictions done by the Machine learning models gives a chance to reduce financial loss for the Insurance Company. 

•	It also contributes to the improvement of the pricing models. This helps the Insurance Company to be one step ahead of its competitors. 

•	Insurance companies need to use comprehensive marketing strategies to attract customers. The automated marketing reaches its peak in this regard. 










