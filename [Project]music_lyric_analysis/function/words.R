# SimplePos09 ---------------------------------------
ko.words09 <- function(doc){
  doc <- as.character(doc)
  pos <- paste(SimplePos09(doc))
  # N/P라는 글자 자체가 필요한 것은 아님
  # ([가-힣])을 통해 한글만 추출 
  extracted <- str_match(pos, '([가-힣]+)/[NP]')
  keyword <- extracted[,2]
  keyword <- keyword[!is.na(keyword)]
  keyword <- keyword[nchar(keyword) >=2 & nchar(keyword) <=5]
  return(keyword)
}

makeTdm09 <- function(doc){
  ctrl <- list(tokenize = ko.words09,
               removePunctuation = TRUE,
               removeNumbers = TRUE)
  tdm <- TermDocumentMatrix(doc, control = ctrl)
  tdm <- as.matrix(tdm)
  tdm <- rowSums(tdm)
  tdm <- tdm[order(tdm, decreasing = TRUE)]
  top100 <- as.data.frame(tdm[1:100])
  all <- as.data.frame(tdm)
  result <- list(top100, all)
  
  return(result)
}
#


# SimplePos22 ------------------------------------------------------
ko.words22 <- function(doc){
  doc <- as.character(doc)
  pos <- paste(SimplePos22(doc))
  # N/P라는 글자 자체가 필요한 것은 아님
  # ([가-힣])을 통해 한글만 추출 
  extracted <- str_match_all(pos, '([가-힣]+)/[MANCPVPA]')
  keyword <- extracted[[1]][,2]
  keyword <- keyword[!is.na(keyword)]
  keyword <- keyword[nchar(keyword) >=2 & nchar(keyword) <=5]
  return(keyword)
}
makeTdm22 <- function(doc){
  ctrl <- list(tokenize = ko.words22,
               removePunctuation = TRUE,
               removeNumbers = TRUE)
  tdm <- TermDocumentMatrix(doc, control = ctrl)
  tdm <- as.matrix(tdm)
  tdm <- rowSums(tdm)
  tdm <- tdm[order(tdm, decreasing = TRUE)]
  top100 <- as.data.frame(tdm[1:100])
  all <- as.data.frame(tdm)
  result <- list(top100, all)
  
  return(result)
}


# Wordcloud ----------------------------------------------
makeWord <- function(words, freq){
  wordcloud(words, freq, min.freq = 10,
            max.words=200, random.order=FALSE,
            rot.per=0.25, colors = brewer.pal(8, "Dark2"))
}


# makeDic -------------------------------------------------
makeDic <- function(result){
  top100Word <- rownames(result[[1]])
  top100Freq <- result[[1]][, 1]
  allWord <- rownames(result[[2]])
  allFreq <- result[[2]][, 1]
  
  top100 <- data.frame(word = top100Word, freq = top100Freq)
  all <- data.frame(word = allWord, freq = allFreq)
  
  result <- list(top100, all)
  return(result)
}


# calScore --------------------------------------------------
score <- 0
calScore <- function(word, dic){
  for(i in 1:length(word)){
    tempWord <- word[i]
    for(j in 1:length(dic)){
      tempDic <- dic[j]
      if(tempWord == tempDic){
        score <- score+1
      }
    }
  }
  return(score)
}


# makeData ------------------------------------------------
makeData <- function(temp){
  doc <- Corpus(VectorSource(temp))
  ctrl <- list(tokenize = ko.words09,
               removePunctuation = TRUE,
               removeNumbers = TRUE)
  tdm <- DocumentTermMatrix(doc, control = ctrl)
  tdm <- as.matrix(tdm)
  tdmDf <- data.frame(tdm)
  
  return(tdmDf)
}

