###################################################################
# Clear the current R environment and load the required libraries
###################################################################

rm(list=ls())
gc()
require(tm)
require(RWeka)
require(NLP)
options(mc.cores=3)

###################################################################
# Download the data used to build the Corpus
# Download the data used to build the profanity database
###################################################################


if(!file.exists("Coursera-SwiftKey.zip")){
        download.file("https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip", "Coursera-SwiftKey.zip")
        unzip("Coursera-SwiftKey.zip")
}


if(!file.exists("profanity.zip")){
        download.file("https://www.freewebheaders.com/download/files/full-list-of-bad-words_text-file_2018_07_30.zip", 
                      "profanity.zip")
        unzip("profanity.zip")
}
profanity <- readLines("full-list-of-bad-words_text-file_2018_07_30.txt")

###################################################################
# Define data scrubbing functions
###################################################################

Scrub.NonASCII <- function(x){ iconv(x, "latin1", "ASCII", sub="")}
Scrub.URL <- function(x){gsub("http[[:alnum:]]*", "", x)}
Scrub.Punctuation.Except.Apostrophe <- 
        function(x){gsub("(?!')[[:punct:]]", "", x, perl=TRUE)}

###################################################################
# Load the US English text data into the console
# Create a summary of data's characteristics
###################################################################

blogs <- readLines("final/en_US/en_US.blogs.txt",
                  warn = FALSE, encoding = "UTF-8")
twitter <- readLines("final/en_US/en_US.twitter.txt",
                  warn = FALSE, encoding = "UTF-8")
news <- readLines("final/en_US/en_US.news.txt",
                  warn = FALSE, encoding = "UTF-8")


data_summary <- 
        data.frame("File.Name" = c("Blogs", "Twitter", "News"),
                   "File.Size" = sapply(list(blogs, twitter, news), 
                                        function(x){
                                                format(object.size(x), "MB")
                                        }),
                   "No.Records" = sapply(list(blogs, twitter, news),
                                        function(x){
                                                length(x)
                                        }),
                   "Total.Characters" = sapply(list(blogs, twitter, news),
                                        function(x){
                                                sum(nchar(x))
                                        }),
                   "Max.No.Characters" = sapply(list(blogs, twitter, news),
                                        function(x){
                                                max(unlist(lapply(x, function(y){
                                                        nchar(y)
                                                })))
                                        })
                   )
saveRDS(data_summary, file="data_summary_eng.Rds")

###################################################################
# Select a sample of textlines to be used from news sites, blogs
# and twitter. The sample size for each is:
# Use 100% of data from news sites
# Use 60% of data from blogs
# Use 20% of data from Twitter
# The purpose of this selection is to focus on conversational 
# english during word prediction. News sites and Blogs have more 
# formal conversational english as opposed to twitter.
###################################################################

# For reproducibility
set.seed(11319)
sample_size_news <- 1
sample_size_blogs <- 0.60
sample_size_twitter <- 0.20

index_blogs <- sample(seq_len(length(blogs)),length(blogs)*sample_size_blogs)
index_twitter <- sample(seq_len(length(twitter)),length(twitter)*sample_size_twitter)
index_news <- sample(seq_len(length(news)),length(news)*sample_size_news)

blogs_sample <- blogs[index_blogs[]]
twitter_sample <- twitter[index_twitter[]]
news_sample <- news[index_news[]]

# Clearing memory
rm(list = c('index_blogs', 'index_twitter', 'index_news'))
rm(list = c('blogs', 'twitter', 'news'))
gc()

###################################################################
# Create the corpus based on sampled data
###################################################################

corpus <- Corpus(VectorSource(c(blogs_sample, twitter_sample, news_sample)),
                 readerControl=list(reader=readPlain, language="en"))
writeLines(as.character(corpus), con="0_corpus_subset_raw.txt")

# Clearing memory
rm(corpus)
rm(list = c('blogs_sample', 'twitter_sample', 'news_sample'))
gc()

###################################################################
# Perform data cleanup procedures on the Corpus.
# Scrubbing rules are as follows
#
# 1: Remove non-ASCII characters
# 2: Remove URLs
# 3: Remove unnecessary spaces
# 4: Remove numbers
# 5: Remove punctuation except for apostrophe
# 6: Remove plain text
# 7: Remove profanity
###################################################################

corpus <- Corpus(VectorSource(readLines("0_corpus_subset_raw.txt")),
                  readerControl=list(reader=readPlain, language="en"))

corpus <- tm_map(corpus, content_transformer(Scrub.NonASCII))
corpus <- tm_map(corpus, content_transformer(Scrub.URL))
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, content_transformer(Scrub.Punctuation.Except.Apostrophe))
corpus <- tm_map(corpus, PlainTextDocument)

corpus <- tm_map(corpus, removeWords, profanity)
rm(profanity)
gc()

corpus <- tm_map(corpus, content_transformer(tolower))
writeLines(as.character(corpus), con="1_corpus_subset_ws.txt")
gc()



