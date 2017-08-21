rm(list=ls())
#' @title parallel coding
#' @author Jungchul HA
#' @version 1.0, 2017.08.21
#' @description 이민식(연세대)_특강

# 01 setting -----------------------------------------

# import use library
library(class)
library(data.table)
library(dplyr)
library(e1071)
library(randomForest)
library(parallel)
library(foreach)
library(doParallel)

# import personal library
source("project/function/MS_model.R", encoding = "UTF-8")



# 02. SVM vs. Random Forest  -------------------------------------

# create data
x <- matrix(runif(1e6), 1000)
y <- gl(2, nrow(x)/2)

# sampling
set.seed(123)
ind <- sample(nrow(x), nrow(x) * 0.7)

## train / test
trainX <- x[ind, ]
trainY <- y[ind]
testX <- x[-ind, ]
testY <- y[-ind]

# SVM
svmModel <- svm(trainX, trainY)
svmPrd <- predict(svmModel, testX)
svmAcc <- sum(svmPrd == testY)/length(testY)

# RF
ranModel <- randomForest(trainX, trainY)
ranPrd <- predict(ranModel, testX)
ranmAcc <- sum(ranPrd == testY)/length(testY)

# Accuracy Comparison
svmAcc; ranmAcc



# 03-1. forLoop SVM % RF -------------------------------------

result <- data.frame(SVM = NA, RF = NA)

t1 <- Sys.time()
for(i in 1:10){
  # modeling
  svmAcc <- MS_model(x, y, i, "SVM")
  ranAcc <- MS_model(x, y, i, "RF")
  
  # insert data
  result[i, ] <- c(svmAcc, ranAcc)
}

t2 <- Sys.time()
t2 - t1



# 03-2. parallel SVM & RF -----------------------------------

# My PC core = 4
# 보유한 CPU 코어 개수 
no_cores <- parallel::detectCores() - 1 # Calculate the number of cores
# 병렬 진행하는 코어 노드 수
cl <- parallel::makeCluster(no_cores)   # Initiate cluster

# code
# 각 노드에서 사용할 변수
parallel::clusterExport(cl, varlist = c("x", "y" ,"MS_model"))
# 각 노드에서 사용할 패키지 할당
parallel::clusterEvalQ(cl, library(e1071))
parallel::clusterEvalQ(cl, library(randomForest))

t3 <- Sys.time()
output <- parallel::parSapply(cl, 1:10, function(i){
  svmAcc <- MS_model(x, y, i, "SVM")
  ranAcc <- MS_model(x, y, i, "RF")
  result <- c(svmAcc, ranAcc)
  return(result)
})
t4 <- Sys.time()
stopCluster(cl)
t4 - t3

## 리소스 모니터를 통해서 cpu 3개가 돌아가는 것을 확인 할 수 있다.



# 04. 실습 knn vs. SVM -----------------------------------------

# seq_len(x) => 1~x 까지 반복됨 
data <- iris[rep(seq_len(nrow(iris)),
                 each = 22),]

# sampling
set.seed(1708)

x <- data[, 1:4]
y <- data[, 5] # label

## train / test
trainX <- x[ind, 1:4]
trainY <- y[ind, 5]
testX <- x[-ind, 1:4]
testY <- y[-ind, 5]

# SVM
svmModel <- svm(trainX, trainY)
svmPrd <- predict(svmModel, testX)
svmAcc <- sum(svmPrd == testY)/length(testY)

# RF
knnModel <- class::knn(trainX, testX, cl=trainY, k=5)
knnAcc <- sum(knnModel == testY)/length(testY)

svmAcc; knnAcc



# 04-1. forLoop ---------------------------------------------------

t1 <- Sys.time()
result <- data.frame(SVM = NA, RF = NA)
for(i in 1:10){
  # modeling
  svmAcc <- MS_model(x, y, i, "SVM")
  knnAcc <- MS_model(x, y, i, "knn")
  
  # insert data
  result[i, ] <- c(svmAcc, ranAcc)
}

t2 <- Sys.time()
t2 - t1
svmAcc; knnAcc



# 04-2. parallel --------------------------------------------------------

no_cores <- parallel::detectCores() - 1 # Calculate the number of cores
cl <- parallel::makeCluster(no_cores) # Initiate cluster

# code
clusterExport(cl, varlist = c("x", "y" ,"MS_model"))
clusterEvalQ(cl, library(e1071))
clusterEvalQ(cl, library(class))

t5 <- Sys.time()
output <- parSapply(cl, 1:10, function(i){
  
  set.seed(i)
  ind <- sample(nrow(x), nrow(x) * 0.7)
  
  ## train / test
  trainX <- x[ind, ]
  trainY <- y[ind]
  testX <- x[-ind, ]
  testY <- y[-ind]
  
  # knn
  knnModel <- knn(trainX, testX, trainY, k=5)
  knnAcc <- sum(knnModel == testY) / length(testY)
  
  # SVM
  svmModel <- svm(trainX, trainY)
  svmPrd <- predict(svmModel, testX)
  svmAcc <- sum(svmPrd == testY) / length(testY)
  
  result <- c(knnAcc, svmACC)
  return(result)
})

t6 <- Sys.time()
stopCluster(cl)
t6 - t5
