#!/bin/bash

download() {
	for url in $(cat $1); do wget -q -T 5 -O resource_$url $url; done
}

download $1

parse_sub() {
	for resource in $(cat $1); do A=$(echo $resource | cut -d "." -f 1); B=$(echo $resource | cut -d "." -f 2); grep -o "[^A-Z,/,\",},{,?,=,',%]*\.${A}\.${B}" resource_$resource | sort -u > sub_$resource.txt; rm resource_$resource; done
}

parse_sub $1

resolve() {
	for resource in $(cat $1); do for subdomain in $(cat sub_$resource.txt); do host $subdomain >> resolved.txt; echo "" >> resolved.txt; done; done; rm sub_*
}

resolve $1

clean() {
	sed '/is an alias/d' resolved.txt >> resolve.txt; sed '/mail is handled/d' resolve.txt >> resolv.txt; sed '/IPv6/d' resolv.txt >> resol.txt; sed '/^[[:space:]]*$/d' resol.txt >> reso.txt; sed '/3(NXDOMAIN)/d' reso.txt >> res.txt; cat res.txt | cut -d " " -f 1,4 >> subip.txt; rm res*
}

clean

uniqip() {
	cat all.txt | cut -d " " -f 2 | sort -u >> uniqip.txt
}

uniqip
