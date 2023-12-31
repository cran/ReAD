#' @title Simulate two sequences of p-values by accounting for the local dependence structure via a hidden Markov model.
#'
#' @param J The number of features to be tested in two studies.
#' @param pi The stationary probabilities of four hidden joint states.
#' @param A The 4-by-4 transition matrix.
#' @param muA The mean of the normal distribution generating the p-value in study 1.
#' @param muA The mean of the normal distribution generating the p-value in study 2.
#' @param sd1 The standard deviation of the normal distribution generating the p-value in study 1.
#' @param sd1 The standard deviation of the normal distribution generating the p-value in study 2.
#'
#' @return A list:
#' \item{pa}{A numeric vector of p-values from study 1.}
#' \item{pb}{A numeric vector of p-values from study 2.}
#' \item{theta1}{The true states of features in study 1.}
#' \item{theta2}{The true states of features in study 2.}
#'
#' @export
SimuData <- function(J     = 10000,
                     pi = c(0.25, 0.25, 0.25, 0.25),
                     A = 0.6 * diag(4) + 0.1,
                     muA   = 2,
                     muB   = 2,
                     sdA   = 1,
                     sdB   = 1){
  s <- c()
  s[1] <- sample(0:3, 1, prob = pi)
  for (j in 2:J){
    s[j] <- sample(0:3, 1, prob = A[s[j-1]+1,])
  }

  states1 = rep(0, J)
  states1[c(which(s == 2), which(s == 3))] = 1
  states2 = rep(0, J)
  states2[c(which(s == 1), which(s == 3))] = 1

  xa <- rnorm(J, mean = muA * states1, sd = sdA)
  xb <- rnorm(J, mean = muB * states2, sd = sdB)

  pa <- 1 - pnorm(xa)
  pb <- 1 - pnorm(xb)

  return(list(
    pa = pa,
    pb = pb,
    theta1 = states1,
    theta2 = states2
  ))
}
