# UI definition

library(shiny)

color_scale   <- c('D', 'E', 'F', 'G', 'H', 'I', 'J')
clarity_scale <- c('IF', 'VVS1', 'VVS2', 'VS1', 'VS2', 'SI1', 'SI2', 
                   'I1', 'I2', 'I3')
cut_scale     <- c('Ideal', 'Premium', 'Very Good', 'Good', 'Fair')

# Define UI for application that draws a histogram
fluidPage(
    
    # Application title
    titlePanel('Diamond Price Estimator'),
    
    # Sidebar with controls for parameters
    sidebarLayout(
        sidebarPanel(
            helpText('Enter the carat weight of the diamond in question.', br(),
            'Then select the color, cut, and clarity.', br(),
            'An estimated price for the diamond will be provided,', br(),
            'and the estimate plotted (intersection of the red lines) with the', br(),
            'data points used to develop the price estimation model.'),
            br(), br(),
            numericInput('carat_in',
                         label = 'Weight (carats)', 
                         value = 1,
                         min = 0.25,
                         max = 5),
            selectInput('color_in',
                        label = 'Color (GIA)',
                        color_scale),
            selectInput('clarity_in',
                        label = 'Clarity (GIA)',
                        clarity_scale),
            selectInput('cut_in',
                        label = 'Cut',
                        cut_scale)
        ),
        
        # Display price estimate
        # Include caveat about age of data
        mainPanel(
            plotOutput('subset_plot'),
            h4('Estimated value: '),
            h3(textOutput('estimate'))
        )
    )
)
