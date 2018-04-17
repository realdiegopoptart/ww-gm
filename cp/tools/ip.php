<?php 
include '../includes/config.php'; 
checkForLogin();

if(isset($_GET['id']))
{
	echo '<META HTTP-EQUIV="Refresh" Content="0; URL=../index.php">';    
	exit;	
}

if($_SESSION['playeradmin'] < 1) {
	echo '<META HTTP-EQUIV="Refresh" Content="0; URL=../index.php">';    
	exit;
}

$sesuID = $_SESSION['uID'];

$query = $con->prepare("SELECT * from players where ID = '$sesuID'");
$query->execute();
$gData = $query->fetch();

$ipquery = $con->prepare("SELECT `IP` FROM `players` WHERE `USERNAME` = ?");
$ipquery->execute(array($_POST['ipname']));
$result = $ipquery->fetch();

echo $result['IP'];



?>