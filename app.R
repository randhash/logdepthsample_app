library(shiny)
library(ggplot2)

#Inputs
dpl <- 3 #number of decimal places to show
dfpt <- 6 #default number of points in profile

ui <- fluidPage(
  titlePanel("Log-spaced depth sample generator"),
  mainPanel(
    numericInput("heightmin", label="Minimum sample height from bed:", value=NA, min=0),
    numericInput("heightmax", label="Maximum sample height from bed:", value=NA, min=0),
    numericInput("depth", label="Water depth:", value=NA, min=0),
    numericInput("n", label="Number of points in profile:", value=dfpt, min=2),
    actionButton("submit", label="Generate profile"),
    actionButton("clear", label="Restore defaults"),
    hr(),
    textOutput("pretext"),
    column(width=3, plotOutput("dplot", width="120px", height="300px")),
    column(width=4, tableOutput("table"))
  )
)

server <- function(input, output, session) {
  #Clear inputs
  observeEvent(input$clear, {
    updateNumericInput(session, "heightmin", value=NA)
    updateNumericInput(session, "heightmax", value=NA)
    updateNumericInput(session, "depth", value=NA)
    updateNumericInput(session, "n", value=dfpt)
  })
  #Generate log-spaced samples once button is pressed
  observeEvent(input$submit, {
    #Check that all inputs are as expected
    if (any(c(input$heightmin>input$heightmax,
              input$heightmax>input$depth,
              input$heightmin==0,
              is.na(input$heightmin),
              is.na(input$heightmax),
              input$heightmin<0))) {
      output$pretext <- renderText({"Error: Adjust values."})
    } else {
      output$pretext <- renderText({""})
      #Calculate sample points
      ##Height
      h <- exp(seq(log(input$heightmin), log(input$heightmax), length.out=ceiling(input$n)))
      ##Convert height to depth
      d <- input$depth-h
      ##Add to data frame
      df <- round(data.frame(depths=d, heights=h), dpl)
      ##Adjust depth for plotting purposes if NA
      depth <- ifelse(is.na(input$depth), maxheight, input$depth)
      ##Nudge label position
      ny <- diff(range(df$heights))*0.04
      ##Plot
      dplot <- ggplot(aes(x=0, y=heights), data=df)+
        geom_point()+
        geom_segment(aes(x=0, xend=0, y=0, yend=depth), alpha=0.6)+
        geom_text(aes(label=heights), hjust=0, nudge_x=0.04)+
        geom_text(aes(label=depths), hjust=1, nudge_x=-0.04)+
        geom_text(aes(y=depth, label="Height:"), hjust=0, nudge_x=0.04, nudge_y=ny)+
        geom_text(aes(y=depth, label="Depth:"), hjust=1, nudge_x=-0.04, nudge_y=ny)+
        coord_cartesian(xlim=c(-1, 1), ylim=c(0, depth+1.5*ny))+
        theme(panel.grid=element_blank(), panel.background=element_blank(), axis.text=element_blank(), axis.ticks=element_blank(), axis.title=element_blank())
      #Output plot
      output$dplot <- renderPlot({dplot})
      #Output table
      output$table <- renderTable({df}, digits=dpl)
    }
  })
}

shinyApp(ui=ui, server=server)