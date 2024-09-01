# Create data folder
if(!file.exists("./data")) {
  dir.create("./data")
}

# Download the dataset
if(!file.exists("./data/exdata_data_household_power_consumption.zip")){
  fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileurl, destfile = "./data/exdata_data_household_power_consumption.zip")
}

# Unzip the dataset
if(!file.exists("./data/household_power_consumption.txt")) {
  unzip(zipfile = "./data/exdata_data_household_power_consumption.zip", exdir = "./data")
}

# Read data
data <- read.csv(
  "./data/household_power_consumption.txt",
  header = TRUE,
  sep = ";",
  dec=".",
  colClasses = rep("character", 9)
)

# Select data from the specified date range
data$Date <- as.Date(data$Date, "%d/%m/%Y")
feb_data <- data[data$Date %in% c("2007-02-01","2007-02-02"),]

# Convert data to numeric type and remove na values
feb_data$Global_active_power <- as.numeric(feb_data$Global_active_power)
feb_data$Voltage <- as.numeric(feb_data$Voltage)
feb_data$Global_reactive_power <- as.numeric(feb_data$Global_reactive_power)
feb_data$Sub_metering_1 <- as.numeric(feb_data$Sub_metering_1)
feb_data$Sub_metering_2 <- as.numeric(feb_data$Sub_metering_2)
feb_data$Sub_metering_3 <- as.numeric(feb_data$Sub_metering_3)
feb_data <- na.omit(feb_data)
feb_data$Datetime <- as.POSIXct(
  paste(feb_data$Date, feb_data$Time),
  format="%Y-%m-%d %H:%M:%S"
)

#Specify plot parameters
png('plot4.png', width = 480, height = 480)
par(mfrow=c(2,2))

# Construct top left plot
plot(
  feb_data$Datetime,
  feb_data$Global_active_power,
  type="l",
  ylab = "Global Active Powers",
  xlab = "",
  xaxt="n"
)
axis(
  side=1,
  at=as.POSIXct(c("2007-02-01 00:00:00", "2007-02-02 00:00:00", "2007-02-03 00:00:00"), format="%Y-%m-%d %H:%M:%S"),
  labels=c("Thu", "Fri", "Sat")
)

# Construct top right plot
plot(
  feb_data$Datetime,
  feb_data$Voltage,
  type="l",
  ylab = "Voltage",
  xlab = "datetime",
  xaxt="n"
)
axis(
  side=1,
  at=as.POSIXct(c("2007-02-01 00:00:00", "2007-02-02 00:00:00", "2007-02-03 00:00:00"), format="%Y-%m-%d %H:%M:%S"),
  labels=c("Thu", "Fri", "Sat")
)

# Construct bottom left plot
plot(
  feb_data$Datetime,
  feb_data$Sub_metering_1,
  type="l",
  ylab = "Energy sub metering",
  xlab = "",
  xaxt="n"
)
lines(feb_data$Datetime, feb_data$Sub_metering_2, col = 'red')
lines(feb_data$Datetime, feb_data$Sub_metering_3, col = 'blue')
legend(
  'topright', 
  legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), 
  col = c('black', 'red', 'blue'),
  lty = 1
)
axis(
  side=1,
  at=as.POSIXct(c("2007-02-01 00:00:00", "2007-02-02 00:00:00", "2007-02-03 00:00:00"), format="%Y-%m-%d %H:%M:%S"),
  labels=c("Thu", "Fri", "Sat")
)

# Construct bottom right plot
plot(
  feb_data$Datetime,
  feb_data$Global_reactive_power,
  type="l",
  ylab = "Global_reactive_power",
  xlab = "datetime",
  xaxt="n"
)
axis(
  side=1,
  at=as.POSIXct(c("2007-02-01 00:00:00", "2007-02-02 00:00:00", "2007-02-03 00:00:00"), format="%Y-%m-%d %H:%M:%S"),
  labels=c("Thu", "Fri", "Sat")
)

# Save the image
dev.off()