<?php

header("Content-type: text/xml"); 

include 'connString.php';

// Formulate Query
$query = sprintf("SELECT * FROM client ORDER BY dCompleted DESC");

// Perform Query
$result = mysql_query($query);

// Check result
// This shows the actual query sent to MySQL, and the error. Useful for debugging.

if (!$result) {
    $message  = 'Invalid query: ' . mysql_error() . "\n";
    $message .= 'Whole query: ' . $query;
    die($message);
}


echo "<?xml version='1.0' encoding='iso-8859-1'?>";
echo "<CLIENTS>";

while ($row = mysql_fetch_assoc($result)) {
	if(strtotime("now") > strtotime($row["dViewable"])){
		echo "<CLIENT>";
		echo "<ID>".$row['id']."</ID>";
		echo "<TITLE>".$row['title']."</TITLE>";
		echo "<DESCRIPTION>".$row['description']."</DESCRIPTION>";
		echo "<LINK>".$row['link']."</LINK>";
		echo "<ICON>".$row['icon']."</ICON>";
		echo "<DADDED>".$row['dAdded']."</DADDED>";
		echo "<DCOMPLETED>".$row['dCompleted']."</DCOMPLETED>";
		echo "<DVIEWABLE>".strtotime($row['dViewable'])."</DVIEWABLE>";
		echo "<ACTIVE>".$row['active']."</ACTIVE>";
		echo "</CLIENT>";
	}
}

echo "</CLIENTS>";

?>