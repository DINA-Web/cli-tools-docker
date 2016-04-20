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

args <- "cfg, c, 2, character, path to cfg file with connection credentials
dest, d, 2, character, path to file with results"

opt <- get_args(args)

cfg <- "dina.cfg"
dest <- "/tmp/users.tsv"

if (interactive()) {
  setwd("~/repos/dina-web/dw-cli-tools/dinar")
  dest <- paste0(getwd(), "/users.tsv")
}

if (!is.null(opt$cfg)) cfg <- opt$cfg
if (!is.null(opt$dest)) dest <- opt$dest

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

user <- dina_db %>% tbl("specifyuser") %>% collect 

agent <- dina_db %>% tbl("agent") %>% collect
 
res <- 
  user %>% 
  left_join(agent, by = "SpecifyUserID") %>%
  select(AgentID, SpecifyUserID, Name, Password)

new_pass <- 
  readLines(paste0("https://www.random.org/passwords/?num=", 
    nrow(res), "&len=8&format=plain&rnd=new"))

res$new_pass <- new_pass

message("Writing results to ", dest)
write.csv(res, file = dest, row.names = FALSE)

if (!interactive()) q(save = "no", status = 0)
