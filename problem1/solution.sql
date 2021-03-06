 # step 1 - Create database patientinfo
CREATE DATABASE IF NOT EXISTS PATIENTINFO
LOCATION "hdfs:///user/hive/warehouse/patient/";

use patientinfo;

#step 2 - create table patient_details

CREATE TABLE PATIENT_DETAILS ( NAME STRUCT<FIRST:STRING,LAST:STRING>,
ADDRESS STRUCT<HOUSENO:STRING,LOCALITY:STRING,CITY:STRING,ZIP:STRING>,
PHONE STRUCT<LANDLINE:STRING,MOBILE:STRING>)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
COLLECTION ITEMS TERMINATED BY ':'
STORED AS SEQUENCEFILE;


# step 3 - create temporary table to load local .csv file

CREATE TEMPPORARY TABLE TEMP1 ( DATA STRING) ;

LOAD LOCAL DATA INFILE 'file:///home/cloudera/Desktop/DATA/data1.csv' INTO TABLE TEMP1;

# step 4 - insert data into patient_details

INSERT OVERWRITE TABLE PATIENT_DETAILS
SELECT NAMED_STRUCT("FIRST",SPLIT(DATA,"\\|")[0],"LAST",SPLIT(DATA,"\\|")[1]),
NAMED_STRUCT("HOUSENO",SPLIT(SPLIT(DATA,"\\|")[2],",")[0],
"LOCALITY",SPLIT(SPLIT(DATA,"\\|")[2],",")[1],
"CITY",SPLIT(SPLIT(DATA,"\\|")[2],",")[2],
"ZIP",SPLIT(DATA,"\\|")[5]),
NAMED_STRUCT("LANDLINE",SPLIT(DATA,"\\|")[3],"MOBILE",SPLIT(DATA,"\\|")[4])
FROM TEMP1;


