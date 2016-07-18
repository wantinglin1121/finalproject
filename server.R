# 後端資料產出(會動的)
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library("quantmod")

# Define server logic required to draw a histogram  
shinyServer(function(input, output) {   #固定的不能修改
   
  #第一張圖的名稱
  output$distPlot <- renderPlot({   #依最後要的選擇plot或text等 跟畫圖有關的包進去renderplot 
                                    #一個function只能有一張圖 
                                    #renderplot裡的東西要在R裡測試 且只跑一張圖
    
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]   #拿資料放進x
    bins <- seq(min(x), max(x), length.out = input$bins + 1)  #資料統計
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')  #繪圖
    })
  
  output$testPlot <- renderPlot({
    getSymbols("AAPL",src="yahoo")  #建立package
    barChart(AAPL)
    })
  
  output$testPlot2 <- renderPlot({
    getSymbols("AAPL",src="yahoo")
  chartSeries(AAPL,theme="white")
  })
})


  

