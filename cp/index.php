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
                <div class="row">
                    <div class="col-md-12">
                        <h1 class="page-header">
                            Player Area
                        </h1>
                    </div>
                </div>
				
				<div class="row">
                    <div class="col-md-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <?php echo $_SESSION['playername']; if($gData['ADMIN'] != 0) echo(" - Administrator");
								else echo " - Player"; ?>
                        </div>
                        <div class="panel-body">
							<p> Player Statistics:</p>
							                <div class="col-lg-8">
                    <div class="panel panel-default">
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-lg-6">
								Kills: <?php echo number_format($gData['KILLS']); ?>
								<hr />
								Deaths: <?php echo number_format($gData['DEATHS']); ?>
								<hr />
								K/D: 
								<?php 
								if($gData['KILLS'] == 0) {
									if($gData['DEATHS'] == 0)
									{
										echo "No Data"; 
									}
									else {
									echo bcdiv($gData['KILLS'], $gData['DEATHS'], 2); 
									}
								} else {
									echo bcdiv($gData['KILLS'], $gData['DEATHS'], 2);
								}
								
								?>
								
								<hr />
								Last Logged IP: <?php if($gData['IP'] != 0) echo $gData['IP']; 
								else echo "None"; ?>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="panel-footer">
        <?php
		include 'includes/footer.php'; 
		?>
        </div>
  </div>					