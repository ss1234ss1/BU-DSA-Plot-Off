library(tidyverse)
library(scales)
library(ggrepel)
library(patchwork)



#Goal: Line Chart of Streams Over Time:
#Create a line chart to show how the total number of streams has 
#changed over the years. This can help identify trends in song popularity.
#Streams / Released Day


spotify<-read_csv("spotify-2023.csv")

#Data Cleansing


summary(spotify)
glimpse(spotify)
problems(spotify)

#Stream values are characters when it is actually integer data.
#change column names to snake_case name to prevent potential problems
spotify<-spotify|>
  janitor::clean_names()|>
  mutate(
    streams=as.numeric(streams)
  )

# When changing streams to type double, there are some NA introduced

summary(spotify)

#There are some NA values in streams and shazam charts
 
spotify<-spotify|>
  mutate(
    streams=if_else(is.na(streams), median(streams, na.rm=TRUE), streams),
    in_shazam_charts=if_else(is.na(in_shazam_charts), median(in_shazam_charts, na.rm=TRUE), in_shazam_charts)
  )


summary(spotify)
problems(spotify)  
glimpse(spotify)

#But do we need to remove outliers? 
boxplot(spotify$streams)

#All data cleansed with free-na values and proper data type

#Data Transformation

#Combine released year,month,day in one column b/c we need to compare streams over time.

spotify<-spotify|>
  mutate(
    released_date=as.Date(paste(released_year, released_month, released_day, sep="-"), 
                          format="%Y-%m-%d"),
    .before=2
    )|>
  arrange(released_date)|>
  select(!c(released_year, released_month, released_day))


glimpse(spotify)

#Data Plot


# Early 1900~ middle 1900/ 1975~1985/ 1985~1995/ 1995~2005/ 2005~2015/ 2015~2023

spotify_middle_1900<-spotify|>
  filter(released_date<"1970-01-01")

mid_1990_plot<- ggplot(spotify_middle_1900, aes(x=released_date, y=streams))+
  geom_point(aes(color=mode))+
  geom_smooth()+
  labs(
    title = "1930-1970"
  )+
  theme(
    axis.text.x = element_text(size=5, angle=45)
  )

spotify_1970_1980<-spotify|>
  filter(released_date<"1980-01-01" & released_date>="1970-01-01")
  
plot_1970_1980<-ggplot(spotify_1970_1980, aes(x=released_date, y=streams))+
  geom_point(aes(color=mode))+
  geom_smooth()+
  labs(
    title = "1970-1980"
  )+
  theme(
    axis.text.x = element_text(size=5, angle=45)
  )

spotify_1980_1990<-spotify|>
  filter(released_date<"1990-01-01" & released_date>="1980-01-01")

plot_1980_1990<-ggplot(spotify_1980_1990, aes(x=released_date, y=streams))+
  geom_point(aes(color=mode))+
  geom_smooth()+
  labs(
    title = "1980-1990"
  )+
  theme(
    axis.text.x = element_text(size=5, angle=45)
  )

spotify_1990_2000<-spotify|>
  filter(released_date<"2000-01-01" & released_date>="1990-01-01")

plot_1990_2000<-ggplot(spotify_1990_2000, aes(x=released_date, y=streams))+
  geom_point(aes(color=mode))+
  geom_smooth()+
  labs(
    title = "1990-2000",
    y="Streams"
  )+
  theme(
    axis.text.x = element_text(size=5, angle=45)
  )


spotify_2000_2010<-spotify|>
  filter(released_date<"2010-01-01" & released_date>="2000-01-01")


plot_2000_2010<-ggplot(spotify_2000_2010, aes(x=released_date, y=streams))+
  geom_point(aes(color=mode))+
  geom_smooth()+
  labs(
    title = "2000-2010"
  )+
  theme(
    axis.text.x = element_text(size=5, angle=45)
  )

spotify_2010_2020<-spotify|>
  filter(released_date<"2020-01-01" & released_date>="2010-01-01")

plot_2010_2020<-ggplot(spotify_2010_2020, aes(x=released_date, y=streams))+
  geom_point(aes(color=mode))+
  geom_smooth()+
  labs(
    title = "2010-2020"
  )+
  theme(
    axis.text.x = element_text(size=5, angle=45),
    plot.title = element_text(size=15)
  )

spotify_2020_present<-spotify|>
  filter(released_date>="2020-01-01")

plot_2020_present<- ggplot(spotify_2020_present, aes(x=released_date, y=streams))+
  geom_point(aes(color=mode))+
  geom_smooth()+
  labs(
    title="2020-Present",
    x="Released Date"
  )+
  theme(
    axis.text.x = element_text(size=5, angle=45)
  )





mid_1990_plot$labels$y<-plot_1970_1980$labels$y <- plot_1980_1990$labels$y <-plot_2000_2010$labels$y<-plot_2010_2020$labels$y<-plot_2020_present$labels$y<- " "
mid_1990_plot$labels$x<-plot_1990_2000$labels$x<-plot_1970_1980$labels$x <- plot_1980_1990$labels$x <-plot_2000_2010$labels$x<-plot_2010_2020$labels$x<- " "

(guide_area()/(mid_1990_plot+plot_1970_1980+plot_1980_1990)/
  (plot_1990_2000+plot_2000_2010)/
   plot_2020_present)+
  plot_annotation(
    title = "Analyzing Musical Moods: Major vs. Minor Streaming Trends",
    subtitle = "Exploring Changes in Listening Preferences",
    theme = theme(plot.title = element_text(size = 20, face = "bold"),
                  plot.subtitle = element_text(size=15))
  )+
  plot_layout(
    guides = "collect",
    widths = c(1,2,2,4),
    heights = c(1, 2, 2, 4)
  )&
  theme(
    axis.title.x=element_text(size=13),
    axis.title.y= element_text(size=13),
    axis.text.x = element_text(size=8, angle=20),
    legend.direction = "horizontal",
    legend.box.background = element_rect(color = "black"),
    legend.position = "top"
  )&
  scale_y_continuous(
    labels = label_number(scale=1/1000000, suffix = "M", seperate=","),
    breaks = seq(1000, 4000000000, by = 1000000000)
  )&
  scale_color_brewer(palette = "Set1")




