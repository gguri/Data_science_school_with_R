##########################################
### 주제     : Music lyric analysis    ###
### 코드     : 크롤링한 데이터 전처리  ###
### 작성자   : JungChul HA             ###
### 작성일자 : 2017.08.17              ###   
##########################################

install.packages("dplyr")
library(dplyr)

##########################################
song = read.csv(file = "../music/song.csv",
                header = TRUE)

id = song %>% 
  select(id)
type = song %>% 
  select(type)
lyric = song %>% 
  select(lyric)
## 가수 artist
## \n, \t 제거
artist = song %>% 
  select(artist)

artist = gsub("\n","", artist[,1])
artist = as.data.frame(artist)
artist = gsub("\t","", artist[,1])
artist = as.data.frame(artist)

## 노래 제목 
## '곡명, \n, \t' 제거
title = song %>% 
  select(title)

title = gsub("곡명","", title[,1])
title = as.data.frame(title)
title = gsub("\n","", title[,1])
title = as.data.frame(title)
title = gsub("\t","", title[,1])
title = as.data.frame(title)

## gsub의 결과는 vector로 반환된다...
## 음? 간편하게 처리하는 방법 없으려나

song = data.frame(id, artist, title, type, lyric)

first_data = read.csv(file = "../music/first_data.csv",
                      header = TRUE)
first_data = first_data %>% 
  select(id, label)

## 그냥 merge를 하게되면 같은 id에 다른 label을 가진 중복으로 들어가버림
## Recycling Rule 때문인것 같다.
analysis_song = merge(song, first_data,
                      by = "id",
                      all = TRUE)

## id와 label을 조합해서 PK로 만들어주고
analysis_song$PK = paste(analysis_song$id, 
                         analysis_song$label, 
                         sep = "_")

## 중복된 PK들을 제거
analysis_song = analysis_song %>% 
  filter(!duplicated(PK))

## 끝
## 저장하기
write.csv(analysis_song,
          file = "../music/analysis_song.csv",
          row.names = FALSE)
