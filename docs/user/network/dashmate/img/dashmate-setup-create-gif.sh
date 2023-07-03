#!/bin/bash

# Script to create a gif from an asciinema cast file using the agg tool
# See https://asciinema.org/ and https://github.com/asciinema/agg
# This is based on cast 594561 (https://asciinema.org/a/594561)
docker run --rm -it -u $(id -u):$(id -g) -v $PWD:/data agg --speed 2 dashmate-setup-dmt.cast dashmate-setup-dmt.gif