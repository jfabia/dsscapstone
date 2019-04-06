###################################################################
# Clear the current R environment and load the required libraries
###################################################################

rm(list=ls())
gc()
require(tm)
require(RWeka)
require(NLP)
require(slam)
require(tidytext)
require(dplyr)
require(stringr)
require(data.table)
require(wordcloud)

options(mc.cores=3)


###################################################################
# Load the N-grams
###################################################################

ngram2.dt <- readRDS("ngram2_dt.Rds")
ngram3.dt <- readRDS("ngram3_dt.Rds")
ngram4.dt <- readRDS("ngram4_dt.Rds")
ngram5.dt <- readRDS("ngram5_dt.Rds")

###################################################################
# Build the WordPredict Function
# Use the Stupid Backoff Method for predicting the next word
###################################################################


WordPredict <- function(input){
  input <- tolower(input)
  input <- unlist(strsplit(as.character(input),' '))
  predict <- NULL
  g <- NULL
  n <- length(input)
  m <- 5 # this is the number of results to return when looking at each ngram
  
  if(n == 1){
    predict <- ngram2.dt[.(paste(input[1], sep = " ")), head(.SD, m), on = "BaseWord"]
    
  }
  
  if(n == 2) {
    predict1 <- ngram3.dt[.(paste(input[n-1], input[n],sep = " ")), head(.SD, m), on = "BaseWord"]
    predict2 <- ngram2.dt[.(paste(input[n], sep = " ")), head(.SD, m), on = "BaseWord"]
    
    predict1$x <- predict1$x / predict1$x[1] * 10
    predict2$x <- predict2$x / predict2$x[1] * 1
    
    predict <- rbind(predict1, predict2)
    
    
  }
  
  if(n == 3) {
    predict1 <- ngram4.dt[.(paste(input[n-2], input[n-1], input[n],sep = " ")), head(.SD, m), on = "BaseWord"]
    predict2 <- ngram3.dt[.(paste(input[n-1], input[n],sep = " ")), head(.SD, m), on = "BaseWord"]
    predict3 <- ngram2.dt[.(paste(input[n], sep = " ")), head(.SD, m), on = "BaseWord"]
    
    predict1$x <- predict1$x / predict1$x[1] * 100
    predict2$x <- predict2$x / predict2$x[1] * 10
    predict3$x <- predict3$x / predict3$x[1] * 1
    
    
    predict <- rbind(predict1, predict2, predict3)
    
    
  }
  
  if(n >= 4) {
    predict1 <- ngram5.dt[.(paste(input[n-3], input[n-2], input[n-1], input[n],sep = " ")), head(.SD, m), on = "BaseWord"]
    predict2 <- ngram4.dt[.(paste(input[n-2], input[n-1], input[n],sep = " ")), head(.SD, m), on = "BaseWord"]
    predict3 <- ngram3.dt[.(paste(input[n-1], input[n],sep = " ")), head(.SD, m), on = "BaseWord"]
    predict4 <- ngram2.dt[.(paste(input[n], sep = " ")), head(.SD, m), on = "BaseWord"]
    
    predict1$x <- predict1$x / predict1$x[1] * 1000
    predict2$x <- predict2$x / predict2$x[1] * 100
    predict3$x <- predict3$x / predict3$x[1] * 10
    predict4$x <- predict4$x / predict4$x[1] * 1
    
    
    predict <- rbind(predict1, predict2, predict3,predict4)
    
    
  }
  
  predict <- predict[!is.na(NextWord),]
  predict <- predict[!duplicated(predict$NextWord),]
  
  if(nrow(predict) == 0){
    return("the")
    
  }
  else{
    g <- wordcloud(predict$NextWord, predict$x, 
                      max.words=20, colors=brewer.pal(8, "Dark2"), rot.per = 0.05)
    return(predict[, NextWord])
    print(g)
  }
  
}

