#Arima Forecast

#einlesen der Daten
GME <- read.csv('C:/Users/S.Faltenberg/Desktop/FHDW/5. Semester/Data Lab/gameStopStockPrediction-master/input/GME_CloseAndReddit_previous_polish_04Jan_11May.csv')
library(forecast) #wird für tslm benötigt

#erstellung der Variablen
GME.close.ts <- ts(GME$Close)
GME.comments.ts <- ts(GME$Anzahl)
GME.cc.ts <- ts.union(GME.close.ts, GME.comments.ts) 

#Darstellung der Daten
plot(GME.cc.ts)

#erstellen des TimeSeries-Objekts
GME.close.ts <- ts(GME$Close)

#Trennung in Traingsdaten und Validierungsdaten
stepsAhead <-18 #Anzahl Prognosetage
nTrain <-length(GME.close.ts) - stepsAhead
train.close.ts <-window(GME.close.ts, start = 1, end = c(1, nTrain))
valid.close.ts <-window(GME.close.ts, start = c(1, nTrain +1), end = c(1, nTrain+stepsAhead))

#Arima nur mit Kursdaten

#Es wird nur mit den Kursdaten gearbeitet, da durch das Nutzen des Trendes ein viel 
#schlechteres Ergebnis erreicht werden würde. Das Arima Modell hatte durch den Trend 
#auch Werte unter 0 vorhergesagt und der MAPE-Wert war weit über 100. Einen Saisonalen 
#Effekt gibt es auch nicht, weswegen dieser auch nicht beachtet wird.

close.arima <- auto.arima(train.close.ts)
summary(close.arima)
plot(train.close.ts, xlab="Zeit", ylab="Kurs",ylim=c(10,600))
lines(close.arima$fitted, lwd = 2)


#Forecast Arima nur mit Kursdaten

#In der Arima-Prediction wird kein Anstieg oder Abfall des Kurswertes prognostiziert. 
#Das Model hat ein Wert ermittelt, der grob den Durschnitt wiedergibt und so ein gutes 
#Ergebnis erzielt.
close.arima.pred <- forecast(close.arima, h = stepsAhead, level=0)
plot(close.arima.pred, ylab = "Kurs", xlab = "Zeit",ylim = c(10,400))
lines(close.arima.pred$fitted, lwd=2)
lines(valid.close.ts)
accuracy(close.arima.pred$mean, valid.close.ts)

#Trennung in Trainingsdaten und Validierungsdaten
train.comments.ts <-window(GME.comments.ts, start = 1, end = c(1, nTrain))
valid.comments.ts <-window(GME.comments.ts, start = c(1, nTrain +1), end = c(1, nTrain+stepsAhead))
train.cc.ts <- window(GME.cc.ts, start = 1, end = c(1, nTrain))
valid.cc.ts <-window(GME.cc.ts, start = c(1, nTrain +1), end = c(1, nTrain+stepsAhead))



#tslm Durchführung mit Kursdaten und Kommentaren

#Da man in Arima keine Korrelationen in Modelle einbauen kann, wird dafür zuerst ein 
#tsml-Model genutzt. Es wird ein Trend^2 genutzt, da dieser wie man in der Summary sehen kann, 
#eine hohe Korrelation hat.
closecomments.tsml <- tslm(train.close.ts~train.comments.ts+ I(trend^2))
summary(closecomments.tsml)


#Arima mit Kursdaten und Kommentaren

#Das tsml-Model nutzen wir jetzt für Arima, da Arima damit umgehen kann. 
#Leider verschlechtert sich aber das Model, da es annimmt, dass der Kurswert auch im 
#negativen Bereich sein kann.

closecomments.arima <- auto.arima(closecomments.tsml$residual)
summary(closecomments.arima)

#Arima mit Kursdaten und Kommentaren

plot(train.close.ts, xlab="Zeit", ylab="Kurs",ylim=c(-60,400))
lines(closecomments.arima$fitted, lwd = 2)


#Forecast Arima mit Kursdaten und Kommentaren

#In der Prediction sieht man, das Arima jetzt keine einfache Gerade angegeben hat, 
#sondern das auch ein Trend erkennbar ist. Es wird vorhergesagt, das die Kursdaten etwas 
#nach oben gehen werden. Allerdings ist die Prediction durch das Model unbrauchbar, da sich 
#diese um den Nullpunkt der y-Achse hält.

closecomments.arima.pred <- forecast(closecomments.arima, h = 18)
plot(closecomments.arima.pred, ylab = "Kurs", xlab = "Zeit",ylim = c(0,400))
lines(closecomments.arima.pred$fitted, lwd=2)
lines(valid.close.ts)
accuracy(closecomments.arima.pred$mean, valid.close.ts)


#Fazit: Das Arima Model hat nur mit den Kursdaten ganz gut abgeschnitten. Der MAE Wert beträgt:
#8.168 und MAPE: 4.97. Allerdings wäre es in der Praxis nicht so gut, da das Model eine Gerade 
#erzeugt hat, ohne Anstieg oder Abfall. Ein Trend ist daher nicht erkennbar, weshalb ich anhand 
#dieses Models kein Geld in GME investieren würde. Arima mit Kursdaten und Kommentaren, sieht im 
#ersten Moment ganz pasabel aus, allerdings ist dieses nach unten verschoben, wodurch es zu sehr 
#großen Abweichungen beim MAE und MAPE kommt. Wenn man Arima nutzen will, dann nur unter Verwendung 
#der Kursdaten und ohne weitere Attribute.