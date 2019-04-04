FROM python:2.7-alpine

RUN apk --no-cache add \
        aspell \
        aspell-en \
        ca-certificates \
        gcc \
	git \
        libffi-dev \
        musl-dev \
        postgresql-dev \
    && pip install --upgrade pip \
    && mkdir -p /usr/share/dict/ \
    && aspell -d en dump master > /usr/share/dict/words

COPY dev-requirements.txt /dictionaryutils/dev-requirements.txt
RUN pip install -r /dictionaryutils/dev-requirements.txt

COPY . /dictionaryutils

CMD cd /dictionary; rm -rf build dictionaryutils dist gdcdictionary.egg-info; python setup.py install --force && cp -r /dictionaryutils . && cd /dictionary/dictionaryutils; nosetests -s -v; export SUCCESS=$?; cd ..; rm -rf build dictionaryutils dist gdcdictionary.egg-info; exit $SUCCESS