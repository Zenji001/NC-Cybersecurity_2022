#!/bin/bash

date_arg=$1
time_arg=$2

# Combine any dealer schedule to STDOUT
for file in *_Dealer_schedule
do
  awk 'NR>2 { print FILENAME ( NF?" ":"" ) $0 }' $file | 
    # Change time format for easier typing
    sed '$d;s/_Dealer_schedule//g;s/:00:00//g;s/ //2'
done |

  # Search for arguements
  grep -E $date_arg |
    grep -E $time_arg |
    awk -F"	" '{ print $1,$3 }' |
    sed 's/:/ /1'
