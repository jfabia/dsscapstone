#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
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


# Define UI for application 
shinyUI(navbarPage("Word Predict", 
 
    tabPanel("Application",
     
      fluidRow(
        column(8, align = "center", offset = 2,
              h3(tags$b("Word Predict")),
              h5(tags$b("An English Word Prediction App")),
              h6("Enter your English text in the field below; the app will predict your next word and generate a word cloud of those predictions"),
              textInput("inputText","","Hello")
              )
            ),
      
      fluidRow(
        column(8, align = "center", offset = 2,
               h6("The top 5 predicted words are"),
               h4(tableOutput("WordPredictResult"))
              )
            ),
      fluidRow(
        column(8, align = "center", offset = 2, 
               plotOutput("WordCloudResult")
              )
            )
      
      ),
    tabPanel("Documentation",
      
      fluidRow(
        column(8, align = "center", offset = 2,
               h3(tags$b("Documentation"))
                )
              ),
      
      fluidRow(
        column(8, align = "center", offset = 2,
               h6("This application is a capstone project for Coursera's Data Science Specialization course by Johns Hopkins University, in partnership with SwiftKey."),
                     
               br(),
                    
               h4(tags$b("Build")),
               h6("Version 1.0"),
               h6("Created by Joseph Fabia"),
               h6("Data provided by Swiftkey through the Coursera website"),
               h6("Built in RStudio Version 1.1.453"),
               h6("Uses R version 3.5.0"),
               h6("Powered by Shiny"),
                    
               br(),
                    
               h4(tags$b("Resources")),
               h6("Product pitch of this app is found here"),
               h6("Github repository containing the app's working files is found here")
                    
                    
              )
           
          )
      )
    )
)


