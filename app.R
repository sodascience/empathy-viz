#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(navbarPage(theme = bslib::bs_theme(bootswatch = "flatly"),
                 # Application title
                 "Empathy Survey",
                 
                 # First menu entry
                 tabPanel(
                   "Input",
                   
                   # First menu body
                   wellPanel(
                     style= "min-width: 300px;max-width: 400px;overflow:auto",
                     verticalLayout(
                       h4("Background information"),
                       textInput("Gender", placeholder = "Gender", label = "Gender:", width = "30%"),
                       textInput("Age", placeholder = "Age", label = "Age:", width = "30%"),
                       textInput("Code", placeholder = "Code", label = "Code:", width = "30%"),
                       submitButton("Submit", icon = NULL, width = '100px')
                   )
                 )),
                 
                 
                 # Second menu entry
                 tabPanel(
                   "Questionnair",
                   
                   # Second menu body
                   sidebarLayout(
                     sidebarPanel(
                                  p("Vraag 1 - pijn"),
                                  p("Vraag 2 - blijheid"),
                                  p("Vraag 3 - droefheid"),
                                  p("Vraag 4 - pijn"),
                                  p("Vraag 5 - blijheid"),
                                  p("Vraag 6 - droefheid")

                                  ),
                     
                     mainPanel(
                       verticalLayout(
                         strong("Survay"),
                         p(style="text-align: justify;",
                           "We maken het allemaal wel eens mee dat we zien dat iemand zich pijn doet,
                         verdrietig is of juist heel blij is. Als we zien dat iemand zich bijvoorbeeld snijdt,
                         het hoofd stoot of struikelt op straat dan weten we dat dat pijn doet maar voelen dat
                         soms ook. Als we horen dat iemand gepest is of buitengesloten wordt dan vinden we dat
                         vaak zielig en soms worden we van iemand die heel blij is zelf ook een beetje blij.
                         Het meeleven of meevoelen met de emoties van anderen doen we soms ongemerkt en met
                         de ene persoon meer dan met de ander. Wat wij graag van jou willen weten is wat jij
                         voelt en doet wanneer je ziet dat iemand verdrietig is, pijn heeft of juist blij is.",
                           style = "font-family: 'times'; font-si18pt"),
                         p(style="text-align: justify;",
                           "de volgende bladzijde staan een aantal uitspraken die gaan over het meevoelen met
                        anderen in verschillende situaties. Het kan natuurlijk zijn dat je nog nooit zo'n
                        situatie hebt meegemaakt. Probeer je dan voor te stellen hoe dat zou zijn,
                        wat je zou voelen en willen doen.",
                           style = "font-family: 'times'; font-si18pt"
                         ),
                         p(style="text-align: justify;",
                           "Er zijn geen goede of foute antwoorden. Het gaat om jouw eigen gevoel.",
                           style = "font-family: 'times'; font-si18pt"
                           
                         ),
                         p(style="text-align: justify;",
                           "Je antwoord geef je door het cijfer te omcirkelen wat het meest op jou van toepassing is:",
                           style = "font-family: 'times'; font-si18pt"
                           
                         ),
                         p(style="text-align: justify;",
                           "1= helemaal niet van toepassing",
                           style = "font-family: 'times'; font-si18pt"
                           
                         ),
                         p(style="text-align: justify;",
                           "2= een beetje van toepassing",
                           style = "font-family: 'times'; font-si18pt"
                           
                         ),
                         p(style="text-align: justify;",
                           "3= redelijk goed van toepassing",
                           style = "font-family: 'times'; font-si18pt"
                           
                         ),
                         p(style="text-align: justify;",
                           "4= sterk van toepassing",
                           style = "font-family: 'times'; font-si18pt"
                           
                         ),
                         p(style="text-align: justify;",
                           "5= heel sterk van toepassing",
                           style = "font-family: 'times'; font-si18pt"
                           
                         ),
                         actionButton("click", "Start", width='100px')
                       )
                     )
                   )
                     
                   ),
                   
                 
               # Third menu with sub-menu
               navbarMenu("Visualization",
                          tabPanel("Pain"),
                          tabPanel("Sadness"),
                          tabPanel("Happiness"))
))


# Define server logic required to draw a histogram
server <- function(input, output) {}

# Run the application 
shinyApp(ui = ui, server = server)