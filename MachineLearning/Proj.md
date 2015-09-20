# Machine Learning Course Project
Dale Cox  
##Introduction 
For the Machine Learning Course Project we had to predict what class of activity the data represented from the Human Activity Recognition dataset. 

##Dataset Source 

Ugulino, W.; Cardador, D.; Vega, K.; Velloso, E.; Milidiu, R.; Fuks, H. Wearable Computing: Accelerometers' Data Classification of Body Postures and Movements. Proceedings of 21st Brazilian Symposium on Artificial Intelligence. Advances in Artificial Intelligence - SBIA 2012. In: Lecture Notes in Computer Science. , pp. 52-61. Curitiba, PR: Springer Berlin / Heidelberg, 2012. ISBN 978-3-642-34458-9. DOI: 10.1007/978-3-642-34459-6_6. 

Read more: http://groupware.les.inf.puc-rio.br/har#dataset#ixzz3lluTA0bt

##Data Model Creation
This code expects the source files to be located in the working directory in which this is executed from. I built my model selection by dropping columns which contained NA's reducing the columns from 160 to 53. This was done with repeated summary and subset commands which have been ommited for space purposes, the final subset being included below. 


```r
library(caret)
```

```
## Loading required package: lattice
## Loading required package: ggplot2
```

```r
set.seed(1234)

data = read.csv("pml-training.csv", na.strings = c("NA","","#DIV/0!") )
trainIndex <- createDataPartition(y=data$classe, p = .8,list = FALSE)
training <- data[ trainIndex,]
testing  <- data[-trainIndex,]

validating = read.csv("pml-testing.csv", na.strings = c("NA","","#DIV/0!") )

trainingSub2 <- subset(training,select= c( roll_belt,pitch_belt,yaw_belt,total_accel_belt, gyros_belt_x,gyros_belt_y,gyros_belt_z,accel_belt_x,accel_belt_y, accel_belt_z, magnet_belt_x, magnet_belt_y, magnet_belt_z, roll_arm, pitch_arm, yaw_arm, total_accel_arm,gyros_arm_x,gyros_arm_y,gyros_arm_z,accel_arm_x,accel_arm_y,accel_arm_z,magnet_arm_x, magnet_arm_y,magnet_arm_z,roll_dumbbell,pitch_dumbbell,yaw_dumbbell,total_accel_dumbbell, gyros_dumbbell_x,gyros_dumbbell_y,gyros_dumbbell_z,accel_dumbbell_x,accel_dumbbell_y,accel_dumbbell_z,magnet_dumbbell_x,magnet_dumbbell_y, magnet_dumbbell_z,roll_forearm,pitch_forearm,yaw_forearm, total_accel_forearm,gyros_forearm_x, gyros_forearm_y,gyros_forearm_z,    accel_forearm_x,   accel_forearm_y,accel_forearm_z,magnet_forearm_x,magnet_forearm_y, magnet_forearm_z,classe ))

testingSub2 <- subset(testing,select= c( roll_belt,pitch_belt,yaw_belt,total_accel_belt, gyros_belt_x,gyros_belt_y,gyros_belt_z,accel_belt_x,accel_belt_y, accel_belt_z, magnet_belt_x, magnet_belt_y, magnet_belt_z, roll_arm, pitch_arm, yaw_arm, total_accel_arm,gyros_arm_x,gyros_arm_y,gyros_arm_z,accel_arm_x,accel_arm_y,accel_arm_z,magnet_arm_x, magnet_arm_y,magnet_arm_z,roll_dumbbell,pitch_dumbbell,yaw_dumbbell,total_accel_dumbbell, gyros_dumbbell_x,gyros_dumbbell_y,gyros_dumbbell_z,accel_dumbbell_x,accel_dumbbell_y,accel_dumbbell_z,magnet_dumbbell_x,magnet_dumbbell_y, magnet_dumbbell_z,roll_forearm,pitch_forearm,yaw_forearm, total_accel_forearm,gyros_forearm_x, gyros_forearm_y,gyros_forearm_z,    accel_forearm_x,   accel_forearm_y,accel_forearm_z,magnet_forearm_x,magnet_forearm_y, magnet_forearm_z,classe ))
```

## Train and Predict
I explored several training models including a composite model. I was not able to generate an Random Forest model as it crashed my system. Of the models I generated I ended up utilizing the GBM model as it had the best accuracy at 97%. The model aslo uses **cross validation** sampling method for training process. The confusion matrix provides the summary statistics of the evaluation highlighting all the key attributes of **error rate** that the predicted model uses. Only the GBM model output is included in this report.   


```r
modFitGBM <- train(classe ~ ., data=trainingSub2, method="gbm", verbose = FALSE, trControl = trainControl(method="cv",))
predGBM <- predict(modFitGBM, testingSub2)
confusionMatrix(testingSub2$classe, predGBM)
#97% accuracy

modFitLDA <- train(classe ~ ., data=trainingSub2, method="lda", trControl = trainControl(method="cv",))
predLDA <- predict(modFitLDA, testingSub2)
confusionMatrix(testingSub2$classe, predLDA)
#71% accuracy

modFitRpart <- train(classe ~ ., data=trainingSub2, method="rpart")
predRpart <- predict(modFitRpart, testingSub2)
confusionMatrix(testingSub2$classe, predRpart)
# 50% accuracy

predDF <- data.frame(predGBM,predLDA,predRpart,classe=testingSub2$classe)
combModFit <- train(classe ~ ., method="gam",data=predDF)
combPred <- predict(combModFit,testingSub2)
confusionMatrix(testingSub2$classe,combPred)
# 47% accuracy 
```


```
## Loading required package: gbm
## Loading required package: survival
## 
## Attaching package: 'survival'
## 
## The following object is masked from 'package:caret':
## 
##     cluster
## 
## Loading required package: splines
## Loading required package: parallel
## Loaded gbm 2.1.1
## Loading required package: plyr
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 1097   14    2    2    1
##          B   23  724   12    0    0
##          C    0   22  655    7    0
##          D    0    3   21  616    3
##          E    4    7    5    6  699
## 
## Overall Statistics
##                                           
##                Accuracy : 0.9664          
##                  95% CI : (0.9602, 0.9718)
##     No Information Rate : 0.2865          
##     P-Value [Acc > NIR] : < 2.2e-16       
##                                           
##                   Kappa : 0.9574          
##  Mcnemar's Test P-Value : 0.0001898       
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            0.9760   0.9403   0.9424   0.9762   0.9943
## Specificity            0.9932   0.9889   0.9910   0.9918   0.9932
## Pos Pred Value         0.9830   0.9539   0.9576   0.9580   0.9695
## Neg Pred Value         0.9904   0.9855   0.9877   0.9954   0.9988
## Prevalence             0.2865   0.1963   0.1772   0.1608   0.1792
## Detection Rate         0.2796   0.1846   0.1670   0.1570   0.1782
## Detection Prevalence   0.2845   0.1935   0.1744   0.1639   0.1838
## Balanced Accuracy      0.9846   0.9646   0.9667   0.9840   0.9937
```


##Course Project Submission 
This is the code I ran for the submission section of the course project. I included the file wrting function the instructor provided to automate file generation. I have the code set to not execute as it generates 2o text files.  

```r
predClass <- predict(modFitGBM, validating)
predClassChar <- as.character(predClass)
# function from https://class.coursera.org/predmachlearn-032/assignment/view?assignment_id=5
pml_write_files = function(x){
  n = length(x)
  for(i in 1:n){
    filename = paste0("problem_id_",i,".txt")
    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}

pml_write_files(predClassChar)
```

##Conclusion 
The GBM model had a predicted accuracy of 97% which is what I used for the course submission. The submission was complete sucessfull resulting in 100% sucessful prediction rate for the submission. 
