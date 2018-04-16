<?php 
include 'includes/config.php'; 
include 'includes/header.php';
checkForLogin();

if(isset($_GET['id']))
{
	echo '<META HTTP-EQUIV="Refresh" Content="0; URL=../pages/index.php">';    
	exit;	
}

if($_SESSION['playeradmin'] < 1) {
	echo '<META HTTP-EQUIV="Refresh" Content="0; URL=index.php">';    
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
                            Admin Area
                        </h1>
                    </div>
                </div>
				
		<div class="panel panel-default">
            <div class="panel-heading">
			<?php echo $_SESSION['playername']; if($gData['ADMIN'] != 0) echo(" - Administrator");?>
            </div>
            <div class="panel-body">
				<p> Admin tools:</p>
				<div class="col-lg-8">
                    <div class="panel panel-default">
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-lg-6">
								<p>Player Ban:</p>
								<form action="tools/ban.php" method="POST">
                                        <div class="form-group">
                                            <label>Username</label>
                                            <input type="text" id="banname" name="banname" class="form-control" placeholder="Username">
                                        </div>
										<?php if(isset($err)): ?>
										<b class="help-block" style="color: red;"><?=$err?></b>
										<?php endif; ?>
										
										<button type="submit" class="btn btn-default">Ban</button>
										<p>Note: Player must be offline to be banned via cp.</p>
								</form>
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