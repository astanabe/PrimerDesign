dat<-read.table("coveragetable.txt", header=T, sep=",")

pdf(file="coveragefig.pdf", width=10, height=5)
par(mfrow=c(1,3))
barplot(xtabs((success/all)*100~primer+error, data=subset(dat, cutoff==100)), beside=T, ylab="percentage of PCR success", xlab="accepted number of mismatch", ylim=c(0,100), main="Result of clustered data of 100% identity cutoff")
barplot(xtabs((success/all)*100~primer+error, data=subset(dat, cutoff==95)), beside=T, ylab="percentage of PCR success", xlab="accepted number of mismatch", ylim=c(0,100), main="Result of clustered data of 95% identity cutoff")
barplot(xtabs((success/all)*100~primer+error, data=subset(dat, cutoff==90)), beside=T, ylab="percentage of PCR success", xlab="accepted number of mismatch", ylim=c(0,100), main="Result of clustered data of 90% identity cutoff")
dev.off()
