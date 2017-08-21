rm(list=ls())
#' @title parallel coding
#' @author Jungchul HA
#' @version 1.0, 2017.08.21
#' @description 이민식(연세대)_특강

# 01. setting ------------------------------------------

# import library
library(dplyr)
library(googlesheets)
library(rvest)

# import personal library
source("project/function/MS_crawling.R", encoding = "UTF-8")

set.seed(1708)



# 02. GS. Access -------------------------------------------

my_sheets <- gs_ls() # 권한 인증하기
# https:// 주소~ 로 들어가서 개인 구글 계정으로 로그인 한 후 접근 허용
# 개인 구글 시트 목록이 나오게 됨

# 만약 사용자를 변경하고 싶다면?
gs_auth(new_user = T) # 새로운 사용자 설정

# 개인 구글 시트 목록
gs_ls()



# 03. GS. Create new sheet ---------------------------------

# 구글 시트지 확인
gs_ls() 

# 구글 시트지 만들기 
gap <- gs_new(title = "newGS") 

# 구글 시트지 삭제
gs_delete(gap) 

# 브라우저로 확인
gs_browse(gap) 


## workspace 설정

# new sheet 만들기
gs_ws_new(gap, "s1")
gs_ws_new(gap, "s2")
gs_ws_new(gap, "s3")

# 확인
gs_ws_ls(gap) 
# 결과는 시트 1 => newGS sheet에 대한 갱신을 하지 않아서

# 새로 접근
gap <- gs_title("newGS")
gs_ws_ls(gap)

# delete
gs_ws_delete(gap, "시트1")



# 04. Data ----------------------------------------------------

# input data
gs_edit_cells(gap, ws = "s2", input = iris)

# read data
gs_iris <- gs_read(gap, "s2")

# Full 한번에 모든 데이터 새로 생성
gs_new("newGS2", ws_title = "s2", input = iris)
gap <- gs_title("newGS2")
gs_browse(gap)

# add data
inputdata <- iris[1:10, ]
gs_add_row(gap, "s2", input = inputdata)
# row가 하나씩 추가되기 때문에 느리다. (R상에서 합치고 올리는게 나음)
# col추가 기능은 아직 없는듯 하다.



# 05. 실습 ----------------------------------------------

# 실습 데이터 - 다음 영화 리뷰
result <- c()
for(i in 1:120){
  result <- rbind(result, MS_crawling(i, 100237)) # 택시운전사 : 100237
}
result$Review <- as.character(result$Review)

result1 <- result[1:100, ]
result2 <- result[101:120, ]

# 1) 다음 영화 리뷰를 크롤링하여 googlesheets에 저장하기
# 2) 다음 영화 리뷰 크롤링하여 googlesheets에 데이터 추가하기
# 구글 시트지 이름 : movieReview
# 구글 worksheet 이름 : 택시운전사

# 시트지, worksheet 생성
# 구글 시트지 만들기 
gap <- gs_new(title = "movieReview") 

# 구글 시트지 삭제
gs_delete(gap)

# 브라우저로 확인
gs_browse(gap) 

# 한글 시트명 생성 => 한글 인코딩 문제 
# 영어는 바로 사용가능
x1Label <- "택시운전사"
x1Label <- iconv(x1Label, to = "UTF-8")
gs_ws_new(gap, x1Label)

# 시트 1 삭제
gs_ws_delete(gap, "시트1")

# 시트 갱신
gap <- gs_title("movieReview") 

# 1) 저장하기
gs_edit_cells(gap, ws = x1Label, input = result1)

# 2) 데이터 추가하기
gs_add_row(gap, x1Label, input = result2)
