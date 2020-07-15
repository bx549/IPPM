## scratch file for chapter on probabilistic models

## stocking a vending machine

## simulate 1000 weeks of demand from the vending machine

n <- 1000            # number of replications
demand <- numeric(n) # create a vector to hold the weekly demand

for (i in 1:n) {
    demand[i] <- rpois(1, 168)
}

## estimated probability of a stock-out
sum(demand >= 180) / n

## estimate of number of beverages remaining at end of week
sales <- ifelse(sales > 180, 180, demand)
180 - mean(sales)

## estimate of probability that 150 or more beverages will be sold
sum(demand >= 150) / n
