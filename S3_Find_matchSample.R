
#%% written by Shen Chun, cshen17@fudan.edu.cn
#%% reviewed by Dr Qiang Luo, qluo@fudan.edu.cn
#%% released on 28 Mar 2020
#%% please cite: Shen, et al. Ameircan Jounral of Psychiatry 2020

#install.packages("MatchIt")
#install.packages("optmatch")
library(MatchIt)
library(optmatch)

data_persistent <- read_excel("data_persistent.xlsx")

#optimal matching
m2.out <- matchit(group ~ sex + age + hand + tiv + site, data = data_persistent,
                  method = "optimal", ratio = 2)
summary(m2.out)
plot(m2.out,type = "jitter")
m2.data <- match.data(m2.out)
write.csv(m2.data,file='optimalMatch.csv')
