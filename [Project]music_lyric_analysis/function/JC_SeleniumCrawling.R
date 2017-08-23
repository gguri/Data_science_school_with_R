JC_SeleniumCrawling <- function(x){
  # javascript가 적용된 페이지 크롤링링
  # Rselenium을 이용하여 멜론 DJ들이 선정한 곡들의 id와 노래 제목 크롤링
  
  url <-  paste0("http://www.melon.com/mymusic/dj/mymusicdjplaylistview_inform.htm?plylstSeq=", x)
  
  remDr$navigate(url)
  
  # id 가져오기
  idNode <- remDr$findElements(using = "class", "btn_icon_detail") 
  tempId <- sapply(idNode, function(id){
    id$getElementAttribute("href")
    })
  tempId <- sapply(tempId, function(id){
    regmatches(id, gregexpr("[0-9]+", id))
    })
  tempId <- as.character(tempId)
  
  # name 가져오기
  nameNode <- remDr$findElements(using = "class", "fc_gray")
  tempName <- sapply(nameNode, function(name){
    name$getElementText()
    })
  tempName <- sapply(tempName, function(name){
    gsub(name, pattern = "(\n|\t|\r)", replace = "")
    })
  tempName <- as.character(tempName)
  
  # artist 가져오기
  artistNode <- remDr$findElements(using = "class", "wrapArtistName")
  tempArtist <- remDr$findElements(using = "class", "fc_mgray")
  tempArtist <- sapply(artistNode, function(artist){
    artist$getElementText()
  })
  tempArtist <- sapply(tempArtist, function(artist){
    gsub(artist, pattern = "(\n|\t|\r)", replace = "")
  })
  tempArtist <- as.character(tempArtist)
  
  temp = data.frame(id = tempId, 
                    artist = tempArtist,
                    name = tempName,
                    dj = x)
  return(temp)
  
  # stop the selenium server

}