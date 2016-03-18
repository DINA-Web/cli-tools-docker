FROM python:3.5
ENV PYTHONUNBUFFERED 1

RUN pip install collectionbatchtool

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ADD dina.cfg /usr/src/app
ADD cbt.py /usr/src/app
ADD export_all_data.py /usr/src/app
ADD import_all_data.py /usr/src/app

ADD docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["python", "export_all_data.py", "-h"]
