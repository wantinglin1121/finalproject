rm(list=ls(all=TRUE))
# install.packages("jiebaR")
# install.packages("tm")
# install.packages("slam")
#install.packages("RColorBrewer")
# install.packages("wordcloud")
# install.packages("topicmodels")
# install.packages("igraph")


library(jiebaRD)
library(jiebaR)       # 斷詞利器
library(NLP)
library(tm)           # 文字詞彙矩陣運算
library(slam)         # 稀疏矩陣運算
library(RColorBrewer)
library(wordcloud)    # 文字雲 
library(topicmodels)  # 主題模型
library(igraph)       # 主題模型關聯

orgPath = "./Month_Data/text_title_all"
text = Corpus(DirSource(orgPath), list(language = NA))
text <- tm_map(text, removePunctuation) #過濾標點符號
text <- tm_map(text, removeNumbers) #過濾數字
#text <- tm_map(text,stripWhitespace) #清除多餘的空格

text <- tm_map(text, function(word) #過濾底下的功能
{ gsub("[A-Za-z0-9]", "", word) }) #function的描述 [A-Za-z0-9] 

# 進行中文斷詞
mixseg = worker()  #worker是對應的字典

totalSegment = data.frame()
for( i in 1:length(text[[1]]) )
{
  result = segment(as.character(text[[1]][i]), jiebar=mixseg)
  totalSegment = rbind(totalSegment, data.frame(result))
}


totaldiff = levels(totalSegment$result)
countMat = data.frame(totaldiff, c(rep(0, length(totaldiff))))
for( i in 1:length(totalSegment$result) )
#for( i in 1:300 )
{
  for( j in 1:length(totaldiff) )
  #for( j in 1:100 )
  {
    if( nchar(totaldiff[j]) >= 2 &&
        totaldiff[j] == as.character(totalSegment$result[i]) )
    {
      countMat[j,2] = countMat[j,2] + 1
    }
  }
}

names(countMat) = c("totaldiff", "freq")
countMat[,2] = countMat[,2] / sum(countMat[,2])

wordcloud(countMat$totaldiff, countMat$freq, min.freq = 1, random.order = F, ordered.colors = T)
#wordcloud(countMat$totaldiff, countMat$freq, min.freq = 1, random.order = F, ordered.colors = T,colors = rainbow(length(totaldiff)))

