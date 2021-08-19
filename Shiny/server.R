#libraries
library(shiny)
library(dplyr)
library(ggplot2)
library(scales)
library(lubridate)
library(DT)
library(rgdal)


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

      shinyServer(function(input, output, session) {

            
            
            #Panel 1
            observe({
                  x <- input$continent
                  
                  # Use character(0) to remove all choices
                  if (is.null(x))
                        x <- character(0)
                  
                  updateSelectInput(session, "country",
                                    choices=unique((subset(mywdata, mywdata$continent==x))$location)
                  )})
            
            data_sub <- reactive({
                  a=select(subset(mywdata, mywdata$location==input$country),c(1,2,3,input$choice))
                  a$date=as.Date(a$date)
                  return (a)
            })
            data_sub1 <- reactive({
                  a=select(subset(mywdata, mywdata$location==input$country),c(1,2,3,input$choice))
                  return (a)
            })
            
            output$graph <- renderPlot({
                  ggplot(data_sub(), 
                         aes_string(x = "date", y=input$choice, group=1)) + 
                        geom_line()+
                        labs(x = "Year")
            })
            
            output$note <- renderText({ 
                  paste("You have selected", input$continent, ",", input$country, "and", input$choice)
            })
            
            #Panel Table
            output$view <- renderTable({
                  tail(data_sub1(),20)
            }) 
            
            #Panel Prediction
            model<-reactive({
                  mdata<-subset(mywdata, mywdata$location==input$country)
                  lm(new_deaths~as.Date(date), data=mdata)
            })
            
            output$lm<-renderText({
                  d <- ymd(Sys.Date()) %m+% months(6)
                  pr=round(predict(model(), newdata = data.frame('date'=as.character(d))),0)
                  paste("The predicted number of new deaths in 6 months time for the selected country based on
               the previous data", 
                        input$country, "is", pr )
            })
            
            
            output$predict<-renderPlot({
                  mdata<-subset(mywdata, mywdata$location==input$country)
                  ggplot(mdata, 
                         aes(x = as.Date(date), y= new_deaths)) + 
                        geom_point()+
                        stat_smooth(method=lm)+
                        labs(x='', y='New Death Cases')
            })
            
      })