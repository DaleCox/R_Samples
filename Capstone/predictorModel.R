library(stringr)
#library(quanteda)

predictTerm <- function(phraseString){
    #drop punctuation
    phraseString <- gsub("[^[:alnum:][:space:]']", "", phraseString)
    print(phraseString)
    
    numWords <- str_count(phraseString, "\\S+")
    #print(numWords)
    if(numWords==2){
        #select last two words of the phrase
        phraseString <- word(phraseString,-2,-1)
        #Put simple regex together
        lastWords <- paste("^",phraseString," ", sep = "")
        #Find matches
        matches <- grep(lastWords,trigrams,ignore.case=TRUE,value=TRUE)
    }else if(numWords > 2){
        #select last three words of the phrase
        phraseString <- word(phraseString,-3,-1)
        #Put simple regex together
        lastWords <- paste("^",phraseString," ", sep = "")
        #Find matches
        matches <- grep(lastWords,quadgrams,ignore.case=TRUE,value=TRUE)
    }else{
        #Put simple regex together
        lastWords <- paste("^",phraseString," ", sep = "")
        #Find matches
        matches <- grep(lastWords,trigrams,ignore.case=TRUE,value=TRUE)
    }
    
    #print(phraseString)
    
    #print(lastWords)
    
    #print(matches[1])
    #get last word
    lastMatch <- "this" #Default match
    if(length(matches)>0){
        lastMatch <- tail(strsplit(matches[1],split=" ")[[1]],1)
    }
    return(lastMatch)
}

# loadNgrams <- function(){
#     #trigrams <<- texts(textfile("trigrams.txt"))
#     trigrams <<- readLines("trigrams.txt", n=1530174)
#     #quadgrams <<- texts(textfile("quadgrams.txt"))
#     quadgrams <<- readLines("quadgrams.txt",n=888996)
# }

loadNgrams <- function(){
    #trigrams <<- texts(textfile("trigrams.txt"))
    trigrams <<- my.read.lines2("trigrams.txt")
    #quadgrams <<- texts(textfile("quadgrams.txt"))
    quadgrams <<- my.read.lines2("quadgrams.txt")
}

#http://www.r-bloggers.com/faster-files-in-r/
my.read.lines2=function(fname) {
    s = file.info( fname )$size 
    buf = readChar( fname, s, useBytes=T)
    strsplit( buf,"\n",fixed=T,useBytes=T)[[1]]
}