setwd("C:/Users/Victor/Desktop/datascicour51")

activity <- read.csv("./activity.csv",stringsAsFactors=F)

activity$date <- as.Date(activity$date)

# Q1

hist(na.omit(activity$steps))

dailymean <- aggregate(steps ~ date, activity, mean, na.rm=T)

dailymedian <- aggregate(steps ~ date, activity, median, na.rm=T)

# Q2

averageInterval <- aggregate(steps ~ interval, activity, mean, na.rm=T)

plot(averageInterval,type="l",main="Avg Steps Taken on Each Interval")

max(averageInterval$steps)

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

hist(activityFilled$steps)

dailymeanFilled <- aggregate(steps ~ date, activityFilled, mean)

dailymedianFilled <- aggregate(steps ~ date, activityFilled, median)


