dat<-read.table("effectivenumbertable.txt", header=T, sep=",")
dat$cutoff<-factor(dat$cutoff, levels=c("100", "95", "90"))

pdf(file="effectivenumberfig.pdf", width=5, height=5)
barplot(xtabs(seq~primer+cutoff, data=dat), beside=T, ylab="number of sequence clusters", xlab="percent identity cutoff used in clustering", main="Effective number of registered sequences")
dev.off()
