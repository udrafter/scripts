# Payrun script

## Set permissions

```sh
chmod +x payrun_script.sh
```

## Set database credentials

* Edit `payrun_script.sh` file and set the correct values to create a connection with the database.

```sh
DB_USER=XXX
DB_PASSWORD=XXX
DB_PORT=3306
DB_HOST=XXX
DB_NAME=XXX
```

## Execute

```sh
./payrun_script.sh
```

## Set input parameters

```sh
Running payrun script...

Please enter start date (yyyy-mm-dd):
  2021-02-16
  Start Date => 2021-02-16

Please enter end date (yyyy-mm-dd):
  2021-02-17
  End Date => 2021-02-17

Please enter the week:
  45
  Week => 45

Please enter the year (yyyy) [Default actual year]:
  Year => 2021
```