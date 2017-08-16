###############################################################################
### 수업내용 : 기초 사용법                                                  ###
###                                                                         ###
### 작 성 자 : JuncChul HA                                                  ###
### 작성일자 : 2017.07.17(월)                                               ###
###############################################################################

## 1. 연산자(Operator)
##  (1) 산술 연산자 : +, -, *, /, **, ^, %%(나머지), %/%(몫)
##  우선 순위에 항상 신경 쓰자
5 ** 2
5 ^ 2
5 %% 2  
5 %/% 2 
3 ^ (1/2)

# 문제 1
# 루트 3은 얼마일까요?
3 ^ (1/2) # 1.732051

##  (2) 할당 연산자 : <-, =, ->
## <-, = 기능은 거의 같지만 특정 함수에서 기능의 에러가 날 수 도 있다.
x <- 3

a <- b = 3
a = b <- 3


##  (3) 비교 연산자 : >, >=, <, <=, ==, !=(같지 않다), !(결과 부정-반대로)
3 > 4 # 결과 FALSE 가 대문자로 출력 -> case sensitive
3 != 4     
!(3 == 4)  

##  (4) 논리 연산자 : &(ampersand) - and, |(vertical bar) - or
##  조건이 여러개면 ()를 써서 조건을 표현해라
(3 > 4) & (3 < 5)
(3 > 4) | (3 < 5)


## 2. 데이터의 유형( Type of Data ) - 대부분의 데이터는 숫자, 문자
##  (1) 수치형(Numeric)
##  (2) 문자형(Character)
##  (3) 논리형(Logical)
x = 3 
y1 = 'Love is choice.'
y2 = "Love is choice."
y3 = " 'Love' is choice. "
Z <- TRUE
y3 = " 'Love' is choice. "
y3
## 3. 데이터의 유형 알아내기
##  (1) mode(데이터) - 해당되는 데이터의 유형을 알려줌 -> return 형태는 문자형
mode(x) # 반환값 "numeric"은 character(문자형)으로 반환된다.
if(mode(x) == "numeric"){ 
x}
# 문법에 적용할때 return 값의 형태를 아는것은 필수적
##  (2) is.xxxx(데이터) -> return 형태는 논리형
# x데이터의 형태가 numeric 인가요? -> TRUE
is.numeric(x) 
if(is.numeric(x)){
  "TRUE"
}
is.character(y1)  
is.logical(Z)


## 4. 데이터 형 변환
## as.xxxx(데이터)
x1 <- 3
x2 <- "3"
x3 <- "Lee"
x4 <- TRUE
as.numeric(x2)
as.numeric(x3)
as.numeric(x4) 
# TRUE = 1, FALSE = 0

as.character(x1)
as.character(x4)

as.logical(x1) 
as.logical(x2)
as.logical(x3)
as.logical(x4)
# 숫자0만 FALSE, 나머지 모든 숫자 값은 TRUE
