# obtain and clean the data

# "Data Source: 2011 Census of Population and Housing"
# population data from Australian 2011 Census data obtained using table builder basic
# http://www.abs.gov.au/websitedbs/censushome.nsf/home/tablebuilder?opendocument&navpos=240
# Sourced on 2014-07-22 11:00am
population_filename <- "NSW_population_by_postcode.csv"
population <- read.csv(population_filename,skip=4,colClasses = c("NULL","character","numeric","NULL"))
population <- population[-1,]
population <- population[-605:-612,]
names(population) <- c("Postcode","Population")
# remove ", NSW" from postcode
population["Postcode"] <- do.call('rbind', strsplit(population[,1],',',fixed=TRUE))[,1]
population["Postcode"] <- as.numeric(population[,"Postcode"])

# fire station information from http://sydneyfire.net.au/radio-info/frnsw/stations/
# Sourced on 2014-07-22 11:00am
fire_station_filename <- "fire_stations.csv"
fire_stations <- read.csv(fire_station_filename,
                          colClasses = c("numeric","character","NULL","NULL","numeric"))
fire_stations <- merge(fire_stations,population,by="Postcode")
fire_stations <- merge(fire_stations,count(fire_stations["Postcode"]),by="Postcode")
names <- names(fire_stations)
names[5] <- "Firestations_in_postcode"
names(fire_stations) <- names

# Fire & Rescue NSW, New South Wales, Annual Statistical Reports, Fire Brigades (NSW) 2003 to 2007,
# Sourced on 2014-07-22 10:30am, http://www.fire.nsw.gov.au/page.php?id=171
urls <- c("http://data.gov.au/storage/f/2013-05-12T205645/tmpZjINNNASR_2006_07.xls",
          "http://data.gov.au/storage/f/2013-05-12T202235/tmpzs90iIASR_2005_06.xls",
          "http://data.gov.au/storage/f/2013-05-12T184251/tmp9gQhbBASR_2004_05.xls",
          "http://data.gov.au/storage/f/2013-05-12T195225/tmpioHJ8jASR_2003_04.xls")

destination_file <- c("fires_2006_2007.xls","fires_2005_2006.xls",
                      "fires_2004_2005.xls","fires_2003_2004.xls")

download_data <- function(){
    for (i in 1:4){
        download.file(urls[i],destination_file[i])
    }
}
# download_data() # do this once

library(xlsx)
get_results <- function(i, fire_stations){
    #Building fires
    bf <- read.xlsx(destination_file[i],sheetName = "Table 3",header=TRUE)
    get_building_fires <- function(station_number){
        res <- as.numeric(as.character(bf[bf[,1]==station_number & !is.na(bf[,1]),3]))
        if (length(res) == 0) res <- NA
        res
    }
    fire_stations["Building_fires"] <- sapply(fire_stations[,"Number"],get_building_fires)
    # total fires casualties, evacuations, rescued
    bf <- read.xlsx(destination_file[i],sheetName = "Table 4",header=TRUE)
    get_total_fires <- function(station_number){
        res <- as.numeric(as.character(bf[bf[,1]==station_number & !is.na(bf[,1]),3]))
        if (length(res) == 0) res <- NA
        res
    }
    fire_stations["Total_fires"] <- sapply(fire_stations[,"Number"],get_total_fires)
    get_total_casualties <- function(station_number){
        res <- as.numeric(as.character(bf[bf[,1]==station_number & !is.na(bf[,1]),4]))
        if (length(res) == 0) res <- NA
        res
    }
    fire_stations["Total_casualties"] <- sapply(fire_stations[,"Number"],get_total_casualties)
    get_persons_rescued <- function(station_number){
        res <- as.numeric(as.character(bf[bf[,1]==station_number & !is.na(bf[,1]),5]))
        if (length(res) == 0) res <- NA
        res
    }
    fire_stations["Persons_rescued"] <- sapply(fire_stations[,"Number"],get_persons_rescued)
    get_persons_evacuated <- function(station_number){
        res <- as.numeric(as.character(bf[bf[,1]==station_number & !is.na(bf[,1]),6]))
        if (length(res) == 0) res <- NA
        res
    }
    fire_stations["Persons_evacuated"] <- sapply(fire_stations[,"Number"],get_persons_evacuated)
    
    
    year <- c(2007,2006,2005,2004)
    fire_stations["Year_ending"] <- year[i]
    fire_stations
}
results <- data.frame()
for (i in 1:4){
    results <- rbind(results,get_results(i, fire_stations))
}
# remove NAs
results <- results[!is.na(results["Total_casualties"]),]
# store the clean data file
write.csv(results,file="building_fires.csv",row.names=FALSE)

