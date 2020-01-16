#Replication Comfortably Numb: Effects of Prolonged Media Coverage. Journal of Conflict Resolution
#Aaron Hoffman & José Kaire 
#Multilevel analysis
#1/14/2020

#Required libraries 
library(data.table)
library(rethinking) #See http://xcelab.net/rm/software/ for details on how to install. 
rstan_options(auto_write = TRUE) #Makes STAN work more efficiently. 

#############
# Data setup #
#############
{
data.for.interaciton <- fread("https://raw.githubusercontent.com/josekaire/comfortably_numb/master/HLM%20replication.csv") #Load data
d<-as.data.frame(na.omit(data.for.interaciton )) #Drop cases with missing data
d$id<-coerce_index(d$pid) #Create index variable 
d$valenceRC<-d$valence*10 #Provides slightly better sampling
#Dummies (not required)
d$video1<-ifelse(d$video==1,1,0)
d$video2<-ifelse(d$video==2,1,0)
d$video3<-ifelse(d$video==3,1,0)
d$video4<-ifelse(d$video==4,1,0)
d$video5<-ifelse(d$video==5,1,0)
}
#####################
# Model and results #
#####################
{
  m5.c<-map2stan(alist(
    valenceRC~dnorm(mu, sigma), #Likelihood
    mu<-a_id+a_vid[video]+bVO[video]*order+bI*exint2, #Linear model 
    bVO[video]~dnorm(bvo, sigma_video),     #Random slope prior
    #Other priors
    c(bI, bvo)~dnorm(0, 10), 
    a_vid[video]~dnorm(0, 10),
    c(a_id)~dnorm(0, 10), 
    c(sigma, sigma_video)~dcauchy(0,2)),
    data=d, iter=13000, warmup=6000, chains=4, cores=4, control=list( adapt_delta=0.9, max_treedepth = 12)) #Iterations and data. 
  
#Recover the joint posterior for predictions
  video1.link<-link(m5.c, data=data.frame( exint2=.5, order=seq(from=1, to=5, by=1), video=1))
  video1.mu<-apply(video1.link, 2, mean)
  video1.PI<-apply(video1.link, 2, PI)
  
  video2.link<-link(m5.c, data=data.frame( exint2=.5, order=seq(from=1, to=5, by=1), video=2))
  video2.mu<-apply(video2.link, 2, mean)
  video2.PI<-apply(video2.link, 2, PI)
  
  video3.link<-link(m5.c, data=data.frame( exint2=.5, order=seq(from=1, to=5, by=1), video=3))
  video3.mu<-apply(video3.link, 2, mean)
  video3.PI<-apply(video3.link, 2, PI)
  
  video4.link<-link(m5.c, data=data.frame( exint2=.5, order=seq(from=1, to=5, by=1), video=4))
  video4.mu<-apply(video4.link, 2, mean)
  video4.PI<-apply(video4.link, 2, PI)
  
  video5.link<-link(m5.c, data=data.frame( exint2=.5, order=seq(from=1, to=5, by=1), video=5))
  video5.mu<-apply(video5.link, 2, mean)
  video5.PI<-apply(video5.link, 2, PI)
  
#Dataframe containing predictions
  pred.data<-data.frame(index=1:25,video=rep(1:5, each=5) ,order=rep(1:5, 5), 
                        videos.mu=c(video1.mu, video2.mu, video3.mu,video4.mu,video5.mu),
                        lower.PI=c(video1.PI[1,], video2.PI[1,], video3.PI[1,], video4.PI[1,], video5.PI[1,]),
                        upper.PI=c(video1.PI[2,], video2.PI[2,], video3.PI[2,], video4.PI[2,], video5.PI[2,]))
}
#######
#Graph 
#######
  
plot(0, 0, yaxt="n", type="n",ylab="", ylim=c(0,140), xlab="Estimated Valence", xlim=c(-2.5, 2.5))
  axis(2, c(10, 40, 70,100, 130), labels=c("Video 5", "Video 4" , "Video 3" , "Video 2", "Video 1"), par(las=1))
  points(pred.data$videos.mu[pred.data$order==1], seq(from=140, to=20, length.out = 5), cex=1.1, pch=15, col="black")
  points(pred.data$videos.mu[pred.data$order==5], seq(from=120, to=0, length.out = 5), cex=1.3, pch=16, col="grey40")
  abline(h=c(25, 55, 85, 115), col=col.alpha("black", .2))
  h<-140; for ( i in 1:5 ) {
    lines(c(pred.data$lower.PI[pred.data$order==1][i],pred.data$upper.PI[pred.data$order==1][i] ), c(h,h), col="black")
    h<-h-30
  }
  h<-120; for ( i in 1:5 ) {
    lines(c(pred.data$lower.PI[pred.data$order==5][i],pred.data$upper.PI[pred.data$order==5][i] ), c(h,h), col="grey40")
    h<-h-30
  }
  legend(c(3, 152),
         c("Watched first", "Watched last"), pch = c(15, 16), col=c("black", "grey40"), horiz=FALSE, bty = "n", y.intersp=3.1)
  
####END#####
