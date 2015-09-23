#server.R
library(shiny)

testval <- "CCTATCGGTGGATTAGCATGTCCCTGTACGTTTCGCCGCGAACTAGTTCACACGGCTTGATGGCAAATGGTTTTTCCGGCGACCGTAATCGTCCACCGAG"
GetTrendArray <- function (dnaString){
    # ensure case
    dnaString <- toupper(dnaString)
    
    charList <-strsplit(dnaString, "")
    
    numNucleotide <- length(charList[[1]])
    
    trendDF <- data.frame(trend = numeric(numNucleotide), nucleotide = character(numNucleotide), stringsAsFactors = FALSE)
    currentTrend = 0;
    for (i in 1:numNucleotide) {
        if (charList[[1]][i] == 'C'){
            currentTrend <- currentTrend - 1;
        }
        if(charList[[1]][i] == 'G')
            currentTrend <- currentTrend + 1;
        
        trendDF$nucleotide[i] <- as.character(charList[[1]][i])
        trendDF$trend[i] <- currentTrend
    };
    
    trendDF;
}


shinyServer(
    function(input, output){
        
        
        #output$inputDNAStr <- renderText({input$dnaStringTA})
        getInputlength <- reactive({
            paste("Number of Base Pair", (nchar(input$dnaStringTA)/2))
        })
        
        getTrendFrame <- reactive({
            trend <- GetTrendArray(input$dnaStringTA)
            plot(trend$trend, type="l",ylab='Trend')
        })
        
        output$numBP <- renderText({getInputlength()})
        output$trendPlot <- renderPlot({getTrendFrame()})
        
        #Future thoughts 
        #Calculate processing time
        #show strands which are +_ the inflection point by 13 so 26 each direction  
        #If time permits enable exploration by setting uper and lower  bounds to be graphed
        #       ...sliders kind of like manipulate would be cool
    }    
)