setwd("C:/Users/Victor/Desktop/coursera/RepData_PeerAssessment1")

Sys.setlocale("LC_TIME", "English")

library(ggplot2)

activity <- read.csv("./activity.csv",stringsAsFactors=F)

activity$date <- as.Date(activity$date)

# Q1

dailyStep <- aggregate(steps ~ date, activity, sum, na.rm=T)

plot(dailyStep,type="h")

mean(dailyStep$steps)
median(dailyStep$steps)

# Q2

averageInterval <- aggregate(steps ~ interval, activity, mean, na.rm=T)

plot(averageInterval,type="l",main="Avg Steps Taken on Each Interval")

averageInterval[averageInterval$steps==max(averageInterval$steps),1] # interval 835

# Q3

sum(is.na(activity$steps)) # 2304

sum(is.na(activity$date)) # 0

sum(is.na(activity$interval))   # 0 => now we know there is only missing
                                # values on "steps" data

activityFilled <- activity

for(i in 1:nrow(activityFilled)){
        if(is.na(activityFilled$steps[i])){ 
                tempInterval <- activityFilled[i,3] # 3 being "interval"
                
                activityFilled$steps[i] <- averageInterval$steps[averageInterval$interval==tempInterval]
        }
}

dailyStepFilled <- aggregate(steps ~ date, activityFilled, sum, na.rm=T)

plot(dailyStepFilled,type="h")

mean(dailyStepFilled$steps)
median(dailyStepFilled$steps)

# Q4

day <- weekdays(activityFilled$date)

weekday <- c()

for (i in 1:length(day)){
        if(day[i]=="Saturday" | day[i]=="Sunday"){
                weekday <- c(weekday,"weekend")
        } else {
                weekday <- c(weekday,"weekday")
        }
}

weekday <- as.factor(weekday)

activityFilled <- cbind(activityFilled,weekday)

averageWeekday <- aggregate(steps ~ interval, activity[weekday=="weekday",], mean)

averageWeekday$weekday="weekday"

averageWeekend <- aggregate(steps ~ interval, activity[weekday=="weekend",], mean)
averageWeekend$weekday="weekend"

averaged <- averageWeekday

averaged <- rbind(averaged,averageWeekend)

qplot(interval,steps,data=averaged,color=weekday,facets=weekday~.) + geom_line()
