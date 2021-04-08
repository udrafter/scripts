#!/bin/bash

echo "Running payrun script..."

DB_USER=root
DB_PASSWORD=root_pass
DB_PORT=3306
DB_HOST=localhost
DB_NAME=homestead

# startDate=$1
# endDate=$2
# period=$3
# year=$4

echo "Please enter start date (yyyy-mm-dd):"
read var1
startDate=$var1
if [ -z "$var1" ]
then
  exit 1
fi
echo "Start Date => $startDate"

echo "Please enter end date (yyyy-mm-dd):"
read var2
endDate=$var2
if [ -z "$var2" ]
then
  exit 1
fi
echo "End Date => $endDate"

echo "Please enter the week:"
read var3
period=$var3
if [ -z "$var3" ]
then
  exit 1
fi
echo "Week => $period"

echo "Please enter the year (yyyy) [Default actual year]: "
read var4
myyear=`date +'%Y'`
year=${var4:-$myyear}
echo "Year => $year"

sql_script=payrun_script.sql

mysql -h$DB_HOST -u$DB_USER -p$DB_PASSWORD -P$DB_PORT --protocol=tcp -D$DB_NAME -e "set @startDate='${startDate}'; set @endDate='${endDate}'; set @period=${period}; set @year=${year}; source ${sql_script};" > output.txt;

cat payrun_script.txt

echo "Payrun script finished"