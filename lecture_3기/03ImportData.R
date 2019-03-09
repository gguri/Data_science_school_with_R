#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
# 수업내용 : 외부 데이터 읽어오기               #
#                                               #
# 작 성 자 : 이부일                             #
# 작성일자 : 2018년 3월 20일 화요일             #
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#

# 1. txt
# 1.1 separator : one blank(white space)
# 1.2 separator : comma(,)
# 1.3 separator : tab

# 2. csv
# 3. excel



# 1. txt ----
# 1.1 separator : one blank(white space)
# dataname <- read.table(file   = "directory/filename.txt",
#                        header = TRUE,
#                        sep    = " ")
blank <- read.table(file   = "d:/da/blank.txt",
                    header = TRUE,
                    sep    = " ")
blank


# 1.2 separator : comma(,)
# dataname <- read.table(file   = "directory/filename.txt",
#                        header = TRUE,
#                        sep    = ",")
comma <- read.table(file   = "d:/da/comma.txt",
                    header = TRUE,
                    sep    = ",")
comma


# 1.3 separator : tab
# dataname <- read.table(file   = "directory/filename.txt",
#                        header = TRUE,
#                        sep    = "\t")
tab <- read.table(file   = "d:/da/hope.txt",
                    header = TRUE,
                    sep    = "\t")
tab


# 2. CSV : Comma Separated Value
# 엑셀의 특수한 형태
# dataname <- read.csv(file   = "directory/filename.csv",
#                      header = TRUE)
reading <- read.csv(file   = "d:/da/reading.csv",
                    header = TRUE,
                    encoding = "EUC")
reading


# 3. excel : xls, xlsx 
# R의 기본 기능에서는 못 읽어옴
# 패키지 이름 : readxl
# 패키지 설치/로딩하기 : 조건 : 인터넷이 연결되어 있어야 함.

# 3.1 패키지 설치하기
# install.packages("package name", repos = "http://cran.rstudio.com")
# install.packages("directory/package namexxx.zip", repos = NULL)
install.packages("readxl")
# c 드라이브의 특정 폴더에 해당 패키지 자료가 저장되어 있음
# 패키지 설치는 동일 컴퓨터는 한 번만 함.


# 3.2 패키지 로딩하기(loading)
# 패키지의 기능들을 메모리에 올림
# R과 패키지와의 연결하기
# library(package name)
library(readxl)
# 패키지 로딩하기는 동일한 컴퓨터에서 필요할 때마다 실행해야 함
# RStudio를 종료하면 R과 패키지 간의 연결은 끊어짐

# dataname <- readxl::read_excel(path      = "directory/filename.xlsx",
#                                sheet     = "sheet name" or index,
#                                col_names = TRUE)
traffic <- readxl::read_excel(path      = "d:/da/traffic.xlsx",
                              sheet     = "data",
                              col_names = TRUE)
traffic

traffic2 <- readxl::read_excel(path      = "d:/da/traffic.xlsx",
                               sheet     = 1,
                               col_names = TRUE)
traffic2

# 작업공간(Working Directory)
# 앞으로 프로젝트할 때에 데이터, 프로그램 등을 저장하는 특정한 폴더까지의
# 디렉토리(경로)

# (1) 현재 설정된 작업공간 알아내기
# getwd()
getwd()

# (2) 새롭게 작업공간 설정하기
# setwd("directory")
setwd("d:/da/")

traffic3 <- readxl::read_excel(path      = "traffic.xlsx",
                               sheet     = 1,
                               col_names = TRUE)
traffic3
