###############################################################################
### 수업내용 : 외부 데이터 읽어오기                                         ###
###                                                                         ###
### 작 성 자 : JuncChul HA                                                  ###
### 작성일자 : 2017.07.18(화)                                               ###
###############################################################################

## 외부 데이터 : txt, csv, excel(xls, xlsx)

##  1. 텍스트 데이터 : txt
##  (1) 구분자(Separator) : 공백 하나(blank, white space)
##  데이터명 = read.table(file="파일위치/파일명.txt", 
##                        header=TRUE, 
##                        sep=" ")

hope = read.table(file = "fs/hope.txt", 
                  header = TRUE, 
                  sep = " ")
hope

##  (2) 구분자(Separator) : comma(,)
##  데이터명 = read.table(file="파일위치/파일명.txt", 
##                        header=TRUE, 
##                        sep=",")

reading = read.table(file = "fs/reading.txt", 
                     header = TRUE, 
                     sep = ",")
reading

##  (3) 구분자(Separator) : 탭(tab)
##  데이터명 = read.table(file="파일위치/파일명.txt", 
##                        header=TRUE, 
##                        sep="\t")

body = read.table(file   = "fs/body.txt", 
                  header = TRUE, 
                  sep    = "\t")
body


##  2. CSV(Comma Separated Value)
##  엑셀의 특수한 형태
##  데이터명 = read.csv(file   = "파일위치/파일명.csv",
##                      header = TRUE)

wish = read.csv(file   = "fs/wish.csv",
                header = TRUE)
wish


##  3. 엑셀 : xls, xlsx
##  R의 기본 기능에서는 못 읽어 옴
##  추가 기능을 설치, 추가기능 : 패키지(Package)
install.packages("readxl")
##  패키지 로딩하기, 구동하기
library(readxl)
##  패키지내 함수를 쓰면 '패키지명::함수' 형태로 사용
##  데이터명 = readxl::read_excel(path="파일위치/파일명.xlsx",
##                                sheet=index or "시트명",
##                                col_names=TRUE)

time = readxl::read_excel(path      = "fs/time.xlsx",
                          sheet     = 1,
                          col_names = TRUE)

time

