<?php

//connection string information


$dbhost = 'localhost';
$dbuser = 'interes5_flash';
$dbpass = 'flashDB00';
$dbname = 'interes5_megan';
//$dbtable= 'client';

$conn = mysql_connect($dbhost, $dbuser, $dbpass) or die                      ('Error connecting to mysql');


mysql_select_db($dbname);


?>