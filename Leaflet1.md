---
title: "Leaflet Project"
author: "Irina White"
date: "30/07/2021"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = FALSE)
```

## Current Date
```{r, warning=FALSE}
library(leaflet)
library(dplyr)
library(tidyr)
Sys.Date()

```

## Current Location
```{r}
my_map<-leaflet()%>%addTiles() %>% addMarkers(lat=51.509865, lng=-0.118092)

my_map
```