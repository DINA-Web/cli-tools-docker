# dw-cli-tools

Integration project to enable data wrangling using various CLI tools for DINA-Web, such as collectionsbatchtool etc

## Usage

Firstly, make sure you have `docker` and `docker-compose` and `make`.

Then use the following make commands:

	- initdb / scrambledb / cleandb : load mysql db dump, renonymize names and remove db
	- ul / dl : to upload or download CSV data @ Internet Archive
	- export / import : to export db data in CSV format or import from CSV into the db
	- build / up / stop / rm : manage docker container life cycles

In general:

	1. First clone this git repo.
	1. Make sure to put your existing mysql db dump in `mysql-autoload`.
	1. Run `make` 
	1. Scramble with `make scrambledb`
	1. Export into CSV with `make export`
	1. Possibly make changes to the CSV files
	1. Import to db with `make import`
	1. Possibly upload dataset to IA using `make ul`


