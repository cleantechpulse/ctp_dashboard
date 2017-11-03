library(dplyr)
library(leaflet)
library(rgdal)
library(DT)
library(shinydashboard)
library(RPostgreSQL)
library(DBI)

source("settings.txt")
#source("helpers.R")
source("queries.R")

offline <<- app.settings$offline.for.debugging #TRUE #FALSE

if(!offline){
  #suppressMessages(gs_auth(token = "googlesheets_token.rds", verbose = FALSE))
}

#shiny::addResourcePath("shinyjs", system.file("srcjs", package = "shinyjs"))

zipcode <- geojsonio::geojson_read("California_zip_v1.geojson", what = "sp")
solar <- zip.summary