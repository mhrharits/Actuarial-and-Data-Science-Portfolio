# Cocoa Price Hedging: Protective Collar vs. Reverse Jade Lizard Strategy
library(dplyr)
library(xts)
library(ggplot2)
library(nortest)
library(QFRM)

datanya <- read.csv("data/Kakao-bappebti.csv") %>%
  mutate(Tanggal = as.Date(Tanggal, "%Y-%m-%d")) %>%
  filter(Penyerahan == "SPOT", as.numeric(format(Tanggal, "%Y")) < 2023)

kakao.harian   <- xts(datanya$Harga, order.by = datanya$Tanggal)
kakao.mingguan <- to.weekly(kakao.harian, name = "Harga", indexAt = "endof", k = 1)
kakao.test     <- as.data.frame(kakao.mingguan) %>%
  select(Harga.Close) %>%
  tibble::rownames_to_column(var = "Tanggal") %>%
  mutate(Tanggal = as.Date(Tanggal))

Log.Return <- diff(log(kakao.test$Harga.Close))
ks.test(Log.Return, "pnorm", mean(Log.Return), sd(Log.Return))

sig <- sd(Log.Return) / sqrt(1 / 52)
S0  <- kakao.test[nrow(kakao.test), 2]
r   <- 5.75 / 100
t   <- 2 / 12

# 1. Protective Collar (K1 = 30000, K2 = 36000)
v.protective.profit <- function(ST, K1 = 30000, K2 = 36000, n = 1) {
  v.put1  <- BS_Simple(S0 = S0, K = K1, r = r, q = 0, ttm = t, vol = sig)$Px$Put
  v.call2 <- BS_Simple(S0 = S0, K = K2, r = r, q = 0, ttm = t, vol = sig)$Px$Call
  if (ST < K1) n * (K1 - ST + v.call2 - v.put1)
  else if (ST <= K2) n * (v.call2 - v.put1)
  else n * (K2 - ST + v.call2 - v.put1)
}

# 2. Reverse Jade Lizard (K1 = 30000, K2 = 33000, K3 = 36000)
v.reverse.profit <- function(ST, K1 = 30000, K2 = 33000, K3 = 36000, n = 1) {
  v.put1  <- BS_Simple(S0 = S0, K = K1, r = r, q = 0, ttm = t, vol = sig)$Px$Put
  v.put2  <- BS_Simple(S0 = S0, K = K2, r = r, q = 0, ttm = t, vol = sig)$Px$Put
  v.call3 <- BS_Simple(S0 = S0, K = K3, r = r, q = 0, ttm = t, vol = sig)$Px$Call
  if (ST < K1) n * (K1 - K2 - v.put1 + v.put2 + v.call3)
  else if (ST < K2) n * (ST - K2 - v.put1 + v.put2 + v.call3)
  else if (ST < K3) n * (-v.put1 + v.put2 + v.call3)
  else n * (K3 - ST - v.put1 + v.put2 + v.call3)
}

x <- 23000:43000
y_pc  <- sapply(x, v.protective.profit)
y_rjl <- sapply(x, v.reverse.profit)

plot(x, x + y_rjl, type = "l", col = "blue", xlab = "Harga Kakao (Rp)", ylab = "Harga Jual Lindung Nilai (Rp)")
lines(x, x + y_pc, col = "darkgreen")
lines(x, x, lty = "dashed", col = "red")
legend("topleft", legend = c("Reverse Jade Lizard", "Protective Collar", "Unsecured Position"),
       col = c("blue", "darkgreen", "red"), lty = c(1, 1, 2), cex = 0.8)
