#GME Regression

#Wir verwenden die Forecast-Library für die Erstellung von linearen Modellen mit TimeSeries-Objekten.
library(forecast) #wird für tslm benötigt

#Der Plot der Kursdaten zeigt den Verlauf über den beobachteten Zeitraum, der Verlauf wirkt wenig linear.
#Darstellung der genutzten Kursdaten
plot(GME$Date, GME$Close,ylab = "Börsenkurs", xlab = "Datum")
lines(GME$Date, GME$Close, col = "green")

#Regression nur mit Kursdaten

#Die erste Regressionanalyse führen wir lediglich mit den Kursdaten durch, um nachher einen Vergleich ziehen zu können, ob die Vorhersage unter Einbeziehung der Kommentare bessere Ergebnisse liefert.

#Einfügen der Kursdaten in TimeSeries-Objekt
kurse.ts<-ts(GME$Close)
plot(kurse.ts, xlab="Zeit", ylab="Kurs",ylim=c(10,600))

#Wir trennen die vorliegenden Daten in Trainings- und Kursdaten, hierbei wählen wir einen 80/20 Split. 80% der Daten werden als Trainingsdaten verwendet, während 20% später zur Validierung des Modells genutzt werden.
#Trennung in Traingsdaten und Validierungsdaten
stepsAhead <-18 #Anzahl Prognosetage
nTrain <-length(kurse.ts) - stepsAhead
train.kurse.ts <-window(kurse.ts, start = 1, end = c(1, nTrain))
valid.kurse.ts <-window(kurse.ts, start = c(1, nTrain +1), end = c(1, nTrain+stepsAhead))

#Wir führen drei verschiedene Regressionen durch: mit linearem Trend, mit polynomialem Trend 2. Ordnung sowie einem polynomialem Trend 3. Ordnung. Wir erhöhen die polynomiale Potenz nicht weiter, da es sonst zu Overfitting kommt, dies wollen wir vermeiden.
#Regression mit linearem Trend
kurse.lm1 <- tslm(train.kurse.ts ~ trend)
summary(kurse.lm1)
plot(train.kurse.ts, xlab="Zeit", ylab="Kurs",ylim=c(10,600))
lines(kurse.lm1$fitted, lwd = 2)

#Regression mit polynomialem Trend 2. Ordnung
kurse.lm2 <- tslm(train.kurse.ts ~ poly(trend, 2))
summary(kurse.lm2)
plot(train.kurse.ts, xlab="Zeit", ylab="Kurs",ylim=c(10,600))
lines(kurse.lm2$fitted, lwd = 2)

#Regression mit polynomialem Trend 3. Ordnung
kurse.lm3 <- tslm(train.kurse.ts ~ poly(trend, 3))
summary(kurse.lm3)
plot(train.kurse.ts, xlab="Zeit", ylab="Kurs",ylim=c(10,600))
lines(kurse.lm3$fitted, lwd = 2)

#Nachdem wir Regressionsmodelle erstellt haben, können wir diese nun mithilfe der Validierungsdaten auf ihre Performance testen.
#Forecasts mit linearem Trend
kurse.lm1.pred <-forecast(kurse.lm1, h = stepsAhead, level=0)
plot(kurse.lm1.pred, ylab = "Kurs", xlab = "Zeit",ylim = c(10,600))
lines(kurse.lm1.pred$fitted, lwd=2)
lines(valid.kurse.ts)
accuracy(kurse.lm1.pred$mean, valid.kurse.ts)

#Forecasts mit polynomialem Trend 2. Ordnung
kurse.lm2.pred <-forecast(kurse.lm2, h = stepsAhead, level=0)
plot(kurse.lm2.pred, ylab = "Kurs", xlab = "Zeit",ylim = c(10,600))
lines(kurse.lm2.pred$fitted, lwd=2)
lines(valid.kurse.ts)
accuracy(kurse.lm2.pred$mean, valid.kurse.ts)

#Forecasts mit polynomialem Trend 3. Ordnung
kurse.lm3.pred <-forecast(kurse.lm3, h = stepsAhead, level=0)
plot(kurse.lm3.pred, ylab = "Kurs", xlab = "Zeit",ylim = c(10,600))
lines(kurse.lm3.pred$fitted, lwd=2)
lines(valid.kurse.ts)
accuracy(kurse.lm3.pred$mean, valid.kurse.ts)
#Es zeigt sich, dass der polynomiale Trend 2. Ordnung am besten abschneidet, mit einem MAE von 20.81 und einem MAPE von 13.28

#Regression mit Kursdaten und Kommentaren

#Nun testen wir, ob mithilfe der Kombination aus Kursdaten und Kommentaren noch bessere Ergbenisse erzielt werden können. Auch hier trennen wir die Daten wieder in Trainings- und Validierungsdaten auf.
#Einfügen der Daten in TimeSeries-Objekt
kommentare.ts<-ts(GME$Anzahl)
plot(kommentare.ts)

#Trennung in Trainingsdaten und Validierungsdaten
train.kommentare.ts <-window(kommentare.ts, start = 1, end = c(1, nTrain))
valid.kommentare.ts <-window(kommentare.ts, start = c(1, nTrain +1), end = c(1, nTrain+stepsAhead))

#Wir führen die Regression sowohl ohne Einbeziehung eines Trends, als auch mit einem Linearen Trend durch.
#Regression mit Kommentaren
kursekommentare.lm1 <- tslm(train.kurse.ts~train.kommentare.ts)
summary(kursekommentare.lm1)
plot(train.kurse.ts, xlab="Zeit", ylab="Kurs",ylim=c(10,600))
lines(kursekommentare.lm1$fitted, lwd = 2)

#Regression mit Kommentaren + linearer Trend
kursekommentare.lm2 <- tslm(train.kurse.ts~train.kommentare.ts+trend)
summary(kursekommentare.lm2)
plot(train.kurse.ts, xlab="Zeit", ylab="Kurs",ylim=c(10,600))
lines(kursekommentare.lm2$fitted, lwd = 2)

#Wir prüfen die Performance der beiden Modelle wieder mithilfe der Validierungsdaten
#Forecasts mit Kommentaren
kursekommentare.lm1.pred<-forecast(kursekommentare.lm1,newdata = valid.kommentare.ts, h =stepsAhead, level = 0)
plot(kursekommentare.lm1.pred, ylab = "Kurs", xlab = "Zeit",ylim = c(10,600))
lines(kursekommentare.lm1.pred$fitted, lwd=2)
lines(valid.kurse.ts)
accuracy(kursekommentare.lm1.pred$mean, valid.kurse.ts)

#Forecasts mit Kommentaren + linearer Trend
kursekommentare.lm2.pred<-forecast(kursekommentare.lm2,newdata = valid.kommentare.ts, h =stepsAhead, level = 0)
plot(kursekommentare.lm2.pred, ylab = "Kurs", xlab = "Zeit",ylim = c(10,600))
lines(kursekommentare.lm2.pred$fitted, lwd=2)
lines(valid.kurse.ts)
accuracy(kursekommentare.lm2.pred$mean, valid.kurse.ts)
#Das Modell ohne Einbeziehung eines Trends schneidet am besten ab, mit einem MAE von 54.25 und einem MAPE von 33.32

#Fazit
#Man kann anhand der Performancemaße erkennen, das bei der Regression die Hinzunahme von Kommentardaten nicht zu besseren Ergebnissen führt. Das die Lineare Regression aber ohnehin nicht besonders geeignet für das Problem ist, lässt sich bereits am Graphen der Kursdaten erkennen. Insofern war mit dem eher schlechten Ergebnis zu rechnen.