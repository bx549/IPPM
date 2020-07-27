## scratch file

## utility function for Alice's retirement funds
u <- function(m) 10 / (1 + exp(-(m/1e5 - 5)) )
m <- seq(0,1e6,by=1000)
plot(m, u(m), type="l")

## produce coordinates for the utility function because
## tikz is plotting the function incorrectly
sink("../coordinates.txt")
for (i in 1:length(m)) {
    cat("(",m[i],",",round(u(m[i]),4),")",sep="")
    if (i %% 5 == 0) {
        cat("\n")
    }
}
cat("\n")
sink()



    
