library(tidyverse)
library(httr)
library(json64)
library(janitor)

#Get Kraken crypto prices data
tickerjson <- GET("https://api.kraken.com/0/public/Ticker", 
                  query = list(pair = "XBTUSD,ETHUSD,ATOMUSD,FILUSD"))

tickerinfo <- (fromJSON(rawToChar(tickerjson$content)))$result

#Create vector of opening prices from Kraken data
krakenprices <- c()

for (currency in tickerinfo) {
  krakenprices <- append(krakenprices, as.integer(currency$c[[1]]))
}

#Create data frame of crypto names to crypto prices
cryptoprices <- data.frame(crypto = names(tickerinfo), price = krakenprices)

#SERVER FUNCTION
server <- function(input, output){
  #Add column showing portfolio balance by crypto to cryptoprices
  
  cryptoheld <- reactive(c(input$ATOM, 
                           input$FIL, 
                           input$ETH, 
                           input$XBT))
  
  cryptobalance <- reactive(data.frame(crypto = c("ATOM", 
                                                  "FIL", 
                                                  "ETH",
                                                  "XBT"),
                                                  balance = cryptoheld() * 
                                                  cryptoprices$price))
  
  reactive(print(length(cryptobalance()$balance)))
  
  #Visualization of Balance
  #Balance Table
  output$balancetable <- renderDataTable(cryptobalance())
  
  #Balance Bar Chart
  output$balancebar <- renderPlot(ggplot(data = cryptobalance(), 
                                         aes(x = crypto,
                                             y = balance)) +
                                  geom_bar(stat = "identity",
                                           width = 0.5,
                                           fill = "green2"))
  
  output$totalbalance <- reactive(as.character(sum(cryptobalance()$balance)))
} #server
                