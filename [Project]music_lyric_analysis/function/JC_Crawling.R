JC_Crawling <- function(i){
  final_url <- paste0("http://www.melon.com/song/detail.htm?songId=", i)
  url <- GET(url = final_url)
  html_url <- read_html(url)
  
  ## #conts 부분 지정해주고
  tempMusic <- url %>% 
    read_html() %>% 
    html_nodes("#conts")
  
  ## 곡 정보 추출
  tempInform <- tempMusic %>% 
    html_nodes(".wrap_song_info dd") %>% 
    html_text() %>% 
    gsub(pattern = "(\n|\t|\r)", replace = "") %>%
    gsub(pattern = "^[[:space:]]", replace = "")
  
  ## inform에서 필요한 정보만
  tempArtist <- c(tempInform[1])  # 가수
  tempType   <- c(tempInform[4])  # 노래 장르
  
  ## 노래 제목 추출
  tempTitle <- tempMusic %>% 
    html_nodes(".wrap_song_info p.songname") %>% 
    html_text() 
  
  ## 노래 가사 추출
  tempLyric <- tempMusic %>% 
    html_nodes(".wrap_lyric .lyric") %>% 
    as.character()
  # html_text로 추출할 시 <br>에 해당하는 부분이 없어져서         
  # 텍스트가 그냥 합쳐짐
  # <br>을 공백으로 만들기 위해 char로 변환해서 태그 전체를 수집
  
  ## 추출한 데이터를 data.frame으로 만들어주고 rbind 시켜주기
  song <- data.frame(id = i, artist = tempArtist, title = tempTitle,
                     type = tempType, lyric = tempLyric)
  
  return(song)
}
