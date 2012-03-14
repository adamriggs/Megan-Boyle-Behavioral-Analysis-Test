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

//$sql="SELECT test,event,timestamp,phase,component FROM test WHERE participant='monkey' AND test='1330026390076' ORDER BY timestamp ASC";

// Perform Query
$result = mysql_query($sql);

//create interval array
$circleClicked=0;
$rewardClicked=0;
$rewardDelivered=0;
$iArray=array();

$newComponent=false;
$endComponent=false;

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
			//echo "init<br>";
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
		
		//echo "row[event]==" . $row['event'] . "<br>";
		
		if($row['event']=="end component"){
			
			array_push($iArray,array("test"=>$row['test'],"phase"=>$row['phase'],"component"=>$row['component'],"clicks"=>$circleClicked,"delivery"=>$rewardDelivered,"consumption"=>$rewardClicked,"newComponent"=>false,"endComponent"=>true));
			
			array_push($iArray,array("test"=>$row['test'],"phase"=>$row['phase'],"component"=>$row['component'],"clicks"=>$circleClicked,"delivery"=>$rewardDelivered,"consumption"=>$rewardClicked,"newComponent"=>$newComponent,"endComponent"=>$endComponent));
			
			$circleClicked=$rewardClicked=$rewardDelivered=0;
			
			
		}  else if($row['event']=="new component"){
			
			array_push($iArray,array("test"=>$row['test'],"phase"=>$row['phase'],"component"=>$row['component'],"clicks"=>$circleClicked,"delivery"=>$rewardDelivered,"consumption"=>$rewardClicked,"newComponent"=>true,"endComponent"=>false));
			
			$iEnd=$row['timestamp']+$iSize;
			
			
		} else {
			
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
			
			while($row['timestamp']>$iEnd){
				
				
				array_push($iArray,array("test"=>$row['test'],"phase"=>$row['phase'],"component"=>$row['component'],"clicks"=>$circleClicked,"delivery"=>$rewardDelivered,"consumption"=>$rewardClicked,"newComponent"=>$newComponent,"endComponent"=>$endComponent));
				
				$circleClicked=0;
				$rewardClicked=0;
				$rewardDelivered=0;
				$iEnd+=$iSize;
				
			}
		}
		
		/*while($row['timestamp']>$iEnd || $prevTest!=$row['test'] || $prevPhase!=$row['phase'] || $prevComponent!=$row['component']){
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
		}*/
		
	}
	
	if($row['newComponent']==true){$newCompoent=true;}
	if($row['endComponent']==true){$endComponent=true;}
	
	array_push($iArray,array("test"=>$prevTest,"phase"=>$prevPhase,"component"=>$prevComponent,"clicks"=>$circleClicked,"delivery"=>$rewardDelivered,"consumption"=>$rewardClicked,"newComponent"=>$newComponent,"endComponent"=>$endComponent));
			
	$circleClicked=0;
	$rewardClicked=0;
	$rewardDelivered=0;
}

//echo "iArray count==" . count($iArray) . "<br>";	
//echo "iArray[0]==" . $iArray[0] . "<br>";
/*for($i=0;$i<count($iArray);$i++){
	print_r($iArray[$i]);
	echo "<br>";	
}*/


//output the html table	
$prevTest="";
$prevPhase="";
$prevComponent="";
$iCount=1;

$condition="";
$component="";
$interval=1;
$i=0;
$j=0;
$numIntervals;

$circleClickedTotal=0;
$rewardClickedTotal=0;
$rewardDeliveredTotal=0;

echo "<html><head><title>html table for excel</title></head>";
echo "<body>";
echo "<table border='1'>";

echo "<tr><td><strong>Participant</strong></td><td>" . $_POST[participant] . "</td><td></td></tr>";
//echo "<tr><td><strong>Participant</strong></td><td>" . "TEST" . "</td><td></td></tr>";

//echo "<tr><td><strong>count(iArray)</strong></td><td>" . count($iArray) . "</td><td></td></tr>";
//echo "<tr><td><strong>sql</strong></td><td>" . $sql . "</td><td></td></tr>";

for($i=0;$i<count($iArray);$i++){
	
	/*echo "i==" . $i . "<br>";
	echo "iArray[$i][newComponent]==" . $iArray[$i]['newComponent'] . "<br>";
	echo "iCount==" . $iCount . "<br>";*/
	
	if($iArray[$i]['newComponent']==true){
		//echo "newComponent<br>";
		
		/*$condition=$iArray[$i]['phase'];
		$component=$iArray[$i]['component'];*/
		
		switch($iArray[$i]['phase']){
			
			case "shaping":
				$numIntervals=12;
			break;
			
			case "baseline":
				$numIntervals=18;
			break;
			
			case "contrast":
				$numIntervals=18;
			break;
			
		}
		
		if($iCount<=$numIntervals && $iCount!=1){
			for($a=$iCount;$a<=$numIntervals;$a++){
				echo "<tr>";
				echo "<td><strong>" . $a . "</strong></td>";
				echo "<td>0</td>";
				echo "<td>0</td>";
				echo "</tr>";
			}
		}
		
		$iCount=1;
		
		phaseBreak($iArray[$i]['phase'],$iArray[$i]['component']);
		
		
	} else {
		//echo "else<br>";
		
		if($iArray[$i]['endComponent']!=true){
			//echo "!endComponent";
			echo "<tr>";
			echo "<td><strong>" . $iCount . "</strong></td>";
			echo "<td>". $iArray[$i]['clicks'] . "</td>";
			echo "<td>" . $iArray[$i]['consumption'] . "</td>";
			echo "</tr>";
			$iCount++;
		}
		
	}
	
	if(interval>numIntervals){
		//echo "*****interval=="+interval;
	}
	
	//echo "*****";
	
	
	
	
	/*if($prevTest!=$iArray[$i]['test']){
		//echo "prevTest unequivalent<br>";
		$prevTest=$iArray[$i]['test'];
		testBreak($prevTest);
		$prevPhase="";
		$prevComponent="";
		$iCount=1;
	}
	
	if($prevPhase!=$iArray[$i]['phase'] || $prevComponent!=$iArray[$i]['component']){
		echo "prevPhase or prevComponent unequivalent<br>";
		echo "prevPhase " . $prevPhase . $iArray[$i]['phase'] . "<br>";
		echo "prevComponent " . $prevComponent . $iArray[$i]['component'] . "<br>";
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
	
	$iCount++;*/
}

if($iCount<=$numIntervals){
		
	for($i=$iCount;$i<=$numIntervals;$i++){
		echo "<tr>";
		echo "<td><strong>" . $i . "</strong></td>";
		echo "<td>0</td>";
		echo "<td>0</td>";
		echo "</tr>";
	}
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