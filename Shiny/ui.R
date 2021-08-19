library(shiny)


#Download dataset
temp <- tempfile()
download.file(
   "https://covid.ourworldindata.org/data/owid-covid-data.csv", temp)
mydata<-read.csv(temp)
unlink(temp)

# Subset data (select required columns, get rid of empty continent values)
mywdata<-mydata[,c(2,3,4,5,8,9)]
mywdata<-mywdata[complete.cases(mywdata$total_deaths),]
mywdata<-subset(mywdata, mywdata$continent!="")

shinyUI(fluidPage(
      
      titlePanel("Latest COVID update"),
      sidebarPanel(
            helpText('Please choose the continent and then the country you want to study'),      
            
            radioButtons("continent",
                         label = h3("Select Continent"),
                         choices = unique(mywdata$continent),
                         selected='Asia',
            ),
            
            selectInput("country",
                        label = h3("Select Country"),
                        choices = "None"
            ),
            
            selectInput('choice', 
                        label=h3("Select which graph to show"),
                        choices=list("Overall Cases"="total_cases", "Overall Deaths"="total_deaths",
                                     "New Reported Deaths"="new_deaths"),
                        selected='total_cases')),
      
      
      mainPanel(
            fluidRow(column(12, align='center',
                            tabsetPanel(
                                  tabPanel("Plot", span(textOutput("note"), style="color:red", align='centre'),
                                           plotOutput("graph")
                                  ),
                                  
                                  tabPanel("Table",  "The last 25 recent entried are shown below",
                                           br(),br(),
                                           tableOutput('view')),
                                  
                                  tabPanel("Predictions", 
                                           "Future prediction of the new deaths based on the linear regression model",
                                           br(),
                                           br(),
                                           'Please select the continent and the country to show the desired plot',
                                           br(),
                                           br(),
                                           textOutput('lm'),
                                           br(),
                                           br(),
                                           plotOutput('predict')
                                  ),
                                  
                                  tabPanel('Documentation', 
                                           'Author: Irina White',
                                           br(),
                                           'Date: 18 August, 2021',
                                           
                                           br(),
                                           br(),
                                           'This project has been design solemnly for the self-educational purposes,
                  however the data used for the project is real and is obtained from the open source:
                  https://covid.ourworldindata.org/data/owid-covid-data.
                  The data on the website is being daily updated.',
                                           br(),
                                           br(),
                                           'The data for the project has been slighly modified for simplicity, only 6 columns
                  have been selected: continent, location, date, total deaths, total cases and new deaths.
                  Also all data with NA values have been omitted.',
                                           br(),
                                           br(),
                                           'The app gives the user an ooprtunity to select continent and country to see the visual 
                  representation of the changes in covid numbers related to death or number of cases.
                  It also includes the tabular format of the same information.',
                                           br(),
                                           br(),
                                           'The prediction Tab includes plot of linear regression of new daily cases and 
                  potential number of new daily cases in 6-month time in the selected country.'
                                           
                                  )
                            ),
                            
            )))
))

