if(!require(ggplot2)){install.packages('ggplot2')}
if(!require(lubridate)){install.packages('lubridate')}
if(!require(ggthemes)){install.packages('ggthemes')}
library(lubridate)
library(ggplot2)
library(ggthemes)

#Loading data into R
pd <- read.csv("Project2Data.csv")

#Creation of factor showing all unique user IDs
uniqueusers <- unique(pd$userid)

#Show's amount of unique user IDs
length(uniqueusers)


#Subsets data from pd where user ID is unique
pd_deduced <- pd[!duplicated(pd[c("userid")]),]

#Shows how many entries from pd_deduced are in each type of account
table(pd_deduced$type)

#Subsets data from pd where attempt result is login, timeout or logout into their own data frames
login <- pd[pd$attemptresult=="LOGIN",]
logout <- pd[pd$attemptresult=="LOGOUT",]
timeout <- pd[pd$attemptresult=="TIMEOUT",]

#Merges subsetted data from above data frames together
one <- merge(login,logout,by=c("maxsessionuid","userid","type"),all.x=TRUE)
final <- merge(one,timeout,by=c("maxsessionuid","userid","type"),all.x=TRUE)

#Renaming columns in 'final' data frame created above
names(final)[4] <- "login"
names(final)[5] <- "event1"
names(final)[6] <- "logout"
names(final)[7] <- "event2"
names(final)[8] <- "timeout"
names(final)[9] <- "event3"


#Taking necessary columns from 'final' data frame and adding them to created 'q3' data frame
q3 <- data.frame(final$maxsessionuid,final$userid,final$type,
                 mdy_hm(final$login),mdy_hm(final$logout),
                 mdy_hm(final$timeout))

#Renaming columns in 'q3' data frame created above 
names(q3)[1] <- "maxsessionuid"
names(q3)[2] <- "userid"
names(q3)[3] <- "type"
names(q3)[4] <- "login"
names(q3)[5] <- "logout"
names(q3)[6] <- "timeout"

#Finds max time from time fields in q3 and adds them to q3 in new column 'max'
x <- data.frame(as.numeric(as.POSIXct(q3$login)),as.numeric(as.POSIXct(q3$logout)),
                as.numeric(as.POSIXct(q3$timeout)))
x[is.na(x)] <- 0
q3$max <- as_datetime(apply(x,1,max))

#Creates new column in q3 named 'diff' showing length of each session
q3$diff <- difftime(q3$max,q3$login,units="hours")

#Subsets data from q3 by type of user access
q3auth <- q3[q3$type=="AUTHORIZED",]
q3lim <- q3[q3$type=="LIMITED",]
q3exp <- q3[q3$type=="EXPRESS",]

#Finds average length of session for each type of user access
a <- c(mean(q3auth$diff))
b <- c(mean(q3lim$diff))
c <- c(mean(q3exp$diff))

#Assigns average for each user type to a vector
AUTHORIZED <- c(paste(floor(a),round((a-floor(a))*60),sep=":"))
LIMITED <- c(paste(floor(b),round((b-floor(b))*60),sep=":"))
EXPRESS <- c(paste(floor(c),round((c-floor(c))*60),sep=":"))

#Adds vectors created above to data frame showing average length of session for each user ID
q3final <- data.frame(AUTHORIZED,LIMITED,EXPRESS)

#Renames row in 'q3final' data frame
row.names(q3final) <- "Average Length of Session"

#Displays 'q3final' data frame
q3final

#Subsets data from 'q3' data frame ordering data by login time
q32 <- q3[order(login),]

#Breaks out data from each week into it's own data frame
p1 <- q32[1:6488,]
p2 <- q32[6489:12112,]
p3 <- q32[12113:18062,]
p4 <- q32[18063:26459,]

#Orders data from data frames created above by user ID
p1a <- p1[order(p1$userid),]
p2a <- p1[order(p2$userid),]
p3a <- p1[order(p3$userid),]
p4a <- p1[order(p4$userid),]

#Takes necessary columns from data frames created above and adds them to a new data frame
p1b <- data.frame(p1a$userid,p1a$type,p1a$maxsessionuid,p1a$login,p1a$max)
p2b <- data.frame(p2a$userid,p2a$type,p2a$maxsessionuid,p2a$login,p2a$max)
p3b <- data.frame(p3a$userid,p3a$type,p3a$maxsessionuid,p3a$login,p3a$max)
p4b <- data.frame(p4a$userid,p4a$type,p4a$maxsessionuid,p4a$login,p4a$max)

#Subsets data from 'p1b' data frame created above into manageable group of user IDs
p1ba <- p1b[1:336,]

#Creates Gantt chart for group of user IDs in 'p1ba' data frame showing session time and length
ggplot(p1ba,aes(x=p1a.login,xend=p1a.max,y=p1a.userid,yend=p1a.userid,color=p1a.type)) +
  geom_segment(size=3) +
  labs(title="Week 1, Agent Group 1",x="Session Time/Length",y="User ID",color="Type") +
  theme_fivethirtyeight() +
  theme(axis.title=element_text())

#Creates factor showing every minute of activity in March
interval <- seq(min(q3$login),max(q3$max),by="mins")

#Creates logical factor showing how many users from each group were logged in each minute
x_auth <- sapply(interval,function(int) sum(q3auth$login <= int & int <= q3auth$max))
x_lim <- sapply(interval,function(int) sum(q3lim$login <= int & int <= q3lim$max))
x_exp <- sapply(interval,function(int) sum(q3exp$login <= int & int <= q3exp$max))

#Creates data frame from the above factors
finalfinal <- data.frame(interval,x_auth,x_lim,x_exp)

#Adds column to data frame adding together how many users from each group were logged in each minute
finalfinal$total <- finalfinal$x_auth+finalfinal$x_lim+finalfinal$x_exp

#Creates time series chart showing the number of concurrent users per minute
ggplot(finalfinal) +
  geom_line(aes(x=interval,y=x_auth,color='AUTHORIZED')) +
  geom_line(aes(x=interval,y=x_exp,color='EXPRESS')) +
  geom_line(aes(x=interval,y=x_lim,color='LIMITED')) +
  geom_line(aes(x=interval,y=total,color='TOTAL')) +
  labs(title="Amount of Concurrent Users",x="Time",y="Number of Users",color='User Type') +
  scale_y_continuous(limits=c(0,100),breaks=seq(0,100,10),expand=c(0,0)) +
  theme_fivethirtyeight() +
  theme(axis.title=element_text())
