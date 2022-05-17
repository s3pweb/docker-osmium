FROM alpine:3.13.1

#RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN apk add --no-cache \
        boost-dev \
        bzip2-dev \
        cmake \
        expat-dev \
        g++ \
        gdal-dev \
        geos-dev \
        git \
        make \
        proj-dev \
        sparsehash \
        zlib-dev \
        lz4-dev

RUN mkdir /code

RUN cd /code && git clone https://github.com/mapbox/protozero.git && \
        cd /code/protozero && \
        mkdir build && \
        cd build && \
        cmake .. && \
        make && \
        make install

RUN cd /code && git clone https://github.com/osmcode/libosmium.git && \
        cd libosmium && \
        mkdir build && \
        cd build && \
        cmake -DCMAKE_BUILD_TYPE=MinSizeRel -DBUILD_EXAMPLES=OFF .. && \
        make

RUN cd /code && git clone https://github.com/osmcode/osmium-tool.git && \
        cd /code/osmium-tool && \
        mkdir build && \
        cd build && \
        cmake -DCMAKE_BUILD_TYPE=MinSizeRel .. && \
        make && \
        make install

RUN apk del git cmake make
RUN rm -rf /code

ENTRYPOINT ["osmium"]

CMD ["--help"]
