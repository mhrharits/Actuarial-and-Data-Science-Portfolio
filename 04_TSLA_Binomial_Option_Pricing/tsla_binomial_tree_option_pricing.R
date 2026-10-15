# Binomial Tree Option Pricing & Convergence Simulation (TSLA)
library(quantmod)
library(ggplot2)
library(derivmkts)

getSymbols("TSLA", src = "yahoo", from = Sys.Date() - 365, to = Sys.Date())
saham <- TSLA$TSLA.Close

sigma   <- sd(diff(log(saham)), na.rm = TRUE) / sqrt(1 / length(saham))
S0      <- as.numeric(saham[length(saham)])
K       <- 0.9 * S0
r       <- 0.05
waktu_T <- 0.5

a_factor <- function(n) exp(r * (waktu_T / n))
peluang  <- function(n) {
  delta_t <- waktu_T / n
  u <- exp(sigma * sqrt(delta_t))
  d <- 1 / u
  (a_factor(n) - d) / (u - d)
}

binom_tree <- function(n) {
  delta_t <- waktu_T / n
  u <- exp(sigma * sqrt(delta_t))
  d <- 1 / u
  pohon <- matrix(0, nrow = n + 1, ncol = n + 1)
  for (i in 1:(n + 1)) {
    for (j in 1:i) {
      pohon[i, j] <- S0 * u^(j - 1) * d^((i - 1) - (j - 1))
    }
  }
  return(pohon)
}

option_tree <- function(payoff, n) {
  pohon <- matrix(0, nrow = length(payoff), ncol = length(payoff))
  pohon[length(payoff), ] <- payoff
  disc <- 1 / a_factor(n)
  p    <- peluang(n)
  for (i in (length(payoff) - 1):1) {
    for (j in 1:i) {
      pohon[i, j] <- disc * (pohon[i + 1, j] * (1 - p) + pohon[i + 1, j + 1] * p)
    }
  }
  return(pohon)
}

cari_harga_opsi <- function(n) {
  binom_pohon <- binom_tree(n)
  payoff      <- abs(binom_pohon[n + 1, ] - K)
  option      <- option_tree(payoff, n)
  return(option[1, 1])
}

V100 <- cari_harga_opsi(100)
x_steps <- 2:100
y_price <- sapply(x_steps, cari_harga_opsi)
y_error <- abs(y_price - V100) / V100

plot(x_steps, y_price, type = "l", col = "purple", lwd = 2, xlab = "Banyaknya Langkah (n)", ylab = "Harga Opsi (USD)")
plot(x_steps, y_error, type = "l", col = "darkgreen", lwd = 2, xlab = "Banyaknya Langkah (n)", ylab = "Galat Relatif")
