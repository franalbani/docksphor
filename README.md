# docksphor

gr-fosphor inside docker for people unable to install it.

## First: build

* `./build`

## Second: run

* `./run`

This will open a `gnuradio-companion` inside docker,
with a flowgraph containing a ZMQ SUB Source connected to `tcp://127.0.0.1:35000`
and a QT Fosphor Sink.

## Third: send your samples

From your app, send samples to a ZMQ PUB Sink binded to `tcp://127.0.0.1:35000`.
