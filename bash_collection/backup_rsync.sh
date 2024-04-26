#!/bin/bash

DATE=$(date '+%F' )
sudo rsync -avz /archivo_resguardo alberto@localhost:/mnt/USB_backup/archivo/$DATE
