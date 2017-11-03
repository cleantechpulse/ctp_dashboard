#Warning message:
#  In rgdal::readOGR(input, rgdal::ogrListLayers(input), verbose = FALSE,  :
#                      Dropping null geometries: 438, 439, 967, 968, 1633
 #read.csv('data.csv')


server <- function(input, output, session) {
  getDataSet<-reactive({
    
    # Get a subset of the solar data which is contingent on the input variables, right now this doesn't matter
    dataset<-solar
    # [solar$Zipcode == input$zipcode]
    joinedDataset <- zipcode
     
    # Join the two datasets together
    dataset<- rename(dataset, ZCTA5CE10 = zip_code)
    dataset$ZCTA5CE10 <- as.factor(dataset$ZCTA5CE10)
    joinedDataset@data <- suppressWarnings(left_join(zipcode@data, dataset, by="ZCTA5CE10"))
    
    joinedDataset
  })
  
  # Due to use of leafletProxy below, this should only be called once
  output$solarMap<-renderLeaflet({
    
    leaflet() %>%
      # addTiles() %>%
      # Centre the map in the middle of our co-ordinates
      setView(-119, 36, 7) %>% 
      addProviderTiles("MapBox", options = providerTileOptions(
        id = "mapbox.light",
        accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN')))
    
    
  })
  
  observe({
    theData<-getDataSet()

    # colour palette mapped to data
    pal <- colorQuantile("YlGn", theData$total_capacity, n = 9)

    # set text for the clickable popup labels
    borough_popup <- paste0("<strong>zipcode: </strong>",
                            theData$ZCTA5CE10,
                            "<br><strong>",
                            input$meas,"
                            total_systems: </strong>",
                            formatC(theData$total_systems, format="d", big.mark=',')
    )

    
    
    # If the data changes, the polygons are cleared and redrawn, however, the map (above) is not redrawn
    leafletProxy("solarMap", data = theData) %>%
      clearShapes() %>%
      addPolygons(data = theData,
                  fillColor = pal(theData$total_capacity), 
                  fillOpacity = 0.8, 
                  highlight = highlightOptions(
                    weight = 2,
                    color = "#c93a3a",
                    dashArray = "",
                    fillOpacity = 0.7,
                    bringToFront = TRUE),
                  color = "#BDBDC3", 
                  weight = 2,
                  popup = borough_popup)  
  
    
    
  })
  
  # table of results, rendered using data table
  output$boroughTable <- renderDataTable(datatable({
    dataSet<-getDataSet()
    dataSet<-dataSet@data[,c("ZCTA5CE10", "total_capacity", "total_systems")] # Just get name and value columns
    names(dataSet)<-c("zipcode",'total_capacity', 'total_systems' )
    dataSet
  },
  options = list(lengthMenu = c(5, 10, 33), pageLength = 5))
  )
  
  # zipcode selecter; values based on those present in the dataset
  output$zipcodeSelect<-renderUI({
    zipcodeRange<-sort(unique(as.numeric(solar$Zipcode)), decreasing=TRUE)
    selectInput("datazipcode", "zipcode", choices=zipcodeRange, selected=zipcodeRange[1])
  })
}
  
  
    
  
  