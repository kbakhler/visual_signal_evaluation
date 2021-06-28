library(shiny)
library(ggplot2)
library(dplyr)

# My function to generate a custom scatter plot.
ggplotRegression <- function (fit) {
  ggplot(fit$model, aes_string(x = names(fit$model)[2], y = names(fit$model)[1])) + 
    geom_point(size = 2) +
    stat_smooth(method = "lm", col = "blue") +
    geom_hline(yintercept=0, col = "red") + 
    geom_vline(xintercept=0, col = "red") +
    labs(title = paste("Actual ~ ", 
                       signif(fit$coef[[1]], 4),
                       " + ",
                       signif(fit$coef[[2]], 4),
                       "* Prediction       ( with Adj R2=",
                       signif(summary(fit)$adj.r.squared, 4),
                       " and P=",
                       signif(summary(fit)$coef[2,4], 4),
                       ")"
                       )
         )
}



# server function
function(input, output) {
  
  # Reactive expression to either include or exclude outliers.
  # This is called whenever the Outliers input button changes.
  outliers <- reactive({
    outl <- switch(input$outliers,
                   outin = TRUE,
                   outout = FALSE,
                   TRUE
                   )
   outl
  })
  
  # Reactive expression to look at all predicitons, only sell predictions, or only buys.
  # This is called whenever the Which Predictions input button changes.
  subset <- reactive({
    buysell <- switch(input$subSignals,
                   all = 1,
                   sells = 2,
                   buys = 3,
                   1
    )
    buysell
  })
  
  
  # Generate a scatter plot of all data. 
  output$plot <- renderPlot({
    inFile <- input$file1
    if (is.null(inFile))
      return(NULL)
    mydata <- read.csv(inFile$datapath, header=input$header, sep=input$sep, 
            quote=input$quote, col.names=c("FilingID","Symbol","Date","Prediction","Actual"))

    
    # using condition23 to create a new data frame without outliers 
    condition25 <- ((mydata[,4] >= -0.25 & mydata[,4] <= 0.25)
                  &
                  (mydata[,5] >= -0.25 & mydata[,5] <= 0.25)
                  )
    mydata2 <- mydata[condition25,]

    # plotting either mydata or mydata2, depending on the Outliers button
    # also plotting either full data set, buy-subset, or sell-subset, depending on the Subset button
    if (outliers()) {
    # switching among subsets: 1=all, 2=sell predictions only, 3=buy predictions only
      if (subset() == 1) {
        myplot <- lm(Actual ~ Prediction, data = mydata)            
      } else if (subset() == 2) {
        myplot <- lm(Actual ~ Prediction, data = filter(mydata, Prediction <= 0))    
      } else {
        myplot <- lm(Actual ~ Prediction, data = filter(mydata, Prediction > 0))    
      }      
    } else {
      # switching among subsets: 1=all, 2=sell predictions only, 3=buy predictions only
      if (subset() == 1) {
        myplot <- lm(Actual ~ Prediction, data = mydata2)            
      } else if (subset() == 2) {
        myplot <- lm(Actual ~ Prediction, data = filter(mydata2, Prediction <= 0))    
      } else {
        myplot <- lm(Actual ~ Prediction, data = filter(mydata2, Prediction > 0))    
      }   
    }
  ggplotRegression(myplot)
  })
  

  # Generate a summary of the data
  output$summary <- renderPrint({
   
    inFile <- input$file1
    if (is.null(inFile))
      return(NULL)
    mydata <- read.csv(inFile$datapath, header=input$header, sep=input$sep, 
             quote=input$quote, col.names=c("FilingID","Symbol","Date","Prediction","Actual"))
    
    # using condition23 to create a new data frame without outliers 
    condition25 <- ((mydata[,4] >= -0.25 & mydata[,4] <= 0.25)
                    &
                      (mydata[,5] >= -0.25 & mydata[,5] <= 0.25)
    )
    mydata2 <- mydata[condition25,]
    
    # returning either mydata or mydata2, depending on the Outliers button
    if (outliers()) {
      # switching among subsets: 1=all, 2=sell predictions only, 3=buy predictions only
      if (subset() == 1) {
        reg <- lm(Actual~Prediction, data = mydata)            
      } else if (subset() == 2) {
        reg <- lm(Actual~Prediction, data = filter(mydata, Prediction <= 0))
      } else {
        reg <- lm(Actual~Prediction, data = filter(mydata, Prediction > 0))
      }       
    } else {
      # switching among subsets: 1=all, 2=sell predictions only, 3=buy predictions only
      if (subset() == 1) {
        reg <- lm(Actual~Prediction, data = mydata2)            
      } else if (subset() == 2) {
        reg <- lm(Actual~Prediction, data = filter(mydata2, Prediction <= 0))
      } else {
        reg <- lm(Actual~Prediction, data = filter(mydata2, Prediction > 0))
      }       
    }
    
    #coef(reg)
    summary(reg)
  })
  
  
  # Generate a summary of the data
  output$summary2 <- renderPrint({
    
    inFile <- input$file1
    if (is.null(inFile))
      return(NULL)
    mydata <- read.csv(inFile$datapath, header=input$header, sep=input$sep, 
                       quote=input$quote, col.names=c("FilingID","Symbol","Date","Prediction","Actual"))
    
    # using condition23 to create a new data frame without outliers 
    condition25 <- ((mydata[,4] >= -0.25 & mydata[,4] <= 0.25)
                    &
                      (mydata[,5] >= -0.25 & mydata[,5] <= 0.25)
    )
    mydata2 <- mydata[condition25,]
    
    # returning either mydata or mydata2, depending on the Outliers button
    if (outliers()) {
      # switching among subsets: 1=all, 2=sell predictions only, 3=buy predictions only
      if (subset() == 1) {
        reg <- lm(Actual~Prediction, data = mydata)            
      } else if (subset() == 2) {
        reg <- lm(Actual~Prediction, data = filter(mydata, Prediction <= 0))
      } else {
        reg <- lm(Actual~Prediction, data = filter(mydata, Prediction > 0))
      }       
    } else {
      # switching among subsets: 1=all, 2=sell predictions only, 3=buy predictions only
      if (subset() == 1) {
        reg <- lm(Actual~Prediction, data = mydata2)            
      } else if (subset() == 2) {
        reg <- lm(Actual~Prediction, data = filter(mydata2, Prediction <= 0))
      } else {
        reg <- lm(Actual~Prediction, data = filter(mydata2, Prediction > 0))
      }       
    }
    
    coef(reg)
    #summary(reg)
  })
  
  
  # Generate a 'Grading' of the data, breaking all predictions into 'buckets'
  output$grades <- renderPrint({
    
    inFile <- input$file1
    if (is.null(inFile))
      return(NULL)
    mydata <- read.csv(inFile$datapath, header=input$header, sep=input$sep, 
                       quote=input$quote, col.names=c("FilingID","Symbol","Date","Prediction","Actual"))
    
    # using condition23 to create a new data frame without outliers 
    condition25 <- ((mydata[,4] >= -0.25 & mydata[,4] <= 0.25)
                    &
                      (mydata[,5] >= -0.25 & mydata[,5] <= 0.25)
    )
    mydata2 <- mydata[condition25,]
    
    # returning either mydata or mydata2, depending on the Outliers button
    if (outliers()) {
      # switching among subsets: 1=all, 2=sell predictions only, 3=buy predictions only
      if (subset() == 1) {
        mydata <- mydata            
      } else if (subset() == 2) {
        mydata <- filter(mydata, Prediction <= 0)
      } else {
        mydata <- filter(mydata, Prediction > 0)
      }
      

      } else {
        # switching among subsets: 1=all, 2=sell predictions only, 3=buy predictions only
        if (subset() == 1) {
          mydata <- mydata2            
        } else if (subset() == 2) {
          mydata <- filter(mydata2, Prediction <= 0)
        } else {
          mydata <- filter(mydata2, Prediction > 0)
        }        
    }

    # this adds a new column, called 'quartile,' to 'mydata'
    # currently hardcoded to 6 
    mydata <- mydata %>% mutate(quartile = ntile(Prediction, 6))
    
    asigs <- filter(mydata, quartile == 6)
    bsigs <- filter(mydata, quartile == 5)
    csigs <- filter(mydata, quartile == 4)
    dsigs <- filter(mydata, quartile == 3)
    esigs <- filter(mydata, quartile == 2)
    fsigs <- filter(mydata, quartile == 1)
    
#    buysigs <- filter(mydata, Prediction > 0.005)
 #   holdsigs <- filter(mydata, Prediction >= -0.005, Prediction <= 0.005)
  #  sellsigs <- filter(mydata, Prediction < -0.005)

    grades <- data.frame(Group=character(),
                         AvgPrediction=numeric(),
                         NumberOfSignals=integer(),
                         AvgActual=numeric()
                         )

    grades <- rbind(grades, data.frame(Group = "A",
                                       AvgPrediction = round(mean(asigs$Prediction), 5),
                                       NumberOfSignals = nrow(asigs),
                                       AvgActual = round(mean(asigs$Actual), 5)
                                       )
                    )  
    grades <- rbind(grades, data.frame(Group = "B", 
                                       AvgPrediction = round(mean(bsigs$Prediction), 5),
                                       NumberOfSignals = nrow(bsigs),
                                       AvgActual = round(mean(bsigs$Actual), 5)
                                       )
                    )  
    grades <- rbind(grades, data.frame(Group = "C", 
                                       AvgPrediction = round(mean(csigs$Prediction), 5),
                                       NumberOfSignals = nrow(csigs),
                                       AvgActual = round(mean(csigs$Actual), 5)
                                      )
                    )  
    grades <- rbind(grades, data.frame(Group = "D",
                                   AvgPrediction = round(mean(dsigs$Prediction), 5),
                                   NumberOfSignals = nrow(dsigs),
                                   AvgActual = round(mean(dsigs$Actual), 5)
                                   )
                    )  
    grades <- rbind(grades, data.frame(Group = "E", 
                                   AvgPrediction = round(mean(esigs$Prediction), 5),
                                   NumberOfSignals = nrow(esigs),
                                   AvgActual = round(mean(esigs$Actual), 5)
                                   )
                    )  
    grades <- rbind(grades, data.frame(Group = "F", 
                                   AvgPrediction = round(mean(fsigs$Prediction), 5),
                                   NumberOfSignals = nrow(fsigs),
                                   AvgActual = round(mean(fsigs$Actual), 5)
                                   )
                    )  
    grades <- rbind(grades, data.frame(Group = "ALL PREDICTIONS", 
                                       AvgPrediction = round(mean(mydata$Prediction), 5),
                                       NumberOfSignals = nrow(mydata), 
                                       AvgActual = round(mean(mydata$Actual), 5)
                                       )
                    )  


    print(grades, row.names = FALSE)

  })
  
  
  
  
  # Generate a table view of the downloaded data
    output$table <- DT::renderDataTable(DT::datatable({
      
      # input$file1 will be NULL initially. After the user selects
      # and uploads a file, it will be a data frame with 'name',
      # 'size', 'type', and 'datapath' columns. The 'datapath'
      # column will contain the local filenames where the data can
      # be found.
      
      inFile <- input$file1
          if (is.null(inFile))
            return(NULL)
      myTable <-  read.csv(inFile$datapath, header=input$header, sep=input$sep, 
                   quote=input$quote, col.names=c("FilingID","Symbol","Date","Prediction","Actual")) 
          
      # using condition23 to create a new data frame without outliers 
      condition25 <- ((myTable[,4] >= -0.25 & myTable[,4] <= 0.25)
                      &
                      (myTable[,5] >= -0.25 & myTable[,5] <= 0.25)
      )
      myTable2 <- myTable[condition25,]
      
      # returning either myTable or myTable2, depending on the Outliers button
      if (outliers()) {
        # switching among subsets: 1=all, 2=sell predictions only, 3=buy predictions only
        if (subset() == 1) {
          myTable            
        } else if (subset() == 2) {
          myTable <- filter(myTable, Prediction <= 0)
        } else {
          myTable <- filter(myTable, Prediction > 0)
        }
        
            
      } else {
        # switching among subsets: 1=all, 2=sell predictions only, 3=buy predictions only
        if (subset() == 1) {
          myTable2            
        } else if (subset() == 2) {
          myTable2 <- filter(myTable2, Prediction <= 0)
        } else {
          myTable2 <- filter(myTable2, Prediction > 0)
        }    
      }
    
    })) 
    
    }
