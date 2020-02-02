#install.packages("colorspace")
#install.packages("ggmosaic")
#install.packages("nnet")
library(colorspace)
library(dplyr)
library(ggplot2)
library(ggmosaic)
library(nnet)
library(grid)

filepath = "Dataset"
#filepath = "dataset_complete.csv"

data = read.csv(filepath)
head(data, 50)

mosaic.data = data.frame(data)

mosaic.data$DELAY_TYPE[mosaic.data$CARRIER_DELAY > 0] = "Carrier"
mosaic.data$DELAY_TYPE[mosaic.data$WEATHER_DELAY > 0] = "Wheather"
mosaic.data$DELAY_TYPE[mosaic.data$SECURITY_DELAY > 0] = "Security"
mosaic.data$DELAY_TYPE[mosaic.data$NAS_DELAY > 0] = "NAS"
mosaic.data$DELAY_TYPE[mosaic.data$LATE_AIRCRAFT_DELAY > 0] = "Late"

mosaic.data = subset(mosaic.data, select=c("OP_UNIQUE_CARRIER", 
                                           "ORIGIN_CITY_NAME", "DELAY_TYPE"))

top5 = names(sort(summary(as.factor(mosaic.data$ORIGIN_CITY_NAME)), decreasing=T)[1:5])
top5

mosaic.data = mosaic.data %>% 
  select(OP_UNIQUE_CARRIER, DELAY_TYPE, ORIGIN_CITY_NAME) %>% 
  filter(ORIGIN_CITY_NAME %in% c(top5))

mosaic.data = mosaic.data %>% group_by(DELAY_TYPE)

mosaic.data = droplevels(mosaic.data)
frequencies = ftable(mosaic.data)

mosaic.data2 = mosaic.data %>%
  select(OP_UNIQUE_CARRIER, DELAY_TYPE, ORIGIN_CITY_NAME) %>% 
  filter(DELAY_TYPE == "Wheather" | DELAY_TYPE == "Security")

mosaic.data3 = mosaic.data %>%
  select(OP_UNIQUE_CARRIER, DELAY_TYPE, ORIGIN_CITY_NAME) %>% 
  filter(DELAY_TYPE == "Security")

# mosaicplot mosaics
test = mosaicplot(~DELAY_TYPE + ORIGIN_CITY_NAME + OP_UNIQUE_CARRIER, data = mosaic.data, 
           shade = TRUE, legend = TRUE, cex.axis = 0.5)

mosaicplot(~DELAY_TYPE + ORIGIN_CITY_NAME + OP_UNIQUE_CARRIER, data = mosaic.data2, 
           shade = TRUE, legend = TRUE, cex.axis = 0.5)


# ggplot Mosaics

ggplot(mosaic.data) +
  geom_mosaic(aes(x=product(OP_UNIQUE_CARRIER, ORIGIN_CITY_NAME, DELAY_TYPE), 
                  fill=OP_UNIQUE_CARRIER), offset = .03) + 
  theme(axis.text.x = element_text(size=8, angle=90),
        axis.text.y = element_text(face="bold", size=10, angle=0)) 

ggplot(mosaic.data2) +
  geom_mosaic(aes(x=product(OP_UNIQUE_CARRIER, ORIGIN_CITY_NAME, DELAY_TYPE), 
                  fill=OP_UNIQUE_CARRIER), offset = .05) + 
  theme(axis.text.x = element_text(size=8, angle=90),
        axis.text.y = element_text(face="bold", size=10, angle=0))



# mosaic Mosaics

palette = diverging_hcl(5, "Cork")
frequencies = ftable(mosaic.data)           


vcd::mosaic(~DELAY_TYPE + ORIGIN_CITY_NAME + OP_UNIQUE_CARRIER, data = mosaic.data, shade=T,
            xlab = "Origin City", ylab = "Type of Delay",
            labeling_args=list(rot_labels=c(bottom=90,top=0),gp_labels=(gpar(fontsize=8))))

vcd::mosaic(~DELAY_TYPE + ORIGIN_CITY_NAME + OP_UNIQUE_CARRIER, data = mosaic.data2, shade=T,
            xlab = "Origin City", ylab = "Type of Delay",
            labeling_args=list(rot_labels=c(bottom=90,top=0),gp_labels=(gpar(fontsize=8))))

vcd::mosaic(~DELAY_TYPE + ORIGIN_CITY_NAME + OP_UNIQUE_CARRIER, data = mosaic.data3, shade=T,
            xlab = "Origin City", ylab = "Type of Delay",
            labeling_args=list(rot_labels=c(bottom=90,top=0),gp_labels=(gpar(fontsize=8))))
