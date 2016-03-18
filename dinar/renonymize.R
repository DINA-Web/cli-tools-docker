#!/usr/bin/Rscript

library(purrr, quietly = TRUE)
suppressPackageStartupMessages(library(dplyr, quietly = TRUE))
library(RMySQL, quietly = TRUE)
library(stringr, quietly = TRUE)
library(getopt, quietly = TRUE)

get_args <- function(args) {
  
  header <- "long, short, enum, type, description, default"
  help <- "help, h, 0, logical, usage description"
  specification <- paste(sep = "\n", header, help, args)
  s <- gsub(", ", ",", specification)
  df <- read.csv2(textConnection(s), sep = ",", quote = "")
  m <- as.matrix.data.frame(df[ ,1:5])
  opt <- getopt(m)
  # if help was asked for print a friendly message
  # and exit with a non-zero error code
  
  if (!is.null(opt$help)) {
    message(getopt(m, usage = TRUE))
    q(status = 1)
  }
  return(opt)
}

get_config <- function(config_file, section) {
  
  if (any(missing(config_file), !file.exists(config_file)))
    stop("No config file given or config file not found")
  
  config <- readLines(config_file)
  eoc <- length(config)
  beg <- 1
  end <- eoc
  
  if (!missing(section) && grepl(section, config)) {
    beg <- grep(section, config, fixed = TRUE) + 1
    nxt <- grep("[.*?]", config[beg:eoc])
    nxt <- ifelse(length(nxt) > 0, nxt[1], eoc)
    end <- ifelse((nxt - 1 > beg && nxt < eoc), nxt - 1, eoc)
  } else {
    message("No config file section or section not found in file")
  }
  
  cfg <- grep("#", config[beg:end], value = TRUE, invert = TRUE)
  cfg <- grep("=", cfg, value = TRUE)
  pairs <- strsplit(cfg, "=")
  namez <- trimws(sapply(pairs, "[[", 1))
  valuez <- trimws(sapply(pairs, "[[", 2))
  df <- as.data.frame(rbind(valuez), stringsAsFactors = FALSE)
  names(df) <- namez
  return (df)
}


# set global option to not use factors
# this has side-effect on read.csv
options(stringsAsFactors = FALSE)
options(row.names = FALSE)
options(width = 160)

args <- "db, d, 2, character, path to sqlite db file with name data
cfg, c, 2, character, path to cfg file with connection credentials"

opt <- get_args(args)

db <- "names.sqlite" 

if (is.null(opt$db))
    message("Using db: ", db)

if (!is.null(opt$db)) db <- opt$db

cfg <- "dina.cfg"

if (!is.null(opt$cfg)) cfg <- opt$cfg
if (interactive()) {
  setwd("~/repos/dina-web/dw-cli-tools/dinar")
}

if (!file.exists(db)) {
  warning("Couldn't find name db: ", db)
  q(status = 0)
}

cfg <- get_config(cfg, "MySQL")

src_mysql_fixed <- function(dbname, host, port = 3306, user, password, ...) {
  
  con <- dbConnect(RMySQL::MySQL(), dbname = dbname, host = host, 
                   port = port, username = user, password = password, ...)
  message("Setting character set for connection")
  #  res <- dbGetQuery(con, statement = "SET collation_connection = utf8_general_ci;")
  res <- dbGetQuery(con, statement = "SET NAMES utf8;")
  info <- dbGetInfo(con)
  src_sql("mysql", con, 
          info = info, disco = dplyr:::db_disconnector(con, "mysql"))  
}


dina_db <- src_mysql_fixed(
  dbname = cfg$Database, 
  host = ifelse(interactive(), "127.0.0.1", cfg$Host), 
  user = cfg$User, 
  password = cfg$Password)

message("Reading name database")

names_db <- src_sqlite(path = db)
names_df <- names_db %>% tbl("names") %>% collect

firstnames <- names_df$firstnames
boys <- names_df$boys
girls <- names_df$girls
lastnames <- names_df$lastnames
surnames <- names_df$surnames

message("Will now process agent, specifyuser, address, dnasequence")

agent <- dina_db %>% tbl("agent") %>% collect
user <- dina_db %>% tbl("specifyuser") %>% collect
address <- dina_db %>% tbl("address") %>% collect
dna <- dina_db %>% tbl("dnasequence") %>% collect

message("Now processing agent table data")

fn <- agent$FirstName
ln <- agent$LastName
initials <- agent$Initials
middle <- agent$MiddleInitial

message("Generating random name lookup tables")
lu_firstnames <- c(firstnames, boys, girls)
# create 5000 combinations of "dual surnames + lastnames"
combos <- expand.grid(surnames, sample(lastnames, 5))
combos <- paste(combos$Var1, combos$Var2)
lu_lastnames <- c(lastnames, surnames, combos)

message("Mapping old values to new random values")

fr_firstnames <- unique(agent$FirstName) # 1965
agent$FirstName <- 
  plyr::mapvalues(agent$FirstName, 
    from = fr_firstnames, 
    to = sample(lu_firstnames, length(fr_firstnames)))

fr_lastnames <- unique(agent$LastName) # 4939
agent$LastName <- 
  plyr::mapvalues(agent$LastName, 
    from = fr_lastnames, 
    to = sample(lu_lastnames, length(fr_lastnames)))

fr_initials <- unique(agent$Initials) # 3
agent$Initials <- 
  plyr::mapvalues(agent$Initials,
    from = fr_initials,
    to = sample(c("M", "X", "Y", "Z"), length(fr_initials), replace = TRUE))

fr_middle <- unique(agent$MiddleInitial) # 178
agent$MiddleInitial <- 
  plyr::mapvalues(agent$MiddleInitial,
    from = fr_middle,
    to = sample(toupper(letters), length(fr_middle), replace = TRUE))

fr_abbrev <- unique(agent$Abbreviation) # 77
agent$Abbreviation <- 
  plyr::mapvalues(agent$Abbreviation, 
    from = fr_abbrev, 
    to = sample(toupper(letters), length(fr_abbrev), replace = TRUE))

agent$Email <- 
  paste0(tolower(agent$FirstName), "@dina-web.example.net")

agent$DateOfBirth <- "1924-01-23"
agent$DateOfDeath <- "1944-07-18"


message("Processing dnasequence table")

new_dnaseq <- paste0(collapse = "", 
  sample(c("T", "A", "G", "C"), 
         size = max(nchar(dna$GeneSequence)), 
         replace = TRUE))

dna$GeneSequence <- new_dnaseq

dna$Text1 <- NA
dna$Text2 <- NA

message("Processing specify user table")

fr_username <- unique(user$Name)

# generate valid usernames but random

lu_username <- paste0(
  substr(tolower(sample(c(boys, girls), 1000)), 1, 4), 
  substr(tolower(surnames), 1, 4))

lu_username <- lu_username[which(nchar(lu_username) > 7, arr.ind = TRUE)]

if (any(duplicated(lu_username))) 
  warning("Duplicated 8 letter usernames!")

user$Name <- 
  plyr::mapvalues(user$Name,
    from = fr_username,
    to = sample(lu_username, length(fr_username)))

user$EMail <- paste0(user$Name, "@dina-web.example.net")
user$Password <- ""
user$LoginCollectionName <- "Example Collection"
user$LoginDisciplineName <- "Example Discipline"

message("Processing address table")

# QUICKFIX: not mapping values, just reusing single value everywhere...

address$Address <- "Frescativägen 40"
address$Address2 <- "Box 50007"
address$Address3 <- "Stockholm"
address$Address4 <- ""
address$Address5 <- ""
address$City <- "Stockholm"
address$Country <- "Sweden"
address$Fax <- "555-555 555"
address$Phone1 <- "555-555 555"
address$Phone2 <- "555-555 555"
address$PostalCode <- "100 00"
address$RoomOrBuilding <- "Office 1247"
address$State <- "Uppland"
address$TypeOfAddr <- "Permanent"

tbldf_enc <- function(tbl_df, encoding = "latin1") {
  res <- data.frame(stringsAsFactors = FALSE,
    apply(tbl_df, MARGIN = 2,
          function(x) iconv(x, to = encoding)))
  return (tbl_df(res))
}

# Upload the anonymized user table
replaceTable <- function(dina_db, table, df) {
  
  anon_table <- paste0("anon_", table)
  
  con <- dina_db$con

  message("Checking if ", anon_table, " exists...")
  if (dbExistsTable(con, name = anon_table)) 
    dbRemoveTable(con, name = anon_table)

  message("Writing table ", anon_table, " to db ...")
  res <- dbWriteTable(con, name = anon_table, 
    value = as.data.frame(df), row.names = FALSE) 

 message("Replacing ", table, " with ", anon_table, " ... ")
 res <- dbSendQuery(con, "set foreign_key_checks = 0;")
 res <- dbSendQuery(con,
  paste0("replace into ", table, " select * from ", anon_table, ";"))
 res <- dbGetQuery(con, "set foreign_key_checks = 1;")
  
  message("Removing ", anon_table)
  res <- dbRemoveTable(con, name = anon_table)
}

tables <- c("agent", "specifyuser", "address", "dnasequence")

message("Renonymizing database")
user$Name[1] <- "nrmuser"
user$IsLoggedIn <- FALSE
user$IsLoggedInReport <- FALSE
replaceTable(dina_db, "specifyuser", user)

address$IsPrimary <- FALSE
address$IsCurrent <- FALSE
replaceTable(dina_db, "address", address)
replaceTable(dina_db, "agent", agent)
replaceTable(dina_db, "dnasequence", dna)

message("Done ... ")
message("The first user is now: ", user$Name[1])
