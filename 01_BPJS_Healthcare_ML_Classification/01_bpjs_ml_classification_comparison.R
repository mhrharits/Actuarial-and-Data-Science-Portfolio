# Supervised Learning Classification on BPJS Kesehatan FKTP Dataset
library(dplyr)
library(caret)
library(class)
library(xgboost)
library(e1071)
library(rpart)
library(rpart.plot)
library(randomForest)
library(kernlab)

data.fktp <- read.csv("data/dataset_fktp.txt", header = FALSE)

set.seed(71)
acak <- sample(1:nrow(data.fktp), 100000)
fktp <- data.fktp[acak, ]

names(fktp) <- c(
  "PSTV01", "PSTV02", "PSTV15", "FKP02", "FKP03", "FKP04", "FKP05",
  "FKP06", "FKP07", "FKP08", "FKP09", "FKP10", "FKP11", "FKP12",
  "FKP14", "FKP14A", "FKP15", "FKP15A", "FKP16", "FKP17", "FKP18",
  "FKP19", "FKP20", "FKP21", "FKP22", "FKP13Class"
)

fktp <- fktp %>%
  na.omit() %>%
  select(-c(PSTV01, PSTV02, FKP02, FKP14, FKP14A, FKP15, FKP15A)) %>%
  mutate(
    FKP03 = as.Date(FKP03),
    FKP04 = as.Date(FKP04),
    FKPHari = as.integer(FKP04 - FKP03)
  ) %>%
  select(-c(FKP03, FKP04))

categorical_cols <- c(
  "FKP05", "FKP06", "FKP07", "FKP08", "FKP09", "FKP10", "FKP11",
  "FKP12", "FKP16", "FKP17", "FKP18", "FKP19", "FKP20", "FKP21",
  "FKP22", "FKP13Class"
)
fktp[categorical_cols] <- lapply(fktp[categorical_cols], as.factor)

set.seed(99)
sampling <- sample(c(TRUE, FALSE), size = nrow(fktp), replace = TRUE, prob = c(0.7, 0.3))
train <- fktp[sampling, ]
test  <- fktp[!sampling, ]

X_train <- train %>% select(-FKP13Class)
y_train <- train$FKP13Class
X_test  <- test %>% select(-FKP13Class)
y_test  <- test$FKP13Class

cv <- trainControl(method = "cv", number = 5)

# 1. Logistic Regression
logistic_model <- train(x = X_train, y = y_train, method = "glm", trControl = cv)
confusionMatrix(predict(logistic_model, newdata = X_test), y_test, mode = "everything", positive = "Sehat")

# 2. KNN (K = 1, 3, 5)
for (k_val in c(1, 3, 5)) {
  knn_model <- train(X_train, y_train, method = "knn", trControl = cv, tuneGrid = data.frame(k = k_val))
  print(confusionMatrix(predict(knn_model, newdata = X_test), y_test, mode = "everything", positive = "Sehat"))
}

# 3. XGBoost
xgb_model <- train(x = X_train, y = y_train, method = "xgbTree", trControl = cv)
confusionMatrix(predict(xgb_model, newdata = X_test), y_test, mode = "everything", positive = "Sehat")

# 4. SVM Radial
svm_model <- train(X_train, y_train, method = "svmRadial", trControl = cv)
confusionMatrix(predict(svm_model, newdata = X_test), y_test, mode = "everything", positive = "Sehat")

# 5. Decision Tree
dt_model <- train(X_train, y_train, method = "rpart", trControl = cv)
rpart.plot(dt_model$finalModel, main = "Decision Tree", extra = 102)
confusionMatrix(predict(dt_model, newdata = X_test), y_test, mode = "everything", positive = "Sehat")

# 6. Random Forest
rf_model <- train(X_train, y_train, method = "rf", trControl = cv)
confusionMatrix(predict(rf_model, newdata = X_test), y_test, mode = "everything", positive = "Sehat")
