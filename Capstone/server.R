library(shiny)
library(stringr)
#library(quanteda)

source("predictorModel.R")

loadNgrams()

shinyServer(function(input, output) {
    
    output$prediction <- renderText({''})
    
    output$prediction <- renderText({predictTerm(input$iPhrase)})
})

