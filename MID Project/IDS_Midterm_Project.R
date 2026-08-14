mydata <- read.csv("Cars93.csv", header = TRUE, sep = ",")
str(mydata)
print(summary(mydata))
print(dim(mydata))


num_cols <- sapply(mydata, is.numeric)
cat_cols <- sapply(mydata, function(x) is.factor(x) | is.character(x))
cat("Number of Numerical Variables:", sum(num_cols), "\n")
cat("Number of Categorical Variables:", sum(cat_cols), "\n")


mydata$Type <- factor(mydata$Type)
mydata$AirBags <- factor(mydata$AirBags)
mydata$DriveTrain <- factor(mydata$DriveTrain)
mydata$Origin <- factor(mydata$Origin)

print(colSums(is.na(mydata)))

set.seed(123)
na_rows_1 <- sample(1:nrow(mydata), 8)
mydata$Horsepower[na_rows_1] <- NA
na_rows_2 <- sample(1:nrow(mydata), 6)
mydata$AirBags[na_rows_2] <- NA

print(colSums(is.na(mydata)))
print(which(is.na(mydata$Horsepower)))
print(which(is.na(mydata$AirBags)))

data_removed <- na.omit(mydata)
print(dim(mydata))
print(dim(data_removed))

mean_hp <- mean(mydata$Horsepower, na.rm = TRUE)
mydata$Horsepower <- ifelse(is.na(mydata$Horsepower), mean_hp, mydata$Horsepower)

air_table <- table(mydata$AirBags)
air_mode <- names(air_table)[which.max(air_table)]
mydata$AirBags[is.na(mydata$AirBags)] <- air_mode
mydata$AirBags <- factor(mydata$AirBags)

print(colSums(is.na(mydata)))

noise_rows_1 <- sample(1:nrow(mydata), 5)
mydata$Price[noise_rows_1] <- mydata$Price[noise_rows_1] + 500

noise_rows_2 <- sample(1:nrow(mydata), 3)
mydata$Type <- as.character(mydata$Type)
mydata$Type[noise_rows_2] <- "Ultra"

boxplot(mydata$Price, main = "Price with Noise")

price_limit <- mean(mydata$Price) + 3 * sd(mydata$Price)
price_check <- mydata$Price > price_limit
print(sum(price_check))
mydata$Price[price_check] <- median(mydata$Price)

type_check <- mydata$Type == "Ultra"
print(sum(type_check))
mydata$Type[type_check] <- "Small"
mydata$Type <- factor(mydata$Type)

boxplot(mydata$Price, main = "Price after Noise Handling")

print(sum(mydata$Price <= 0))
print(sum(mydata$MPG.city <= 0))
print(sum(mydata$Horsepower <= 0))
print(sum(mydata$Passengers < 1))

price_min <- min(mydata$Price)
price_max <- max(mydata$Price)
mydata$Price.norm <- (mydata$Price - price_min) / (price_max - price_min)
print(summary(mydata$Price.norm))

hp_min <- min(mydata$Horsepower)
hp_max <- max(mydata$Horsepower)
mydata$Horsepower.norm <- (mydata$Horsepower - hp_min) / (hp_max - hp_min)

mydata$Price.log <- log(mydata$Price)
print(summary(mydata$Price.log))

boxplot(mydata$Price, main = "Boxplot of Price")
boxplot(mydata$Horsepower, main = "Boxplot of Horsepower")

Q1 <- quantile(mydata$Price, 0.25)
Q3 <- quantile(mydata$Price, 0.75)
IQR_price <- Q3 - Q1
lower <- Q1 - 1.5 * IQR_price
upper <- Q3 + 1.5 * IQR_price
outliers <- mydata$Price[mydata$Price < lower | mydata$Price > upper]
print(outliers)
print(length(outliers))

print(summary(mydata))
print(sd(mydata$Price))
print(sd(mydata$Horsepower))
print(mean(mydata$Price))
print(median(mydata$Price))
print(var(mydata$Price))

hist(mydata$Price, main = "Histogram of Price", xlab = "Price")
hist(mydata$MPG.city, main = "Histogram of MPG City", xlab = "MPG City")
barplot(table(mydata$Type), main = "Car Type Distribution")
plot(mydata$Horsepower, mydata$Price, main = "Price vs Horsepower")

n <- nrow(mydata)
train_rows <- sample(1:n, size = 0.8 * n)
train_data <- mydata[train_rows, ]
test_data <- mydata[-train_rows, ]
print(nrow(train_data))
print(nrow(test_data))

print(cor(mydata$Price, mydata$Horsepower))
print(cor(mydata$Price, mydata$Weight))
print(cor(mydata$Price, mydata$MPG.city))
print(cor(mydata$Price, mydata$EngineSize))

model <- lm(Price ~ Horsepower + Weight + EngineSize, data = train_data)
print(summary(model))




getwd()
file.access(getwd(), 2)

write.csv(mydata, "Cars93_cleaned.csv", row.names = FALSE)

list.files()