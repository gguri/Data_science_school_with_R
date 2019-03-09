#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
# 수업내용 : Data Handling = Data Pre-processing #
#                                                #
# 작 성 자 : 이부일                              #
# 작성일자 : 2018년 3월 20일 화요일              #
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#

# 0. 패키지 설치/로딩하기 ----
install.packages("readxl")    # 엑셀 불러오기
install.packages("DT")        # 웹형태로 데이터 출력
install.packages("writexl")   # 엑셀로 저장하기
install.packages("data.table")# 데이터핸들링/분석
library(readxl)
library(DT)
library(writexl)
library(data.table)


# 1. 작업공간 설정하기 ----
setwd("d:/da/")


# 2. 데이터 불러오기 ----
profileDF <- readxl::read_excel(path      = "profile.xlsx",
                                sheet     = 1,
                                col_names = TRUE)


# 3. 데이터 전체 보기 ----
# 3.1 dataname : console에 출력이 됨
profileDF

# 3.2 View(dataname)
View(profileDF)


# 4. 데이터 일부 보기 ----
# 4.1 head(dataname, n = ) : console에 출력
head(profileDF)
head(profileDF, n = 3)

# 4.2 tail(dataname, n = ) : console에 출력
tail(profileDF)
tail(profileDF, n = 3)

# 4.3 DT::datatable(head(dataname, n = )) : 웹형태로 출력
DT::datatable(head(profileDF))
DT::datatable(profileDF)


# 5. 데이터의 구조(Structure) 보기 ----
# str(data)
str(profileDF)


# 6. 데이터의 속성(Attributes)
# 6.1 행의 개수 : nrow(data)
nrow(profileDF)

# 6.2 열의 개수 : ncol(data)
ncol(profileDF)

# 6.3 행의 이름 : rownames(data)
rownames(profileDF)

as.numeric(rownames(profileDF))
as.character(profileDF$id)

# 6.4 열의 이름 = 변수명 : colnames(data)
colnames(profileDF)

# 6.5 차원(Dimension)
# dim(data)
dim(profileDF)
dim(profileDF)[1] # 행의 개수
dim(profileDF)[2] # 열의 개수


# 6.6 차원의 이름(dim names) : dimnames(data)
dimnames(profileDF)
dimnames(profileDF)[1]   # 행의 이름 : list
dimnames(profileDF)[[1]] # 행의 이름 : vector
dimnames(profileDF)[2]   # 열의 이름 : list
dimnames(profileDF)[[2]] # 열의 이름 : vector


# 7. 데이터의 슬라이싱
# data[rowIndex , colIndex]

# 7.1 column
# data[ , colIndex]
# (1) 열의 위치를 알 때
profileDF[ , 1] # id
profileDF[ , 2] # gender

# 문제 : 1, 4, 5번째 열을 가져오세요.
profileDF[ , c(1, 4, 5)]

# 문제 : 2, 3, 4번째 열을 가져오세요.
profileDF[ , 2:4]

# 문제 : 홀수 번째 열을 가져오세요.
profileDF[ , seq(from = 1, to = ncol(profileDF), by = 2)]


# (2) 열의 이름을 알 때
profileDF[ , "gender"]
profileDF[ , "height"]

# 문제 : id, height, weight를 가져오세요.
profileDF[ , c("id", "height", "weight")]

# 열의 이름 = 변수명에 특정한 패턴이 있는 경우
# grep("pattern", characterVector, value = )
colnames(profileDF)

# 변수명 중에서 'e'라는 문자를 포함하고 있는 위치를 알려줌
grep("e", colnames(profileDF), value = FALSE)
grep("[e|a]", colnames(profileDF), value = FALSE)


# 변수명 중에서 'e'라는 문자를 포함하는 열을 추출
profileDF[ , grep("e", colnames(profileDF), value = FALSE)]

# 변수명 중에서 'e'라는 문자를 포함하고 있는 값(변수명)을 알려줌
grep("e", colnames(profileDF), value = TRUE)
profileDF[ , grep("e", colnames(profileDF), value = TRUE)]


# 변수명 중에서 'h'라는 문자로 시작하는 변수명(또는 위치)
grep("^h", colnames(profileDF))
profileDF[ , grep("^h", colnames(profileDF))]

# 변수명 중에서 't'라는 문자로 끝나는 변수명(또는 위치)
grep("t$", colnames(profileDF))
profileDF[ , grep("t$", colnames(profileDF))]


# 7.2 row
# data[rowIndex , ]
profileDF[1 , ]
profileDF[c(1, 4, 5) , ]
profileDF[2:4 , ]
profileDF[seq(from = 1, to = nrow(profileDF), 2) , ]

# 성별이 '여자'인 데이터
profileDF[profileDF$gender == "여자" , ]

# 전공이 '경영'인 데이터
profileDF[profileDF$major == "경영" , ]

# 몸무게가 60kg 이하인 데이터
profileDF[profileDF$weight <= 60 , ]

# 몸무게가 60kg 이하이고 전공은 '통계'인 데이터
profileDF[(profileDF$weight <= 60) & (profileDF$major == "통계") , ]

# 몸무게가 60kg 이하이거나 또는 전공은 '통계'인 데이터
profileDF[(profileDF$weight <= 60) | (profileDF$major == "통계") , ]

# %in%
# 원소(element) %in% 집합
# 전공이 '경영' 이거나 '통계'인 사람의 데이터
profileDF[(profileDF$major == "경영") | (profileDF$major == "통계") , ]
profileDF[profileDF$major %in% c("경영", "통계")  , ]


# 7.3 row and column
# 전공이 '경영' 이거나 '통계'인 사람의 height, weight를 가져오세요.
profileDF[profileDF$major %in% c("경영", "통계")  , c("height", "weight")]



# 8. 새로운 변수 만들기 ----
# data$newVariable <- 작업
# 8.1 연산 ----
profileDF$bmi <- profileDF$weight / (profileDF$height / 100)**2

# 8.2 cut() ----
# cut(data$variable,
#     breaks = 구간정보,
#     right  = TRUE) # 초과 ~ 이하 구간
#     right  = FALSE # 이상 ~ 미만 구간

profileDF$bmi.group <- cut(profileDF$bmi,
                           breaks = c(0, 18.5, 23, 40),
                           right  = FALSE)
levels(profileDF$bmi.group) <- c("저체중", "정상", "과체중")

# 8.3 ifelse() ----
# ifelse(조건, 참일때의 값, 거짓일 때의 값)
ifelse(profileDF$bmi < 18.5, "저체중", "그외")
profileDF$bmi.group2 <- ifelse(profileDF$bmi < 18.5, 
                               "저체중",
                               ifelse(profileDF$bmi < 23, "정상", "과체중"))

# 9. 변수 삭제하기 ----
# data$variable <- NULL
profileDF$bmi.group2 <- NULL


# 10. 외부 데이터로 저장하기 ----
# 10.1 txt ----
# write.table(data, 
#             file      = "directory/filename.txt",
#             sep       = ",",
#             row.names = FALSE)
write.table(profileDF,
            file      = "profile_0321.txt",
            sep       = ",",
            row.names = FALSE)

# 10.2 csv ----
# write.csv(data,
#           file      = "directory/filename.csv",
#           row.names = FALSE)
write.csv(profileDF,
          file      = "profile_0321.csv",
          row.names = FALSE)


# 10.3 excel ----
# R의 기본 기능에서는 못함
# writexl::write_xlsx(data,
#                     path = "directory/filename.xlsx")
writexl::write_xlsx(profileDF,
                    path = "profile_0321.xlsx")


# 11. 데이터의 목록 보기
# ls() : list segment의 약자
ls()


# 12. R데이터로 저장하기
# save(data, file = "directory/filename.RData")
save(profileDF, file = "profile_0321.RData")


# 13. 데이터 삭제하기
# 13.1 몇 개 지우기
# rm(data1, data2, ...)    : remove의 약자
# remove(data1, data2, ...)
rm(profileDF)

# 13.2 모두 지우기
# rm(list = ls())
x1 <- 10
x2 <- 1:10
x3 <- c("A", "B")
rm(list = ls())


# 14. R데이터 불러오기
# load(file = "directory/filename.RData")
load(file = "profile_0321.RData")
View(profileDF)


# 15. 데이터 정렬하기
# data[order(data$variable, decreasing = ) , ]
age <- c(31, 21, 21, 28, 27, 24)
age[1]
order(age, decreasing = FALSE)
order(age, decreasing = TRUE)
age[order(age, decreasing = FALSE)] # 오름차순
age[order(age, decreasing = TRUE)]  # 내림차순

# 성별 : 오름차순 정렬
profileDF[order(profileDF$gender, decreasing = FALSE) , ]

# 성별 : 내림차순 정렬
profileDF[order(profileDF$gender, decreasing = TRUE) , ]

# 키 : 오름차순 정렬
profileDF[order(profileDF$height, decreasing = FALSE) , ]

# 성별 : 오름차순, 키 : 오름차순
profileDF[order(profileDF$gender, profileDF$height, decreasing = FALSE) , ]

# 성별 : 내림차순, 키 : 내림차순
profileDF[order(profileDF$gender, profileDF$height, decreasing = TRUE) , ]

# 성별 : 오름차순, 키 : 내림차순
profileDF[order(profileDF$gender, -profileDF$height, decreasing = FALSE) , ]

# 성별 : 내림차순, 키 : 오름차순
profileDF[order(profileDF$gender, -profileDF$height, decreasing = TRUE) , ]

# 성별 : 내림차순, 전공 : 오름차순
profileDF[order(profileDF$gender, -profileDF$height, decreasing = TRUE) , ]
# 기본 기능에서는 안됨

# dataDT <- data.table::as.data.table(data)
profileDT <- data.table::as.data.table(profileDF)
profileDT
profileDT[order(gender, -major)]



# 16. 데이터 합치기
# 16.1 위/아래 : rbind(data1, data2)
DF1 <- data.frame(id = 1:3, age = c(10, 20, 30))
DF1

DF2 <- data.frame(id = 4:6, age = c(40, 50, 60))
DF2

DF3 <- rbind(DF1, DF2)
DF3

# 16.2 왼쪽 / 오른쪽 : cbind(data1, data2)
# 16.3 왼쪽 / 오른쪽 : merge(data1, data2, by = "primary key")
DF4 <- data.frame(id = c(1, 2, 6, 7), age = c(10, 20, 60, 70))
DF5 <- data.frame(id = c(1, 6, 8, 9, 10), bt = c("a", "a", "b", "ab", "o"))
DF4
DF5

# (1) inner join
# merge(data1, data2, by = "primary key")
merge(DF4, DF5, by = "id")

# (2) outer join : full join
# merge(data1, data2, by = "primary key", all = TRUE)
merge(DF4, DF5, by = "id", all = TRUE)

# (3) outer join : left join
# merge(data1, data2, by = "primary key", all.x = TRUE)
merge(DF4, DF5, by = "id", all.x = TRUE)

# (4) outer join : right join
# merge(data1, data2, by = "primary key", all.y = TRUE)
merge(DF4, DF5, by = "id", all.y = TRUE)
