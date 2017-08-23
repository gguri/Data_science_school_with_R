rm(list=ls())
#' @title Music lyric analysis
#' @author Jungchul HA
#' @version 1.0, 2017.08.23
#' @description Data pre-processing


# 01. setting -----------------------------------------------

# library
library(dplyr)


# 02. data setting --------------------------------------------
step1 <- read.csv(file = "data/1step_modif.csv", 
                  stringsAsFactors = FALSE)
              
step2 <- read.csv(file = "data/2step.csv", 
                  stringsAsFactors = FALSE)


# 03. text pre-processing ------------------------------------
## 1) label 달아주기
## 2) 노래 제목 전처리
## 3) 가사 전처리

# 03-1. label 달아주기 ---------------------------------------

one <- step1 %>% 
  select(id, label)

# label은 다르지만 id가 중복인 데이터 존재 => 333에서 339건이됨
music <- merge(step2, one,
               by = "id", all = TRUE)

# id와 label을 합쳐서 PK 생성
# 중복되는 PK 제거
music$PK <- paste(music$id, music$label, sep = "-")
music <- music %>% 
  filter(!duplicated(PK))


# 03-2. 제목 전처리 --------------------------------------------

# title 
music$title <- music$title %>% 
  gsub(pattern = "(\n|\t|\r)", replace = "") %>%
  gsub(pattern = "곡명", replace = "") %>%
  gsub(pattern = "^[[:space:]]", replace = "") 
# (\n|\t|\r) 제거
# 곡명 제거
# 모든 공백문자 제거

# 03-3. 가사 전처리 ---------------------------------------------

# lyric
music$lyric <- music$lyric %>% 
  gsub(pattern = "(.*)-->|</div>", replace = "") %>% 
  gsub(pattern = "(\n|\t|\r)", replace = "") %>%
  gsub(pattern = "^[[:space:]]", replace = "") %>% 
  gsub(pattern = "<br>", replace = " ") %>% 
  gsub(pattern = " +", replace = " ")  
# (.*)--> : -->를 기준으로 앞부분 모두 제거 , </div> 제거
# " +" : 공백이 1개 이상이면 공백을 하나로 만들기


# 04. analysis data ---------------------------------------------

analysis <- music %>% 
  select(artist, title, type, label, lyric)

write.csv(analysis, "data/analysis.csv",
          row.names = FALSE)
