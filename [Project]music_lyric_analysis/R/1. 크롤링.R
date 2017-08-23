rm(list=ls())
#' @title Music lyric analysis
#' @author Jungchul HA
#' @version 1.0, 2017.08.17
#' @description Web Crawling


# 01. setting -----------------------------------------------

# library
library(rvest)
library(RSelenium)
library(dplyr)
library(R.utils)
library(httr)

# function
source("function/JC_SeleniumCrawling.R", encoding = "UTF-8")
source("function/JC_Crawling.R", encoding = "UTF-8")

# 02. crawling ----------------------------------------------
# 1) RSelenium - 1step (멜론 DJ리스트 곡 id 수집)
# 2) rvest - 2step (곡 id를 바탕으로 가사 수집)


# 02-1. 1step crawling --------------------------------------

# 멜론 DJ플레이리스트
# 멜론 DJ id를 이용하여 DJ들이 선정한 곡들의 id와 곡명 크롤링
djId = c(401837367, 417619493, 411011913, 428746517, 401719231,
         410343627, 412079713, 431136044, 428565108, 428903298)


# selenium server start
rD <- rsDriver()
remDr <- rD[["client"]]

# crawling
result <- c()
for(i in 1:length(djId)){
  printf("%d번째 멜론 DJ(%d)의 플레이리스트를 수집 중 \n", i,djId[i])
  result <- rbind(result, JC_SeleniumCrawling(djId[i]))
}
# selenium server close
remDr$close()
rD[["server"]]$stop() 

result$label <- recode(result$dj,
                       "401837367"=1, "417619493"=1,
                       "411011913"=2, "428746517"=2,
                       "401719231"=3, "410343627"=3,
                       "412079713"=4, "431136044"=4,
                       "428565108"=5, "428903298"=5)

write.csv(result, "data/1step.csv", row.names = FALSE)
# 379곡 크롤링
# 1) 국내 가요
# 2) 중복된 곡 제거 (labal이 다르면 그냥 두기)
# 334곡으로 정리

first_result <- read.csv(file = "data/1step_modif.csv", 
                         stringsAsFactors = F)


# 02-2. 2step -----------------------------------------------------

id <- first_result %>% 
  select(id)

result = c()
for(i in 1:nrow(id)){
  printf("%d번째 노래(id = %d)의 가사를 수집 중 \n", i, id[i,])
  result <- rbind(result, JC_Crawling(id[i,]))
  Sys.sleep(0.5)
}

write.csv(result, "data/2step.csv", row.names = FALSE)
