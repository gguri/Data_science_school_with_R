#############################################################
### 수업내용 : 데이터 핸들링 = 데이터 전처리              ###
###                                                       ###
### 작 성 자 : JuncChul HA                                ###
### 작성일자 : 2017.07.19(수)                             ###
#############################################################

## Data Handling = Data Pre-processing

#############################################################

# 소스코드를 전달할때 다른 누군가는 설치가 필요할 수도 있다.
options(repos="https://cran.rstudio.com")
install.packages("readxl") 
install.packages("data.table")
install.packages("DT")
install.packages("openxlsx")
library(readxl)
library(data.table)
library(DT)
library(openxlsx)

## 작업공간(working Directory)
## setwd("파일위치")

##########################################################

## 데이터 읽어오기
# 외부 데이터를 읽어오면 data.frame 형태로 저장된다
student = readxl::read_excel(path      = "fs/data/student.xlsx",
                             sheet     = "data",
                             col_names = TRUE)

##  1. 데이터 전체보기
##  (1) View(데이터)
View(student)

##  (2) 데이터 : 콘솔(Console)에 출력
student


##  2. 데이터의 구조(Structure) 보기
##  str(데이터)
str(student)
str(student$id)


##  3. 데이터의 일부 보기
##  (1) head(데이터)
head(student)
# 상위 6개의 데이터를 보여줌
head(student, n = 3)

##  (2) tail(데이터)
tail(student)
# 하위 6개의 데이터를 보여줌
tail(student, n = 3)


##  4. 데이터 프레임의 속성
##  (1) 행의 개수 : nrow(데이터) 
nrow(student) 

##  (2) 열의 개수 => 변수의 개수 : ncol(데이터) 
ncol(student)

##  (3) 행의 이름 : rownames(데이터) => 결과 character형의 벡터
rownames(student)

##  (4) 열의 이름 = 변수의 이름 : colnames(데이터) 결과 character형의 벡터
colnames(student)

##  (5) 차원(dimension) : 행, 렬  
##  dim(데이터) => 행과 열의 개수가 나옴
dim(student)
dim(student)[1] # 행
dim(student)[2] # 열

##  (6) 차원의 이름 : 행의 이름, 열의 이름
##  dimnames(데이터)
dimnames(student)
dimnames(student)[1] # 리스트
dimnames(student)[[1]] # 벡터
dimnames(student)[[1]][3] # 벡터( dimnames(student)[[1]] )의 3번 째 것


##  5. 데이터(data.frame)의 슬라이싱
##  데이터[행index, 열index] => data.frame은 행,열의 2차원 구조
##  vectorization이 적용됨. for문 없이 연산을 끝까지 수해
##  (1) 열(Column)
##  데이터[ , index]
student[ , 1]
student[ , 2]

# 문제 1 : 2,3,6 번째 열을 가져오세요
student[ , c(2, 3, 6)]

# 문제 2 : 4번째 부터 8번째
student[ , 4:8]

# 문제 3 : 짝수번째
student[ , seq(from = 2, 
               to   = ncol(student), 
               by   = 2)]

# vector에서는 length
# data.frame에서는 nrow, ncol

student[ , "weight"]
student[ , "height"]
student[ , c("weight", "height")]
# index가 chracter 이므로 c()만 사용가능


## 변수명에 특정한 패턴이 있는 것을 추출
## grep("패턴", 문자열)
colnames(student)

# 변수명 중에서 'e'라는 글자를 포함하고 있는 변수명의 위치
grep("e", 
     colnames(student))

# 'e'라는 글자를 포함하고 있는 변수명
grep("e", 
     colnames(student), 
     value=TRUE) 

# 'e'라는 글자를 포함하고 있는 데이터를 추출
student[ , grep("e", 
                colnames(student), 
                value=TRUE)]

# 'a'라는 글자로 시작하는 데이터를 추출 => ^a
student[ , grep("^a", 
                colnames(student), 
                value=TRUE)]

# 't'라는 글자로 끝나는 데이터를 추출 => t$
student[ , grep("t$", 
                colnames(student), 
                value=TRUE)]

# 't'라는 글자로 끝나거나, 'a'라는 글자로 시작하는 데이터를 추출
student[ , grep("t$|^a", 
                colnames(student), 
                value=TRUE)]

# 정규표현식을 익히자

##  (2) 행(row)
student[1, ]
student[c(1,3,4), ]
student[4:10, ]
student[seq(from = 1,
            to   = nrow(student),
            by   = 3), ]

# 성별이 여자인 데이터만 가져오기
student.female = student[student$gender == "여자", ]

# 거주지가 수원이 아닌 사람들의 데이터
student[student$address != "수원", ]

# 몸무게가 50 이하인 사람들의 데이터
student[student$weight <= 50, ]

# 나이가 30대 이상이고, 키는 175 이상인 사람
student[(student$age >= 30) & (student$height >= 175), ]

# 나이가 30대 이상이거나 키는 175 이상인 사람
student[(student$age >= 30) | (student$height >= 175), ]


##  (3) 행, 열 
student[ 4:10,   # 행
         c("id", "weight", "height") ]

# 문제 7:
# 키가 170cm 이상이고, 몸무게는 60kg 이상인 사람들의 
# 변수명에 'e'라는 글자가 들어가는 데이터
student[(student$height >= 170) & (student$weight >= 60),
        grep("e", 
             colnames(student)
             )]


##  6. 새로운 변수 만들기
##  데이터$변수명 = 연산(수식)
student$bmi = student$weight / ((student$height/100)^2)

# ifelse(조건, 참일때 표현식, 거짓일때 표현식)
student$age_group = ifelse(student$age >= 30, "30대 이상", "20대 이하")

# 문제 8
# age_group2 : 20대 초반, 20대 중반, 30대 이상)
# 25세 미만, 25~29, 30~
student$age_group2 = ifelse(student$age >= 30, "30세 이상", 
                            ifelse(student$age >= 25, "20대 중반", "20대 초반"))

# cut(데이터명$변수명, breaks=구간정보) => numeric data에 적용
student$bmi_group = cut(student$bmi, 
                        breaks = c(0, 18.5, 23, 25, 30))
# 데이터의 결과를 보면 ( ]와 같이 소괄호, 대괄호로 표현된다.
# (18.5, 23] => 18.5초과 23이하 
# 즉 () 소괄호는 초과 / [] 대괄호는 이하
# 0과 30초과 값들은 NA로 표시됨

student$bmi_group = cut(student$bmi, 
                        breaks = c(0, 18.5, 23, 25, 30),
                        right=FALSE)

view(student)
# right = FALSE를 주게되면 괄호의 위치가 바뀌게 됨 
# [18.5, 23) => 18.5 이상 23 미만
# 30이상 값들은 NA로 표시됨

score = readxl::read_excel(path = "fs/data/score.xlsx",
                           sheet = 1,
                           col_names = TRUE)

# 각 행들의 평균 구하기
score$avg = rowMeans(score[ , 2:6]) 
# 성적들의 평균. id는 제외
?colMeans

##  7. 데이터의 값을 수정하기 
home = readxl::read_excel(path      = "fs/data/home.xlsx",
                          sheet     = 1,
                          col_names = TRUE)
View(home)
home
home[home$price == 500, "price"] = 50
home
home[home$price == 500, "price"]
home[home$price == 500,]

##  8. 데이터 정렬하기
##  (1) 벡터를 정렬하기 : sort(벡터, decreasing=)
##  기본 오름차순 정렬
money = c(45, 50, 40, 50, 50, 30, 500)
money
sort(money)
sort(money, decreasing = TRUE) # 내림차순

##  (2) order(데이터명$변수명, decreasing=)
##  sort는 벡터에서만 사용가능 하다. data.frame에서 사용불가능
order(money)
View(money)

# order 를 쓰면 정렬될 인덱스만 알려준다 ****
money[order(money),]
# 데이터는 행이 바뀌는 것 => data.frame 슬라이싱의 행 자리에 들어간다
student[ order(student$height, decreasing = TRUE) , ]

# 성별 오름차순 / 키 오름차순
student[ order(student$gender, student$height) , ]

# 성별 내림차순 / 키 내림차순
student[ order(student$gender, student$height, decreasing = TRUE ) , ]

# 성별 오름차순 / 키 내림차순
# 조건이 다르니 -를 사용
student[ order(student$gender, -student$height) , ]

# 성별 내림차순 / 키 오름차순
# - 는 numeric에만 적용 가능
# decreasing 은 모든 값(성별, 키)에 내림차순을 적용
student[ order(student$gender, -student$height, decreasing = TRUE ) , ]


# 성별 오름차순 / 거주지 내림차순
# character 타입의 데이터를 따로 정렬하려면? 
# - 는 numeric에만 적용된다 => 기본 기능에서는 못 한다
# data.table 패키지를 사용
studentDT = as.data.table(student)
str(studentDT) # data.frame, data.table 2가지 형태 모두 인식
studentDT[ order(gender, -address) , ]  # 결과를 콘솔 화면에 보여주기만 함
setorder(studentDT, gender, -address)  # setorder 정렬해서 결과 저장

## 시간이 얼마나 소요되는지를 알려주는 함수
## system.time(작업내용)
DF = data.frame(id=1:1000000,
                type=sample(letters, size=10000000, replace=TRUE))
# letters 는 소문자 26개를 가지는 벡터
sample(letters, size=5) # letters 에서 샘플 5개만 뽑기
sample(letters, size=10000000) # 표본의 크기가 모집단의 크기보다 크다.
sample(letters, size=10000000, replace=TRUE) # replace=TRUE 뽑은거 중복 가능
DT = as.data.table(DF)

# system.time 에서는 =를 사용하면 error가 나온다
system.time( x <- DF[DF$type == "a", ] )
system.time( x = DF[DF$type == "a", ] )
# setkey()는 hash 자료구조를 사용한 탐색 알고리즘
data.table::setkey(DT, type)
system.time(x <- DT[J("a"), ])

# data.table::setkey(), J(), fread(), datatable()
# data.table cheet sheet => data.table에서 많이 사용하는 패키지
# data.table의 해당 함수들을 공부하자

DT::datatable(student[student$gender == "남자", ])

##  9. 데이터 합치기
##  (1) rbind(데이터1, 데이터2) -> 위. 아래로 데이터 합치기
df1 = data.frame(id     = 1:3,
                 age    = 10:12,
                 gender = c("F","F","M"))

df2 = data.frame(id     = 4:5,
                 age    = c(20,30),
                 gender = c("M","M"))
df1;df2
df3 = rbind(df1, df2)
df3

##  (2) merge(데이터1, 데이터2, by=)
df4 = data.frame(id  = c(1, 2, 4, 7),
                 age = c(10, 20, 40, 70))
df5 = data.frame(id = c(1, 2, 3, 6, 10),
                 gender = c("M", "M", "F", "M", "F"))
df4;df5

# merge 4가지 방법
##  i. inner join(교집합)
##  merge(데이터1, 데이터2, by=)
##  inner join은 2가지 데이터만 join. 3가지 이상은 다른 기능으로
##  by는 PK(Primary Key)
merge(df4, df5, by="id")

##  ii. outer join  
##  - full join(합집합)
##  R은 숫자는 NA  / 문자는 <NA> 로 표시해서 구분해준다.
##  merge(데이터1, 데이터2, by=, all=TRUE)
##  argument all=TRUE
merge(df4, df5, by="id", all=TRUE)
DT::datatable(merge(df4, df5, by="id", all=TRUE))

##  - left join
##  merge(데이터1, 데이터2, by=, all.x=TRUE)
merge(df4, df5, by="id", all.x=TRUE)

##  - right join
##  merge(데이터1, 데이터2, by=, all.y=TRUE)
merge(df4, df5, by="id", all.y=TRUE)

# 여러개의 테이블을 2개씩 말고 빠르게 join 하는 방법은 구글링해보자!

##  10. R데이터 저장하기
##  (1) 외부 데이터로 저장하기
##  write.csv(R데이터, file="파일위치/파일명.csv")
write.csv(student,
          file      = "fs/data/student.csv",
          row.names = FALSE)
# row.names = FALSE    행이름은 저장하지 마라

##  (2) R데이터로 저장하기
##  save(R데이터, file="파일위치/파일명.RData")

##  (3) R데이터 불러오기
##  load(file="파일위치/파일명.RData)

