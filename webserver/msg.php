<?php
include "index.php";
// http://127.0.0.1/micasend/web/msg.php?message=lol&sender=test
if(isset($_GET['message']) AND !empty($_GET['message']) AND isset($_GET['sender']) AND !empty($_GET['sender']))
{
	$msg = htmlspecialchars($_GET['message']);
	$sender = htmlspecialchars($_GET['sender']);
	$admin = 0;
	$reqins = $db->prepare("INSERT INTO msg(content, sender, admin, date_time) VALUES(?, ?, ?, ?)");
	$reqins->execute(array($msg, $sender, $admin, date("Y-m-d H:i:s", time())));
	header('Location: msg.php');
}

$req = $db->query("SELECT * FROM msg");
$result = $req->fetchAll(PDO::FETCH_ASSOC);

if(isset($_GET['getmsg']) AND !empty($_GET['getmsg'])) {
	$getmsg = htmlspecialchars($_GET['getmsg']);
	if($getmsg == "content") {
		for($i=0; $i<count($result); $i++) {
			echo $result[$i]["content"];
			if($i < (count($result)-1)) {
				echo " ";
			}
		}
	} elseif ($getmsg == "sender") {
		for($i=0; $i<count($result); $i++) {
			echo $result[$i]["sender"];
			if($i < (count($result)-1)) {
				echo " ";
			}
		}
	} elseif ($getmsg == "date_time") {
		for($i=0; $i<count($result); $i++) {
			echo str_replace(" ","§",$result[$i]["date_time"]);
			if($i < (count($result)-1)) {
				echo " ";
			}
		}
	} elseif ($getmsg == "json") {
		echo "[";
		for($i=0; $i<count($result); $i++) {
			echo '{"content":"'.$result[$i]["content"].'", "sender":"'.$result[$i]["sender"].'", "date_time":"'.$result[$i]["date_time"].'"}';
			if($i < (count($result)-1)) {
				echo ",";
			}
		}
		echo "]";
	} else {
		for($i=0; $i<count($result); $i++) {
			echo '{"'.$result[$i]["content"].'";"'.$result[$i]["sender"].'";"'.$result[$i]["date_time"].'"}<br>';
		}
	}
}

?>