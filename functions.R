###################################################################
# Set up the libraries and N-Grams
###################################################################

suppressPackageStartupMessages(c(
require(shiny),
require(tm),
require(wordcloud),
require(data.table)))

 ngram2.dt <- readRDS("./data/ngram2_dt.Rds")
 ngram3.dt <- readRDS("./data/ngram3_dt.Rds")
 ngram4.dt <- readRDS("./data/ngram4_dt.Rds")
 ngram5.dt <- readRDS("./data/ngram5_dt.Rds")


###################################################################
# Build the Word Predict function
# This function uses the N-grams loaded and performs a 
# Stupid Backoff method to predict the next word based on
# the user's current input
################################################################### 
 
WordPredict <- function(input){
  input <- tolower(input)
  input <- unlist(strsplit(as.character(input),' '))
  predict <- NULL
  g <- NULL
  n <- length(input)
  m <- 5 # this is the number of results to return when looking at each ngram
  
  if(is.null(input)){
    stop("Enter input")
  }
  
  if(n == 1){
    predict <- ngram2.dt[.(paste(input[1], sep = " ")), head(.SD, m), on = "BaseWord"]
    
  }
  
  if(n == 2) {
    predict1 <- ngram3.dt[.(paste(input[n-1], input[n],sep = " ")), head(.SD, m), on = "BaseWord"]
    predict2 <- ngram2.dt[.(paste(input[n], sep = " ")), head(.SD, m), on = "BaseWord"]
    
    predict1$x <- predict1$x / predict1$x[1] * 2
    predict2$x <- predict2$x / predict2$x[1] * 1
    
    predict <- rbind(predict1, predict2)
    
    
  }
  
  if(n == 3) {
    predict1 <- ngram4.dt[.(paste(input[n-2], input[n-1], input[n],sep = " ")), head(.SD, m), on = "BaseWord"]
    predict2 <- ngram3.dt[.(paste(input[n-1], input[n],sep = " ")), head(.SD, m), on = "BaseWord"]
    predict3 <- ngram2.dt[.(paste(input[n], sep = " ")), head(.SD, m), on = "BaseWord"]
    
    predict1$x <- predict1$x / predict1$x[1] * 5
    predict2$x <- predict2$x / predict2$x[1] * 2
    predict3$x <- predict3$x / predict3$x[1] * 1
    
    predict <- rbind(predict1, predict2, predict3)
    
    
  }
  
  if(n >= 4) {
    predict1 <- ngram5.dt[.(paste(input[n-3], input[n-2], input[n-1], input[n],sep = " ")), head(.SD, m), on = "BaseWord"]
    predict2 <- ngram4.dt[.(paste(input[n-2], input[n-1], input[n],sep = " ")), head(.SD, m), on = "BaseWord"]
    predict3 <- ngram3.dt[.(paste(input[n-1], input[n],sep = " ")), head(.SD, m), on = "BaseWord"]
    predict4 <- ngram2.dt[.(paste(input[n], sep = " ")), head(.SD, m), on = "BaseWord"]
    
    predict1$x <- predict1$x / predict1$x[1] * 10
    predict2$x <- predict2$x / predict2$x[1] * 5
    predict3$x <- predict3$x / predict3$x[1] * 2
    predict4$x <- predict4$x / predict4$x[1] * 1
    
    predict <- rbind(predict1, predict2, predict3,predict4)
    
    
  }
  
  predict <- predict[!is.na(NextWord),]
  predict <- predict[!duplicated(predict$NextWord),]
  
  if(nrow(predict) == 0){
    print("the")
    
  }
  else{
    
    print(predict[, NextWord])
    
  }
  
}

###################################################################
# Build the Cloud Predict function
# This function is used to generate a word cloud based on all the
# predictions generated by the WordPredict function.
################################################################### 


CloudPredict <- function(input){
  input <- tolower(input)
  input <- unlist(strsplit(as.character(input),' '))
  predict <- NULL
  g <- NULL
  n <- length(input)
  m <- 5 # this is the number of results to return when looking at each ngram
  
  if(is.null(input)){
    stop("Enter input")
  }
  
  if(n == 1){
    predict <- ngram2.dt[.(paste(input[1], sep = " ")), head(.SD, m), on = "BaseWord"]
    
  }
  
  if(n == 2) {
    predict1 <- ngram3.dt[.(paste(input[n-1], input[n],sep = " ")), head(.SD, m), on = "BaseWord"]
    predict2 <- ngram2.dt[.(paste(input[n], sep = " ")), head(.SD, m), on = "BaseWord"]
    
    predict1$x <- predict1$x / predict1$x[1] * 2
    predict2$x <- predict2$x / predict2$x[1] * 1
    
    predict <- rbind(predict1, predict2)
    
    
  }
  
  if(n == 3) {
    predict1 <- ngram4.dt[.(paste(input[n-2], input[n-1], input[n],sep = " ")), head(.SD, m), on = "BaseWord"]
    predict2 <- ngram3.dt[.(paste(input[n-1], input[n],sep = " ")), head(.SD, m), on = "BaseWord"]
    predict3 <- ngram2.dt[.(paste(input[n], sep = " ")), head(.SD, m), on = "BaseWord"]
    
    predict1$x <- predict1$x / predict1$x[1] * 5
    predict2$x <- predict2$x / predict2$x[1] * 2
    predict3$x <- predict3$x / predict3$x[1] * 1
    
    predict <- rbind(predict1, predict2, predict3)
    
    
  }
  
  if(n >= 4) {
    predict1 <- ngram5.dt[.(paste(input[n-3], input[n-2], input[n-1], input[n],sep = " ")), head(.SD, m), on = "BaseWord"]
    predict2 <- ngram4.dt[.(paste(input[n-2], input[n-1], input[n],sep = " ")), head(.SD, m), on = "BaseWord"]
    predict3 <- ngram3.dt[.(paste(input[n-1], input[n],sep = " ")), head(.SD, m), on = "BaseWord"]
    predict4 <- ngram2.dt[.(paste(input[n], sep = " ")), head(.SD, m), on = "BaseWord"]
    
    predict1$x <- predict1$x / predict1$x[1] * 3
    predict2$x <- predict2$x / predict2$x[1] * 2
    predict3$x <- predict3$x / predict3$x[1] * 1.5
    predict4$x <- predict4$x / predict4$x[1] * 1
    
    predict <- rbind(predict1, predict2, predict3,predict4)
    
    
  }
  
  predict <- predict[!is.na(NextWord),]
  predict <- predict[!duplicated(predict$NextWord),]
  
  if(nrow(predict) == 0){
    g <- NULL
    
  }
  else{
    par(mar=c(3,3,2,2)) 
    g <- wordcloud(predict$NextWord, predict$x, 
                   max.words=20, colors=brewer.pal(8, "Dark2"), rot.per = 0.05, scale=c(5,0.6))
    print(g)
  }
  
}
