##### CART MODEL ##### setwd("C:/Training") getwd() 
## [1] "C:/Training" 
read.csv("insurance_part2_data (1).csv",header = TRUE)->MYDATA 
##### DESCRIPTIVE STATISTICS ##### 
pacman::p_load(summarytools,randomForest,tidyverse,esquisse,rpart,rpart.plot, MLmetrics,rsample) summarytools::view(dfSummary(MYDATA)) View(MYDATA) str(MYDATA) 
## 'data.frame':    3000 obs. of  10 variables: 
##  $ Age         : int  48 36 39 36 33 45 61 36 36 36 ... 
##  $ Agency_Code : Factor w/ 4 levels "C2B","CWT","EPX",..: 1 3 2 3 4 4 2 3 3 3 ... 
##  $ Type        : Factor w/ 2 levels "Airlines","Travel Agency": 1 2 2 2 1 
1 2 2 2 2 ... 
##  $ Claimed     : Factor w/ 2 levels "No","Yes": 1 1 1 1 1 2 1 1 1 1 ... 

##  $ Commision   : num  0.7 0 5.94 0 6.3 ... 
##  $ Channel     : Factor w/ 2 levels "Offline","Online": 2 2 2 2 2 2 2 2 2 2 ... 
##  $ Duration    : int  7 34 3 4 53 8 30 16 19 42 ... 
##  $ Sales       : num  2.51 20 9.9 26 18 45 59.4 80 14 43 ... 
##  $ Product.Name: Factor w/ 5 levels "Bronze Plan",..: 3 3 3 2 1 1 3 2 2 2 ... 
##  $ Destination : Factor w/ 3 levels "Americas","ASIA",..: 2 2 1 2 2 2 1 2 
2 2 ... 
attach(MYDATA) summary(MYDATA) 
##       Age        Agency_Code            Type      Claimed      Commision     
##  Min.   : 8.00   C2B: 924    Airlines     :1163   No :2076   Min.   :  0.0 0   
##  1st Qu.:32.00   CWT: 472    Travel Agency:1837   Yes: 924   1st Qu.:  0.0 0   
##  Median :36.00   EPX:1365                                    Median :  4.6
3   
##  Mean   :38.09   JZI: 239                                    Mean   : 14.5 3   
##  3rd Qu.:42.00                                               3rd Qu.: 17.2 3   
##  Max.   :84.00                                               Max.   :210.2
1   
##     Channel        Duration          Sales                   Product.Name  
##  Offline:  46   Min.   :  -1.0   Min.   :  0.00   Bronze Plan      : 650   
##  Online :2954   1st Qu.:  11.0   1st Qu.: 20.00   Cancellation Plan: 678   
##                 Median :  26.5   Median : 33.00   Customised Plan  :1136   
##                 Mean   :  70.0   Mean   : 60.25   Gold Plan        : 109   
##                 3rd Qu.:  63.0   3rd Qu.: 69.00   Silver Plan      : 427   
##                 Max.   :4580.0   Max.   :539.00                            
##    Destination   
##  Americas: 320   
##  ASIA    :2465   
##  EUROPE  : 215   
##                  
##                  

##  
anyNA(MYDATA) 
## [1] FALSE 
funModeling::plot_num(MYDATA) 
###### SPLITTING THE DATASET INTO TEST AND TRAIN DATA  
SPLIT_DATA=initial_split(MYDATA,prop = 0.7) 
TRAIN=training(SPLIT_DATA) TEST=testing(SPLIT_DATA) table(MYDATA$Claimed) 
##  
##   No  Yes  
## 2076  924 
table(TRAIN$Claimed) 
##  
##   No  Yes  
## 1458  642 
table(TEST$Claimed) 
##  
##  No Yes  
## 618 282 
prop.table(table(MYDATA$Claimed)) 
##  
##    No   Yes  
## 0.692 0.308 
prop.table(table(TRAIN$Claimed)) 
##  
##        No       Yes  
## 0.6942857 0.3057143 
prop.table(table(TEST$Claimed)) 
##  
##        No       Yes  
## 0.6866667 0.3133333 
### THE PROPORTION OF "YES" & "NO" IN TRAIN,TEST,ORIGINAL DATASET ARE MORE OR LESS SAME 

##### SETTING UP THE CONTROL PARAMETERS ##### CONTROL_PARAMETER=rpart.control(minsplit = 25,                         minbucket = 10,                         cp=0,                         xval = 5) 
 
##### BUILDING THE CART MODEL ##### CART_MODEL=rpart(Claimed~.,                  data=TRAIN,                  method = "class",                  control = CONTROL_PARAMETER) print(CART_MODEL) 
## n= 2100  
##  
## node), split, n, loss, yval, (yprob) 
##       * denotes terminal node 
##  
##     1) root 2100 642 No (0.69428571 0.30571429)   
##       2) Agency_Code=CWT,EPX,JZI 1455 251 No (0.82749141 0.17250859)   
##         4) Sales< 28.5 675  52 No (0.92296296 0.07703704) * 
##         5) Sales>=28.5 780 199 No (0.74487179 0.25512821)   
##          10) Commision< 80.19 753 178 No (0.76361222 0.23638778)   
##            20) Product.Name=Bronze Plan,Cancellation Plan,Silver Plan 246  
28 No (0.88617886 0.11382114) * 
##            21) Product.Name=Customised Plan,Gold Plan 507 150 No (0.704142 01 0.29585799)   
##              42) Product.Name=Customised Plan 491 140 No (0.71486762 0.285
13238)   
##                84) Age>=64.5 14   0 No (1.00000000 0.00000000) * 
##                85) Age< 64.5 477 140 No (0.70649895 0.29350105)   
##                 170) Age>=30.5 408 112 No (0.72549020 0.27450980)   
##                   340) Sales< 38.5 104  19 No (0.81730769 0.18269231) * 
##                   341) Sales>=38.5 304  93 No (0.69407895 0.30592105)   
##                     682) Duration< 34.5 162  42 No (0.74074074 0.25925926)  

##                      1364) Commision< 56.43 152  36 No (0.76315789 0.23684
211) * 
##                      1365) Commision>=56.43 10   4 Yes (0.40000000 0.60000 000) * 
##                     683) Duration>=34.5 142  51 No (0.64084507 0.35915493)  
##                      1366) Destination=Americas,ASIA 104  32 No (0.6923076 9 0.30769231)   
##                        2732) Commision>=50.49 13   1 No (0.92307692 0.0769 2308) * 
##                        2733) Commision< 50.49 91  31 No (0.65934066 0.3406
5934)   
##                          5466) Age< 49.5 81  25 No (0.69135802 0.30864198)  
##                           10932) Sales>=58.7 43   9 No (0.79069767 0.20930 233) * 
##                           10933) Sales< 58.7 38  16 No (0.57894737 0.42105 263)   
##                             21866) Duration< 59.5 15   4 No (0.73333333 0.
26666667) * 
##                             21867) Duration>=59.5 23  11 Yes (0.47826087 0 .52173913) * 
##                          5467) Age>=49.5 10   4 Yes (0.40000000 0.60000000 ) * 
##                      1367) Destination=EUROPE 38  19 No (0.50000000 0.5000
0000)   
##                        2734) Duration< 65 22   9 No (0.59090909 0.40909091 ) * 
##                        2735) Duration>=65 16   6 Yes (0.37500000 0.6250000 0) * 
##                 171) Age< 30.5 69  28 No (0.59420290 0.40579710)   
##                   342) Commision>=38.61 11   2 No (0.81818182 0.18181818) * 
##                   343) Commision< 38.61 58  26 No (0.55172414 0.44827586)   
##                     686) Sales< 96.5 47  19 No (0.59574468 0.40425532)   
##                      1372) Age>=25.5 33  11 No (0.66666667 0.33333333) * 
##                      1373) Age< 25.5 14   6 Yes (0.42857143 0.57142857) * 
##                     687) Sales>=96.5 11   4 Yes (0.36363636 0.63636364) * 
##              43) Product.Name=Gold Plan 16   6 Yes (0.37500000 0.62500000) * 
##          11) Commision>=80.19 27   6 Yes (0.22222222 0.77777778) * 
##       3) Agency_Code=C2B 645 254 Yes (0.39379845 0.60620155)   

##         6) Sales< 33 249 104 No (0.58232932 0.41767068)   
##          12) Sales< 15.5 73  14 No (0.80821918 0.19178082)   
##            24) Sales< 6.625 24   0 No (1.00000000 0.00000000) * 
##            25) Sales>=6.625 49  14 No (0.71428571 0.28571429)   
##              50) Commision>=3.775 20   1 No (0.95000000 0.05000000) * 
##              51) Commision< 3.775 29  13 No (0.55172414 0.44827586)   
##               102) Age>=46 15   5 No (0.66666667 0.33333333) * 
##               103) Age< 46 14   6 Yes (0.42857143 0.57142857) * 
##          13) Sales>=15.5 176  86 Yes (0.48863636 0.51136364)   
##            26) Sales>=29.7 21   2 No (0.90476190 0.09523810) * 
##            27) Sales< 29.7 155  67 Yes (0.43225806 0.56774194)   
##              54) Duration>=53 11   3 No (0.72727273 0.27272727) * 
##              55) Duration< 53 144  59 Yes (0.40972222 0.59027778)   
##               110) Duration< 23.5 124  56 Yes (0.45161290 0.54838710)   
##                 220) Age< 25.5 18   6 No (0.66666667 0.33333333) * 
##                 221) Age>=25.5 106  44 Yes (0.41509434 0.58490566)   
##                   442) Sales< 16.5 15   5 No (0.66666667 0.33333333) * 
##                   443) Sales>=16.5 91  34 Yes (0.37362637 0.62637363)   
##                     886) Age>=30.5 63  27 Yes (0.42857143 0.57142857)   
##                      1772) Sales< 21.175 26  12 No (0.53846154 0.46153846)  
##                        3544) Commision>=4.9 14   4 No (0.71428571 0.285714 29) * 
##                        3545) Commision< 4.9 12   4 Yes (0.33333333 0.66666
667) * 
##                      1773) Sales>=21.175 37  13 Yes (0.35135135 0.64864865 ) * 
##                     887) Age< 30.5 28   7 Yes (0.25000000 0.75000000) * 
##               111) Duration>=23.5 20   3 Yes (0.15000000 0.85000000) * 
##         7) Sales>=33 396 109 Yes (0.27525253 0.72474747)   
##          14) Duration< 11.5 29   8 No (0.72413793 0.27586207) * 
##          15) Duration>=11.5 367  88 Yes (0.23978202 0.76021798)   
##            30) Commision< 53.165 234  67 Yes (0.28632479 0.71367521)   
##              60) Product.Name=Customised Plan,Gold Plan 18   9 No (0.50000 000 0.50000000) * 
##              61) Product.Name=Bronze Plan,Silver Plan 216  58 Yes (0.26851
852 0.73148148)   

##               122) Duration>=370 11   5 No (0.54545455 0.45454545) * 
##               123) Duration< 370 205  52 Yes (0.25365854 0.74634146)   
##                 246) Duration< 23.5 72  23 Yes (0.31944444 0.68055556)   
##                   492) Sales< 44.4 17   7 No (0.58823529 0.41176471) * 
##                   493) Sales>=44.4 55  13 Yes (0.23636364 0.76363636) * 
##                 247) Duration>=23.5 133  29 Yes (0.21804511 0.78195489)   
##                   494) Commision>=8.865 116  28 Yes (0.24137931 0.75862069 )   
##                     988) Age< 26.5 25   9 Yes (0.36000000 0.64000000) * 
##                     989) Age>=26.5 91  19 Yes (0.20879121 0.79120879)   
##                      1978) Age>=55 14   5 Yes (0.35714286 0.64285714) * 
##                      1979) Age< 55 77  14 Yes (0.18181818 0.81818182)   
##                        3958) Duration< 51 40  11 Yes (0.27500000 0.7250000 0)   
##                          7916) Duration>=27.5 29  11 Yes (0.37931034 0.620 68966)   
##                           15832) Age< 35.5 17   8 No (0.52941176 0.4705882
4) * 
##                           15833) Age>=35.5 12   2 Yes (0.16666667 0.833333 33) * 
##                          7917) Duration< 27.5 11   0 Yes (0.00000000 1.000 00000) * 
##                        3959) Duration>=51 37   3 Yes (0.08108108 0.9189189
2) * 
##                   495) Commision< 8.865 17   1 Yes (0.05882353 0.94117647) * 
##            31) Commision>=53.165 133  21 Yes (0.15789474 0.84210526) * 
par(xpd=NA) rpart.plot(CART_MODEL) 
  
 
printcp(CART_MODEL) 
##  
## Classification tree: 
## rpart(formula = Claimed ~ ., data = TRAIN, method = "class",  
##     control = CONTROL_PARAMETER) 
##  
## Variables actually used in tree construction: 
## [1] Age          Agency_Code  Commision    Destination  Duration     
## [6] Product.Name Sales        
##  
## Root node error: 642/2100 = 0.30571 
##  
## n= 2100  
##  
##            CP nsplit rel error  xerror     xstd 
## 1  0.21339564      0   1.00000 1.00000 0.032885 
## 2  0.06386293      1   0.78660 0.78660 0.030506 
## 3  0.02024922      2   0.72274 0.75389 0.030061 
## 4  0.01635514      3   0.70249 0.73053 0.029728 
## 5  0.01168224      5   0.66978 0.72586 0.029660 
## 6  0.00778816      7   0.64642 0.70249 0.029313 
## 7  0.00467290      8   0.63863 0.68069 0.028976 
## 8  0.00311526     11   0.62150 0.71184 0.029453 
## 9  0.00155763     16   0.60592 0.73053 0.029728 
## 10 0.00124611     28   0.58567 0.73832 0.029840 
## 11 0.00103842     33   0.57944 0.73832 0.029840 
## 12 0.00077882     36   0.57632 0.73676 0.029818 
## 13 0.00025961     38   0.57477 0.73676 0.029818 
## 14 0.00000000     44   0.57321 0.74766 0.029973 
plotcp(CART_MODEL) 
##### PRUNING THE TREE WITH THE OPTIMAL CP VALUE 
PTREE=prune(CART_MODEL, cp=0.005) plot(PTREE,uniform = TRUE) text(PTREE,use.n = TRUE, all=TRUE,cex=0.4,xpd=TRUE) 
printcp(PTREE) 
##  
## Classification tree: 
## rpart(formula = Claimed ~ ., data = TRAIN, method = "class",  
##     control = CONTROL_PARAMETER) 
##  
## Variables actually used in tree construction: 
## [1] Agency_Code Commision   Duration    Sales       
##  
## Root node error: 642/2100 = 0.30571 
##  
## n= 2100  
##  
##          CP nsplit rel error  xerror     xstd 
## 1 0.2133956      0   1.00000 1.00000 0.032885 
## 2 0.0638629      1   0.78660 0.78660 0.030506 
## 3 0.0202492      2   0.72274 0.75389 0.030061 
## 4 0.0163551      3   0.70249 0.73053 0.029728 

## 5 0.0116822      5   0.66978 0.72586 0.029660 
## 6 0.0077882      7   0.64642 0.70249 0.029313 
## 7 0.0050000      8   0.63863 0.68069 0.028976 
##### ATTACHING THE PREDICTION CLASS TO THE ORIGINAL DATASET 
TRAIN$predict.class<-predict(PTREE,TRAIN,type = "class") 
TRAIN$predict.class 
View(TRAIN) 
##### EXTRACTING THE PROBABILITY SCORES predict(PTREE,TRAIN) 
##### HANDLING TEST DATA 
TEST$predict.class<-predict(PTREE,TEST,type = "class") 
TEST$predict.scores<-predict(PTREE,TEST)[,2] 
View(TEST) 
##### PERFORMANCE MEASURE METRICS 
##### RECEIVER OPERATION CHARACTERISTICS CURVE 
library(ROCR) 
##### USING PREDICTION AND PERFORMANCE FUNCTION 
##### TRAIN DATA pred<-prediction(TRAIN$predict.scores,TRAIN$Claimed) perf<-performance(pred,"tpr","fpr") plot(perf) 
 
##### TEST DATA pred1<-prediction(TEST$predict.scores,TEST$Claimed) perf1<-performance(pred1,"tpr","fpr") plot(perf1) 
 
 
 
##### CONFUSION MATRIX FOR TRAIN DATA 
MLmetrics::ConfusionMatrix(TRAIN$predict.class,TRAIN$Claimed) 
##       y_pred 
## y_true   No  Yes 
##    No  1305  153 
##    Yes  257  385 
MLmetrics::Accuracy(TRAIN$predict.class,TRAIN$Claimed) 
## [1] 0.8047 
619 
MLmetrics::Sensitivity(TRAIN$predict.class,TRAIN$Claimed) 
## [1] 0.8354673 
MLmetrics::Specificity(TRAIN$predict.class,TRAIN$Claimed) 
## [1] 0.7156134 
MLmetrics::Precision(TRAIN$predict.class,TRAIN$Claimed) 
## [1] 0.8950617 
##### CONFUSION MATRIX FOR TEST DATA 
MLmetrics::ConfusionMatrix(TEST$predict.class,TEST$Claimed) 
##       y_pred 
## y_true  No Yes 
##    No  531  87 
##    Yes 123 159 
MLmetrics::Accuracy(TEST$predict.class,TEST$Claimed) 
## [1] 0.7666667 
MLmetrics::Sensitivity(TEST$predict.class,TEST$Claimed) 
## [1] 0.8119266 
MLmetrics::Specificity(TEST$predict.class,TEST$Claimed) 
## [1] 0.6463415 
MLmetrics::Precision(TEST$predict.class,TEST$Claimed) 
## [1] 0.8592233 
 	  
5.4 RANDOM FOREST  
##### RANDOM FOREST ##### setwd("C:/Training") 
read.csv("insurance_part2_data (1).csv",header=TRUE)->MYDATA pacman::p_load(summarytools,randomForest,tidyverse,esquisse,rpart,rpar
t.plot,MLmetrics,rsample)  summarytools::view(dfSummary(MYDATA))   
## Output file written: C:\Users\sachi\AppData\Local\Temp\RtmpM3H6dG\file4bdc
7fff4402.html 
###### SPLITTING THE DATASET INTO TEST AND TRAIN DATA  
SPLIT_DATA=initial_split(MYDATA,prop = 0.7) 
TRAIN=training(SPLIT_DATA) TEST=testing(SPLIT_DATA) table(MYDATA$Claimed) 
##  
##   No  Yes  
## 2076  924 
table(TRAIN$Claimed) 
##  
##   No  Yes  
## 1443  657 
table(TEST$Claimed) 
##  
##  No Yes  
## 633 267 
prop.table(table(MYDATA$Claimed)) 
##  
##    No   Yes  
## 0.692 0.308 
prop.table(table(TRAIN$Claimed)) 
##  
##        No       Yes  
## 0.6871429 0.3128571 
prop.table(table(TEST$Claimed)) 
##  

##        No       Yes  
## 0.7033333 0.2966667 
RF_MODEL<-randomForest(as.factor(Claimed)~.,data=TRAIN,                       importance=TRUE) print(RF_MODEL) 
##  
## Call: 
##  randomForest(formula = as.factor(Claimed) ~ ., data = TRAIN,      importa nce = TRUE)  
##                Type of random forest: classification 
##                      Number of trees: 500 
## No. of variables tried at each split: 3 
##  
##         OOB estimate of  error rate: 22.62% 
## Confusion matrix: 
##       No Yes class.error 
## No  1225 218   0.1510742 
## Yes  257 400   0.3911720 
### OOB ERROR = 22.62% ; ACCURACY = 100-OOB ERROR =77.38% plot(RF_MODEL) 
RF_MODEL$err.rate 
##### HANDLING TEST DATA 
TEST$predict.class<-predict(PTREE,TEST,type = "class") 
TEST$predict.scores<-predict(PTREE,TEST)[,2] 
View(TEST) 
##### PERFORMANCE MEASURE METRICS 
##### RECEIVER OPERATION CHARACTERISTICS CURVE 
library(ROCR) 
##### USING PREDICTION AND PERFORMANCE FUNCTION 
##### TRAIN DATA pred<-prediction(TRAIN$predict.scores,TRAIN$Claimed) perf<-performance(pred,"tpr","fpr") plot(perf) 
 
##### TEST DATA pred1<-prediction(TEST$predict.scores,TEST$Claimed) perf1<-performance(pred1,"tpr","fpr") plot(perf1) 
 
 
 
##### CONFUSION MATRIX FOR TRAIN DATA 
MLmetrics::ConfusionMatrix(TRAIN$predict.class,TRAIN$Claimed) 
##       y_pred 
## y_true   No  Yes 
##    No  1305  153 
##    Yes  257  385 
MLmetrics::Accuracy(TRAIN$predict.class,TRAIN$Claimed) 
## [1] 0.8047 
619 
MLmetrics::Sensitivity(TRAIN$predict.class,TRAIN$Claimed) 
## [1] 0.8354673 
MLmetrics::Specificity(TRAIN$predict.class,TRAIN$Claimed) 
## [1] 0.7156134 
MLmetrics::Precision(TRAIN$predict.class,TRAIN$Claimed) 
## [1] 0.8950617 
##### CONFUSION MATRIX FOR TEST DATA 
MLmetrics::ConfusionMatrix(TEST$predict.class,TEST$Claimed) 
##       y_pred 
## y_true  No Yes 
##    No  531  87 
##    Yes 123 159 
MLmetrics::Accuracy(TEST$predict.class,TEST$Claimed) 
## [1] 0.7666667 
MLmetrics::Sensitivity(TEST$predict.class,TEST$Claimed) 
## [1] 0.8119266 
MLmetrics::Specificity(TEST$predict.class,TEST$Claimed) 
## [1] 0.6463415 
MLmetrics::Precision(TEST$predict.class,TEST$Claimed) 
## [1] 0.8592233 
 	  
importance(RF_MODEL) 
##                     No       Yes MeanDecreaseAccuracy MeanDecreaseGini 
## Age          10.522464 -5.632904             5.306007        98.568045 
## Agency_Code   6.835430 36.545512            30.546016        98.356369 
## Type         -1.900668 11.353716             9.821417        21.809693 
## Commision     8.535920 22.475481            24.782754        89.019416 
## Channel       9.493906  8.832065            12.512159         5.252134 
## Duration     -1.319818 21.064565            19.366677       131.975847 
## Sales        -1.950062 30.096744            30.894708       123.120574 
## Product.Name  9.775998 25.471427            32.253180        79.249667 
## Destination   4.209798 -0.134155             4.367368        17.112653 
#SALES,PRODUCTNAME,AGENCYCODE,COMMISSION,CHANNEL,TYPE ARE IMPORTANT VARIABLES IN OUR ANALYSIS 
# AGE,DESTINATION INCREASES THE MODEL ERROR RATE AND CAN BE DROPPED ON INTERE ST 
##### FINE TUNING THE MODEL 
##### USING FOR LOOP TO FIND THE OPTIMUM MTRY VALUE a=c() for(i in 2:10){ 
  model<-randomForest(Claimed~.,data = TRAIN,ntree=500,mtry=i,importance=TRUE
)    prevalid<-predict(model,MYDATA,type="class") 
    a[i-1]=mean(prevalid==MYDATA$Claimed) 
   } a 
## [1] 0.8216667 0.8730000 0.9096667 0.9246667 0.9300000 0.9273333 0.9290000 
## [8] 0.9276667 0.9273333 
plot(2:10,a) 
 
 
set.seed(123) 
TUNED_MODEL<-tuneRF(x=TRAIN[,-4],                    y=as.factor(TRAIN$Claimed),                    mtryStart = 3,### no of variables to start with                    ntreeTry = 300,### no of times to split                    stepFactor = 1.6,### no of steps                    improve = 0.05,                    trace = TRUE,                    plot = TRUE,                    doBest = TRUE,### pitching of graph                    nodesize=10,                    importance=TRUE)## to see all the important values 
## mtry = 3  OOB error = 21.9%  ## Searching left ... 
## mtry = 2     OOB error = 21.86%  
## 0.002173913 0.05  ## Searching right ... 
## mtry = 4     OOB error = 23.24%  
## -0.06086957 0.05 
varImpPlot(TUNED_MODEL)
TRAIN$predict.class<-predict(TUNED_MODEL,TRAIN,type = 
	 	"class")  
	TRAIN$predict.score<-predict(TUNED_MODEL,TRAIN,type = 	"prob"	)[,	2]  
				
View(TRAIN)  
TEST$predict.class<-predict(TUNED_MODEL,TEST,type = "class")  
TEST$predict.score<-predict(TUNED_MODEL,TEST,type = 	"prob"	)[,
2]  
View(TEST)  
##### PERFORMANCE METRIC MEASURES  
(ROCR)
library   
##### TRAIN DATA 
predicto<-prediction(TRAIN$predict.score,TRAIN$Claimed) 

	perf<-performance(predicto,	"tpr","fpr") 
		
plot(perf)   
 predicto1<-prediction(TEST$predict.score,TEST$Claimed)
##### TEST DATA 
 perfo<-performance(predicto1,
"tpr","fpr") 
 plot(perfo)

 
##### CONFUSION MATRIX 
MLmetrics::ConfusionMatrix(TRAIN$predict.class,TRAIN$Claimed) 
##       y_pred 
## y_true   No  Yes 
##    No  1261  182 
##    Yes  210  447 
MLmetrics::Accuracy(TRAIN$predict.class,TRAIN$Claimed) 
## [1] 0.8133333 
MLmetrics::Sensitivity(TRAIN$predict.class,TRAIN$Claimed) 
## [1] 0.85724 
MLmetrics::Specificity(TRAIN$predict.class,TRAIN$Claimed) 
## [1] 0.7106518 
MLmetrics::Precision(TRAIN$predict.class,TRAIN$Claimed) 
## [1] 0.8738739 
MLmetrics::ConfusionMatrix(TEST$predict.class,TEST$Claimed) 
##y_pred 
 
## y_true  No Yes 
##    No  554  79 
##    Yes 102 165 
MLmetrics::Accuracy(TEST$predict.class,TEST$Claimed) 
## [1] 0.7988889 
MLmetrics::Sensitivity(TEST$predict.class,TEST$Claimed) 
## [1] 0.8445122 
MLmetrics::Specificity(TEST$predict.class,TEST$Claimed) 
## [1] 0.6762295 
MLmetrics::Precision(TEST$predict.class,TEST$Claimed) 
## [1] 0.8751975 
importance_variable=round(randomForest::importance(TUNED_MODEL),2) importance_variable[order(importance_variable[,3],decreasing=TRUE),] 
##                 No   Yes MeanDecreaseAccuracy MeanDecreaseGini 
## Product.Name 10.07 21.14                27.80            67.26 
## Agency_Code   8.01 31.76                27.72            81.11 
## Sales         2.00 23.35                26.70            67.88 
## Commision     7.94 20.56                23.21            58.74 
## Duration      0.43 14.75                15.44            57.20 
## Channel      12.14  9.05                14.69             4.23 
## Type         -1.21 12.76                11.33            22.18 
## Destination   5.12  3.27                 8.59             9.75 
## Age           9.20 -3.58                 5.44            38.13 
##### ARTIFICIAL NEURAL NETWORKS ##### setwd("C:/Training") getwd() 
## [1] "C:/Training" 
read.csv("insurance_part2_data (1).csv",header = TRUE)->MYDATA 
pacman::p_load(summarytools,esquisse,tidyverse,dummies,funModeling,scales,rsa mple,neuralnet,MLmetrics,InformationValue,NeuralNetTools) funModeling::plot_num(MYDATA funModeling::cross_plot(data = MYDATA,target = "Claimed") funModeling::correlation_table(MYDATA,"Claimed") 
##    Variable Claimed 
5.5 ANN 

## 1   Claimed    1.00 
## 2     Sales    0.35 
## 3 Commision    0.30 
## 4  Duration    0.21 
## 5       Age   -0.03 
DUMMYDATA=dummy.data.frame(MYDATA[,-4]) glimpse(DUMMYDATA) 
## Observations: 3,000 
## Variables: 20 
## $ Age                             <int> 48, 36, 39, 36, 33, 45, 61, 36, 36 ,... 
## $ Agency_CodeC2B                  <int> 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1 ,... 
## $ Agency_CodeCWT                  <int> 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0 ,... 
## $ Agency_CodeEPX                  <int> 0, 1, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0
,... 
## $ Agency_CodeJZI                  <int> 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0 ,... 
## $ TypeAirlines                    <int> 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1 ,... 
## $ `TypeTravel Agency`             <int> 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0
,... 
## $ Commision                       <dbl> 0.70, 0.00, 5.94, 0.00, 6.30, 15.7 5... 
## $ ChannelOffline                  <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,... 
## $ ChannelOnline                   <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ,... 
## $ Duration                        <int> 7, 34, 3, 4, 53, 8, 30, 16, 19, 42
,... 
## $ Sales                           <dbl> 2.51, 20.00, 9.90, 26.00, 18.00, 4 5... 
## $ `Product.NameBronze Plan`       <int> 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0
,... 
## $ `Product.NameCancellation Plan` <int> 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0 ,... 
## $ `Product.NameCustomised Plan`   <int> 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0
,... 

## $ `Product.NameGold Plan`         <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
,... 
## $ `Product.NameSilver Plan`       <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1 ,... 
## $ DestinationAmericas             <int> 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0 ,... 
## $ DestinationASIA                 <int> 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1 ,... 
## $ DestinationEUROPE               <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
,... 
names(DUMMYDATA)=str_replace_all(names(DUMMYDATA),c(" " = "-" , "&" = "and" , 
"-" = "_")) str(DUMMYDATA) 
SCALED_DATA=scale(DUMMYDATA) 
head(SCALED_DATA)
TARGET= MYDATA %>%   select(Claimed) %>%   mutate(Claimed= case_when(     Claimed == 'No' ~ '0', 
    TRUE ~ '1' 
  )) 
NEWDATA=cbind(TARGET,SCALED_DATA) summarytools::view(dfSummary(NEWDATA)) 
NEWDATA$Claimed=as.factor(NEWDATA$Claimed) 
##### SPLITTING THE DATASET INTO TRAIN AND TEST DATA 
SPLIT_DATA= initial_split(NEWDATA,prop=0.7) 
TRAIN=training(SPLIT_DATA) TEST=testing(SPLIT_DATA) table(NEWDATA$Claimed) 
NEWDATA$Claimed=as.factor(NEWDATA$Claimed) 
##    0    1  
## 2076  924 
table(TRAIN$Claimed) 
##  
##    0    1  
## 1457  643 
table(TEST$Claimed) 
##  
##   0   1  
## 619 281 
prop.table(table(NEWDATA$Claimed)) 
##  
##     0     1  
## 0.692 0.308 
prop.table(table(TRAIN$Claimed)) 
##  
##         0         1  
## 0.6938095 0.3061905 
prop.table(table(TEST$Claimed)) 
##  
##         0         1  
## 0.6877778 0.3122222 
### THE PROPORTION OF "YES" & "NO" IN TRAIN,TEST,ORIGINAL DATASET ARE MORE OR LESS SAME 
names(TRAIN) 
##  [1] "Claimed"                       "Age"                           
##  [3] "Agency_CodeC2B"                "Agency_CodeCWT"                
##  [5] "Agency_CodeEPX"                "Agency_CodeJZI"                
##  [7] "TypeAirlines"                  "TypeTravel_Agency"             
##  [9] "Commision"                     "ChannelOffline"                
## [11] "ChannelOnline"                 "Duration"                      
## [13] "Sales"                         "Product.NameBronze_Plan"       
## [15] "Product.NameCancellation_Plan" "Product.NameCustomised_Plan"   
## [17] "Product.NameGold_Plan"         "Product.NameSilver_Plan"       

## [19] "DestinationAmericas"           "DestinationASIA"               
## [21] "DestinationEUROPE" 
NEURALNET_MODEL=neuralnet(Claimed~.,              data=TRAIN,              hidden = c(4,3),              threshold = c(0.1,0.5),              lifesign = "full",              lifesign.step = 100,              err.fct = "sse",              linear.output = FALSE,              act.fct = "logistic") 
TARGET= MYDATA %>%   select(Claimed) %>%   mutate(Claimed= case_when(     Claimed == 'No' ~ '0', 
    TRUE ~ '1' 
  )) 
NEWDATA=cbind(TARGET,SCALED_DATA) summarytools::view(dfSummary(NEWDATA)) 
## Switching method to 'browser' 
## Output file written: C:\Users\sachi\AppData\Local\Temp\RtmpYzlf8N\file54e4
print(NEURALNET_MODEL) 
## $covariate
##### MODEL EVALUATION FOR TRAIN DATA TRAIN$prob=NEURALNET_MODEL$net.result[[1]] hist(TRAIN$prob, breaks = 4) 
 
TRAIN$CLASS=ifelse(TRAIN$prob[,1]>0.5,0,1) TRAIN$CLASS=as.factor(TRAIN$CLASS) summarytools::view(dfSummary(TRAIN)) 
## Switching method to 'browser' 
## Output file written: C:\Users\sachi\AppData\Local\Temp\RtmpYzlf8N\file54e4 ff66512.html 
##### MODEL EVALUATION FOR TEST DATA 
PREDICTED_PROB=compute(NEURALNET_MODEL,TEST) TEST$prob=PREDICTED_PROB$net.result hist(TEST$prob, breaks = 4) 
 
TEST$CLASS=ifelse(TEST$prob[,1]>0.5,0,1) TEST$CLASS=as.factor(TEST$CLASS) summarytools::view(dfSummary(TEST)) 
## Output file written: C:\Users\sachi\AppData\Local\Temp\RtmpYzlf8N\file54e4 201b10a.html 
##### PERFORMANCE METRIC MEASURES FOR TRAIN DATA 
MLmetrics::ConfusionMatrix(TRAIN$CLASS,TRAIN$Claimed) 
##       y_pred 
## y_true    0    1 
##      0 1286  171 
##      1  249  394 
MLmetrics::Accuracy(TRAIN$CLASS,TRAIN$Claimed) 
## [1] 0.8 

MLmetrics::Sensitivity(TRAIN$CLASS,TRAIN$Claimed) 
## [1] 0.837785 
MLmetrics::Specificity(TRAIN$CLASS,TRAIN$Claimed) 
## [1] 0.6973451 
MLmetrics::Precision(TRAIN$CLASS,TRAIN$Claimed) 
## [1] 0.8826356 
##### PERFORMANCE METRIC MEASURES FOR TEST DATA 
MLmetrics::ConfusionMatrix(TEST$CLASS,TEST$Claimed) 
##       y_pred 
## y_true   0   1 ##      0 526  93 
##    
   1 122 159 
MLmetrics::Accuracy(TEST$CLASS,TEST$Claimed) 
## [1] 0.7611111 
MLmetrics::Sensitivity(TEST$CLASS,TEST$Claimed) 
## [1] 0.8117284 
MLmetrics::Specificity(TEST$CLASS,TEST$Claimed) 
## [1] 0.6309524 
MLmetrics::Precision(TEST$CLASS,TEST$Claimed) 
## [1] 0.8497577 
library(caret) 
confusionMatrix(table(TRAIN$CLASS,TRAIN$Claimed),positive ="1",mode = "everyt hing") 
## Confusion Matrix and Statistics 
##  
##     
##        
 0    1 
##   0 1286  249 
##   1  171  394 
##                                            
##                Accuracy : 0.8              
##                  95% CI : (0.7822, 0.8169) 

##     No Information Rate : 0.6938           
##     P-Value [Acc > NIR] : < 2.2e-16        
##                                            
##                   Kappa : 0.5128           
##                                            
##  Mcnemar's Test P-Value : 0.0001718        
##                                            
##             Sensitivity : 0.6128           
##             Specificity : 0.8826           
##          Pos Pred Value : 0.6973           
##          Neg Pred Value : 0.8378           
##               Precision : 0.6973           
##                  Recall : 0.6128           
##                      F1 : 0.6523           
##              Prevalence : 0.3062           
##          Detection Rate : 0.1876           
##    Detection Prevalence : 0.2690           
##       Balanced Accuracy : 0.7477           
##                                            ##        'Positive' Class : 1                
##  
confusionMatrix(table(TEST$CLASS,TEST$Claimed),positive ="1",mode = "everythi ng") 
## Confusion Matrix and Statistics  
##       0   1 
##   0 526 122 
##   1  93 159 
##                Accuracy : 0.7611           
##                  95% CI : (0.7319, 0.7886) 
##     No Information Rate : 0.6878           
##     P-Value [Acc > NIR] : 7.058e-07        
##                                            
##                   Kappa : 0.4276           
##                                            
##  Mcnemar's Test P-Value : 0.05619          
##                                            
##             Sensitivity : 0.5658           
##             Specificity : 0.8498           
##          Pos Pred Value : 0.6310           
##          Neg Pred Value : 0.8117           
##               Precision : 0.6310           
##                  Recall : 0.5658           
##                      F1 : 0.5966           
##              Prevalence : 0.3122           ##          Detection Rate : 0.1767           
##   
  Detection Prevalence : 0.2800           
##       Balanced Accuracy : 0.7078           
##                                            
##        'Positive' Class : 1                
##  
 


