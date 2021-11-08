
# Build the structure of the Radio-MatrixFrame 

RMF_func <- function(){
  rowID <- c(1, 2, 3, 4, 5)
  rowNames <- list(Q1 = c("Ik voel pijn", "Ik moet er om lachen", "Ik raak van slag", "Ik vind het naar voor haar", "Ik wil haar helpen"),
                   Q2 = c("Ik voel me blij","Ik heb er de pest in", "Ik raak van slag", "Ik vind het fijn voor haar", "Ik wil haar feliciteren"),
                   Q3 = c("Ik voel me verdrietig", "Ik moet er om lachen", "Ik raak van slag", "Ik vind het naar voor haar", "Ik wil haar troosten"),
                   Q4 = c("Ik voel pijn", "Ik moet er om lachen", "Ik raak van slag", "Ik vind het naar voor hem", "Ik wil haar helpen"),
                   Q5 = c("Ik voel me blij","Ik heb er de pest in", "Ik raak van slag", "Ik vind het fijn voor hemr", "Ik wil haar feliciteren"),
                   Q6 = c("Ik voel me verdrietig", "Ik moet er om lachen", "Ik raak van slag", "Ik vind het naar voor hem", "Ik wil haar troosten"))
  columnNames <- c("helemaal niet", "een beetje",
                   "redelijk goed", "sterk",
                   "heel sterk")
  
  radiM = data.frame(rowID, rowNames, columnNames)
  
  # Save radiM dataframe as a csv file
  write.csv(x=radiM, file="D:/project/R-projects/dashboard-shiny/empathy-viz/data/RadioMatrix.csv", row.names = FALSE)
  
}




# Build the structure of the Qlist
Qlist_func <- function(){

  Qnum <- c(1, 2, 3, 4, 5, 6)
  Question <- c("Stel, je loopt op straat. Het is winter en glad. In de verte zie je iemand uitglijden met de fiets. Als je dichterbij komt zie je dat het een goede vriendin van je is die op de grond ligt met een nare schaafwond. Zij houdt zich groot, maar heeft veel pijn. Wat voel je en wat doe je?",
                "Je bent op een schoolfeest. Op een gegeven moment worden er een paar mooie prijzen verloot. Je valt zelf niet in de prijzen, maar wel een goede vriendin waarmee je samen op het feest bent. Zij is natuurlijk heel blij. Wat voel je en wat doe je?",
                "Op school hebben jullie een belangrijk examen gehad. De uitslag wordt bekend gemaakt. Zelf ben je geslaagd, maar je beste vriendin is gezakt en moet het jaar overdoen. Je ziet haar vechten tegen de tranen. Wat voel jij en wat doe je?",
                "Je bent met een paar vrienden en vriendinnen in het zwembad. Het is druk en er staat een lange rij voor de hoge duikplank. De één durft meer dan de ander en als een vriend van je treuzelt wordt hij van de plank geduwd. Hij valt plat op het water. Je ziet het gebeuren. Wat voel je en wat doe je?",
                "Een goede vriend houdt erg van zingen en optreden. Hij heeft meegedaan aan de voorrondes van de Voice Kids. Als je op school komt staat iedereen om hem heen: hij is door de voorrondes gekomen en zal op tv komen. Hij is natuurlijk heel blij. Wat voel je en wat doe je?",
                "Stel, je loopt op straat en ziet opeens dat een vriend van je wordt gepest door een paar leeftijdsgenoten. Ze staan om hem heen, pakken zijn schooltas af en gooien de inhoud op straat. Ze lopen lachend weg. Jouw vriend pakt zijn spullen op en ziet er heel verdrietig uit. Wat voel jij en wat doe je?"
                )
  subQ1 <- c("Stel dat het een jongen is die je verder niet kent. Wat voel je en doe je dan?",
             "Stel dat het een jongen is die je verder niet kent. Wat voel je en doe je dan?",
             "Stel dat het een jongen is die je verder niet kent. Wat voel je en doe je dan?",
             "Stel dat het een jongen is die je verder niet kent. Wat voel je en doe je dan?",
             "Stel dat het een jongen is die je verder niet kent. Wat voel je en doe je dan?",
             "Stel dat het een jongen is die je verder niet kent. Wat voel je en doe je dan?")
  subQ2 <- c("Of een jongen die je niet graag mag. Wat voel je en doe je dan?",
             "Of een jongen die je niet graag mag. Wat voel je en doe je dan?",
             "Of een jongen die je niet graag mag. Wat voel je en doe je dan?",
             "Of een jongen die je niet graag mag. Wat voel je en doe je dan?",
             "Of een jongen die je niet graag mag. Wat voel je en doe je dan?",
             "Of een jongen die je niet graag mag. Wat voel je en doe je dan?")


  Qlist = data.frame(Qnum, Question, subQ1, subQ2)

  # Save Qlist as a csv file
  write.csv(x=radiM, file="D:/project/R-projects/dashboard-shiny/empathy-viz/data/Qlist1.csv", row.names = FALSE)

}

Qlist_func()

