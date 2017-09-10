rm(list=ls())
#' @title Music lyric analysis
#' @author Jungchul HA
#' @version 1.0, 2017.08.23
#' @description 한글 작업 Document Term Matrix
#               각 label 단어사전 만들기

# 01. setting -----------------------------------------------
# library
library(tm)
library(dplyr)
library(KoNLP)
library(caret)
useSejongDic()
library(stringr)
library(glmnet)
library(e1071)

# function
source("function/words.R", encoding = "UTF-8")

# 02. data import --------------------------------------------
song <- read.csv("data/analysis.csv", header = TRUE)
song$title <- as.character(song$title)
song$lyric <- as.character(song$lyric)
song$label <- as.factor(song$label)

# sampling
set.seed(1708)
ind <- sample(nrow(song), nrow(song) * 0.7)

# 03. dtm ---------------------------------------------------
# 각 label별로 사전 만들기
case1 <- song %>% filter(label == 1)
case2 <- song %>% filter(label == 2)
case3 <- song %>% filter(label == 3)
case4 <- song %>% filter(label == 4)
case5 <- song %>% filter(label == 5)
doc1 <- Corpus(VectorSource(case1$lyric))
doc2 <- Corpus(VectorSource(case2$lyric))
doc3 <- Corpus(VectorSource(case3$lyric))
doc4 <- Corpus(VectorSource(case4$lyric))
doc5 <- Corpus(VectorSource(case5$lyric))

# step 
tdmResult <- makeTdm09(case1$lyric)
# makeTdm09 -> SimplePos09에서 N(명사), P(용언)만 추출한 tdm

# dictionary
result <- makeDic(tdmResult)
result <- makeData(case1)


# makeDic -> all(전체결과), top100을 list로 반환

# write.csv(result[[1]], "data/top100(case1).csv",
#          row.names = FALSE)
# write.csv(result[[2]], "data/all(case1).csv",
#          row.names = FALSE)

# top100을 사전으로 사용
case1 <- read.csv("data/top100(case1).csv", header = TRUE) 
case2 <- read.csv("data/top100(case2).csv", header = TRUE) 
case3 <- read.csv("data/top100(case3).csv", header = TRUE) 
case4 <- read.csv("data/top100(case4).csv", header = TRUE) 
case5 <- read.csv("data/top100(case5).csv", header = TRUE) 
dic1 <- as.character(case1[,1])
dic2 <- as.character(case2[,1])
dic3 <- as.character(case3[,1])
dic4 <- as.character(case4[,1])
dic5 <- as.character(case5[,1])
dic <- unique(c(dic1, dic2, dic3, dic4, dic5))
rm(case1, case2, case3, case4, case5)

# 04. step1(단어 포함 빈도) ----------------------------------
# 해당 가사의 tdm을 만들어 준 후 단어 포함 유무에 따라 1점씩 counting한 후 최고점을 lable로 지정
class <- c()
scores <- 0
for(i in 1:nrow(song)){
  temp <- song[i,5]
  doc <- Corpus(VectorSource(temp))
  ctrl <- list(tokenize = ko.words09,
               removePunctuation = TRUE,
               removeNumbers = TRUE)
  tdm <- TermDocumentMatrix(doc, control = ctrl)
  tdm <- as.matrix(tdm)
  word <- rownames(tdm)
  tdmDf <- data.frame(tdm)
  freq <- tdmDf[,1]
  df <- data.frame(word = word, freq = freq)
  word <- as.character(df[,1])
  
  score1 <- calScore(word, dic1)
  score2 <- calScore(word, dic2)
  score3 <- calScore(word, dic3)
  score4 <- calScore(word, dic4)
  score5 <- calScore(word, dic5)
  scores <- c(score1, score2, score3, score4, score5)
  class <- rbind(class, which.max(scores))
}
class <- cbind(song, class)
class$vs <- ifelse(class$label == class$class, 1, 0)  
table(class$vs)  
# 0 : 109 / 1 : 221 => 67% 예측  


# 05. step2(svm) --------------------------------------------
temp <- song[,5]

# makeData -> 분석에 사용할 tdm을 data.frame으로 반환
data <- makeData(temp)
# tdm 단어 길이 argument가 자꾸 에러나서 수동으로...
test <- colnames(data)
word <- test[nchar(test) >=2&nchar(test) <=5]
data <- data %>% dplyr::select(word)
# 사전에 포함된 단어 column만 추출
result <- data %>% dplyr::select(dic)
result <- cbind(label = song$label, result)
train <- result[ind,]
test <- result[-ind,]

# test의 특징과 클래스 분리
testFeatureVars <- test[,-1]
testClassVars <- test[,1]

# RBF (방사기저함수)를 이용한 SVM
formulaInit <- "label ~ ."
formulaInit <- as.formula(formulaInit)
svmModel <- svm(formula = formulaInit, 
                 data = train,
                 kernel = "radial",
                 cost = 100, gamma = 1)

summary(svmModel)

# svm.model을 이용한 예측
svmPredictions <- predict(svmModel, testFeatureVars)
# 결과 => 개판

# tune 
costWeights <- c(0.1, 10, 100)
gammaWeights <- c(0.01, 0.25, 0.5, 1)
tuningResults <- tune(svm, formulaInit,
                      data = train, kernel = "radial")
ranges <- list(cost = costWeights, gamma = gammaWeights)
print(tuningResults)
svmModelBest <- tuningResults$best.model
svmPredictionsBest <- predict(svmModelBest,
                              testFeatureVars)
svmResult <- data.frame(testClassVars, svmPredictionsBest)
svmResult$vs <- ifelse(svmResult$testClassVars == svmResult$svmPredictionsBest, 1, 0)
table(svmResult$vs)
# 0: 63 / 1: 37
resultF <- svmResult[svmResult$vs==0, ]
# 1,3,4 를 비교적 제대로 예측하지 못함.

  
# 06. step3(naivebayes) -----------------------------------
temp <- song[,5]

data <- makeData(temp)
test <- colnames(data)
word <- test[nchar(test) >=2 & nchar(test) <=5]
data <- data %>% dplyr::select(word)

filterName <- c()
for(i in 2:ncol(data)){
  for(j in 1:length(dic)){
    if(colnames(data)[i] == dic[j]){
      tempName <- colnames(data)[i]
      filterName <- rbind(filterName, tempName)  
    }   
  }
}
result <- data %>% dplyr::select(filterName)
result <- cbind(label = song$label, result)
train <- result[ind,]
test <- result[-ind,]

# first model
formulaInit <- "label ~ ."
formulaInit <- as.formula(formulaInit)
# 0인 값들이 존재하므로 laplace 0.1
model <- naiveBayes(formulaInit, data = train, laplace = 0.1)
pred <- predict(model, test[,-1])
testLabels <- test[,1]
testLabels <- as.data.frame(cbind(testLabels, pred))
testLabels$vs <- ifelse(testLabels$testLabels == testLabels$pred,1,0)
table(testLabels$vs)
# 0: 63 / 1: 37

# naivebayes 0인 데이터들 확률 계산 못함
# 어떻게 해야될까.... 에
# second model -> 5-fold 
# 전체 데이터를 가지고 5-fold cv를 실시해서 모델을 훈련
train_control <- trainControl(method="cv", number=5)
tuneModel <- train(formulaInit, data=result,
                   trControl=train_control, method="nb")
pred <- predict(tuneModel, test[,-1])
testLabels <- test[,1]
testLabels <- as.data.frame(cbind(testLabels, pred))
testLabels$vs <- ifelse(testLabels$testLabels == testLabels$pred,1,0)
table(testLabels$vs)
# 0: 33 / 1: 66
# 예측 70%
resultF <- testLabels[testLabels[,3] == 0,]
# 1,2,3 인 노래들을 4,5로 전부 예측 한 것을 볼 수있음
# 사전의 정리가 필요할 것 같다.



# 07. multi logistic --------------------------------------------
temp <- song[,5]

# makeData -> 분석에 사용할 tdm을 data.frame으로 반환
data <- makeData(temp)
# tdm 단어 길이 argument가 자꾸 에러나서 수동으로...
test <- colnames(data)
word <- test[nchar(test) >=2&nchar(test) <=5]
data <- data %>% dplyr::select(word)
# 사전에 포함된 단어 column만 추출
result <- data %>% dplyr::select(dic)

result <- cbind(label = song$label, result)
train <- result[ind,]
test <- result[-ind,]

formulaInit <- "label ~ ."
formulaInit <- as.formula(formulaInit)

multiModel <- nnet::multinom(
  formulaInit,  # 모델 포뮬러
  train,     # 포뮬러를 적용할 데이터
  MaxNWts = 1300
)

fitted(
  multiModel  # 모델
)


pred <- predictMNL(multiModel,test)
testLabels <- test[,1]
testLabels <- cbind(testLabels, pred)
testLabels <- as.data.frame(testLabels)
testLabels$vs <- ifelse(testLabels$testLabels == testLabels$pred,1,0)
table(testLabels$vs)

predictMNL <- function(model, newdata) {
  
  # Only works for neural network models
  if (is.element("nnet",class(model))) {
    # Calculate the individual and cumulative probabilities
    probs <- predict(model,newdata,"probs")
    cum.probs <- t(apply(probs,1,cumsum))
    
    # Draw random values
    vals <- runif(nrow(newdata))
    
    # Join cumulative probabilities and random draws
    tmp <- cbind(cum.probs,vals)
    
    # For each row, get choice index.
    k <- ncol(probs)
    ids <- 1 + apply(tmp,1,function(x) length(which(x[1:k] < x[k+1])))
    
    # Return the values
    return(ids)
  }
}

# 0  1 
# 68 31 


# 08. naive model test -----------------------------------------
# 5-fold를 가지고 실시한 모델이 가장 예측을 잘하는 것 같은데
# 다른 데이터를 가지고 해당 모델을 시험해보자
# tuneModel -> naivebayes 모델
# 각 lable별로 sample데이터 수집
sample <- read.csv("data/sample.csv", header = TRUE)
temp <- sample[,5]
data <- makeData(temp)
test <- colnames(data)
word <- test[nchar(test) >=2&nchar(test) <=5]
data <- data %>% dplyr::select(word)
data <- cbind(label = sample$label, data)

filterName <- c()
for(i in 2:ncol(data)){
  for(j in 1:length(dic)){
    if(colnames(data)[i] == dic[j]){
      tempName <- colnames(data)[i]
      filterName <- rbind(filterName, tempName)  
    }   
  }
}

result <- data %>% dplyr::select(filterName)
result <- cbind(label = sample$label, result)

pred <- predict(tuneModel, result[,-1])
