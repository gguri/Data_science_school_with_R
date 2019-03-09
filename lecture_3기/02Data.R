#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
# 수업내용 : 데이터(Data)                       #
#                                               #
# 작 성 자 : 이부일                             #
# 작성일자 : 2018년 3월 19일 월요일             #
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#

# 1. Vector     : 벡터 *****
# 2. Factor     : 요인 **
# 3. Matrix     : 행렬
# 4. Array      : 배열
# 5. Data.Frame : 데이터 프레임 *****
# 6. List       : 리스트 ***


# 1. Vector
# 하나의 열(Column)로 구성됨, 1차원 구조
# 하나의 유형으로 구성됨
# 데이터 분석의 기본 단위

# 1.1 to make vector
# (1) 하나의 값(element)으로 이루어진 벡터
v1 <- 10
v2 <- "male"
v3 <- FALSE

# (2) 두 개 이상의 값(element)으로 이루어진 벡터
# i. c(element1, element2, ...)
# c : combine or concatenate의 약자
# character vector, numeric vector, logical vector를 만들 수 있음
# element 간에 규칙이 없을 때에 사용함
age <- c(27, 26, 26)
age
address <- c("서울", "서울", "홍콩")
income <- c(4500, 0, 0)
smoke <- c(TRUE, FALSE, FALSE)
v4 <- c(6, 12, 3)
v5 <- c(7, 19, 31)
v6 <- c(v4, v5)
v6

# ii. :
# numeric vector만 만듬
# 1씩 증가/감소되는 숫자들로 이루어짐
# start:end
# start < end : 1씩 증가
# start > end : 1씩 감소
# start = end : start or end
# start에 있는 숫자부터 시작해서 end에 있는 숫자를 넘지 않을 때까지
# 1씩 증가 또는 1씩 감소됨
v7 <- 1:5
v7
1:100000
5:1
-3.3:1
1:-3.3


# iii. seq(from = , to = , by = )
# seq : sequnce의 약자
# numeric vector만 만듬
# :의 확장
# 모든 증가/감소를 표현할 수 있음
# from : start
# to   : end
# by   : 증가/감소의 폭
# from, to, by : seq함수의 argument
seq(from = 1, to = 5, by = 1)
seq(from = 1, to = 5, by = 0.001)
# 문제 : 5부터 시작해서 1을 넘지 않을 때까지 0.5씩 감소하는 벡터
seq(from = 5, to = 1, by = -0.5)
seq(5, 1, -0.5)


# iv. sequence()
# numeric vector만 만듬
# sequence(숫자) : 1~숫자 사이의 정수로 된 벡터
# 숫자는 양수를 넣어야 함.
sequence(5)
sequence(6.8)
sequence(1)
sequence(-3)

# 문제
# 1, 1, 2, 1, 2, 3, 1, 2, 3, 4, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 6
c(1, 1:2, 1:3, 1:4, 1:5, 1:6)
c(sequence(1), sequence(2), sequence(3), sequence(4), sequence(5), sequence(6))
sequence(1:6)


# v. rep()
# rep : replicate의 약자
# character vector, numeric vector, logical vector에 적용
# rep(vector, times = , each = )
rep(1, times = 10)
rep(1, each = 10)

rep(1:2, times = 10)
rep(1:2, each = 10)

# 문제 : a, b, c, a, b, c, a, b, c, a, b, c
rep(c("a", "b", "c") , times = 4)
rep(1:3, times = 3, each = 5)

# 문제 : 1이 100개, 2는 29개, 3은 5개로 되어 있는 벡터
c(rep(1, times = 100), rep(2, times = 29), rep(3, times = 5))
rep(1:3, times = c(100, 29, 5))


# 1.2 attribute : 속성 ----
# (1) type           : mode(vector), is.xxxx(vector)
# (2) element의 개수 : length(vector)
hobby <- c("영화보기", "골프", "축구", "수영", "코딩")
length(hobby)

# (3) element의 이름 : names(vector)
names(hobby)
names(hobby) <- c("소호영", "이경아", "현경근", "안진환", "하정철")
hobby
names(hobby) <- NULL


# 1.3 indexing ----
# element의 위치
# 첫 번째는 1로 시작함


# 1.4 Slicing ----
# 벡터에서 일부 element를 잘라서 가져옴=추출하기
# vector[index]
food <- c("치킨", "푸딩", "파스타", "빵", "오트밀")
food[1]
food[2]
# 문제 : 2, 3, 5번째를 가져오세요.
food[c(2, 3, 5)]

# 문제 : 3, 4, 5 번째를 가져오세요
food[3:5]

# 문제 : 홀수 번째를 가져오세요.
food[seq(from = 1, to = 5, by = 2)]
food[seq(from = 1, to = length(food), by = 2)]


# 1.5 sort ----
# 오름차순
# 내림차순
# sort(vector, decreasing = )
# decreasing = FALSE : 오름차순, default
# decreasing = TRUE  : 내림차순
sort(hobby)
sort(hobby, decreasing = FALSE)
sort(hobby, decreasing = TRUE)


sort(hobby, decreasing = TRUE)[1:3]


# 1.6 연산(Compute)
v1 <- 1:3
v2 <- 4:6
v3 <- v1 + v2 # 벡터화(Vectorization)
v3

v4 <- 1:6     # 재사용 규칙(Recycling Rule)
v1 + v4

v5 <- 1:5
v1 + v5



# 2. Factor
# 하나의 열(Column)로 구성됨, 1차원 구조
# 집단 = 그룹 = 카테고리로 인식함

# 2.1 to make factor
# factor(vector, labels = , levels = , ordered = )
bt <- c("a", "b", "a", "b", "ab", "ab")
bt

bt.factor1 <- factor(bt)
bt.factor1

bt.factor2 <- factor(bt, labels = c("A형", "AB형", "B형"))
bt.factor2

bt.factor3 <- factor(bt, levels = c("ab", "b", "a"))
bt.factor3

bt.factor4 <- factor(bt, 
                     levels = c("ab", "b", "a"),
                     labels = c("AB형", "B형", "A형"))
bt.factor4

bt.factor5 <- factor(bt, 
                     levels = c("ab", "b", "a"),
                     labels = c("AB형", "B형", "A형"),
                     ordered = TRUE) # 순서형 자료로 인식
bt.factor5


# 2.2 attributes
# 집단의 개수와 집단의 이름
# levels(factor)
levels(bt.factor5)
levels(bt.factor5)[1]



# 3. Matrix
# 행(row)과 열(column)로 구성됨, 2차원 구조
# 벡터처럼 하나의 데이터 유형만 가짐
# 벡터화, 재사용규칙이 적용됨
# 벡터의 확장
# 통계, 딥러닝에서 많이 사용함

# 3.1 to make matrix
# (1) rbind(vector1, vector2, ...)
# bind vectors based on row
v1 <- 1:3
v2 <- 4:6
rbind(v1, v2)

# (2) cbind(vector1, vector2, ...)
# bind vectors based on column
cbind(v1, v2)

# (3) matrix(vector, nrow = , ncol = , byrow = TRUE)
matrix(1:4, nrow = 2, ncol = 2)
matrix(1:4, nrow = 2, ncol = 2, byrow = TRUE)


# 3.2 slicing
# matrix[row , col]
A <- matrix(1:4, nrow = 2, ncol = 2)
A
A[1 , ] # 1행 추출 : 벡터
A[ , 2] # 2열 추출 : 벡터

B <- matrix(1:6, nrow = 2, ncol = 3)
B
B[ , 2]               # 벡터
B[ , 2, drop = FALSE] # 행렬
B[ , 2:3]             # 행렬
B[1, 3]


# 3.3 행렬의 연산 : 덧셈, 뺄셈, 곱셈, 역행렬, 전치행렬
A <- matrix(1:4, nrow = 2, ncol = 2)
B <- matrix(5:8, nrow = 2, ncol = 2)
A + B
B + A
A - B

A %*% B # 곱셈
B %*% A 

# 역행렬(Inverse Matrix) : solve(matrix)
solve(A)
A %*% solve(A)
solve(A) %*% A

# x + y = 3
# x - y = 1
# 위 문제를 행렬로 풀기
A <- matrix(c(1, 1, 1, -1), nrow = 2, ncol = 2)
B <- matrix(c(3, 1), nrow = 2, ncol = 1)
A
B
solve(A) %*% B

# 전치행렬(Transpose matrix) : t(matrix)
# 행과 열을 바꿈
t(A)



# 4. Array : 배열
# 다차원 구조를 표현할 수 있음
# 벡터, 행렬의 확장

# 4.1 to make array
# array(vector, dim = )
array(1:10, dim = 12)         # vector, 1차원
array(1:10, dim = c(4, 4))    # matrix, 2차원
array(1:10, dim = c(2, 2, 5)) # array,  3차원




# 5. Data.Frame : 데이터 프레임
# 행과 열로 구성되어 있음, 2차원 구조
# 여러 개의 데이터 유형을 가질 수 있음
# 하나의 열에는 하나의 데이터 유형만 갖지만
# 다른 열은 다른 데이터 유형을 가질 수 있음
# R에서 데이터라고 하면 데이터 프레임

# 5.1 to make data.frame
# data.frame(vector1, vector2, matrix1, ....)
id <- 1:3
major <- c("경제", "소프트웨어", "컴퓨터공학")
income <- c(100000, 10000, 50000)
survey <- data.frame(id, major, income)
survey

cbind(id, major, income)



# 6. List : 리스트
# 데이터 분석 결과 중 일부가 리스트 형태임
# 리스트의 element로 vector, factor, matrix, array, data.frame, list를
# 가질 수 있음

# 6.1 to make list
# list(vector, factor, matrix, array, data.frame, list)
id <- 1:5
bt.factor <- factor(bt)
result <- list(id, bt.factor, survey)
result

# 6.2 slicing
result[1]   # list
result[[1]] # vector

result[2]   # list
result[[2]] # factor

result[3]   # list
result[[3]] # data.frame
