#!/bin/bash

download() {
	for url in $(cat $1); do mkdir resource_$url; wget -q -O resource_$url/resource_$url $url; done
}

download $1

parse_sub() {
	for resource in $(cat $1); do cd ./resource_$resource; A=$(echo $resource | cut -d "." -f 1); B=$(echo $resource | cut -d "." -f 2); grep -o "[^A-Z,/,\",},{,?,=,',%]*\.${A}\.${B}" resource_$resource | sort -u > sub_$resource.txt; cd ../; done
}

parse_sub $1

resolve() {
	for resource in $(cat $1); do cd ./resource_$resource; for subdomain in $(cat sub_$resource.txt); do host $subdomain >> resolved.txt; echo "" >> resolved.txt; done; cd ../; done
}

resolve $1
