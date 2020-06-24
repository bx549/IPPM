## scratch file for chapter on data analysis

## Exercise: Lognormal distribution parameter estimation
Lifetimes <- read.table("../data/component-lifetimes.txt", header=T)

(mu <- mean(log(Lifetimes$t)))
(sigma <- sd(log(Lifetimes$t)))

## mean time to failure
(mttf <- exp(mu + (sigma^2)/2))

## probability that a component lasts longer than 10,000 hours
(p <- 1 - pnorm((log(10000)-mu)/sigma))

## histogram and fitted distribution
## put in section 4.2 graphics?



## Exercise: College students and driving speed
Speed <- read.csv("../data/speed_gender_height.csv")
ggplot(Speed) + geom_boxplot(aes(x=gender, y=speed), na.rm=TRUE)

ggplot(Speed) + geom_point(aes(x=height, y=speed, color=gender), na.rm=TRUE)

fm <- lm(speed ~ height + gender, data = Speed)
summary(fm)


