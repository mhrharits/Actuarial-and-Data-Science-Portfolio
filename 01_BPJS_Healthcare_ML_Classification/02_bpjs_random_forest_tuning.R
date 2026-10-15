# BDC Satria Data - Manual Hyperparameter Tuning for Random Forest
library(rpart)
library(ggplot2)
library(caret)
library(randomForest)
library(tidyr)
library(dplyr)
library(e1071)

train <- read.csv("data/train_fktp.txt", header = FALSE)

names(train) <- c(
  "PSTV01", "PSTV02", "PSTV15", "FKP02", "FKP03", "FKP04", "FKP05",
  "FKP06", "FKP07", "FKP08", "FKP09", "FKP10", "FKP11", "FKP12",
  "FKP14", "FKP14A", "FKP15", "FKP15A", "FKP16", "FKP17", "FKP18",
  "FKP19", "FKP20", "FKP21", "FKP22", "FKP13Class"
)

train <- train %>%
  na.omit() %>%
  select(FKP05:FKP13Class) %>%
  mutate(FKP13Class = ifelse(FKP13Class == "Sehat", 1, 0))

normalize <- function(x) (x - min(x)) / (max(x) - min(x))
train_numeric <- normalize(train %>% select_if(is.numeric) %>% select(1:16))
train_df <- data.frame(train_numeric, FKP13Class = train$FKP13Class)

set.seed(71)
sampling <- sample(c(TRUE, FALSE), size = nrow(train_df), replace = TRUE, prob = c(0.7, 0.3))
uji  <- train_df[sampling, ]
coba <- train_df[!sampling, ]

# Hyperparameter Grid Search (ntree & mtry)
hutan3 <- randomForest(as.factor(FKP13Class) ~ ., data = uji, ntree = 50, mtry = 7) # Best F1 = 0.9968173
prediksi <- predict(hutan3, newdata = coba, type = "class")
confusionMatrix(as.factor(prediksi), as.factor(coba$FKP13Class), mode = "everything", positive = "1")
