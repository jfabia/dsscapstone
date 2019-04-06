#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


suppressPackageStartupMessages(c(
  require(shiny),
  require(tm),
  require(wordcloud),
  require(data.table)))




shinyServer(function(input, output) {

  withProgress(message="Initializing", value = 0, {
    n <- 1
    source("./PredictInput.R")    
    incProgress(1/n, detail = "Loading n-grams")
    
  })
  
      
  PredictedWord <- reactive({
    withProgress(message = "Generating results", value = 1, {
      if(input$inputText==""){
      stop("You must enter valid input")
            }
    WordPredict(input$inputText)
      })
  
  })
  
  
  PredictedCloud <- reactive({
    withProgress(message = "Generating Wordcloud", value = 1, {
      if(input$inputText==""){
      stop("You must enter valid input")
            }
    CloudPredict(input$inputText)
    
      })
    
  })
  
  output$WordPredictResult <- renderTable(
    t(data.table(unique(PredictedWord()))[1:5,]),
    rownames=FALSE, colnames=FALSE, bordered = TRUE)
  
  output$WordCloudResult <- renderPlot(PredictedCloud())
  
    
  })
  
