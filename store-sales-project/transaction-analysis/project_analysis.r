library(ggplot2)
library(forecast)
library(TTR)
library(readr)
library(dplyr)
library(tseries)
library(zoo)

# Leitura dos dados de transações realizadas na loja, em formato .csv
trs_data <- read.csv("transactions.csv")

# Verificar os dados
head(trs_data)
str(trs_data)

# Converter a coluna 'date' para o tipo Date (precaução)
trs_data$date <- as.Date(trs_data$date)

# Categorizando os dados de forma mensal
monthly_trs <- trs_data %>%
  group_by(month = format(date, "%Y-%m")) %>%
  summarise(transactions = sum(transactions))

# Verificar os dados agregados
head(monthly_trs)

# Tratando dados faltantes, caso exista, para evitar problemas nos modelos de previsão # nolint
datas_completas <- seq(as.Date("2013-01-01"), as.Date("2017-12-01"), by="month")
meses_faltantes <- datas_completas[!datas_completas %in% as.Date(paste0(monthly_trs$month, "-01"))] # nolint
print(meses_faltantes)

monthly_completo <- data.frame(
  month = format(datas_completas, "%Y-%m"),
  transactions = 0
)

monthly_completo$transactions[match(monthly_trs$month, monthly_completo$month)] <- monthly_trs$transactions # nolint

monthly_completo$transactions[monthly_completo$transactions == 0] <- NA

monthly_completo$transactions <- na.approx(monthly_completo$transactions, na.rm = FALSE) # nolint

# Verificação dos dados
head(monthly_completo)

# Criar a série temporal mensal (frequência 12) e uma sem valores "NA" para visualizar o ACF # nolint
trs_series <- ts(monthly_completo$transactions, start = c(2013, 1), frequency = 12) # nolint9in
trs_series_omit <- na.omit(trs_series)

# Verificar a série temporal
print(trs_series)

trs_components <- decompose(trs_series)

print(trs_components)

# Análise de outliers e sazonalidade
boxplot(trs_series, main = "Outlier Analysis", ylab = "Transações")

acf(trs_series_omit, lag.max = 24)
ggAcf(trs_series, lag.max = 24)

plot(trs_components)

# Usando o modelo de Holt-Winters para realizar previsões, assumindo que há sazonalidade, já que está claro pelo Lag 12 # nolint
trs_forecast <- HoltWinters(trs_series, beta = TRUE, gamma = TRUE)
plot(trs_forecast)

trs_pred <- forecast(trs_forecast, h = 12)

autoplot(trs_pred) +
  labs(title = "Previsão de Transações com Holt-Winters",
       x = "Ano", y = "Transações") +
  theme_minimal()

# Usando o modelo ARIMA para experimentação
adf_test <- adf.test(trs_series)
print(adf_test)  # Verificar se a série é estacionária

# Ajustar o modelo ARIMA
arima_model <- auto.arima(trs_series, seasonal = TRUE)
summary(arima_model)

# Previsões com o modelo ARIMA
arima_previsao <- forecast(arima_model, h = 12)
autoplot(arima_previsao) + ggtitle("Previsão com Modelo ARIMA") + xlab("Tempo") + ylab("Transações") # nolint

# Checagem de erros e teste de Ljung-Box
checkresiduals(arima_model)
checkresiduals(trs_forecast)

Box.test(resid(arima_model), type = "Ljung-Box")
Box.test(resid(trs_forecast), type = "Ljung-Box")

accuracy(arima_previsao)
accuracy(trs_forecast$fitted, trs_series)