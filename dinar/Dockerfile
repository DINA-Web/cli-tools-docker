FROM rocker/ropensci:latest

RUN install2.r --error \
	getopt

ADD ./renonymize.R /renonymize.R
ADD ./userdump.R /userdump.R
ADD ./dina.cfg /dina.cfg
ADD ./names.sqlite /names.sqlite

ADD docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

WORKDIR /

CMD ["./renonymize.R", "--help"]
