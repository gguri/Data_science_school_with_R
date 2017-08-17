###############################
### 수업내용 : 분류기       ###
###############################

library(e1071)
library(caret)
library(class)
####################################
## 1. k-최근접 이웃 알고리즘 (k-NN) - 지도학습

## 분류하려는 점에서 최근접한 k개의 훈련 데이터로 결정
## 3개 => 데이터 주변의 3개의 데이터로 분류
## 5개 => 데이터 주변의 5개의 데이터로 분류

## k-NN은 직관적이고 간단하여 설명 / 수정이 용이함

## k는 어떻게 정하는게 좋을까?
## k가 증가함에 따라 과적합 감소, 잘못된 분류 증가
## 분산과 평향의 trade-off
## 거리에 반비례하는 가중치를 주는 방법도 있음

## 현재의 훈련 모델에서는 k=5가 좋을 수도 있지만,
## 장기적인 관점에서의 k도 고려해야 한다.

## 선형회귀  vs.  k-NN  
## 선형회귀는 모수적 <-> k-NN은 비모수적 방법
## 모수적 : 강한 가정이 존재(선형성)
## 비모수적 : 우리는 훈련 데이터가 있고 그걸 가지고 분류를 할 것이다.
##        => 선형성이라는 가정도 없고, 어떤 특징이 있는지도 모르겠다. 그냥 분류할 거다.
## 선형회귀 : 선형적인 모형을 위해서는 선형회귀가 유리
## k-NN     : 오차의 분포 / 선형성을 가정할 수 없는 기하학적 분류에 사용
## k-NN은 계산량이 많음

## iris데이터에서 100개 샘플링
ind = sample(1:nrow(iris), 100)

## species를 구분하는 데이터 
iris.training = iris[ind, 1:4]
iris.test = iris[-ind, 1:4]

## 분류 데이터 => species
iris.trainLabels = iris[ind, 5]
iris.testLabels = iris[-ind, 5]

## 모형을 만든다는 건 정확한 표현이 아님. => 여기서 모형은 훈련 데이터 전체
## 분류기를 만들어보자

## k = 1   / 패키지 없이
## 4차원 거리 함수 (4개의 변수들이 존재)
distance4 <- function(x, y) {
  tmp <- sqrt(sum((x[1]-y[1])^2+(x[2]-y[2])^2+(x[3]-y[3])^2+(x[4]-y[4])^2))
  return (tmp)
}
distance4(iris.training[1,], cbind(0,0,0,0))
distance4(iris.training[1,], iris.test[1,])


# 1 Nearest Neighbor를 계산하는 함수
# 입력값
# x: 훈련 데이터
# y: x와 거리를 계산하여 분류할 특정 데이터
# labels: 레이블
# 출력: y의 위치와 분류된 class
nn1 <- function(x, y, labels) {
  df <- data.frame()
  for(i in 1:nrow(x)) {
    df_tmp <- data.frame(dist=distance4(x[i,], y), class=labels[i])
    df <- rbind(df, df_tmp)
  }
  return (cbind(y, Species=df[which.min(df$dist),]$class))
}

nn1(iris.training, iris.training[95,], iris.trainLabels)
iris.trainLabels[95]

# iris.test에 있는 값들을 분류
iris_pred_k1 <- data.frame()
for(i in 1:nrow(iris.test)) {
  iris_pred_k1 <- rbind(iris_pred_k1,
                        nn1(iris.training, iris.test[i,], iris.trainLabels))
}
iris_pred_k1
## 데이터를 확인해보자
data.frame(iris.testLabels, iris_pred_k1$Species)

plot(iris_pred_k1$Sepal.Length, iris_pred_k1$Sepal.Width, pch=21, bg=c("red","green","blue")[unclass(iris_pred_k1$Species)])

## 분류된 데이터 확인
plot(iris_pred_k1$Petal.Length, iris_pred_k1$Petal.Width, pch=21, bg=c("red","green","blue")[unclass(iris_pred_k1$Species)])
qplot(Petal.Length, Petal.Width, data = iris_pred_k1, color = Species, size = 0.1)

## 혼동행렬 구분
confusionMatrix(iris_pred_k1$Species, iris.testLabels)
## Accuracy: 전체에서 맞게 예측한 비율 (TP + TN) / (TP + TN + FP + FN)
## Sensitivity: 실제 분류 중 맞게 예측한 비율 
## => 민감도 True Positive Rate : TP / TP + FP
## Specificity: 실제 분류가 아닌 것 중 맞게 예측한 비율 
## => 특이도 True Negative Rate : TN / TN + FP
## Pos Pred Value: 긍정 예측 중 올바른 예측 비율 -> 정밀도
## Neg Pred Value: 부정 예측 중 올바른 예측 비율
## Prevalence: 전체에서 긍정 예측 비율

nn5 <- function(x, y, labels) {
  df <- data.frame()
  for(i in 1:nrow(x)) {
    df_tmp <- data.frame(dist=distance4(x[i,], y), class=labels[i])
    df <- rbind(df, df_tmp)
  }
  dist.sort <- sort(df$dist, index.return=TRUE)
  n1 <- df[dist.sort$ix[1],]
  n2 <- df[dist.sort$ix[2],]
  n3 <- df[dist.sort$ix[3],]
  n4 <- df[dist.sort$ix[4],]
  n5 <- df[dist.sort$ix[5],]
  class <- tail(names(sort(table(rbind(n1, n2, n3, n4, n5)$class))), n=1)
  return (cbind(y, Species=class))
}

nn5(iris.training, iris.training[95,], iris.trainLabels)

## 훈련/예측 (k=3, 패키지 사용)
iris_pred <- knn(train=iris.training, test=iris.test, cl=iris.trainLabels, k=3)
iris_pred
?knn
## 최적의 k 찾기

## 10-fold cross validation
## 최적의 k 찾기
ctrl <- caret::trainControl(method="cv", number = 10)
iris.train.cl <- cbind(iris.trainLabels, iris.training)
grid <- expand.grid(k=c(1,3,5,7,10,15,20,30,40))
knnFit <- train(iris.trainLabels ~ .,
                data = iris.train.cl,
                method = "knn",
                trControl = ctrl,
                tuneGrid=grid)
plot(knnFit)

####################################
## 2. k-평균 알고리즘 (k-means) - 비지도학습

## k-NN과 다르게 비지도학습 => 정답이 없다.
## 알고리즘 
## 1. 무작위로 k개의 점을 선택
## 2. 모든 데이터 각각을 1번의 k개 점 중 가장 가까운 점에 할당하여 클러스터를 구성
## 3. 각 클러스터들의 평균점 계산(k개 존재)
## 4. 3번의 평균점을 기준으로 2번부터 반복
## 5. 클러스터들이 변하지 않으면 종료

## 알고리즘이 단순
## k와 최초에 선택한 중심점에 민감
## 클러스터의 모양에 따라 잘 작동하지 않을 수 있음

### 결론 : k-NN과 k-means 는 k라는 이름만 공유할 뿐 전혀 다른 알고리즘


####################################
## 3. 나이브 베이즈 분류 (Naive Bayes)
## P(X|Hi) 는 조건부 확률 P(xk|Hi)들의 단순 곱(xk들의 독립을 가정)
## P(Hi|X)(= P(X|Hi)P(Hi)/P(X) )이 최대가 되는 Hi 탐색
## X를 Hi로 분류
## 여기서 X가 이산형이면, xk가 나타나는 개수로부터 확률 계산
## X가 연속형이면 정규분포를 가정하고 평균과 표준편차에 따른 확률밀도함수 사용
##               => 또는 Kernel Density Estimation
## 왜 Naive 인가? - xk가 서로 독립관계라서

## 예시) 스팸 메일 분류 작업
## 사전확률 
## P(S) : 전체 메일 중 스팸의 비율
## P(H) = 1-P(S) : 전체 메일 중 스팸이 아닌 비율
## 단어 w가 메일 내용에 포함될 때 그 메일이 스팸일 확률
## P(S|w) = P(w|S)P(S)/P(w)  => 최대가 되는 S를 탐색
## P(w|S) = 스팸인 메일에서 단어 w가 포함될 확률
## P(w) : 단어 w가 전체 메일에서 포함되는 확률

## P(S) 어짜피 모른다면 전체가 전부 같다고 보는게 좋다.
## 전체 메일 중 스팸 메일 50%, 햄메일 50%로 가저

## 스팸에서 단어 wk가 포함되는 확률 P(wk|S) 파악
## 스팸이 아닌 메일에서 단어 wk가 포함되는 확률 P(Wk|H)

## P(S), P(H)가 각각 전부다 같다고 가정해서 소거가 가능
## 어짜피 특정한 값을 추정하는게 아니라 대소비교를 통해 분류를 하는게 목적이기 때문에
## P(M|h)에서 흐린 부분이 없다면 특정 값이 나오지는 않지만 비교는 가능함


## 이산형 - 스팸 이메일 분류 
## 사전확률
spam = 0.5 # 스팸
ham = 0.5  # 스팸이 아님

# 스팸일 때 'hello'라는 단어가 들어갈 확률: 30%
hello_spam = 0.3
# 스팸일 때 'world'라는 단어가 들어갈 확률: 2%
world_spam = 0.02
# 햄일 때 'hello'라는 단어가 들어갈 확률: 20%
hello_ham = 0.2
# 햄일 때 'world'라는 단어가 들어갈 확률: 1%
world_ham = 0.01

## 베이즈 정리에 의해 수식이 바꿈
# 'hello'가 들어갈 때 스팸일 확률
spam_hello <- hello_spam / (hello_spam + hello_ham)
spam_hello
# 'world'가 들어갈 때 스팸일 확률
spam_world <- world_spam / (world_spam + world_ham)
spam_world
# 'hello'가 들어갈 때 햄일 확률
ham_hello <- hello_ham / (hello_spam + hello_ham)
ham_hello
# 'world'가 들어갈 때 햄일 확률
ham_world <- world_ham / (world_spam + world_ham)
ham_world

# {hello, world} 단어 집합이 들어갈 때 스팸일 확률
spam_hello * spam_world
# {hello, world} 단어 집합이 들어갈 때 햄일 확률
ham_hello * ham_world
# 0.400 vs. 0.133  =>  따라서 스팸

## 위에서 계산된 확률값이 정확한 확률값은 아니지만 
## 단순히 스팸 / 햄 을 분류하기 위해서만 계산한 값
## 만약 단어의 경우의 수가 많을 경우 확률의 모든 값을 단순히 곱하게 되면 
## 컴퓨터가 처리하기 어려운 수준의 작은 값들로 줄어들게 된다.
## 각 확률에 log변환을 통해 확률을 계산해서 비교를 해주면 됨.


### 연속형 - iris 데이터(연속형)
## 사전 확률
# setosa 
setosa <- nrow(iris[iris$Species=='setosa',])/nrow(iris)
setosa
# versicolor
versicolor <- nrow(iris[iris$Species=='versicolor',])/nrow(iris)
versicolor
# virginica
virginica <- nrow(iris[iris$Species=='virginica',])/nrow(iris)
virginica

### 조건부 확률 (Sepal.Length에 대해서만)
## Sepal.Length가 5인 경우 조건부 확률을 위해서
## 정규 분포를 가정하고 평균과 표준편차 계산

# setosa의 경우 Sepal.Length의 평균과 표준편차
mean_sepal.length_setosa <- mean(iris$Sepal.Length[iris$Species=='setosa'])
sd_sepal.length_setosa <- sd(iris$Sepal.Length[iris$Species=='setosa'])

# versicolor의 경우 Sepal.Length의 평균과 표준편차
mean_sepal.length_versicolor <- mean(iris$Sepal.Length[iris$Species=='versicolor'])
sd_sepal.length_versicolor <- sd(iris$Sepal.Length[iris$Species=='versicolor'])

# virginica의 경우 Sepal.Length의 평균과 표준편차
mean_sepal.length_virginica <- mean(iris$Sepal.Length[iris$Species=='virginica'])
sd_sepal.length_virginica <- sd(iris$Sepal.Length[iris$Species=='virginica'])

# 꽃 종류별 Sepal.Length의 확률 밀도
# 꽃 받침의 길이가 5일때 어디에 해당되는지를 확인해보자
p_sepal.length_setosa <- dnorm(5, mean=mean_sepal.length_setosa,
                               sd=sd_sepal.length_setosa)
p_sepal.length_setosa

p_sepal.length_versicolor <- dnorm(5, mean=mean_sepal.length_setosa,
                                   sd=sd_sepal.length_versicolor)
p_sepal.length_versicolor

p_sepal.length_virginica <- dnorm(5, mean=mean_sepal.length_setosa,
                                  sd=sd_sepal.length_virginica)
p_sepal.length_virginica

# Sepal.Length이 주어졌을 떄 setosa일 확률
p_setosa_sepal.length <- p_sepal.length_setosa / (p_sepal.length_setosa 
                                                  + p_sepal.length_versicolor 
                                                  + p_sepal.length_virginica)
p_setosa_sepal.length

# e1071 패키지 사용
model <- e1071::naiveBayes(Species ~ ., data = iris[ind,])
model
## 모델은 각각의 평균과 표준편차 결과를 가진다

# 예측
e1071::predict(model, iris[-ind,-5])
iris.testLabels
# 혼동행렬
caret::confusionMatrix(predict(model, iris[-ind,-5]), iris.testLabels)

## 교차검증
### Leave One Out Cross Validation
train_control <- trainControl(method="LOOCV")
model <- train(Species~., data=iris, trControl=train_control, method="nb")
print(model)
# 정규분포를 쓰기보다는 주어진 데이터에 적합한 분포를 사용하겠다.
# usekernel: Kernel Density Estimation

### 10-fold Cross Validation
train_control <- trainControl(method="cv", number=10)
model <- train(Species~., data=iris, trControl=train_control, method="nb")
print(model)

### 교차검증은 모델간의 성능을 비교해주는 방법
### 교차검증은 여러가지 방법은 있지만 ... 강사님 경험대로라면? 
### 여러가지 교차검증을 해도 비슷한 결과가 도출된다.



# 연습

## 손글씨 숫자 분류
#데이터: [Digit Recognizer](https://www.kaggle.com/c/digit-recognizer)
# 단순히 패키지에 데이터를 넣고 돌리게 되면 데이터 타입에서 에러가 발생함
# 확인해서 돌려보자

## 키와 몸무게에 따른 성별 분류
# 파일: 01_heights_weights_genders.csv