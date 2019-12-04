#!/bin/bash

# Load RHC dataset into database
pg_ctl -o "-c listen_addresses='localhost'" -w restart
pgfutter --schema public csv /tmp/rhc.csv

# Load MADlib extension
pgxn load -d postgres -U postgres madlib

