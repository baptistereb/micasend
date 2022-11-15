<?php
include "index.php";
// http://127.0.0.1/micasend/web/msg.php?message=lol&sender=test
if(isset($_GET['message']) AND !empty($_GET['message']) AND isset($_GET['sender']) AND !empty($_GET['sender']))
{
	$msg = htmlspecialchars($_GET['message']);
	$sender = htmlspecialchars($_GET['sender']);
	$certif = 0;

	if(isset($_GET['token']) AND !empty($_GET['token'])) {
		$token = htmlspecialchars($_GET['token']);
		$requser = $db->prepare("SELECT id, token FROM user WHERE pseudo = ?");
        $requser->execute(array($sender));
        $result = $requser->rowcount();
        if ($result == 1) { //l'utilisateur existe t-il ?
            $user = $requser->fetch();
            if($user[1] == $token) { //le token est-il bon ?
            	//utilisateur certifié
            	$certif=$user[0];
            }
        }
	}

	$reqins = $db->prepare("INSERT INTO msg(content, sender, id_certified_user, date_time) VALUES(?, ?, ?, ?)");
	$reqins->execute(array($msg, $sender, $certif, date("Y-m-d H:i:s", time())));
	header('Location: msg.php');
}

$req = $db->query("SELECT * FROM msg");
$result = $req->fetchAll(PDO::FETCH_ASSOC);

if(isset($_GET['getmsg']) AND !empty($_GET['getmsg'])) {
	$getmsg = htmlspecialchars($_GET['getmsg']);
	if($getmsg == "id") {
		for($i=0; $i<count($result); $i++) {
			echo $result[$i]["id"];
			if($i < (count($result)-1)) {
				echo " ";
			}
		}
	} elseif ($getmsg == "content") {
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
	} elseif ($getmsg == "id_certified_user") {
		for($i=0; $i<count($result); $i++) {
			echo $result[$i]["id_certified_user"];
			if($i < (count($result)-1)) {
				echo " ";
			}
		}
	} elseif ($getmsg == "json") {
		echo "[";
		for($i=0; $i<count($result); $i++) {
			echo '{"content":"'.$result[$i]["content"].'", "sender":"'.$result[$i]["sender"].'", "date_time":"'.$result[$i]["date_time"].'", "id_certified_user":"'.$result[$i]["id_certified_user"].'"}';
			if($i < (count($result)-1)) {
				echo ",";
			}
		}
		echo "]";
	} else {
		for($i=0; $i<count($result); $i++) {
			echo '{"'.$result[$i]["content"].'";"'.$result[$i]["sender"].'";"'.$result[$i]["date_time"].'";"'.$result[$i]["id_certified_user"].'"}<br>';
		}
	}
}

?>