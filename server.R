
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

library(dplyr)
rainfall <- read.csv(file = "Kerala_District_Rainfall_Normal_0.csv")

mytib <- tbl_df(data = rainfall)
mytib1 <- select(.data = mytib,2,15) %>% 
            mutate(ANNUAL_inches = ANNUAL * 0.0393701)

shinyServer(function(input, output) {
    
    # 1 litre is 0.264172 gallons and 
    # On an avg, 135 litres is assumed to be consumed by 1 person in a day; 365 days per year
    
    output$daily_cons <- reactive({input$members * 135})
    output$yearly_cons_litres <- reactive({input$members * 135 * 365 })
    output$yearly_cons_gal <- reactive({input$members * 135 * 365 * 0.264172})
    
    
    # Assuming only 70 % of the total area can harvest RW, and the rest is wasted
    output$rwh_area <- reactive({input$area * 0.70})
    
    # To display the user selected District
    output$selected_district <- reactive({input$district})
    
    
    # To display the average rainfall for the selected district,
        #myreactiveValues <- reactiveValues(obj1val,obj2val)

        myval1fun <- reactive({
            mytib2 <- select(filter(mytib1, DISTRICT == input$district),3)
            myval1 <- mytib2$ANNUAL_inches
            return(myval1)
        }) 
        
        output$distr_annrf_gal  <- reactive({
            myval1fun()
        })
        
        # 1 inch rain in 1000 sq.ft area can harvest 620 gallons
        
          myval2fun <- reactive({
            mytib2 <- select(filter(mytib1, DISTRICT == input$district),3)
            myval1 <- mytib2$ANNUAL_inches
            myval2 <- myval1 * 620 * (input$area/1000) * 0.70
            return(myval2)
        }) 
        output$yearly_harv_gal  <- reactive({
            myval2fun()
        })
        
        myval3fun <- reactive({
            # to recalculate the volume of water consumed by the family annually in gallons
            mytemp <- input$members * 135 * 365 * 0.264172
            
            myval3 <- myval2fun() / mytemp
            return(myval3)
        }) 
        output$prop_savings  <- reactive({
            myval3fun()
        })

        # 2. to plot - Start *******************************************************
        myplotfun <- reactive({
            # to recalculate the volume of water consumed by the family annually in gallons
            myconsump <- input$members * 135
            return(myconsump)
        }) 
        output$plot <- renderPlot({
            forplot_area <- input$area
            forplot_members <- input$members
            plot(x = forplot_area, 
                 y = (myval2fun()/31.5), 
                 type = "h",
                 main="Your Annual havesting Capacity based on floor area & district",
        #         sub = "(based on floor area & district",
                 xlab="Roof Area ", 
                 ylab="RWH capacity in barrels ", 
                 col = "red",
                 lwd = 5,
                 border = "white")
        })
        # 3. to display table value **************************************************
        output$table <- renderTable({
            mytib1
        })
})
