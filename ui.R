
header<-dashboardHeader(title="CleanTechPulse")

body<-dashboardBody(
  fluidRow(
    column(width = 9,
           box(width = NULL, solidHeader = TRUE,
               leafletOutput("solarMap", height=400)
           ),
           box(width=NULL,
               dataTableOutput("boroughTable")
           )
    ),
    column(width=3,
           box(width=NULL,
               uiOutput("zipcodeSelect"),
               radioButtons("meas", "Scale",c("Small"="Small", "Large"="Large"))
               # checkboxInput("city", "Include City of London?",TRUE)

           )
    )
  )
)
dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)