## this file is a scratchpad for code that goes into the notebook and
## the chapter

## 1,302 UCLA students were asked to fill out
## a survey where they were asked about their height,
## fastest speed they have ever driven, and gender.

Speed <- read.csv("../data/speed-gender-height.csv")

fm <- lm(speed ~ height, data = Speed)
summary(fm)

ggplot(Speed, aes(x=height, y=speed)) +
    geom_point() +
    geom_smooth(method="lm", se=FALSE)

ggplot(mtcars, aes(x=wt, y=mpg)) +
    geom_point() +
    geom_smooth(method="lm", se=FALSE)

fm2 <- lm(speed ~ height + gender, data = Speed,
          na.action="na.exclude")
summary(fm2)

Speed <- mutate(Speed, fit = predict(fm2, na.action=NULL))

ggplot(Speed, aes(x=height, y=speed, color=gender)) +
    geom_point() +
    geom_smooth(method="lm", mapping=aes(y=fit))

## ad an interaction term
fm3 <- lm(speed ~ height + gender + height:gender, data = Speed,
          na.action="na.exclude")
summary(fm3)

Speed <- mutate(Speed, fit3 = predict(fm3, na.action=NULL))

ggplot(Speed, aes(x=height, y=speed, color=gender)) +
    geom_point() +
    geom_smooth(method="lm", mapping=aes(y=fit3))

## computing R^2
Speed <- read.csv("../data/speed-gender-height.csv")
Speed2 <- na.omit(Speed)  # its' easier with no missing values

fm <- lm(speed ~ height, data = Speed2)
summary(fm)

y <- Speed2$speed
y.hat <- predict(fm)

TSS <- sum( (y - mean(y))^2)
RSS <- sum( (y - y.hat)^2)
1 - RSS/TSS   # R-squared


## transformations on data
ggplot(msleep) +
    geom_point(aes(x = brainwt, y = sleep_total))

ggplot(msleep, aes(x = log(brainwt), y = sleep_total)) +
    geom_point() +
    geom_smooth(method="lm", se=FALSE)

fm <- lm(sleep_total ~ log(brainwt), data=msleep)
summary(fm)

## a one-unit increase in log(brainwt) decreases
## sleep time by about one hour (on avg).

## for interpretation, plug in a few values to get an idea
(5.9474 -1.039*log(2)) - (5.9474 -1.039*log(3))



## exercise: linear regression with a single predictor
ggplot(faithful) + geom_histogram(aes(x=eruptions), bins=30)
ggplot(faithful) + geom_histogram(aes(x=waiting), bins=30)

ggplot(faithful) + geom_point(aes(x=eruptions, y=waiting))


## exercise: Multiple linear regression with mtcars data
fm <- lm(mpg ~ cyl + hp + wt, data = mtcars)
summary(fm)

beta0 <- coef(fm)[1] # intercept
beta1 <- coef(fm)[2] # cyl
beta2 <- coef(fm)[3] # hp
beta3 <- coef(fm)[4] # wt

mtcars.adj <- mutate(mtcars,
                   mpg.adj = beta0 + beta1*mean(cyl) + beta2*mean(hp) + beta3*wt
                   )

ggplot(mtcars.adj) +
    geom_point(aes(x=wt, y=mpg)) +
    geom_line(aes(x=wt, y=mpg.adj), color="red")

mtcars.adj$pred <- fitted(fm)

ggplot(mtcars.adj) +
    geom_point(aes(x=pred, y=mpg)) +
    geom_abline() +
    labs(x="Predicted mpg", y="Actual mpg")

n <- nrow(mtcars)
k <- 4
y <- mtcars.adj$mpg
y.hat <- mtcars.adj$pred

sqrt( sum((y - y.hat)^2) / (n-k) )

## exercise: Linear regression with numeric and categorical predictors.
Sales <- read.csv("../data/sales.csv")
Sales$season <- factor(Sales$season, levels=c(0,1),
                   labels=c("winter","summer"))

## put the data in long format for ggplot2
price <- with(Sales, c(company.price, competitor.price))
sales <- with(Sales, rep(sales, 2))
seller <- factor(rep(c("company","competitor"), each=10))
season <- with(Sales, rep(season, 2))
Sales2 <- data.frame(price=price, sales=sales, seller=seller, season=season)

ggplot(Sales2) +
    geom_point(aes(x=price, y=sales, shape=seller, color=season), size=3) +
    labs(y="sales in 1000s of units")

fm <- lm(sales ~ company.price + competitor.price + season, data=Sales)
summary(fm)
coef(fm)

## Exercise: Logistic regression
Med <- read.csv("../data/harrell.csv")

fm <- glm(response ~ age + gender, family=binomial(link="logit"), data=Med)
summary(fm)

invlogit <- function(x) 1/(1+exp(-x)) # helper function

beta0 <- coef(fm)[1]  # pull out the coefficients
beta1 <- coef(fm)[2]
beta2 <- coef(fm)[3]

unname(invlogit(beta0 + beta1*42 + beta2))  # 42 yr-old male
unname(invlogit(beta0 + beta1*52 + beta2))  # 52 yr-old male

## compute probability of response as a function of age
## for males and for females and plot.
Med <- mutate(Med,
            p.male = invlogit(beta0 + beta1*age + beta2),
            p.female = invlogit(beta0 + beta1*age)
            )

ggplot(Med) +
    geom_jitter(aes(x=age, y=response, color=gender), height=.01, width=.01) +
    geom_line(aes(x=age, y=p.male, color="male")) +
    geom_line(aes(x=age, y=p.female, color="female")) +
    labs(x="Age", y="Probability of response to treatment") +
    scale_color_manual(name="Gender", values=c(male="blue",female="magenta"))


## Exercise: VO2 max
VO2 <- read.csv("../data/vo2max-aerobic-fitness.csv")

fm <- lm(VO2max ~ Age, data=VO2)
summary(fm)

# plot the data and overlay the fitted regression line
ggplot(VO2, aes(x=Age, y=VO2max)) +
    geom_point() +
    geom_smooth(method = "lm", se = FALSE, color="red")


## Exercise: time series sales data
Sales <- tibble(
    month=1:12,
    actual=c(105,135,120,105,90,120,145,140,100,80,100,110),
    ## compute the 3-period moving average
    saleslag1 = dplyr::lag(actual, 1),
    saleslag2 = dplyr::lag(actual, 2),
    ma = (actual + saleslag1 + saleslag2) / 3 
)

## compute the exponential smoothing values
alpha <- 0.3  # the smooting parameter
n <- nrow(Sales)
smooth <- numeric(n)         # will hold the smoothed values
smooth[1] <- Sales$actual[1] # to start the exponential smooting formula

for (i in 1:(n-1)) {
    smooth[i+1] <- alpha * Sales$actual[i] + (1-alpha) * smooth[i]
}

Sales$smooth <- smooth

## put the data in "long" format so that plotting with ggplot2 is easy
SalesLong <- Sales %>%
    pivot_longer(c(actual, ma, smooth), names_to = "series", values_to = "sales")

ggplot(SalesLong) +
    geom_line(aes(x=month, y=sales, color=series))


## Exercise: Simulation of a simple trading strategy.
Bit <- read.csv("BTC-USD.csv", stringsAsFactors=FALSE)
Bit$Date <- as.Date(Bit$Date)

(p <- ggplot(Bit) + geom_line(aes(x=Date, y=Close)))

(p2 <- ggplot(Bit) + geom_point(aes(x=Volume, y=Close)))

## plot Close vs Volume on log scale
require(scales)
p2 + scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),
                  labels = trans_format("log10", math_format(10^.x))) +
    scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x),
                  labels = trans_format("log10", math_format(10^.x)))

## get set up
alpha <- 0.5  # the smooting parameter
n <- length(Bit$Close)
net <- 0                 # gain/loss
fcst <- numeric(n)       # will hold the forecast
fcst[1] <- Bit$Close[1]  # to start the exponential smooting formula

for (i in 2:n) {
    # fcst[i] holds the prediction for day i+1
    fcst[i] <- alpha * Bit$Close[i] + (1-alpha) * fcst[i-1]

    if (fcst[i] >= Bit$Close[i]) { # fcst is for price increase
        net  <- net - Bit$Close[i] # buy one BTC
    } else {                       # fcst is for price decrease
        net <- net + Bit$Close[i]  # sell one BTC
    }
}
message("net dollar position = ",  net)

# plot the forecasted price and the actual price
Bit$fcst <- fcst
p + geom_line(aes(x=Date, y=fcst), color="blue")
