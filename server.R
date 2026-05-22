# Server-side processing

library(shiny)
library(dplyr)

function(input, output) {

    data(diamonds)
    ds1 <- diamonds[, c(1:4, 7)]
    ds1 <- ds1 |> mutate_if(is.integer, as.numeric)
    lin_model <- lm(price~., ds1)
    
    output$subset_plot <- renderPlot({
        dset <- ds1 |> 
            filter(grepl(input$cut_in, cut), grepl(input$color_in, color), 
                   grepl(input$clarity_in, clarity))
        lin_model <- lm(price ~ carat, dset)
        est_price <- predict(lin_model, newdata = data.frame(carat = input$carat_in))
        subset_plot <- ggplot(data = dset, aes(x = carat, y = price)) +
            geom_point(alpha = 0.25) +
            geom_smooth(method = 'lm') +
            geom_hline(yintercept = est_price, color = 'red') +
            geom_vline(xintercept = input$carat_in, color = 'red')
        subset_plot
    })
    output$estimate <- renderText({
        dset <- ds1 |> 
            filter(grepl(input$cut_in, cut), grepl(input$color_in, color), 
                   grepl(input$clarity_in, clarity))
        lin_model <- lm(price ~ carat, dset)
        est_price <- predict(lin_model, newdata = data.frame(carat = input$carat_in))
        
        if(input$carat_in > max(dset$carat)){
            return(paste('$', round(est_price, digits = -1), '  (Out of model range - accuracy of estimate questionable.)'))
        }
        if(est_price < 0){
            return('Out of model range - no estimate available.')
        }
        return(paste0('$',round(est_price, digits = -1)))
    })
}