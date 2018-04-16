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

$banquery = $con->prepare("UPDATE `players` SET `BANNED` = '1' WHERE `USERNAME` = ?");
$banquery->execute(array($_POST['banname']));

?>

<p>Ban Successful</p>

<?php
	echo '<META HTTP-EQUIV="Refresh" Content="0; URL=../admin.php">';    
	exit;
?>