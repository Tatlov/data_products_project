library(shiny)

col_mask <- rep("integer",11)
col_mask[3] <- "NULL"
df <- read.csv("building_fires.csv",colClasses = col_mask)
axis_choice <- names(df)[c(-2,-4,-10)]

# set defaults, necessary because 
# after first selectInput("y_axis",...) input$y_axis is empty
x_axis_default <- "Total_fires"
y_axis_default <- "Building_fires"
# debugging
verbose <- FALSE

shinyServer(
    function(input,output){
        # select the y-axis, this is in server.R to automatically generate the choices
        output$y_axis_selector <- renderUI({
            if (verbose) cat("y_axis input\n")
            selectInput("y_axis", h3("y-axis"), as.list(axis_choice), 
                        selected = y_axis_default) 
        })
        # select the x-axis
        output$x_axis_selector <- renderUI({
            if (verbose) cat("x_axis input\n")
            selectInput("x_axis", h3("x-axis"), as.list(axis_choice), 
                        selected = x_axis_default) 
        })
        # x-axis-range double slider, min and max adjust with axis selection
        output$xlim_slider <- renderUI({
            if (verbose) cat("x slider\n")
            xmin <- ifelse(length(input$x_axis)==0,min(df[,x_axis_default]),
                           min(df[,input$x_axis]))
            xmax <- ifelse(length(input$x_axis)==0,max(df[,x_axis_default]),
                           max(df[,input$x_axis]))
            sliderInput("sliderx", label = h5("Range"), min = xmin, 
                    max = xmax, 
                    value = c(xmin,xmax), step = 1)
        })
        # y-axis-range double slider, min and max adjust with axis selection
        output$ylim_slider <- renderUI({
            if (verbose) cat("y slider\n")
            ymin <- ifelse(length(input$y_axis)==0,min(df[,y_axis_default]),
                           min(df[,input$y_axis]))
            ymax <- ifelse(length(input$y_axis)==0,max(df[,y_axis_default]),
                           max(df[,input$y_axis]))
            sliderInput("slidery", label = h5("Range"), min = ymin, 
                        max = ymax, 
                        value = c(ymin,ymax), step = 1)
        })
        
        # display the input values
        output$sliderx <- renderText({
            if (verbose) cat("slider x out\n")
            paste0(input$x_axis," on x-axis from ",input$sliderx[1],
                   " to ",input$sliderx[2]," with difference ",
                   input$sliderx[2]-input$sliderx[1],".")})
        output$slidery <- renderText({
            if (verbose) cat("slider y out\n")
            paste0(input$y_axis," on y-axis from ",input$slidery[1],
                   " to ",input$slidery[2]," with difference ",
                   input$slidery[2]-input$slidery[1],".")})
        output$year <- renderText({
            if (verbose) cat("year out\n")
            paste0("You selected the following years: ",
                   paste(input$year,collapse=", "),".")})
        
        # create the output plot
        output$plot <- renderPlot({
            # which years should be displayed, input$year from checkboxGroupInput
            mask <- df[,"Year_ending"] %in% input$year
            x_axis <- ifelse(length(input$x_axis)==0,x_axis_default,input$x_axis)
            y_axis <- ifelse(length(input$y_axis)==0,y_axis_default,input$y_axis)
            plot(df[mask,x_axis], df[mask,y_axis], 
                 xlab=as.character(x_axis), ylab=as.character(y_axis),
                 xlim=input$sliderx, ylim=input$slidery,
                 col = 2008-df[mask,"Year_ending"])
        })
        
    }
)

