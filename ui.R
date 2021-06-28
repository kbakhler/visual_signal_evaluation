library(shiny)
library(ggplot2)


fluidPage(
  
  # Application title
  titlePanel("Analyzing Model Predictions 3"),
  
  # Sidebar with controls to import data and select 
  # which subset of predictions to analyze.
  sidebarLayout(
    sidebarPanel(
      
      radioButtons("subSignals", "Which Predictions to Analyze:",
                   c("All Predictions" = "all",
                     "Only Predictions < 0%" = "sells",
                     "Only Predictions > 0%" = "buys")),
      
      radioButtons("outliers", "Outliers:",
                   c("Include All Data" = "outin",
                     "Exclude Predictions/Actual <-25% or >+25%" = "outout")),
      
      br(),
      br(),
      br(),
      
      fileInput('file1', 'Choose Text File',
                accept=c('text/csv', 
                         'text/comma-separated-values,text/plain', 
                         '.csv')),
      
      checkboxInput('header', 'Header', FALSE),
      radioButtons('sep', 'Separator',
                   c(Comma=',',
                     Semicolon=';',
                     Tab='\t'),
                   ','),
      radioButtons('quote', 'Quote',
                   c(None='',
                     'Double Quote'='"',
                     'Single Quote'="'"),
                   '')
    ),
    
    # Show a tabset that includes a scatter plot, summary, and table views
    # of the generated distribution
    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("Scatter Plot", 
                           br(),
                           plotOutput("plot")
                           ), 
      
                  
              
                  tabPanel("Summary", 
                           h3("Linear Regression of Actual~Prediction"),
                           h4("We'd like lots of stars to the right of Coefficients section"),                           
                           verbatimTextOutput("summary"),
                           h3("Intercept & Slope"),
                           h4("We'd like slope (prediction coefficient) of close to +1 as it'd hint at predictions=actuals"),
                           h4("Negative slope is bad"),
                           verbatimTextOutput("summary2")
                           ), 
                  
                  tabPanel("Grading", 
                           h2("Grouping our predictions into 'buckets'"),
                           br(),
                           h4("Absolute Levels: we'd like for a 'A' prediction to exhinit 'best' Avg Actual Outcome >0"),                           
                           h4("...similarly, we'd like for a 'F' prediction to exhinit 'worst' Avg Actual Outcome <0"),                           
                           br(),                           
                           h4("Relative Order is also immportant"),                           
                           h4("We'd like Avg Actual Outcome to steadily decrease from 'A' signals to 'F' signals"),                           
                           br(),
                           verbatimTextOutput("grades")
                  ), 
                  
                  
                  tabPanel("Data Table", DT::dataTableOutput("table")
                           )
                  
      )
    )
  )
)
