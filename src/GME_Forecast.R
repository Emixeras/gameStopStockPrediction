rm(list=ls())
library(readxl)
library(ggplot2)
library(oddsratio)
library(dplyr)
library(xts)
library(forecast)
library(marima)

GME <- read.csv('C:/Users/S.Faltenberg/Desktop/FHDW/5. Semester/Data Lab/gameStopStockPrediction-master/input/GME_CloseAndReddit_previous_polish_04Jan_11May.csv')

attributes(GME)

date <- GME$Date
comments <- GME$Anzahl
Close <- GME$Close

GME.close <- GME
GME.close$X <- NULL
GME.close$Date <- NULL
GME.close$Anzahl <- NULL

GME.close.ts <- ts(GME.close)
GME.close.ts

GME.ts <- ts(GME)
GME.ts

train.ts <- window(GME.close.ts, end = 71)
valid.ts <- window(GME.close.ts, start = 72)


stepsAhead <- 18
train.ts <- window(GME.ts, end = 71)
valid.ts <- window(GME.ts, start = 72)



plot(GME.ts)





autoplot(train.ts) + geom_smooth(method="Arima")+ labs(x ="Date", y = "GME close", title="GME Aktien-Kurs")
autoplot(GME.ts[,"Close"]) +
  xlab("DAYS") + ylab("CLOSE")

fit <- auto.arima(GME.ts[,"Close"], seasonal=FALSE)

fit
fit %>% forecast(h=10) %>% autoplot(include=80)

arimaAP <- auto.arima(train.ts)


train.lm.trend <- tslm(train.ts ~ trend + I(trend^2))

train.res.arima <- arima(train.lm.trend$residuals, order = c(1,0,0))

train.res.arima.pred <- forecast(train.res.arima, h = nValid)

summary(train.res.arima)

plot(train.lm.trend$residuals, ylim = c(-100, 300), ylab = "Close",
     xlab = "Time", bty = "l", xaxt = "n", xlim = c(1,89), main = "")

lines(train.res.arima.pred$fitted, lwd = 2, col = "blue")

summary(train.res.arima)





stl.res <- stl(train.ts) # Decomposition
plot(stl.res)
fc.stl <- forecast(stl.res, level=0, h=30) # ohne Konfidenzintervall
plot(forecast(fc.stl, h=30), main=" ")


train.ts

GME.ts

ar <- c(1)
ma <- c(1)

model1 <- define.model(kvar = 4, ar= ar, ma=ma, rem.var = c(1,2), indep = c(3,4))
marima1 <- marima(DATA = GME.ts, ar.pattern = model1$ar.pattern, ma.pattern = model1$ma.pattern, Check = FALSE, Plot = FALSE, penalty = 0.0)



forecast1 <- arma.forecast(series = train.ts, marima = marima1, nstart = 1, nstep = 70)








