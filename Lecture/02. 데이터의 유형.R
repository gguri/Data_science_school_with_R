###############################################################################
### 수업내용 : 데이터의 유형                                                ###
###                                                                         ###  
### 작 성 자 : JuncChul HA                                                  ###
### 작성일자 : 2017.07.17(월)                                               ###
###############################################################################

## 1. 벡터(Vector) ****
## 2. 요인(Factor) vector의 일종으로 집단별로 인식하기 위해 사용
## 3. 행렬(Matrix) 
## 4. 배열(Array)
## 5. 데이터 프레임(Data.Frame) ****
## 6. 리스트(List)
## 7. 데이터 테이블(Data.Table)
## 8. 시계열(Time Series)

###############################################################################
## I. 벡터(Vector)
#   하나 이상의 값(원소 : element)으로 이루어짐
#   하나의 열(column)로 되어 있음
#   하나의 데이터 유형만 가짐(***)

## 1. 벡터를 생성하는 방법 -> 원소가 2개 이상일 때 사용하는 방법
## 벡터를 생성하기 보다는 데이터 일부를 추출하는 방법...?

##  (1) c(원소1, 원소2, ...)
##  c : combine, concatenate의 약자
##  numberic, character, logical 벡터를 만들 수 있다.
##  원소들 간의 규칙이 없을 경우에 사용함 ****
##  데이터를 추출 할 때 많이 사용한다.
age = c(29, 21, 25, 24, 27) # age라는 벡터를 생성함
mode(age)
is.numeric(age)

gender = c("female", "male", "female", "male", "male")
mode(gender)
is.character(gender)

marry = c(FALSE, FALSE, TRUE, FALSE)
mode(marry)
is.logical(marry)

v1 = c(1, "Lee", FALSE) 
v1
v2 = c(1, TRUE, FALSE)
v2
# vector는 하나의 데이터 유형만 가짐
# 데이터 유형의 우선 순위 = Character > Numeric > Logical
# 우선 순위가 높은 유형에서 하위 요형으로 변환은 잘 되지 않는다.

v1 = c(7, 36, 96)
v2 = c(8, 18, 28, 38)
c(v1,v2)


##  (2) :
##  numeric vector에만 적용됨
##  1씩 증가되는 숫자나 또는 1씩 감소되는 숫자로 이루어진 벡터를 생성할 때
##  규칙이 있는 숫자

##  start : end
##  start < end : 1씩 증가
##  start > end : 1씩 감소
##  start = end : start or end

## start부터 시작해서 end를 넘지 않을 때 까지
## 1씩 증가 또는 1씩 감소
## 항상 start부터 시작한다!
1:5
-2.3:1 
# start가 실수면 마무리도 실수다
1:-2.3 
# start가 정수면 마무리도 정수다


##  (3) seq(from=, to=, by=) 3개의 argument가 필수적으로 필요하다.
##  seq : sequence 약자 - 수열
##  numeric vector에만 사용
##  : 의 확장 개념
##  from : start
##  to   : end
##  by   : 증가 또는 감소 폭
seq(from = 1, to = 100, by = 5)
seq(from = 1, to = 5, by = 0.5)

## 문제 2
## 5부터 시작해서 1을 넘지 않을 때 까지 0.1씩 감소
seq(from = 5, to = 3, by = -0.1)
## by argument에는 증가, 감소를 표현하는 부호가 필요하다. (****)


##  (4) sequence(숫자)
##  numeric vector 에만 적용됨
##  1 ~ '숫자' 사이의 정수로 이루어진 벡터
sequence(10)
sequence(3.7)


##  (5) rep(vector, times=, each=)
##  times는 vector를 반복 - 
##  each는 vector 각각의 원소를 반복
##  numeric , character, logical vector에 적용됨
##  rep : replicate의 약자

rep(1, times = 10)
rep(1, each = 10)

rep(1:2, times = 5)
rep(1:2, each = 5)

## 문제 3
## "남자" 10개, "여자" 10개를 가지는 벡터를 생성하시오.
rep(c("남자","여자"), each = 3)

## ex <- c("남자","여자")를 할 시 쓸모없는 ex라는 변수가 생기고  
## rep를 할 시 메모리의 낭비가 발생
ex <- c("남자","여자")


rep(1, 40*(1-.8)) 
# length 7 on most platforms
rep(1, 40*(1-.8)+1e-7) 
# better
# (1-.8)이라는 값이 얼핏 보기에는 0.2지만 실제로는 0.1999999와 같은 값이기에 
# rep함수의 argument로 사용했을때 
# 40 * (1-.8)을 하면 7이라는 값이 R 상에서는 인식되는 현상? 
# 해결법 1e-7를 더해준다. 

rep(1:3, times=5, each=10)
# arguments 우선순위가 존재한다. each 

# 문제 4 : 1을 100번, 2를 50번, 3을 13번 출력
rep(1:3, c(100,50,13))
rep(1:3, times=c(100,50,13))

# 데이터를 수령하여 추출할때
# c, :, seq 3가지 
# c는 순서가 없는 데이터 추출
# :는 start, end 만큼 데이터 추출할때
# seq는 특정한 간격별로 데이터를 추출할때

###############################################################################
### 작성일자 : 2017.07.18(화)                                               ###
###############################################################################

##  (6) paste(벡터1, 벡터2 ..., sep=)
##  벡터의 각각의 원소들을 합쳐서 character 형태의 원소를 생성
##  결과는 character 형태! sep을 주지 않으면 공백이 들어간다.
paste(1, 1)
paste(1, 1, sep="-")
paste(1, 1, sep="")
paste("x", 1, sep="")
# 변수명, 이름을 줄 때 사용하면 좋다.
paste(1:3, 1:3) 
paste(1:3, 1:3, sep="-")
# "1 1" "2 2" "3 3"
# 벡터화(Vectorization) ****

# 문제 8
# "X1", "X2", "X3", "X4"를 가지는 벡터를 생성
paste("X", 1:4, sep="")
# 재활용 
# 규칙과 벡터화가 같이 적용됨


##  2. 벡터의 속성
##  (1) length(벡터) : 벡터가 가지는 원소의 개수
age = c(26, 27, 25)
length(age)

##  (2) names(벡터) : 원소의 이름
names(age)
# NA(Not Available)-> 통계에서 : Missing value = 결측치, 결측값 **** 
# : 데이터는 가지고 있지만 실제 주소값 내부에는 데이터가 없다
# ex) 어떤 사람은 몸무게를 알려주지만 다른 한명은 비밀이라서 몸무게를 알려주지 않았다.

# NULL : 객체, 개체(Object)
# R에서는 데이터, 그래프, 분석된 결과

# 데이터를 그래프로 나타낼 때 NA는 특정 값이 없는 것이고, 
# NULL은 그래프 자체가 없다는 의미
age
names(age) = c("Ha", "Jeong", "Kim")
names(age)
# names의 결과는 character type의 벡터

age
# 하나의 열을 가지는 벡터구나. names는 age 벡터의 부수적인 설명 역할

names(age) = NULL

##  3. 벡터의 슬라이싱(Slicing) = 인덱싱(Indexing)
##  벡터 중에서 일부의 원소(들)을 추출 
##  벡터[index]
##  index가 1부터 시작

income = c(500, 1000, 3500, 400, 300)
income[1:3]
income[5]

# 문제 5
# 1, 4, 5번째의 원소를 한 번에 가져오기
income[c(1,4,5)] # 문제 5

# 문제 6
# 2번째 부터 5번째 가져오기
income[2:5] # 문제 6

# 문제 7
# 홀수번째 원소 값 가져오기
income[seq(from=1, to=length(income), by=2)] # 문제 7


##  4. 벡터의 연산 : +, -, *, /
v1 = 1:3
v2 = 4:6
v3 = v1 + v2
v3

v3 = 1:6
v1 + v3
# 데이터의 갯수 v1 = 3 / v3 = 6이다 
# 연산시 데이터의 개수가 큰 만큼 채워준다 
# R의 특징 - Recycling Rule

v4 = 1:8
v1 + v4
# 결과는 나오지만 Warning message가 나온다. 



###############################################################################
## II. 요인(Factor)
##  벡터의 일종
##  차이점 : 집단(group)으로 인식함
##  1차원 - 하나의 열로 구성
##  기본적으로 벡터는 집단으로 인식하지 않음. 

## factor(벡터, labels=, levels, ordered=)
bt = c("ab", "ab", "a", "a", "b")
bt
# ab, a, b 혈액형으로 인식하지 않는다.

bt_factor <- factor(bt)
bt_factor
# Levels: a ab b => 3개의 집단으로 인식함

bt_factor2 <- factor(bt, 
                     labels = c("A형","AB형","B형"))
bt_factor2
# labels: 데이터 나오는게 바뀜 
# ! -> 데이터 자체가 바뀌는것인지 확인

bt_factor3 <- factor(bt,
                     levels = c("b","ab","a"))
bt_factor3
# levels: 집단의 순서 - 데이터 자체는 바뀌지 않지만 b, ab, a순으로 바뀌게 됨

bt_factor4 <- factor(bt,
                     levels = c("b","ab","a"),
                     labels = c("B형","AB형","A형"))
bt_factor4
# levels와 labels를 같이 사용할 때 labels의 값들은 levels에 대응되도록 사용해야 한다

bt_factor5 <- factor(bt, 
                     levels  = c("b","ab","a"), 
                     labels  = c("A형","AB형","B형"),
                     ordered = TRUE)
bt_factor5

# ordered : 특정한 결과값이 의미있게 구분할 때 사용 -> 부등호가 나타남

## factor의 속성
##  (1) levels(요인)
levels(bt_factor)

##  (2) ordered(요인) : 집단의 순서가 의미 있도록 변경
ordered(bt_factor)
# bt.factor의 속성을 ordered=TRUE로 만들어 주겠다는 것


###############################################################################
## III. 행렬(Matrix)
##  행(row)과 열(column)로 구성되어 있음
##  2차원
##  벡터의 확장 -> 1개 이상의 열로 구성
##  벡터의 규칙이 대부분 적용 
##  즉, 하나의 데이터 유형을 가지며 
##  Recycing Rule, Vectorization 적용 가능

##  1. 행렬을 만드는 방법
##  (1) rbind(벡터1, 벡터2, ...), cbind(벡터1, 벡터2, ...)
v1 = 1:3
v2 = 4:6
M1 = rbind(v1, v2) 
# 수학에서의 변수는 대문자로 사용
M1
# rbind 용어 의미 bind based on row? 맞는지 확인해보자
# row를 기준으로 벡터를 결합하여 행렬을 생성

M2 = cbind(v1, v2)
M2

v3 <- 1:6
M3 <- cbind(v1, v2, v3)
M3

##  (2) matrix(벡터, nrow=, ncol=, byrow=)
matrix(1:4, nrow=2, ncol=2)
# R은 열(column)이 우선으로 채워진다
# byrow=TRUE 는 행(row)을 우선으로 채워라!
M3 = matrix(1:4, nrow=2, ncol=2, byrow=TRUE)
matrix(1:4, nrow=3, ncol=3)


##  2. 행렬의 슬라이싱
##  행렬[행index, 열index]
M3
M3[1, ]    # 1행
M3[2, ]    # 2행
M3[1:2, ]  #1,2행 
M3[,1 ]    # 2열
M3[,1:2 ]  # 1,2열
M3[1,2 ]   # 1행, 2열


##  3. 행렬의 덧셈과 뺄셈
##  형태(shape)가 동일해야한다. 2x3 은 2x3만 연산가능
A <- matrix(1:4, nrow=2, ncol=2)
B <- matrix(5:8, nrow=2, ncol=2)
A + B
A - B
A * B # 단순한 index끼리 연산 하는 것 뿐 행렬의 곱셈은 아니다.

##  4. 행렬의 곱셈 : A_r1,c1 %*% B_r2,c2 
##  조건 : c1 = r2 -> 곱하고자하는 A의 열과 B의 행의 개수가 같아야 한다.
##  최종 결과는 r1 by c2 matrix가 나타남
A = matrix(1:4, nrow=2, ncol=2)
B = matrix(5:8, nrow=2, ncol=2)
A %*% B


##  5. 역행렬(Reverse Matrix)
##  조건1 : 정방행렬(Square Matrix) - 행과 열의 개수 같음
##  조건2 : 행렬식이 0이 아니어야 함
## A(a11, a12
##   a21, a22)
##  조건 1 : 2by2 행렬
##  조건 2 : (a11 x a22) - (a12 x a21) != 0 
## A(a22, -a12
##   -a21, a11)
##  위의 결과에 1/(a11 x a22) - (a12 x a21) 를 곱해줌
##  solve() 함수를 사용
A1 = matrix(1:4, nrow=2, ncol=2)
A2 = solve(A1)
A2
A1 %*% A2 
# 단위행렬. A1와 A2(A1의 역행렬)을 곱하면 단위행렬이 나옴

B1 = matrix(c(2, 1, -1, 3), nrow=2, ncol=2)
B2 = matrix(c(3, 10), nrow=2, ncol=1)
solve(B1) %*% B2


##  5. 전치행렬(Transpose matrix)
##  행과 열을 바꿈
##  t(행렬)
t(A)
A


###############################################################################
## IV. 배열(Array)
##  다차원
##  vector, 행렬의 확장
##  벡터의 특징 그대로 적용됨

## array(벡터, dim=)
array(1:10, dim=10)
# dim에는 하나의 숫자만 
# 1차원 형태를 지닌 벡터의 결과 
array(1:10, dim=3:4)
# dim에 3,4 => 2개의 숫자
# 2차원 형태를 지닌 행렬의 결과
array(1:10, dim=c(3,4,2))
# 3행 4열 2높이 => 3차원


###############################################################################
## V. 데이터 프레임(Data.Frame) ****
##  행, 열로 구성됨, 2차원 구성 
##  여러 개의 데이터 유형을 가질 수 있음 ****
##  단, 하나의 열은 하나의 데이터 유형만 가짐 ****

## data.frame(벡터1, 벡터2, 행렬, ...)
id = 1:5
gender = c("m", "m", "m", "f", "m")
address = c("구파발", "강동", "압구정", "수원", "용인")
survey = data.frame(id, gender, address)
survey

###############################################################################
## VI. 리스트(List)
##  분석한 결과를 저장할 때에 많이 사용하는 형태
##  가장 유연한 데이터 형태
##  리스트의 원소로 벡터, 요인, 행렬, 배열, 데이터 프레임, 리스트를 가질 수 있음

## list(벡터, 요인, 행렬, 배열, 데이터 프레임, 리스트, ...)

v1 = 1:10
v2 = 1:3
v3 = c("ch", "nu", "lo")
v4 = c(TRUE, FALSE)
m1 = cbind(v1, v2)
result = list(v1, v2, v3, v4, m1, survey)
result

## list의 슬라이싱
## [1] vs [[1]]

a1 = result[1]
a2 = result[[1]]

b1 = result[4]
b2 = result[[4]]
b1
b2
c1 = result[3]
c2 = result[[3]]
d1 = result[[4]]
e1 = result[[4]]
mode(e1)
# 대괄호 1개 사용 : 결과는 list
# 대괄호 2개 사용 : numeric, character, logical, list로 나타남. 
# data.frame의 결과가 list로 나타나는 것은 여러개의 데이터 타입이 존재하기 때문인 듯

