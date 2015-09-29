# Food court Data visualization and processing

library(ggplot2)
library(dplyr)
library(stringr)
library(RColorBrewer)
library(lubridate)
library(reshape2)
library(colorspace)


# Lab RGB colors
redL   <- c("#B71234")
dredL  <- c("#822443")
dgrayL <- c("#565A5C")
lblueL <- c("#7090B7")
dblueL <- c("#003359")
lgrayL <- c("#CECFCB")

setwd("~/GitHub/DataVizPractice")
fcd <- tbl_df(read.csv("food.court.dates.csv", stringsAsFactors = FALSE, strip.white=TRUE))

# What is the structure of the data? Reads in as characters and intergers; Need to coerce to dates;
fcd$Date <- mdy(fcd$Date)
fcd$pDate <- mdy_hm(fcd$Timevalue)
fcd <- select(fcd, -X)

# Rename a few variables to avoid confusion
fcd <- rename(fcd, dayOfMonth = Day, dayOfWeek = day)

# Set months as factors to make ordering easy; Same for days
fcd$Month = factor(fcd$Month,levels=c("January","February","March",
                            "April","May","June","July","August","September",
                            "October","November","December"), ordered=TRUE)

fcd$dow <- factor(fcd$dayOfWeek, levels = c("Sunday", "Monday", "Tuesday", "Wednesday", 
                        "Thursday", "Friday", "Saturday"), ordered = TRUE)

fcd$tod <- factor(fcd$Time, levels = c("7:00", "7:15", "7:30", "7:45",
                                       "8:00", "8:30", "9:00", "10:00", "10:30", "10:45",
                                       "11:00", "11:15", "11:30", "11:45", "12:00", 
                                       "12:15", "12:30", "12:45", "13:00", "13:15", 
                                       "13:30", "13:45", "14:00", "14:30", "14:45",
                                       "15:00", "15:30", "16:00", "16:30", "17:00", "17:15",
                                       "17:30", "17:45", "18:00", "18:15", "18:30", "21:00"),
                                        ordered = TRUE)
# Verify factors sorted and mapped correctly
table(fcd$tod, fcd$Time)                    

# Average and Total visitors by day, month & time of day;
# Have Laura show to how to convert to function
fcd <- group_by(fcd, dayOfMonth) %>% 
  mutate(domAve = sum(Visitors) / n(), domTotal = sum(Visitors)) %>% 
  arrange(desc(domAve))

fcd <-  group_by(fcd, dayOfWeek) %>%
  mutate(dowAve = sum(Visitors) / n(), dowTotal = sum(Visitors)) %>%
  arrange(desc(dowTotal))

fcd <-  group_by(fcd, Time) %>%
  mutate(timeAve = sum(Visitors) / n(), timeTotal = sum(Visitors)) %>%
  arrange(desc(timeTotal))

fcd <-  group_by(fcd, Month) %>%
  mutate(monthAve = sum(Visitors) / n(), monthTotal = sum(Visitors)) %>%
  arrange(desc(monthTotal))

fcd <- group_by(fcd, Date) %>%
  mutate(dateAve = sum(Visitors) / n(), dateTotel = sum(Visitors))


# What time of the day should I avoid the food court?
fcdTime <- group_by(fcd, Time) %>% 
  summarise(aveVisit = mean(Visitors), sdVisit = sd(Visitors), maxVisit = max(Visitors), 
            minVisit = min(Visitors), nVisits = n(), totVisit = sum(Visitors)) %>% 
  arrange(desc(Time, freqVisits))


# What day of the month has the highest average of visitors?
fcd %>% group_by(dayOfMonth) %>% 
  summarise(aveVisit = mean(Visitors), sdVisit = sd(Visitors), maxVisit = max(Visitors), 
            minVisit = min(Visitors), nVisits = n(), totVisit = sum(Visitors)) %>% 
  arrange(desc(aveVisit, freqVisits))

# What days of the week have the highest average of visitors?
fcd %>% group_by(dayOfWeek) %>% 
  summarise(aveVisit = mean(Visitors), sdVisit = sd(Visitors), maxVisit = max(Visitors), 
            minVisit = min(Visitors), nVisits = n(), totVisit = sum(Visitors)) %>% 
  arrange(desc(aveVisit, freqVisits))

# What day of the month has the most number of visitors?
tmp <- group_by(fcd, Month, dow) %>%
  summarise(aveVisit = mean(Visitors), sdVisit = sd(Visitors))#, maxVisit = max(Visitors), 
            #minVisit = min(Visitors), nVisits = n(), totVisit = sum(Visitors)) %>% 
  #arrange(desc(aveVisit, freqVisits))

# Plot food court data by time of the day using grouping averages

# Plotting sizes
widthDDheat = 3.25*2*1.15
heightDDheat = 3*2
widthDDavg = 1.85


tmp.m <- melt(tmp, id = c("Month", "dow"))
theme_ops <-  theme_minimal() + theme(legend.position = "top", 
                     legend.key = element_blank(), 
                     legend.text = element_text(size = 14),
                     panel.border = element_blank(),
                     panel.grid.major = element_blank(),
                     panel.grid.minor = element_blank(),
                     axis.line = element_blank(),
                     axis.ticks = element_blank())#,
                     #panel.background = element_rect(fill = "gray97"),
                     #panel.border = element_blank())
                     


# Plot food court data by Day and time  
tmp.dt <- group_by(fcd, dow, tod) %>%
  summarise(aveVisit = mean(Visitors)) %>%arrange(tod)
tmp.dtm <- melt(tmp.dt, id = c("dow", "tod"))

ggplot(tmp.dtm, aes(tod, dow)) + geom_tile(aes(fill = value), colour = "white") +
  scale_fill_gradientn(colours = brewer.pal(9, "YlOrRd"), name = 'food court visitors') +
  labs(x = "", y="") +
  geom_text(aes(y = dow, x = tod, label = round(value, 0)), size = 4) +
  theme_ops

# Plot data by Month & Time
tmp.mt <- group_by(fcd, Month, tod) %>%
  summarise(aveVisit = mean(Visitors)) %>%arrange(tod)
tmp.mtm <- melt(tmp.mt, id = c("Month", "tod"))

ggplot(tmp.mtm, aes(tod, Month)) + geom_tile(aes(fill = value), colour = "white") +
  scale_fill_gradientn(colours = brewer.pal(9, "YlOrRd"), name = 'food court visitors') +
  labs(x = "", y="") +
  geom_text(aes(y = Month, x = tod, label = round(value, 0)), size = 4) +
  theme_ops

# Summarise by Month day
tmp.md <- group_by(fcd, Month, dow) %>%
  summarise(aveVisit = mean(Visitors))
tmp.mdm <- melt(tmp.md, id = c("Month", "dow"))

tmp.mdm$dow <-  factor(tmp.mdm$dow, levels = rev(levels(tmp.mdm$dow)))
ggplot(tmp.mdm, aes(x = Month, y = dow)) + geom_tile(aes(fill = value), colour = "white") +
  scale_fill_gradientn(colours = brewer.pal(9, "YlOrRd"), name = 'food court visitors') +
  labs(x = "", y="", title = "Food Court Voucher Sales (average / day)") +
  geom_text(aes(y = dow, x = Month, label = round(value, 0)), size = 4) + theme_ops


# Summarise by day of month and time (may get thin!)
tmp.domtod <- group_by(fcd, dayOfMonth, tod) %>%
  summarise(aveVisit = mean(Visitors))
tmp.domtodm <- melt(tmp.domtod, id = c("dayOfMonth", "tod"))

ggplot(tmp.domtodm, aes(x = tod, y = dayOfMonth)) + geom_tile(aes(fill = value), colour = "white") +
  scale_fill_gradientn(colours = brewer.pal(9, "YlOrRd"), name = 'food court visitors') +
  labs(x = "", y="") + scale_y_reverse(breaks = 31:1) +
  geom_text(aes(y = dayOfMonth, x = tod, label = round(value, 0)), size = 4) +
  theme_ops



# Run pal to choose your own color palette
pal <- choose_palette()
clr <- pal(12)

ggplot(fcd, aes(x = Date, y = tod, color = Month, size = dateTotel)) + geom_point(position = "jitter") + theme_minimal()
ggplot(fcd, aes(x = Date, y = Visitors)) + geom_step()

fcd$tod <- factor(fcd$tod, levels = rev(levels(fcd$tod)))
ggplot(fcd, aes(x = dayOfMonth, y = tod, size = Visitors, color = Month)) + geom_point() +
  scale_colour_manual(values = clr) + scale_x_continuous(breaks = 1:31) + theme_bw() + geom_jitter()


fcd$dow <- factor(fcd$dow, levels = rev(levels(fcd$dow)))
ggplot(fcd, aes(x = Month, y = dow, color = Visitors, size = (Visitors))) + geom_point() + geom_jitter() +
  theme_minimal()


ggplot(fcd, aes(x = dayOfMonth, y = tod, size = Visitors, colour = Visitors)) + geom_point() + facet_wrap(~dow, ncol = 7) +
  geom_jitter() + scale_color_continuous() + theme_minimal()
   


