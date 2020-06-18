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
