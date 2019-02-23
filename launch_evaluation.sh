#!/bin/bash
./self_organizing_map.R --rate 0.75 --radius 2 --number_iteration 1
./self_organizing_map.R --rate 2 --radius 2 --number_iteration 1
./self_organizing_map.R --rate 0.75 --radius 2 --number_iteration 3
./self_organizing_map.R --rate 0.10 --radius 2 --number_iteration 1
./self_organizing_map.R --rate 0.75 --radius 4 --number_iteration 1
./self_organizing_map.R --rate 0.75 --radius 0.5 --number_iteration 1
./self_organizing_map.R --rate 0.75 --radius 0.5 --number_iteration 3
./self_organizing_map.R --rate 0.1 --radius 0.5 --number_iteration 1
./self_organizing_map.R --rate 2 --radius 0.5 --number_iteration 3

