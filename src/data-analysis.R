## scratch file for chapter on data analysis

## lognormal distribution parameter estimation
Lifetimes <- read.table("../data/component-lifetimes.txt", header=T)

(mu <- mean(log(Lifetimes$t)))
(sigma <- sd(log(Lifetimes$t)))

## mean time to failure
(mttf <- exp(mu + (sigma^2)/2))

## probability that a component lasts longer than 10,000 hours
(p <- 1 - pnorm((log(10000)-mu)/sigma))

## histogram and fitted distribution
## put in section 4.2 graphics?


## college students and driving speed
Speed <- read.csv("../data/speed-gender-height.csv")
ggplot(Speed) + geom_boxplot(aes(x=gender, y=speed), na.rm=TRUE)

ggplot(Speed) + geom_point(aes(x=height, y=speed, color=gender), na.rm=TRUE)

fm <- lm(speed ~ height + gender, data = Speed)
summary(fm)


## fruit spoilage
Spoil <- read.table("../data/fruit-spoilage.txt", header=T)
summary(Spoil)

sd(Spoil$Number.of.Spoiled.Peaches)

## an alternative way to get the quartiles
quantile(Spoil$Number.of.Spoiled.Peaches, probs=c(.25,.50,.75))

table(Spoil) # shows that the mode is 1

## restaurant service times
t <- rnorm(220, mean=70, sd=18)  # generate our own data
idx <- sample(1:length(t), 50)   # choose a few times and make them longer
t[idx] <- t[idx] + rexp(50, rate=1/12)
hist(t)
t <- round(t)
write.table(t, file="../data/restaurant-service-times.txt", row.names=FALSE)

Service <- read.table("../data/restaurant-service-times.txt", header=T)

alpha <- 0.05 # the confidence level
n <- nrow(Service) 
xbar <- mean(Service$t)
se <- sd(Service$t)/sqrt(n)
cp <- qnorm(1 - alpha/2) # critical point using std normal distribution

xbar + c(-1,1) * cp * se # a 95% confidence interval


## clinical trial data
Trial <- read.csv("../data/clinical-trial.txt", header=T)

median(Trial$Medicine.A) - median(Trial$Medicine.B)  # point estimate

B <- 200         # number of bootstrap replicates
s <- numeric(B)  # will hold the bootstrap replicates
n <- nrow(Trial)

for (i in 1:B) {
    medA <- sample(Trial$Medicine.A, n, replace=T)
    medB <- sample(Trial$Medicine.B, n, replace=T)
    s[i] <- median(medA) - median(medB)
}

sd(s)  # bootstrap estimate of std error
quantile(s, probs=c(.025,.975))  # 95% boostrap CI



