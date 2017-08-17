##########################################
### 주제     : Music lyric analysis    ###
### 코드     : 웹 크롤러               ###
### 작성자   : JungChul HA             ###
### 작성일자 : 2017.08.17              ###   
##########################################

install.packages("httr")
install.packages("rvest")
install.packages("dplyr")
install.packages("xlsx")

library(httr)
library(rvest)
library(dplyr)
library(xlsx)

###############################
## 사이트 : Melon(멜론)
## 노래 가사 분석을 위한 웹 크롤러 설계
 
## 1 단계 - DJ playlist
## url : http://www.melon.com/mymusic/dj/mymusicdjplaylistview_inform.htm?plylstSeq=)
## 노래 제목(title), 노래 id(id) 수집 후 label
## javascript가 적용된 페이지 Rselenium사용해서 크롤링 시도
## Rselenium 패키지 설치 후 서버 시작이 Docker 형식으로 바뀐듯(도커 모름..)
## 대안책) Python - Beautifulsoup와 selenium 패키지를 통해 제목과 id수집
## => R로 열심히 삽질 한 후, 크롤러는 python으로 하라는 이유를 알 것 같다.

## 2 단계 - 노래 가사 수집 
## ID를 통해 곡 정보 페이지로 이동
## url : http://www.melon.com/song/detail.htm?songId=
## 노래 id를 이용해서 
## 노래 제목(title), 가수(artist), 장르(type), 가사(lyric)

## 1 단계 결과물 first_data 불러오기
first_data <- read.csv(file = "music/first_data.csv",
                       header = TRUE)

# 곡 id만 추출
id = first_data %>% 
  select(id)

# 기본 곡 정보 url
first_url <- "http://www.melon.com/song/detail.htm?songId="
song = data.frame()

# id 개수 358만큼 for문 반복
for(i in 1:nrow(id)){
  
  ## 기본 url에 id가 추가된 url 생성 
  final_url = paste(first_url,
                    id[i,],
                    sep="")
  
  ## read_html() 전체 뮤직 데이터
  url = GET(url = final_url)
  
  ## #conts 부분 지정해주고
  music <- url %>% 
    read_html() %>% 
    html_nodes("#conts")
 
  ## 곡 정보 추출
  inform <- music %>% 
    html_nodes(".wrap_song_info dd") %>% 
    html_text()
  
  ## inform에서 필요한 정보만
  artist = c(inform[1])  # 가수
  type   = c(inform[4])  # 노래 장르
  
  ## 노래 제목 추출
  title <- music %>% 
    html_nodes(".wrap_song_info p.songname") %>% 
    html_text()
  
  ## 노래 가사 추출
  lyric <- music %>% 
    html_nodes(".wrap_lyric .lyric") %>% 
    html_text()
  
  ## 추출한 데이터를 data.frame으로 만들어주고 rbind 시켜주기
  song_data = data.frame(artist = artist, title = title,
                         type = type, lyric = lyric)
  song = rbind(song, song_data)
}

## id 테이블과 합치고
song = cbind(id,song)

## song으로 내보내기
write.csv(song, file = "music/song.csv")

## 데이터 전처리 필요
## title => 곡명  단어 제거
## \t\n등 특수기호 제거 필요