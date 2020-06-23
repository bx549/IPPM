## this file is a scratchpad for code that goes into the notebook

## 1,302 UCLA students were asked to fill out
## a survey where they were asked about their height,
## fastest speed they have ever driven, and gender.

dat <- read.csv("speed_gender_height.csv")
attach(dat)

## speed vs gender
boxplot(speed ~ gender, ylab="speed")

plot(height, speed, pch=as.integer(gender))
legend("bottomright", levels(gender), pch=gender)

## compare ANOVA output to regression output
## for the same data
fm1 <- aov(speed ~ gender)  ## ANOVA
fm2 <- lm(speed ~ gender)   ## regression

# speed vs height
fm2 <- lm(speed ~ height)
summary(fm2)

plot(height, speed)
abline(fm2)

# speed vs gender and height
fm3 <- lm(speed ~ gender + height)
summary(fm3)

# plot the regression lines for males and females
b0 <- coef(fm3)[1]
b1 <- coef(fm3)[2]
b2 <- coef(fm3)[3]

plot(height, speed, col=c("magenta","blue")[gender])
curve(b0 + b2*x, add=TRUE, col="magenta")   # females
curve(b0 + b1 + b2*x, add=TRUE, col="blue") # males

# check model fit
layout(matrix(c(1,2,3,4), nrow=2, ncol=2))
plot(fm3)


# add an interaction term for gender and height
fm4 <- lm(speed ~ gender + height + gender*height)
summary(fm4)

b0 <- coef(fm4)[1]
b1 <- coef(fm4)[2]
b2 <- coef(fm4)[3]
b3 <- coef(fm4)[4]

# now the slopes differ by gender
plot(height, speed, col=c("magenta","blue")[gender])
curve(b0 + b2*x, add=TRUE, col="magenta")        # females
curve(b0 + b1 + (b2+b3)*x, add=TRUE, col="blue") # males


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
