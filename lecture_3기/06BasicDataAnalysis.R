#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
# 수업내용 : Basic Data Analysis                 #
#                                                #
# 작 성 자 : 이부일                              #
# 작성일자 : 2018년 3월 23일 금요일              #
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#

install.packages("ggplot2")
install.packages("RColorBrewer")
install.packages("prettyR")
install.packages("e1071")
install.packages("psych")
library(ggplot2)
library(RColorBrewer)
library(prettyR)
library(e1071)
library(psych)


# 자료의 종류 : 질적 자료, 양적 자료
# 일변량 : Uni-variate, 하나의 열
# 예제 데이터 : ggplot2::diamonds

# 1. 일변량 질적 자료의 분석 : cut, color, clarity
# 1.1 표 = 빈도표(빈도, 백분율)
# (1) 빈도(Frequency)
# table(data$variable)
table(diamonds$cut)
sort(table(diamonds$cut) , decreasing = TRUE)
sort(table(diamonds$color) , decreasing = TRUE)
sort(table(diamonds$clarity) , decreasing = TRUE)

# (2) 백분율(Percent) : 0 ~ 100
# prop.table(frequency)*100
prop.table(table(diamonds$cut))*100
sort(prop.table(table(diamonds$cut))*100 , decreasing = TRUE)
sort(prop.table(table(diamonds$color))*100 , decreasing = TRUE)
sort(prop.table(table(diamonds$clarity))*100 , decreasing = TRUE)

# 소수점의 반올림 : 특별하지 않으면 최종적인 결과는 소수점 1자리를 가짐
# round(소수점을 갖는 데이터, digits = 1)
round(sort(prop.table(table(diamonds$cut))*100 , decreasing = TRUE) , digits = 1)
round(sort(prop.table(table(diamonds$color))*100 , decreasing = TRUE) , digits = 1)
round(sort(prop.table(table(diamonds$clarity))*100 , decreasing = TRUE) , digits = 1)

for(i in 2:4){
    print(sort(table(diamonds[ , i]) , decreasing = TRUE))
    print(round(sort(prop.table(table(diamonds[ , i]))*100 , decreasing = TRUE) , digits = 1))
}


# 1.2 그래프
# (1) 막대그래프
# barplot(frequency or percent)
barplot(sort(table(diamonds$cut) , decreasing = TRUE))

# i. 막대 색깔 : col = "color"
barplot(sort(table(diamonds$cut) , decreasing = TRUE),
        col = "purple")

barplot(sort(table(diamonds$cut) , decreasing = TRUE),
        col = c("red", "blue", "green", "yellow", "pink"))

RColorBrewer::display.brewer.all()
pal <- RColorBrewer::brewer.pal("Set1", n = 5)
barplot(sort(table(diamonds$cut) , decreasing = TRUE),
        col = pal)

barplot(sort(table(diamonds$cut) , decreasing = TRUE),
        col = rainbow(5))

# ii. 제목 : main = "title"
barplot(sort(table(diamonds$cut) , decreasing = TRUE),
        col  = "purple",
        main = "Status of Diamonds's Quality")

# iii. y축제목 : ylab = "y's axis label"
barplot(sort(table(diamonds$cut) , decreasing = TRUE),
        col  = "purple",
        main = "Status of Diamonds's Quality",
        ylab = "Frequency")

# iv. y축눈금 : ylim = "y's axis limit"
# ylim = c(min, max)
barplot(sort(table(diamonds$cut) , decreasing = TRUE),
        col  = "purple",
        main = "Status of Diamonds's Quality",
        ylab = "Frequency",
        ylim = c(0, 25000))

# v. 가로막대그래프 : horiz = TRUE
# horiz : horizontal의 약자
barplot(sort(table(diamonds$cut) , decreasing = FALSE),
        col  = "purple",
        main = "Status of Diamonds's Quality",
        xlab = "Frequency",
        xlim = c(0, 25000),
        horiz = TRUE)

for(i in 2:4){
    barplot(sort(table(diamonds[ , i]) , decreasing = TRUE),
            col  = "purple",
            main = paste("Status of", colnames(diamonds)[i]),
            ylab = "Frequency",
            ylim = c(0, max(table(diamonds[ , i]))))
}

# 그래픽 화면 분할하기
# par(mfrow = c(nrow =, ncol =))
# par(mfcol = c(nrow =, ncol =))
# mf : multi frame
# mfrow : 행부터 그래프를 채움
# mfcol : 열부터 그래프를 채움
par(mfrow = c(3, 1))
for(i in 2:4){
    barplot(sort(table(diamonds[ , i]) , decreasing = TRUE),
            col  = "purple",
            main = paste("Status of", colnames(diamonds)[i]),
            ylab = "Frequency",
            ylim = c(0, max(table(diamonds[ , i]))))
}

par(mfrow = c(1, 1))


# (2) 원그래프
# pie(Frequency or Percent)
pie(sort(table(diamonds$cut) , decreasing = TRUE))

# 반지름 : radius = 0.8
pie(sort(table(diamonds$cut) , decreasing = TRUE),
    radius = 1)

# 시계방향 : clockwise = TRUE
pie(sort(table(diamonds$cut) , decreasing = TRUE),
    radius    = 1,
    clockwise = TRUE)

# 첫째 조각의 각도 : init.angle = 90
pie(sort(table(diamonds$cut) , decreasing = TRUE),
    radius    = 1,
    clockwise = TRUE,
    init.angle = 0)


# 문제 : 각 질적 자료에 대한 막대그래프, 원그래프를 작성하시오.
par(mfrow = c(3, 2))
for(i in 2:4){
    barplot(sort(table(diamonds[ , i]) , decreasing = TRUE),
            col  = "purple",
            main = paste("Status of", colnames(diamonds)[i]),
            ylab = "Frequency",
            ylim = c(0, max(table(diamonds[ , i]))))
    
    pie(sort(table(diamonds[ , i]) , decreasing = TRUE),
        radius    = 1,
        clockwise = TRUE,
        init.angle = 0)
}


# pdf 파일로 그래프 저장하기
# pdf(file = "directory/filename.pdf") : 저장 시작
# 그래프 작성하는 작업
# dev.off() : 저장 끝
# dev : device of graphic
pdf(file = "d:/da/graph.pdf")
for(i in 2:4){
    barplot(sort(table(diamonds[ , i]) , decreasing = TRUE),
            col  = "purple",
            main = paste("Status of", colnames(diamonds)[i]),
            ylab = "Frequency",
            ylim = c(0, max(table(diamonds[ , i]))))
    
    pie(sort(table(diamonds[ , i]) , decreasing = TRUE),
        radius    = 1,
        clockwise = TRUE,
        init.angle = 0)
}
dev.off()



# 2. 일변량 양적 자료의 분석
# 2.1 표(구간의 빈도, 백분율)
# 구간를 가지는 새로운 변수를 만들어야 함.
# 그 새로운 변수에 대해서 빈도, 백분율을 구함.
diamonds$price.group <- cut(diamonds$price,
                            breaks = seq(from = 0, to = 20000, by = 5000),
                            right  = FALSE)

levels(diamonds$price.group) <- c("5000 미만",
                                  "5000 이상 ~ 10000 미만",
                                  "10000 이상 ~ 15000 미만",
                                  "15000 이상")

table(diamonds$price.group)
prop.table(table(diamonds$price.group))*100


# 2.2 그래프 : 히스토그램, 상자그림
# (1) 히스토그램(Histogram)
# hist(data$variable, breaks = )
hist(diamonds$price)
hist(diamonds$price, breaks = seq(from = 0, to = 20000, by = 2000))
hist(diamonds$price, breaks = 100)
price.hist <- hist(diamonds$price, breaks = seq(from = 0, to = 20000, by = 100))
price.hist
price.hist$breaks
price.hist$counts
max(price.hist$counts)


# (2) 상자그림(Boxplot)
# boxplot(data$variable, range = 1.5)
boxplot(diamonds$price)
boxplot(diamonds$price, range = 2)
boxplot(diamonds$price, range = 1)

# 집단별 상자그림 
# boxplot(data$variable ~ data$variable)
# boxplot(양적 자료 ~ 질적 자료)
boxplot(diamonds$price ~ diamonds$cut)
boxplot(diamonds$price ~ diamonds$color)
boxplot(diamonds$price ~ diamonds$clarity)


# 2.3 기술통계량 = 요약통계량
# Descriptive Statistics = Summary Statistics
# (1) 중심 = 대표값 : 평균, 절사평균, 중위수, 최빈수
# i. 평균(Mean)
# mean(data$variable, na.rm = TRUE)
mean(diamonds$price)
money <- c(20000, 18000, 20000, NA)
mean(money)
mean(money, na.rm = TRUE)

# ii. 5% 절사평균(5% Trimmed Mean)
# mean(data$variable, trim = 0.05, na.rm = TRUE)
mean(diamonds$price, trim = 0.05)

# iii. 중위수(Median)
# median(data$variable, na.rm = TRUE)
median(diamonds$price)

# iv. 최빈수(Mode)
# which.max(table(data$variable))
which.max(c(10, 5, 100))
which.max(table(diamonds$price))

# prettyR::Mode()
prettyR::Mode(diamonds$price)


# (2) 퍼짐 = 산포 = 다름 : 범위, 사분위범위, 분산, 표준편차, 중위수절대편차
# i. 범위(Range)
# diff(range(data$variable))
range(diamonds$price)
diff(c(326, 18823, 326))
diff(range(diamonds$price))

# ii. 사분위범위(IQR : Inter Quartile Range)
# IQR(data$variable)
IQR(diamonds$price)

# iii. 분산=표본분산(Variance)
# var(data$variable)
var(diamonds$price)

# iv. 표준편차(SD : Standard Deviation)
# sd(data$variable)
sd(diamonds$price)

# v. 중위수절대편차(MAD : Median Absolute Deviation)
# mad(data$variable)
mad(diamonds$price)

# (3) 분포의 모양
# i. 왜도(Skewness)
# e1071::skewness(data$variable)
e1071::skewness(diamonds$price)

# ii. 첨도(Kurtosis)
# e1071::kurtosis(data$variable)
e1071::kurtosis(diamonds$price)

# (4) 기타
# i. 최소값(Min)
# min(data$variable)
min(diamonds$price)

# ii. 최대값(Max)
# max(data$variable)
max(diamonds$price)


# 유용한 함수들
# i. by(양적 자료, 질적 자료, 함수명)
by(diamonds$price, diamonds$cut, mean)
by(diamonds$price, diamonds$cut, sd)
by(diamonds$price, diamonds$cut, hist)
by(diamonds$price, diamonds$cut, boxplot)
by(diamonds$price, diamonds$cut, summary)

# ii. summary()
summary(diamonds$price)
summary(diamonds)

# iii. psych::describe(), psych::describeBy()
psych::describe(diamonds$price)
psych::describe(diamonds$price, trim = 0.05)
psych::describe(diamonds$price, trim = 0.05)[c(2, 3, 4)]
psych::describe(diamonds[ , c(1, 5:10)])

# psych::describeBy(양적 자료, 질적 자료)
psych::describeBy(diamonds$price, diamonds$cut)
psych::describeBy(diamonds[ , c(1, 5:10)], diamonds$cut)

