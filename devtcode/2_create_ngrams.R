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

options(mc.cores=3)

###################################################################
# Load the corpus
###################################################################

corpus <- VCorpus(VectorSource(readLines("1_corpus_subset_ws.txt")),
                 readerControl=list(reader=readPlain, language="en"))


###################################################################
# Create the Tokenization functions 
###################################################################

ngram1Token <- function(x) {
        NGramTokenizer(x, Weka_control(min = 1, max = 1,
                                       delimiters = " \\r\\n\\t.,;:\"()?!")
                                          )}
ngram2Token <- function(x) {
        NGramTokenizer(x, Weka_control(min = 2, max = 2,
                                       delimiters = " \\r\\n\\t.,;:\"()?!")
        )}

ngram3Token <- function(x) {
        NGramTokenizer(x, Weka_control(min = 3, max = 3,
                                       delimiters = " \\r\\n\\t.,;:\"()?!")
        )}

ngram4Token <- function(x) {
        NGramTokenizer(x, Weka_control(min = 4, max = 4,
                                       delimiters = " \\r\\n\\t.,;:\"()?!")
        )}

ngram5Token <- function(x) {
  NGramTokenizer(x, Weka_control(min = 5, max = 5,
                                 delimiters = " \\r\\n\\t.,;:\"()?!")
  )}


###################################################################
# Create the initial N-Grams and save them to a text file
###################################################################


ngram1 <- TermDocumentMatrix(corpus, control = list(tokenize = ngram1Token))
ngram1.df <- slam::row_sums(ngram1)
ngram1.df <- tidy(ngram1.df)
saveRDS(ngram1.df, file="ngram1_sample.Rds")
rm(ngram1)
rm(ngram1.df)
gc() # prompt R to return memory to the OS

ngram2 <- TermDocumentMatrix(corpus, control = list(tokenize = ngram2Token))
ngram2.df <- slam::row_sums(ngram2)
ngram2.df <- tidy(ngram2.df)
saveRDS(ngram2.df, file="ngram2_sample.Rds")
rm(ngram2)
rm(ngram2.df)
gc() # prompt R to return memory to the OS


ngram3 <- TermDocumentMatrix(corpus, control = list(tokenize = ngram3Token))
ngram3.df <- slam::row_sums(ngram3)
ngram3.df <- tidy(ngram3.df)
saveRDS(ngram3.df, file="ngram3_sample.Rds")
rm(ngram3)
rm(ngram3.df)
gc() # prompt R to return memory to the OS


ngram4 <- TermDocumentMatrix(corpus, control = list(tokenize = ngram4Token))
ngram4.df <- slam::row_sums(ngram4)
ngram4.df <- tidy(ngram4.df)
saveRDS(ngram4.df, file="ngram4_sample.Rds")
rm(ngram4)
rm(ngram4.df)
gc() # prompt R to return memory to the OS


ngram5 <- TermDocumentMatrix(corpus, control = list(tokenize = ngram5Token))
ngram5.df <- slam::row_sums(ngram5)
ngram5.df <- tidy(ngram5.df)
saveRDS(ngram5.df, file="ngram5_sample.Rds")
rm(ngram5)
rm(ngram5.df)
rm(corpus)
gc() # prompt R to return memory to the OS


###################################################################
# Reload the initial N-Grams to drop words which only show
# up once in the N-Gram. Save them to a text file.
###################################################################


ngram1.df <- readRDS("ngram1_sample.Rds")
ngram2.df <- readRDS("ngram2_sample.Rds")
ngram3.df <- readRDS("ngram3_sample.Rds")
ngram4.df <- readRDS("ngram4_sample.Rds")
ngram5.df <- readRDS("ngram5_sample.Rds")

ngram1.df <- ngram1.df[which(ngram1.df$x != 1) , ] 
saveRDS(ngram1.df, file="ngram1_trunc.Rds")
rm(ngram1.df)
gc()


ngram2.df <- ngram2.df[which(ngram2.df$x != 1) , ] 
saveRDS(ngram2.df, file="ngram2_trunc.Rds")
rm(ngram2.df)
gc()


ngram3.df <- ngram3.df[which(ngram3.df$x != 1) , ] 
saveRDS(ngram3.df, file="ngram3_trunc.Rds")
rm(ngram3.df)
gc()


ngram4.df <- ngram4.df[which(ngram4.df$x != 1), ] 
saveRDS(ngram4.df, file="ngram4_trunc.Rds")
rm(ngram4.df)
gc()

ngram5.df <- ngram5.df[which(ngram5.df$x != 1), ]
saveRDS(ngram5.df, file="ngram5_trunc.Rds")
rm(ngram5.df)
gc()
 


ngram2.df <- readRDS("ngram2_trunc.Rds")
ngram2.df$BaseWord <- word(string = ngram2.df$names, start = 1, end = 1, sep = fixed(" "))
ngram2.df$NextWord <- word(string = ngram2.df$names, start = 2, end = 2, sep = fixed(" "))
saveRDS(ngram2.df, file="ngram2_dt.Rds")
rm(ngram2.df)
gc()

ngram3.df <- readRDS("ngram3_trunc.Rds")
ngram3.df$BaseWord <- word(string = ngram3.df$names, start = 1, end = 2, sep = fixed(" "))
ngram3.df$NextWord <- word(string = ngram3.df$names, start = 3, end = 3, sep = fixed(" "))
saveRDS(ngram3.df, file="ngram3_dt.Rds")
rm(ngram3.df)
gc()


ngram4.df <- readRDS("ngram4_trunc.Rds")
ngram4.df$BaseWord <- word(string = ngram4.df$names, start = 1, end = 3, sep = fixed(" "))
ngram4.df$NextWord <- word(string = ngram4.df$names, start = 4, end = 4, sep = fixed(" "))
saveRDS(ngram4.df, file="ngram4_dt.Rds")
rm(ngram4.df)
gc()


ngram5.df <- readRDS("ngram5_trunc.Rds")
ngram5.df$BaseWord <- word(string = ngram5.df$names, start = 1, end = 4, sep = fixed(" "))
ngram5.df$NextWord <- word(string = ngram5.df$names, start = 5, end = 5, sep = fixed(" "))
saveRDS(ngram5.df, file="ngram5_dt.Rds")
rm(ngram5.df)
gc()


###################################################################
# Reload the N-Grams and rank them by frequency in descending order
###################################################################

ngram1.df <- readRDS("ngram1_trunc.Rds")
ngram2.df <- readRDS("ngram2_dt.Rds")
ngram3.df <- readRDS("ngram3_dt.Rds")
ngram4.df <- readRDS("ngram4_dt.Rds")
ngram5.df <- readRDS("ngram5_dt.Rds")


ngram1.dt <- as.data.table(ngram1.df)
ngram1.dt <- ngram1.dt[order(-x)]

ngram2.dt <- as.data.table(ngram2.df)
ngram2.dt <- ngram2.dt[,c("names") := NULL][order(-x)]

ngram3.dt <- as.data.table(ngram3.df)
ngram3.dt <- ngram3.dt[,c("names") := NULL][order(-x)]

ngram4.dt <- as.data.table(ngram4.df)
ngram4.dt <- ngram4.dt[,c("names") := NULL][order(-x)]

ngram5.dt <- as.data.table(ngram5.df)
ngram5.dt <- ngram5.dt[,c("names") := NULL][order(-x)]

saveRDS(ngram2.dt, file="ngram1_dt.Rds")
saveRDS(ngram2.dt, file="ngram2_dt.Rds")
saveRDS(ngram3.dt, file="ngram3_dt.Rds")
saveRDS(ngram4.dt, file="ngram4_dt.Rds")
saveRDS(ngram5.dt, file="ngram5_dt.Rds")

rm(list=ls())
gc()
