#!/usr/bin/env bash

useDate=$(date +'%Y-%m-%d %H:%M:%S');
response=$(curl --silent -m 10 $1)

if [[ -n $response ]]
then
	echo "{\"sampletime\":\"$useDate\", \"sampleResult\":$response"} >> $2_$(date +"%Y-%m").txt
else 
	echo "{\"sampletime\":\"$useDate\", \"sampleResult\":\"Error\""} >> $2_$(date +"%Y-%m").txt
fi; 
sudo cp $2_$(date +"%Y-%m").txt /var/www/html/$2_$(date +"%Y-%m").txt