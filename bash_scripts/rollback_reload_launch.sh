#!/bin/bash

cd bash_scripts

./rollback_db
./load_data
./launch_server

cd ..
