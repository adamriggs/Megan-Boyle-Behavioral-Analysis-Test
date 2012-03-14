<?php

//header("Content-type: text/html"); 

//filename for download
$filename = "participant_excel_data.xls";

header("Content-Disposition: attachment; filename=\"$filename\"");
header("Content-Type: application/vnd.ms-excel");

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

//$sql="SELECT test,event,timestamp,phase,component FROM test WHERE participant='asdf2' AND test='1327956629686' ORDER BY timestamp ASC";

// Perform Query
$result = mysql_query($sql);

//create interval array
$circleClicked=0;
$rewardClicked=0;
$rewardDelivered=0;
$iArray=array();

if(!$result){
	echo mysql_error();
} else {
	$iCount=1;
	$iEnd=0;
	$iSize=10*1000;
	$initDone=false;
	
	$prevTest="";
	$prevPhase="";
	$prevComponent="";
	
	while ($row = mysql_fetch_assoc($result)) {
		
		if(!$initDone){
			$iEnd=$row['timestamp'];
			$iEnd+=$iSize;
			
			$prevTest=$row['test'];
			$prevPhase=$row['phase'];
			$prevComponent=$row['component'];
			
			$initDone=true;	
		}
		
		/*if($iCount==13 || $iCount==14){
			echo "row[event]==" . $row['event'] . "<br>";
		}*/
		
		/*echo "rowT==" . $row['timestamp'] . "<br>";
		echo "iEnd==          " . $iEnd . "<br>";
		echo "<br>";*/
		
		while($row['timestamp']>$iEnd || $prevTest!=$row['test'] || $prevPhase!=$row['phase'] || $prevComponent!=$row['component']){
			//echo "*****if<br>";
			
			array_push($iArray,array("test"=>$row['test'],"phase"=>$row['phase'],"component"=>$row['component'],"clicks"=>$circleClicked,"delivery"=>$rewardDelivered,"consumption"=>$rewardClicked));
			
			$circleClicked=0;
			$rewardClicked=0;
			$rewardDelivered=0;
			
			$iEnd+=$iSize; 
			
			$prevTest=$row['test'];
			$prevPhase=$row['phase'];
			$prevComponent=$row['component'];
			
			$iCount++;
		}
		
		
		switch($row['event']){
			case "circle clicked":
				//echo "circleClicked<br>";
				$circleClicked++;
			break;
			
			case "reward clicked":
				//echo "rewardClicked<br>";
				$rewardClicked++;
			break;
			
			case "reward delivered":
				//echo "rewardDelivered<br>";
				$rewardDelivered++;
			break;
		}
		
	}
	
	
	array_push($iArray,array("test"=>$prevTest,"phase"=>$prevPhase,"component"=>$prevComponent,"clicks"=>$circleClicked,"delivery"=>$rewardDelivered,"consumption"=>$rewardClicked));
			
	$circleClicked=0;
	$rewardClicked=0;
	$rewardDelivered=0;
}

echo "iArray count==" . count($iArray) . "<br>";	
//echo "iArray[0]==" . $iArray[0] . "<br>";


//output the html table	
$prevTest="";
$prevPhase="";
$prevComponent="";
$iCount=1;

echo "<html><head><title>sample html table for excel</title></head>";
echo "<body>";
echo "<table border='1'>";

echo "<tr><td><strong>Participant</strong></td><td>" . $_POST[participant] . "</td><td></td></tr>";
//echo "<tr><td><strong>count(iArray)</strong></td><td>" . count(iArray) . "</td><td></td></tr>";
//echo "<tr><td><strong>sql</strong></td><td>" . $sql . "</td><td></td></tr>";

for($i=0;$i<count($iArray);$i++){
	
	if($prevTest!=$iArray[$i]['test']){
		//echo "prevTest unequivalent<br>";
		$prevTest=$iArray[$i]['test'];
		testBreak($prevTest);
		$prevPhase="";
		$prevComponent="";
		$iCount=1;
	}
	
	if($prevPhase!=$iArray[$i]['phase'] || $prevComponent!=$iArray[$i]['component']){
		/*echo "prevPhase or prevComponent unequivalent<br>";
		echo "prevPhase " . $prevPhase . $iArray[$i]['phase'] . "<br>";
		echo "prevComponent " . $prevComponent . $iArray[$i]['component'] . "<br>";*/
		$prevPhase=$iArray[$i]['phase'];
		$prevComponent=$iArray[$i]['component'];
		phaseBreak($prevPhase,$prevComponent);
		$iCount=1;
	}
	
	echo "<tr>";
	echo "<td><strong>" . $iCount . "</strong></td>";
	echo "<td>" . $iArray[$i]['clicks'] . "</td>";
	echo "<td>" . $iArray[$i]['consumption'] . "</td>";
	echo "</tr>";
	
	$iCount++;
}

echo "</table>";
echo "</body>";
echo "</html>";

//functions


function tableTitle(){
	echo "<tr><td><strong>Participant</strong></td><td>" . $_POST[participant] . "</td><td></td></tr>";
}

function testBreak($test){
	lineBreak();
	lineBreak();
	lineBreak();
	lineBreak();
	echo "<tr><td><strong>Test Date</strong></td><td>" . date("n/j/Y g:i:s a",((int)($test/1000))) . "</td><td></td></tr>";	
	//echo "<tr><td>Test Date</td><td>" . $test . "</td><td></td></tr>";	
}

function phaseBreak($phase,$component){
	lineBreak();
	lineBreak();
	echo "<tr><td><strong>Phase</strong></td><td>" . $phase . "</td><td></td></tr>";
	echo "<tr><td><strong>Component</strong></td><td>" . $component . "</td><td></td></tr>";
	lineBreak();
	lineBreak();
	echo "<tr><td><strong>Interval</strong></td><td><strong>Clicks</strong></td><td><strong>Consumption</strong></td></tr>";
}

function lineBreak(){
	echo "<tr><td></td><td></td><td></td></tr>";
}

?>