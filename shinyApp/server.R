library(shiny)

col_mask <- rep("integer",11)
col_mask[3] <- "NULL"
df <- read.csv("building_fires.csv",colClasses = col_mask)
axis_choice <- names(df)[c(-2,-4,-10)]



shinyServer(
    function(input,output){
        # which years should be displayed, input$year from checkboxGroupInput
        mask <- reactive({df[,"Year_ending"] %in% input$year})
        # select the y-axis, this is in server.R to automatically generate the choices
        output$y_axis_selector <- renderUI({
            selectInput("y_axis", h3("y-axis"), as.list(axis_choice), selected = "Building_fires") 
        })
        # select the x-axis
        output$x_axis_selector <- renderUI({
            selectInput("x_axis", h3("x-axis"), as.list(axis_choice), selected = "Total_fires") 
        })
        # x-axis-range double slider, min and max adjust with axis selection
        xmin <- reactive({min(df[,input$x_axis])})
        xmax <- reactive({max(df[,input$x_axis])})
        output$xlim_slider <- renderUI({
            sliderInput("sliderx", label = h5("Range"), min = xmin(), 
                    max = xmax(), 
                    value = c(xmin(),xmax()), step = 1)
        })
        # y-axis-range double slider, min and max adjust with axis selection
        ymin <- reactive({min(df[,input$y_axis])})
        ymax <- reactive({max(df[,input$y_axis])})
        output$ylim_slider <- renderUI({
            sliderInput("slidery", label = h5("Range"), min = ymin(), 
                        max = ymax(), 
                        value = c(ymin(),ymax()), step = 1)
        })
        # display the input values
        output$sliderx <- renderText({paste0(input$x_axis," on x-axis from ",input$sliderx[1],
                                             " to ",input$sliderx[2],
                                             " with difference ",
                                             input$sliderx[2]-input$sliderx[1],".")})
        output$slidery <- renderText({paste0(input$y_axis," on y-axis from ",input$slidery[1],
                                             " to ",input$slidery[2],
                                             " with difference ",
                                             input$slidery[2]-input$slidery[1],".")})
        output$year <- renderText({paste0("You selected the following years: ",
                                          paste(input$year,collapse=", "),".")})
        # create the output plot
        output$plot <- renderPlot({plot(df[mask(),input$x_axis], df[mask(),input$y_axis], 
                 xlab=as.character(input$x_axis), ylab=as.character(input$y_axis),
                 xlim=input$sliderx, ylim=input$slidery,
                 col = 2008-df[mask(),"Year_ending"])
        })
        
    }
)

