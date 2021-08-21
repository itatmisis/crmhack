#!/bin/bash

cd /tmp
wget https://alphacephei.com/vosk/models/vosk-model-small-ru-0.15.zip
unzip vosk-model-small-ru-0.15.zip
cd -
mv /tmp/vosk-model-small-ru-0.15/* ./*