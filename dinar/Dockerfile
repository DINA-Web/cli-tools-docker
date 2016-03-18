FROM rocker/ropensci 

RUN install2.r --error \
	getopt

ADD ./renonymize.R /renonymize.R
ADD ./dina.cfg /dina.cfg
ADD ./names.sqlite /names.sqlite

ADD docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

WORKDIR /

CMD ["./renonymize.R", "--help"]
