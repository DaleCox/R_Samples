library(shiny)

shinyUI(bootstrapPage(
    titlePanel("Data Science Capstone Text Prediction", windowTitle = "Capstone Text Prediction"),
    HTML('<i>Dale Cox </i><br/><br/>'),
    
    wellPanel(
        helpText("Enter phrase and press suggest to get next predicted word"),
        textInput('iPhrase', '', value = "one of the"),
        submitButton("Suggest Word")
    ),
    HTML('<br/><br/>'),
    
    wellPanel(
        helpText("Predicted word: "),
        textOutput("prediction")
    )
))