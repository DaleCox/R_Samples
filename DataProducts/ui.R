#ui.R
library(shiny)
shinyUI(pageWithSidebar(
    headerPanel("Ori-C Finder"),
    sidebarPanel(
        helpText("This application will help determine the origin of replication (Ori-c) in a strand of DNA.
                The strands which are the most negitive are the most likely to contain the strands Ori-C.
                In the example provided this is the part of the graph that dips to -4 and starts to rise"),
        helpText("An initial value has been seeded to demonstrate functionality. 
                 Adding additional nucleotides (A, T, G, or C) will update the plot"),
        HTML('<textarea id="dnaStringTA" rows="8" cols="40">CCTATCGGTGGATTAGCATGTCCCTGTACGTTTCGCCGCGAACTAGTTCACACGGCTTGATGGCAAATGGTTTTTCCGGCGACCGTAATCGTCCACCGAG</textarea>')
        
    ),
    mainPanel(
        h2('Results'),
        h3('Summary'),
        textOutput("numBP"),
        h3('Trend Plot'),
        plotOutput("trendPlot")
        
    )
))