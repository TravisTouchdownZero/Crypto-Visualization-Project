source("cryptoserv.R")
library(shiny)
library(shinythemes)

#Define ui
ui <- fluidPage(theme = shinytheme("cerulean"),
                navbarPage(
                  # theme = "cerulean",  # <--- To use a theme, uncomment this
                  "Crypto Portfolio Visualization",
                  tabPanel("Balance",
                           sidebarPanel(
                             numericInput("XBT", 
                                          "XBT Held", 
                                          0),
                             numericInput("FIL", 
                                          "FIL Held", 
                                          0),
                             numericInput("ETH", 
                                          "ETH Held", 
                                          0),
                             numericInput("ATOM", 
                                          "ATOM Held", 
                                          0),
                           ), # sidebarPanel
                           mainPanel(
                             h1("USD Balance Display"),
                             
                             h4("USD Balance"),
                             dataTableOutput("balancetable"),
                             verbatimTextOutput("totalbalance"),
                             plotOutput("balancebar")
                             
                           ) # mainPanel
                  )
                ) # navbarPage
) # fluidPage