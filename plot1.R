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
data$Date = as.Date(data$Date, "%d/%m/%Y")
feb_data <- data[data$Date %in% c("2007-02-01","2007-02-02"),]

# Convert data to numeric type and remove na values
gap <- na.omit(as.numeric(feb_data$Global_active_power))

# Construct the plot
png('plot1.png', width = 480, height = 480)
par(mfrow=c(1,1))
hist(
  gap,
  col = "red",
  xlab = "Global Active Powers (kilowatts)",
  main = "Global Active Power"
)
dev.off()
