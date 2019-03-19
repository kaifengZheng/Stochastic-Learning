table = read.csv("./BoilerData_AVE.csv")
table_zero = scale(table)
plot(table_zero[,5],table_zero[,6],main="Economizer Inlet Temp VS stack pressure in H2O ",xlab="Economizer Inlet Temp",ylab="stack pressure in H2O",col="darkblue")
x=table_zero[,5]
y=table_zero[,6]
pr.out = prcomp(table_zero)
p2 = c(pr.out$rotation[5,2],pr.out$rotation[6,2])
k21 = p2[2]/p2[1]
k22 = -1/k21
intercept1 = y-k22*x
xn2 = -intercept1/(k22-k21)
yn2 = k21*xn2
lines(c(max(xn2),min(xn2)),c(k21*max(xn2),k21*min(xn2)),type="b",lty=4,col="red",lwd=2)
segments(x,y,xn2,yn2,col="orange",lwd=1.5)
for(i in 1:64){
  if(xn2[i]<0&&yn2[i]>0){
    t[i] = sqrt(xn2[i]^2+yn2[i]^2)
  }else (t[i] = -sqrt(xn2[i]^2+yn2[i]^2))
}
