library(shiny)
library(ggplot2)
library(maps)
library(RColorBrewer)
library(scales)
library(plyr)

shinyServer(

  function(input, output) {
    ## Read data
    avRep <- "data/reputation.data"
    data <- read.csv(avRep, sep="#", header=FALSE, na.strings = c('NA','NAN','',' '))
    colnames(data) <- c("IP", "Reliability", "Risk", "Type",
                         "Country", "Locale", "Coords", "x")
    
    # av.df <- data
    
    
    ## Read Reactive Inputs
    mapcol <- reactive({input$mapcolor})
    type <- reactive({input$type})
    level <- reactive({input$level})
    
    
    
    output$table <- renderTable({
      if(level() == 'High'){
        av.df = data[data$Risk >2, ]
      }else if(level() == 'Low'){
        av.df = data[data$Risk <3, ]
      }else{
        av.df = data
      }
      
      if(type() != 'All'){
        av.df <- av.df[av.df$Type == type(),]
      }
      
      countrySum = count(av.df, 'Country')
      countrySum <- arrange(countrySum, -freq )
      head(countrySum)  
    })
    
    output$mapPlot <- renderPlot({
      if(level() == 'High'){
        av.df = data[data$Risk >2, ]
      }else if(level() == 'Low'){
        av.df = data[data$Risk <3, ]
      }else{
        av.df = data
      }
      
      if(type() != 'All'){
        av.df <- av.df[av.df$Type == type(),]
      }
      # create a vector of lat/long data by splitting on ","
      av.coords.vec <- unlist(strsplit(as.character(av.df$Coords), ","))
      av.coords.mat <- matrix(av.coords.vec, ncol=2, byrow=TRUE)
      av.coords.df <- as.data.frame(av.coords.mat)
      colnames(av.coords.df) <- c("lat","long")
      av.coords.df$long <- as.double(as.character(av.coords.df$long))
      av.coords.df$lat <- as.double(as.character(av.coords.df$lat))
      
      if( mapcol() == 'Black'){
        fillcolor = 'black'
      }else if(mapcol() == 'White'){
        fillcolor = 'white'
      }else{
        fillcolor = 'slategrey'
      }
      set2 <- brewer.pal(8,"Set2")
      world <- map_data('world')
      ggplot() +
        geom_polygon(data=world, aes(long, lat, group=group), fill=fillcolor) + 
        geom_point(data=av.coords.df, aes(x=long, y=lat),color=set2[2], size=2, alpha=0.1) +
        labs(x="", y="") + 
        theme(panel.background=element_rect(fill=alpha(set2[3],0.2), colour='white')) +
        coord_fixed()
    })
  }
)