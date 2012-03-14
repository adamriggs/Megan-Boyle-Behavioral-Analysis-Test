<?php

//mysql connection info
include 'connString.php';

//get table name and remove it from $_POST
$table=$_POST[table];
unset($_POST[table]);

//get row id number and remove it from $_POST
$id=$_POST[id];
unset($_POST[id]);

//get the array of keys from $_POST and build a string of comma seperated names = value pairs
$keystring="";
$keysep="";

foreach($_POST as $i => $value){
	$keystring.=$keysep;
	$keystring.=$i . "='" . $value . "'";
	$keysep=", ";
}

//set the sql query string
$sql="UPDATE $table SET $keystring WHERE id='$id'";

//execute the query and report back status in xml form
echo "<?xml version=\"1.0\"?>";
echo "<update>";
echo "<sql>" . $sql . "</sql>";
if (!mysql_query($sql,$conn)){
	die('<result>' . mysql_error() . "</result>");
} else {
	echo "<result>success</result>";
}
echo "</update>";

mysql_close($conn)

?>