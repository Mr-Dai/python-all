FROM buildpack-deps:stretch

ENV PATH /usr/local/bin:$PATH
ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
        libssl1.0-dev tk-dev \
    && rm -rf /var/lib/apt/lists/*

ADD ./install-python.sh ./install-python.sh

RUN bash install-python.sh 2.6.9
RUN bash install-python.sh 2.7.18
RUN bash install-python.sh 3.4.10
RUN bash install-python.sh 3.5.10
RUN bash install-python.sh 3.6.13
RUN bash install-python.sh 3.7.10
RUN bash install-python.sh 3.8.8
RUN bash install-python.sh 3.9.2

# Use 3.9 on default
RUN cd /usr/local/bin \
	&& rm -f idle && ln -s idle3.9 idle \
	&& rm -f pydoc && ln -s pydoc3.9 pydoc \
	&& rm -f python && ln -s python3.9 python \
	&& rm -f python-config && ln -s python3.9-config python-config

# Install PIP
RUN set -ex; \
	\
	wget -O get-pip.py "https://bootstrap.pypa.io/get-pip.py"; \
	\
	python get-pip.py \
		--disable-pip-version-check \
		--no-cache-dir ; \
	pip --version; \
	\
	find /usr/local -depth \
		\( \
			\( -type d -a \( -name test -o -name tests \) \) \
			-o \
			\( -type f -a \( -name "*.pyc" -o -name "*.pyo" \) \) \
		\) -exec rm -rf "{}" +; \
	rm -f get-pip.py

CMD ["/bin/bash"]
