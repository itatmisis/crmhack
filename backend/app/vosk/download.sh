#!/bin/bash

cd /tmp
#wget https://alphacephei.com/vosk/models/vosk-model-ru-0.10.zip # Версия на 2.5ГБ, качественее.
wget https://alphacephei.com/vosk/models/vosk-model-small-ru-0.15.zip
unzip vosk-model-small-ru-0.15.zip
cd -
mv /tmp/vosk-model-small-ru-0.15/* ./
