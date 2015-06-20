library(shiny)

library(ggplot2)

shinyUI(fluidPage(
  fluidRow(
    column(5,
      headerPanel(img (src = "img/dataproduct.jpg"),
               "Developing Data Products: Courserea Project")
    ),
    column(7,
      br(),br(),
      titlePanel("Malicious Hosts Visualization")
    )
  ),
  br(),
  fluidRow(
    column(2,offset = 1,
      selectInput("mapcolor", "Select map color",
                c("Grey", "Black", "White",
                  selected=NULL))
    ),
    column(3,offset = 1,
      selectInput("type", "Select Type",
                c('All','Scanning Host','Spamming','Malicious Host') )
    ),
    column(2,offset = 1,
             selectInput("level", "Select Risk Level",
                         c('All','High','Low') )
    )
  ),
  br(),
  fluidRow(
    column(9,
      h4('\  \ Malicious Hosts Maps', align='center'),
      plotOutput('mapPlot')
    ),column(3,
      h4('Malicious Hosts by Countries'),
      br(),
      tableOutput('table')
    )
  ),

  fluidRow(
    column(11,offset=1,
      h4('Documentation'),
      p('Github link: https://github.com/hgiang/CourseraDevelopingDataProduct'),
      p('This app is aimed to visualization and summarize that malicious activity over the cyber world. The map prodives
        a geo-location presentation of malicious hosts in the world. The table show a brief summary about the source 
        countries of these host.'),
      p('To interact with the map and the summary table, user have the following options'),
      tags$div(
        tags$ul(
          tags$li('change the color of the displayed maps'),
          tags$li('chose the activity type to display'),
          tags$li('chose the risk level of the events')
        )
      ),
      h4('Data sources'),
      p('This project take a snapshot data from http://reputation.alienvault.com/reputation.data. Particularly, 
        we made use of the data downloaded by Jay Jacobs and Bob Rudis. The data is also used in their book: 
        Data-Driven Security: Analysis, Visualization and Dashboards.')
    )
  )
))