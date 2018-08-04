rmse_rep <- read.table('results/results_RMSEK_04.txt', header = T)

means = apply(rmse_rep, 2, mean)
sds = apply(rmse_rep, 2, sd)

plot(means, xlab = c('Best', 1:nK), ylab = 'RMSE', ylim = c(min(means - 2*sds), max(means + 2*sds)), pch = 15, col = 'blue')

for (k in 1:(nK + 1)) lines(x = c(k, k), y = c(means[k] + sds[k], means[k] - sds[k]), col = 'blue')
