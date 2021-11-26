
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

# Application Documentation
#title: "Rain water harvesting Web App - Assignment using Shiny"
#author: "Balaji K"
#date: "17 Feb 2018"

# This web application interactively accepts 3 input values from the user - Number of 
# family members, Roof Area and District one belongs to, to recommend how much of water 
# could be harvested.
#      The three inputs are accepted via 2 sliders and 1 drop-down list.  A lookup table is 
# made available by downloading rainfall data from the internet.  Water requirement based
# on the family's consumption is calculated & reported.  Capacity to harvest RW depending 
# on the district's annual rainfall and the family's floor area are also calculated &
# reported.  
#       3 tabs are kept - one for textual interaction, second one for graphical representation and
# the third for displaying the lookup table.

library(shiny)
shinyUI(fluidPage(

  # Application title
  titlePanel(h5("Potential for Rain Water Harvesting")),

  # Sidebar with a slider input for area, number of family members and district
  sidebarLayout(
    sidebarPanel(
      sliderInput("members","Nbr of family members:", min = 1, max = 10, value = 4),
      sliderInput("area", "Floor Area in sq.ft:", min = 500, max = 5000, value = 2000),
      selectInput(inputId = "district",
                  label = "District",
             #     choices = rainfall$DISTRICT,
                  choices = c("THIRUVANANTHA", "PALAKKAD","CANNUR"),
                  selected = "THIRUVANANTHA", 
                  multiple = FALSE,
                  width = '100%')
    ),
  mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Summary", 
                           # plotOutput("distPlot")
                           h3("Rain water harvesting Capacity Calulator"),
                           h4("Your family's daily water consumption (in litres) is: "), textOutput("daily_cons"),
                           # h4("Your family's Annual water consumption in litres is "), textOutput("yearly_cons_litres"),
                           h4("Your family's Annual water consumption (in gallons) is: "), textOutput("yearly_cons_gal"),
                           
                           h4("You have selected your district as: "), textOutput("selected_district"), 
                           
                           # h4("Annual rainfall in your district is: "), textOutput("distr_annrf_gal"),
                           h4("Annual rainfall (in inches) in your district is: "), textOutput("distr_annrf_gal"),
                           h4("Effective area (in sq.ft) you have for RW harvesting: "), textOutput("rwh_area"), 
                           
                           h4("Rain water you can harvest (in gallons) annually is: "), textOutput("yearly_harv_gal"),
                           h4("If you decide to harvest all of this RW, your proportionate savings would be: "), textOutput("prop_savings"),
                           h4("times what you consume"),
                           verbatimTextOutput("summary")
                           ),
                  tabPanel("Plot", 
                           plotOutput("plot")
                  ),
                  tabPanel(title = "Table",
                           h3("District-wise Annual rainfall in inches"),
                           tableOutput("table")
                           )
      )
    )
  )
))

