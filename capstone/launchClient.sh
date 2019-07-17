#!/bin/bash


cd $HOME/caliper/packages/caliper-tests-integration/reports/
python -m http.server 8888 &
ssh -R 3333:localhost:8888 cliffton.io &