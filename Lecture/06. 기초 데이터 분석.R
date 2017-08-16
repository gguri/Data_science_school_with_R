###############################################################################
### 수업내용 : 기초 데이터 분석                                             ###
###                                                                         ###
### 작 성 자 : JuncChul HA                                                  ###
### 작성일자 : 2017.07.20(목)                                               ###
###############################################################################
options(repos="https://cran.rstudio.com")
install.packages("hflights")
install.packages("prettyR")
install.packages("psych")
library(hflights)
library(R.utils)
library(DT)
library(data.table)
library(prettyR)
library(psych)
###############################################################################

## 예제 데이터 : hflights::hflights
## ::데이터 => 괄호가 없으면 데이터
## hflights 데이터 : 227496(row) 21(column)

## 데이터 일부 보기
DT::datatable(head(hflights))
hflights = data.frame(hflights::hflights)
hflightsDT = as.data.table(hflights)
dim(hflightsDT)
colnames(hflightsDT)

## 자료의 종류 : 통계적인 관점
## 질적 자료 vs 양적 자료

## 질적 자료 : 글자(문자), 숫자(의미가 없는 숫자)
## ex) 혈액형을 숫자로 넣으면? -> 연산이 불가능
## 기준 : 숫자가 의미가 있는가?

## 양적 자료 : 숫자(의미가 있는 숫자 - 사칙연산이 되는 숫자)

## 정의(Definition)

###############################################################################
##  I. 일변량(Uni-variate) 질적 자료의 분석
##  일변량 => 하나의 열

##  1. 표 = 빈도표 : 빈도(frequence), 백분율(percent)
##  (1) 빈도 : table(데이터명$변수명) 
##   R에서 table은 질적자료의 빈도를 구할 때 많이 사용
table(hflights$Month)
sort( table(hflights$Month) , decreasing = TRUE)
?table

##  (2) 백분율 = (빈도/합계)*100
##  prop.table(빈도결과)*100
##  prop = proportional(비율)
##  비율 : 0~1  /  백분율 : 0~100
sort( prop.table(table(hflights$Month))*100 , decreasing = TRUE)

##  백분율은 소수점 한 자리 까지만 보고서에 작성하자
round( sort( prop.table(table(hflights$Month))*100 , decreasing = TRUE) , digits = 1 )

## 데이터 2개 합치기
month.table = cbind( freq    = sort( table(hflights$Month) , decreasing = TRUE),
                     percent = round( sort( prop.table(table(hflights$Month))*100 , decreasing = TRUE) , digits = 1 ))

DT::datatable(month.table)

## month.table 데이터를 csv로 저장하기
## write.csv(R데이터, file="파일위치/파일명.csv")
write.csv(month.table,
          file = "fs/data/month.table.csv")

# 문제  Dest의 빈도 백분율의 현황
dest.table = cbind( freq    = sort( table(hflights$Dest) , decreasing = TRUE),
                    percent = round( sort( prop.table(table(hflights$Dest))*100 , decreasing = TRUE) , digits = 1 ))

DT::datatable(dest.table)
write.csv(dest.table,
          file = "fs/data/dest.table.csv")

## prettyR::freq()
#prettyR::freq(데이터명$변수명)
prettyR::freq(hflights$Month)
# 결과는 백분율과 유효백분율(!NA)가 나타남
# 유효백분율 : 실질적으로 응답한 사람(NA제외)
# ex) 사람 12명 중 1명이 무응답일 때 합계를 11로 계산 

# display.na=FALSE  /  유효 백분율을 출력하지 마라
prettyR::freq(hflights$Month,
              display.na = FALSE)

# decr.order = FALSE  / 기본적으로 내림차순, 정렬을 없애라
prettyR::freq(hflights$Month,
              display.na = FALSE,
              decr.order = FALSE)
?prettyR

##  2. 그래프 : 막대그래프(세로, 가로), 원그래프
##  (1) 막대그래프 : barplot(빈도결과)  / 기본 세로 막대그래프
barplot( sort( table(hflights$Month) , decreasing = TRUE) )

# 막대 색깔 : col = "color"
barplot( sort( table(hflights$Month) , decreasing = TRUE),
         col = "skyblue")

# 그래프 제목 : main = "제목"
barplot( sort( table(hflights$Month) , decreasing = TRUE),
         col  = "skyblue",
         main = "월별 운행의 현황")

# y축 제목 : ylab = "축제목"
# ylab = y label의 약자
barplot( sort( table(hflights$Month) , decreasing = TRUE),
         col  = "skyblue",
         main = "월별 운항의 현황",
         ylab = "운항 횟수")
## y축 제목은 꼭 써야한다. ****

# y축 눈금 : ylim = c(최소값, 최대값)
# ylim = y limit의 약자
barplot( sort( table(hflights$Month) , decreasing = TRUE),
         col  = "skyblue",
         main = "월별 운항의 현황",
         ylab = "운항 횟수",
         ylim = c(0, 25000)
         )
## y축의 최소값은 0으로 해야된다. 
## 절단효과 : 최소값을 올리게 되면 전체적인 차이가 더 크게 보일 수 있기 때문

# 가로막대 : horiz = TRUE
# horiz = horizontal
barplot( sort( table(hflights$Month) , decreasing = FALSE),
         col  = "skyblue",
         main = "월별 운항의 현황",
         xlab = "운항 횟수",
         xlim = c(0, 25000),
         horiz = TRUE
        )
## 가로 막대 그래프로 변경 했기에 xlab, xlim 으로 바꿔야 함
## 젤 위에 가장 큰 값을 주어야 한다. => 내림차순

##  (2) 원그래프 : pie(빈도)
pie( sort( table(hflights$Month) , decreasing = TRUE) )
## 원그래프는 조각이 5개 이하인 경우에만 사용하자

# 반지름 : radius = 0.8(기본값)
pie( sort( table(hflights$Month) , decreasing = TRUE),
     radius = 1.2)

# 첫째 조각의 각도 : init.angle = 
pie( sort( table(hflights$Month) , decreasing = TRUE),
     radius = 1.0,
     init.angle = 90)



###############################################################################
##  II. 일변량(Uni-variate) 양적 자료의 분석
##  (1) 표 : 빈도표(구간의 빈도, 백분율)
##  (2) 그래프 : 히스토그램, 상자그림
##  (3) 기술통계량 = 요약통계량

##  1. 표 : 구간의 빈도, 백분율
DT::datatable(head(hflights))

# 최소값, 최대값
ArrDelay.range = range(hflights$ArrDelay, na.rm = TRUE)
ArrDelay.range

## 구간의 개수
interal.count = 1 + 3.3*log10(length(hflights$ArrDelay))
interal.count
## 제곱근 계산
sqrt(length(hflights$ArrDelay))

## 구간의 폭 = 계급의 폭
range(hflights$ArrDelay, na.rm = TRUE)
diff(range(hflights$ArrDelay, na.rm = TRUE))
# diff(숫자)
# diff(c(1,3,5)) => 3-1 / 5-3 => 2개씩 짝 지어서 계산
diff(ArrDelay.range) / interal.count

hflights$ArrDelay.group = cut(hflights$ArrDelay,
                              breaks = seq(from = -120,
                                           to   = 1020,
                                           by   = 60),
                              right = FALSE)
View(hflights)


# hflights$ArrDelay.group => 질적자료
table(hflights$ArrDelay.group)
prop.table(table(hflights$ArrDelay.group))*100
round(prop.table(table(hflights$ArrDelay.group))*100, digits = 3)


##  2. 그래프
##  (1) 히스토그램(Histogram) - 3가지
##  i. hist(데이터명$변수명) : Sturge 공식 적용
hist(hflights$ArrDelay)
?hist
# hist에 적용된 알고리즘에 대해 알아보자

##  ii. hist(데이터명$변수명, breaks = 구간의 개수)
hist(hflights$ArrDelay,
     breaks = 100)

##  iii. hist(데이터명$변수명, breaks = 구간의 정보)
hist(hflights$ArrDelay,
     breaks = seq(from = -120,
                  to   = 1020,
                  by   = 60),
     xlim = c(-120, 1020))

##  (2) 상자그림(Boxplot) : 이상치 유무 
##  i. boxplot(데이터명$변수명)
boxplot(hflights$ArrDelay)

money = c(40, 50, 50, 50, 40, 50, 40, 70, 30, 40, 50, 60, 250)
boxplot(money)
money2 = c(40, 50, 50, 50, 40, 50, 40, 30, 30, 40, 50, 60, 25)
boxplot(money2)

##  ii. 집단별 상자그림
##  boxplot(데이터명$변수명 ~ 데이터명$변수명)
##  boxplot(양적자료 ~ 질적자료)
##  R의 관점에서 factor형태로 되어 있어야 한다.
boxplot(hflights$ArrDelay ~ hflights$Origin)
boxplot(hflights$ArrDelay ~ hflights$Month)
# 각 이상치를 없앨까, 변환할까? 등

##  3. 기술통계량 = 요약통계량 => 숫자
##  Descriptive Statistics = Summary Statistics

##  모수(Parameter) vs 통계량(Statistics)
##  모집단(Population) vs 표본(Sample)

# 기술통계량, 요약통계량 -> 표본에서 나온거구나
# 모수는 모집단이 어떻게 생긴지 알려주는 수많은 숫자들
# 모집단의 평균, 표준편차, 최소값 -> 모수
# 표본에서 나온 평균, 최소값, 표준편차 -> 통계량

# 양적자료를 바탕으로 다양한 숫자를 만들어내는 것 = 통계량

##  (1) 중심 = 대표값
##  평균, 절사평균, 중위수(중앙값), 최빈수(최빈값)
##  절사평균 : 평균은 이상치에 영향을 많이 받는다. -> 이상치를 뺀 평균
##  최빈수 : 동일한 값이 많이 나타난 수
#   i. 평균 : mean(데이터명$변수명, na.rm = TRUE)
mean(hflights$ArrDelay, na.rm = TRUE)
# 하지만 이 평균을 가지고 분석을 하기에는 위험하다.
# 이상치(outlier)의 존재 때문

#   ii. 5% 절사평균(Trimmed Mean)
#   mean(데이터명$변수명, trim = 0.05, na.rm = TRUE)
#   작은쪽, 큰쪽 각각 5%씩 절사해서 90%의 평균을 계산하여 분석
#   5%는 바꿔도 되는 기준
mean(hflights$ArrDelay, trim = 0.05, na.rm = TRUE)
mean(hflights$ArrDelay, trim = 0.1, na.rm = TRUE)

#   iii. 중위수 : median(데이터명$변수명, na.rm=TRUE)
median(hflights$ArrDelay, na.rm = TRUE)
#   중위수 0을 기준으로 일찍오거나 늦게온 비행기가 50%씩 존재한다.

#   iv. 최빈수(Mode) - 2가지 방법
#  1) which.max(table(데이터명$변수명))
which.max(c(10, 5, 3, 200))
#   벡터의 가장 큰 값 200의 index를 알려준다
which.max(table(hflights$ArrDelay))
#   -4 가 54번째 있었다.
#   ArrDelay데이터에서 4분 일찍 도착한게 가장 많았다.

#  2) prettyR::Mode()
prettyR::Mode(hflights$ArrDelay)


## 중심을 뭘로 볼까? 를 고민해야한다


##  (2) 퍼짐 = 산포 = 다름(****)
# 통계는 '다름' 이 있기 때문에 분석한다. 이 다름의 차이를 수치화 하여 나타낸다.
# 이 '다름'은 왜 발생했을까? (****)
##  범위, 사분위범위(사분위수범위), 분산
##  표준편차(평균과의 차이), 중위수 절대 편차(중위수와 차이)
##  범위와 표준편차는 이상치(outlier)에 영향을 많이 받는다.
##  중위수 절대 편차는 이상치(outlier)의 영향을 적게 받는다.

##  i. 범위(Range)
range(hflights$ArrDelay, na.rm = TRUE)
# R에서 range 함수는 최소값, 최대값 2개를 알려줌
diff(range(hflights$ArrDelay, na.rm = TRUE))
# 2개의 차이 계산 diff()
## 범위는 이상치의 영향을 많이 받음 
## 그래서 나온게 사분위수범위

##  ii. 사분위범위 = 사분위수범위 = IQR(Inter Quartile Range)
##  IQR(데이터명$변수명, na.rm = TRUE)
IQR(hflights$ArrDelay, na.rm = TRUE)
## 범위(1048), 사분위범위(19)의 차이가 다르다. 
## 사분위범위를 보고 항공기들은 19분정도 늦게 도착하네 라고 볼 수 있음.

##  iii. (표본) 분산(Variance)
## 모든 데이터에서 평균을 빼고 제곱을 한다. 
## 데이터-평균를 편차(Deviation)이라고 한다. 편차를 다 더하면 0이 된다. => 따라서 제곱
## 통계는 데이터의 합계가 아닌 '자유도'로 나눈다.
## df : degree of freedom
## var(데이터명$변수명, na.rm = TRUE)
var(hflights$ArrDelay, na.rm = TRUE)
##  분산은 각 데이터의 제곱을 통해 계산하므로 결과는 '분의 제곱'이다.

##  iv. (표본)표준편차(SD : Standard Deviation)
##  sd(데이터명$변수명, na.rm = TRUE)
sd(hflights$ArrDelay, na.rm = TRUE)
##  평균은 7분 정도 늦는데, 각 데이터들마다 평균과의 차이가 다르다.
##  여기서 평균과의 차이는 약 30분(표준편차)
##  -27분 ~ 37분 범위 안에서 대부분 도착한다.
##  표준편차가 작다 - 평균이랑 가까운 데이터들
##  표준편차가 크다 - 평균이랑 먼 데이터들

##  v. 중위수 절대 편차(MAD : Median Absolute Deviation) 
##  mad(데이터명$변수명, na.rm = TRUE)
mad(hflights$ArrDelay, na.rm = TRUE)
##  중위수 절대 편차를 기준으로 비행기들이 13분 늦거나 일찍오는구나

##  (3) 분포의 모양
##  데이터가 하나가 아닌 여러개다. 
##  R의 기본 기능에서는 못 구함 - 왜도, 첨도
##  i. 왜도(Skewness) : 대칭여부
##  왜도가 0에 가까운 값이라면 '데이터들이 대칭이다.' 라고 볼 수 있다.
##  왜도가 0에서 멀어진다면 '데이터들이 비대칭이다.' 라고 볼 수 있다.
##  왜도 > 0 : 이상하게 큰애가 있다면 오른쪽으로 긴 곡선
##  왜도 < 0 : 이상하게 작은애가 있다면 왼쪽으로 긴 곡선

##  ii. 첨도(Kurtosis) : 중심이 얼마나 뾰족한가?
##  첨도가 0에 가까운 값이라면 중심이 보통높이 구나
##  첨도 > 0 : 중심이 높아진다 -> 비슷한 데이터가 많이 있다
##  첨도 < 0 : 중심이 낮아진다 -> 비슷한 데이터가 적다

## psych::describe(), describeBy()
## R에서 by가 있다면 항상 집단별로 무엇을 한다는 의미
psych::describe(hflights$ArrDelay)
# 결과 중 se : standard error 표준오차 0.06
# 지금 표본에서 평균이 7.09분이 나왔는데, 
# '다른 표본'을 뽑으면 평균이 지금 표본의 평균과 달라지겠죠?
# 그럼 얼마나 달라질까를 알려주는 값 => 표준오차

## psych::describeBy(데이터명$변수명, 데이터명$변수명)
## psych::describeBy(양적자료, 질적자료)
psych::describeBy(hflights$ArrDelay, hflights$Origin)
psych::describeBy(hflights$ArrDelay, hflights$Month)


## summary(데이터명$변수명)
# 질적 자료 = 빈도, 백분율 / 만약에 factor라면 빈도만 알려줌
# 양적 자료 = 6개(최소, 최대, 평균, 123사분위수)
summary(hflights$Month)
hflights$Month = as.factor(hflights$Month) #질적자료
summary(hflights$Month)
hflights$Month = as.numeric(hflights$Month) #양적자료
summary(hflights$ArrDelay)

##  summary(데이터명)
summary(hflights)
#  UniqueCarrier 를 보면 factor가 아니기 떄문에 저렇게 나오는데 factor로 바꿔서 계산 가능

## by(양적자료, 질적자료, 함수명)
by(hflights$ArrDelay, hflights$Origin, mean, na.rm = TRUE)
# 공항이 2개가 있는데 각 공항에 대하서 ArrDelay에 대한 평균을 구해줘
by(hflights$ArrDelay, hflights$Origin, sd, na.rm = TRUE)
by(hflights$ArrDelay, hflights$Origin, summary, na.rm = TRUE)
by(hflights$ArrDelay, hflights$Origin, psych::describe)
# 질적 자료를 기준으로 양적자료의 함수를 알려줘

## ()의 역할
## 실행되고, 결과도 출력하라는 뜻 / 우선순위
x=3
x
(x=3)
