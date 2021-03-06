---
# Word Predict: An English Word Prediction App
---
***

## Overview
***

The aim of this project is to create an application that will predict the next english word based on a combination of words provided by the user. Data used for the prediction algorithm is provided by SwiftKey, who partnered with John Hopkins University for this project. The data is used to build a Word Corpus, which in turn is used to build n-gram language models, which are probability distributions of how frequent combination of words appear. Using these n-grams, the Stupid Backoff method is applied when predicting the next word. The application will display the top five predictions in descending order, and will also display of wordcloud of all the results.  

## Repository Directory
***

Subfolders

- data: folder; contains the N-grams generated for the app
- devtcode: folder; contains the scripts used to develop the N-grams and used for the app
- pitch: folder; contains the materials used to create the pitch presentation

Files

- functions.R contains the functions called by the Shiny app.
- server.R and ui.R are the core codes for the Shiny app.

