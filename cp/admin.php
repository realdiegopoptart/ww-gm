<?php 
include 'includes/config.php'; 
include 'includes/header.php';
checkForLogin();

if(isset($_GET['id']))
{
	echo '<META HTTP-EQUIV="Refresh" Content="0; URL=../pages/index.php">';    
	exit;	
}

$sesuID = $_SESSION['uID'];

$query = $con->prepare("SELECT * from players where ID = '$sesuID'");
$query->execute();
$gData = $query->fetch();

?>



<?php
	include 'includes/footer.php'; 
?>