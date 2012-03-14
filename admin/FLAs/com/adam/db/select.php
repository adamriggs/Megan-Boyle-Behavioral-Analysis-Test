<?php

header("Content-type: text/xml"); 

include 'connString.php';

// Formulate Query
$sql = "SELECT ";

if($_POST[keyword] && $_POST[keyword]!=""){
	$sql= $sql  .  $_POST[keyword] . " ";
}

$sql=$sql . $_POST[columns] . " FROM " . $_POST[table];

if($_POST[where] && $_POST[where]!=""){
	$where=$_POST[where];
	$where=str_replace("\'", "'",$where);
	$sql= $sql . " WHERE " .  $where;
}

if($_POST[order] && $_POST[order]!=""){
	$sql= $sql . " ORDER BY " .  $_POST[order];
}

// Perform Query
$result = mysql_query($sql);

// Format XML Response
echo "<?xml version='1.0' encoding='iso-8859-1'?>";
echo "<SELECT>";
echo "<SQL>" . $sql . "</SQL>";
echo "<RESULT>";

if(!$result){
	echo mysql_error();
} else {
	while ($row = mysql_fetch_assoc($result)) {
		echo "<ROW>";
		$keys=array_keys($row);
		
		foreach($keys as $i => $value){
			echo "<" . strtoupper($value) . ">" . $row[$keys[$i]] . "</" . strtoupper($value) . ">";
		}
		echo "</ROW>";
	}
}

echo "</RESULT>";
echo "</SELECT>";

?>