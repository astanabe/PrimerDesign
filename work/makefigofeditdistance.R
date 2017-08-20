dat<-read.table("editdistancetable.txt", header=T, sep=",")

pdf(file="editdistancefig.pdf", width=10, height=5)
par(mfrow=c(1,3))
hist(subset(dat, cutoff==100)$dist, breaks="Scott", ylab="frequency", xlab="edit distance", main="Result of clustered data of 100% identity cutoff")
hist(subset(dat, cutoff==95)$dist, breaks="Scott", ylab="frequency", xlab="edit distance", main="Result of clustered data of 95% identity cutoff")
hist(subset(dat, cutoff==90)$dist, breaks="Scott", ylab="frequency", xlab="edit distance", main="Result of clustered data of 90% identity cutoff")
dev.off()
