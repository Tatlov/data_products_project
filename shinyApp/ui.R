library(shiny)
shinyUI(fluidPage(
            titlePanel("Explore some information on fires between 2003 and 2007 in NSW, Australia"),
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
                          fires in NSW. The data concerns fires which the New 
                          South Wales Fire Brigades responded to and reported on.
                          On the left-hand side under input are a few self-explanatory 
                          widgets that you can use to select inputs. The main panel 
                          on the right-hand side will show the resulting output 
                          - a graph and a summary of the inputs."),
                      div("The data shown in this App was combined from three 
                          different sources. The population in a given postcode was 
                          obtained from the Australian 2011 Census of Population and Housing
                          using", a("table builder basic", 
                                    href= "http://www.abs.gov.au/websitedbs/censushome.nsf/home/tablebuilder?opendocument&navpos=240"),
                          "on 2014-07-22 at 11:00am. The post code and identifier of fire 
                          stations was obtained from this", 
                          a("website",href = "http://sydneyfire.net.au/radio-info/frnsw/stations/"),
                          "on 2014-07-22 at 11:00am. The source of information
                          on the number of fires, casualties, and people evacuated 
                          and rescued from fire corresponding to individual fire stations 
                          was Fire & Rescue NSW, New South Wales, 
                          Annual Statistical Reports, Fire Brigades (NSW) 2003 to 2007.
                          The data was downloaded on 2014-07-22 at 10:30am. 
                          The original data source and more documentation on the variables are at 
                          http://www.fire.nsw.gov.au/page.php?id=171. I used this ",
                          a("script", 
                            href = "https://github.com/Tatlov/data_products_project/blob/master/get_and_clean.R"),
                          "to obtain, clean and combine the data."
                      ), width = 12
            )
        )
    
)

