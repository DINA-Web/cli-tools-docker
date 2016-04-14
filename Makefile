ME=$(USER)
all: build init up

clean: stop rm

cleandb:
	docker-compose stop db
	docker-compose rm -vf db
	sudo chown -R $(ME):$(ME) ./mysql-datadir
	sudo rm -rf mysql-datadir

initdb:
	@echo "If you just ran make cleandb, this will load latest db dump placed in mysql-autoload"
	docker-compose up -d db
	@echo "Run docker-compose logs db for seeing progress"

scrambledb:
	@echo "Scrambling / renonymyzing db..."
	./change_db_enc.sh
	docker-compose run dinar ./renonymize.R
	@echo "... and now sanitizing data ..."
	mysql -u dina -ppassword12 -D dina_nrm -h 127.0.0.1 < sanitize_db.sql
	@echo "Now please run make dumpdb to export a mysql dumpfile"

dumpdb:
	@echo "Dumping db... make sure you ran make scrambledb first ... creating dina_nrm.sql.gz"
	mysqldump -u dina -ppassword12 -h 127.0.0.1 --databases dina_nrm > dina_nrm.sql
	gzip dina_nrm.sql

userdump:
	@echo "Dumping users"
	docker-compose run dinar ./userdump.R

ul:
	@echo "Packaging and uploading data from cbt-data to Internet Archive"
	cd cbt-data/ && tar cvfz ../dw-datasets.tgz *.csv && cd ..
	ia upload dw-datasets dw-datasets.tgz --metadata="title:DINA-Web Datasets"
	rm dw-datasets.tgz
	firefox https://archive.org/details/dw-datasets &

dl:
	@echo "Downloading DINA-Web Datasets using wget"
	wget http://archive.org/download/dw-datasets/dw-datasets.tgz -O dw-datasets.tgz
	mkdir -p cbt-data	
	tar xvfz dw-datasets.tgz -C cbt-data
	rm -rf dw-datasets.tgz

dl-ia:
	@echo "Downloading DINA-Web Datasets from Internet Archive into cbt-data"
	ia download dw-datasets dw-datasets.tgz
	mkdir -p cbt-data
	tar xvfz dw-datasets/dw-datasets.tgz -C cbt-data
	rm -rf dw-datasets
	
test:
	@echo "Testing to run tools"
	docker-compose run cbt python import_all_data.py -h
	docker-compose run dinar ./renonymize.R -h

export:
	@echo "Export all data as CSV"
	docker-compose run cbt python export_all_data.py

import:
	@echo "Import data from CSV"
	docker-compose run cbt python import_all_data.py -v dina.cfg /tmp

build:
	@echo "Rebuilding images"
	docker-compose build

up:
	docker-compose up -d

stop:
	docker-compose stop

rm:
	docker-compose rm -vf
