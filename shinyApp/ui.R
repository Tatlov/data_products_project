library(shiny)
shinyUI(fluidPage(
            titlePanel("Explore fire stations in NSW, Australia"),
            sidebarLayout(
                sidebarPanel(h3("Input"),
                             checkboxGroupInput("year",h4("Ending of Financial Year"),
                                                c("2004","2005","2006","2007"),
                                                selected = "2007"),
                             uiOutput('x_axis_selector'),
                             uiOutput('xlim_slider'),
                             uiOutput('y_axis_selector'),
                             uiOutput('ylim_slider')
                ),
                mainPanel(h3("Summary of your current input:"),
                          textOutput('year'),
                          textOutput('sliderx'),
                          textOutput('slidery'),
                          h3("Output"),
                          plotOutput('plot')
                )
            ),
            mainPanel(h2("Documentation"),
                      div("This app allows you to explore information related to 
                          fires in NSW."),
                      div("Where does the data come from?"))
        )
    
)

