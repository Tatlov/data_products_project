library(shiny)

df <- read.csv("building_fires.csv")
axis_choice <- names(df)[c(-3,-2,-5,-11)]

shinyServer(
    function(input,output){
        mask <- reactive({df[,"Year_ending"] %in% input$year})
        output$y_axis_selector <- renderUI({
            selectInput("y_axis", h3("y-axis"), as.list(axis_choice), selected = "Building_fires") 
        })
        output$x_axis_selector <- renderUI({
            selectInput("x_axis", h3("x-axis"), as.list(axis_choice), selected = "Total_fires") 
        })
        xmin <- reactive({min(df[mask(),input$x_axis])})
        xmax <- reactive({max(df[mask(),input$x_axis])})
        output$xlim_slider <- renderUI({
            sliderInput("sliderx", label = h5("Range"), min = xmin(), 
                    max = xmax(), 
                    value = c(xmin(),xmax()))
        })
        ymin <- reactive({min(df[mask(),input$y_axis])})
        ymax <- reactive({max(df[mask(),input$y_axis])})
        output$ylim_slider <- renderUI({
            sliderInput("slidery", label = h5("Range"), min = ymin(), 
                        max = ymax(), 
                        value = c(ymin(),ymax()))
        })
        output$plot <- renderPlot({
            if(input$submit==0) return()
            isolate({plot(df[mask(),input$x_axis], df[mask(),input$y_axis], 
                 xlab=as.character(input$x_axis), ylab=as.character(input$y_axis),
                 xlim=input$sliderx, ylim=input$slidery )
        })})
        
    }
)

