# Comparing Vanilla and Asset-or-Nothing Options on Strangle Strategy
library(dplyr)
library(xts)
library(ggplot2)
library(nortest)
library(QFRM)

kakao <- read.csv("data/Kakao-bappebti.csv") %>%
  filter(Penyerahan == "SPOT") %>%
  mutate(Tanggal = as.Date(Tanggal))

kakao.harian   <- xts(kakao$Harga, order.by = kakao$Tanggal)
kakao.mingguan <- to.weekly(kakao.harian, name = "Harga", indexAt = "endof", k = 1)
kakao.test     <- as.data.frame(kakao.mingguan) %>%
  select(Harga.Close) %>%
  tibble::rownames_to_column(var = "Tanggal") %>%
  mutate(Tanggal = as.Date(Tanggal))

Log.Return <- diff(log(kakao.test$Harga.Close[1:103]))
shapiro.test(Log.Return)

S0  <- kakao.test[103, 2]
r   <- 5.75 / 100
t   <- 2 / 12
sig <- sd(Log.Return) / sqrt(1 / 52)
k1  <- 32000
k2  <- 34000

v.strangle.profit <- function(ST, K1 = k1, K2 = k2, n = 25) {
  v.put1  <- BS_Simple(S0 = S0, K = K1, r = r, q = 0, ttm = t, vol = sig)$Px$Put
  v.call2 <- BS_Simple(S0 = S0, K = K2, r = r, q = 0, ttm = t, vol = sig)$Px$Call
  if (ST < K1) n * (K1 - ST - v.call2 - v.put1)
  else if (ST <= K2) n * (-v.call2 - v.put1)
  else n * (ST - K2 - v.call2 - v.put1)
}

an.strangle.profit <- function(ST, K1 = k1, K2 = k2, n = 25) {
  biner.call2 <- OptPx(Opt(Style = "Binary", Right = "Call", S0 = S0, K = K2, ttm = t), r = r, vol = sig)
  biner.put1  <- OptPx(Opt(Style = "Binary", Right = "Put",  S0 = S0, K = K1, ttm = t), r = r, vol = sig)
  c2 <- BinaryBS(biner.call2, Type = "asset-or-nothing")$PxBS
  c1 <- BinaryBS(biner.put1,  Type = "asset-or-nothing")$PxBS
  if (ST <= K1) n * (ST - c2 - c1)
  else if (ST <= K2) n * (-c2 - c1)
  else n * (ST - c2 - c1)
}

x  <- 20000:40000
y1 <- sapply(x, v.strangle.profit)
y3 <- sapply(x, an.strangle.profit)

plot(x, y1, type = "l", col = "black", ylim = c(-600000, 300000), xlab = "Cocoa Price (IDR)", ylab = "Profit (IDR)")
lines(x, y3, col = "darkgreen")
abline(h = 0)
legend("topleft", legend = c("Vanilla Strangle", "Asset-or-Nothing Strangle"), col = c("black", "darkgreen"), lty = 1)
