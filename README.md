# dw-cli-tools

Integration project to enable data wrangling using various CLI tools for DINA-Web, such as collectionsbatchtool etc

This set of micro-services are bundled together into one app using `docker-compose`. Settings for the individual components can be inspected in the `docker-compose.yml`-file.

## Intro

This app provides tools that can be used from the command line (CLI) to manage and automate data IO ie export and import into the DINA-Web system. 

It provides Python and R CLI tools that help with automating batch loading of data as well as "scrambling" or "renonymizing" datasets to remove e-mailadresses and some other personal data.

The initial focus is to provide support for import and export of Collections data (used in dw-collections-api), but the plan is to also support Media and other datatypes for various modules in DINA-Web.

## Usage

Before anything else, make sure you have `docker` and `docker-compose` and `make`. Then use `git` to clone this repository. If you have an existing db dump, put it in `mysql-autoload` and then issue `make` - this will build and start services and provide the CLI tools along with all their dependencies. 

After that, the following `make` commands can be used:

### Migrate from existing db

Use these commands to migrate data form an existing compatible mysql db dump - using the Specify 6/7 db schema - and to renonymize personal data.

- `initdb`
- `scrambledb`
- `cleandb` 

Export db data in CSV format or import from CSV

- `export`
- `import`

### Upload och download Collections data in CSV

The Internet Archive (archive.org) is used for distributing these datasets (requires install of <https://pypi.python.org/pypi/internetarchive>)

- `ul`
- `dl`

These commands currently work against <https://archive.org/details/dw-datasets>

## Manage various aspects of the apps life cycle

- `build`
- `up`
- `stop`
- `rm`


# Example workflow

1. Load an existing Specify 6 mysql db dump by putting the file in the mysql-autoload dir and do `make initdb`
1. Scramble personal data with `make scrambledb`
1. Export Collection data into CSV with `make export` (modify the dina.cfg for the Collection you are targeting, and do `make build` first)
1. Possibly make changes to the CSV files, if you need to, perhaps geolocalize etc...
1. Import the new Collections data into the db with `make import`


