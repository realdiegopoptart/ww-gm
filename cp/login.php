<?php 
include 'includes/config.php';

if(isset($_SESSION['USERNAME']))
{
	echo '<META HTTP-EQUIV="Refresh" Content="0; URL=index.php">';   
	exit;
}

if(isset($_POST['pname']) && isset($_POST['ppass']))
{
	if(!isset($_SESSION['playername']))
	{
		$query = $con->prepare("SELECT `ADMIN`, `USERNAME`, `ID` from `players` where `USERNAME` = ? and `PASSWORD` = ?");
		$query->execute(array($_POST['pname'], strtoupper(hash("whirlpool", $_POST['ppass']))));
		if($query->rowCount() > 0)
		{
			$data = $query->fetch();
			
			$_SESSION['playername'] = $data['USERNAME'];
			$_SESSION['playeradmin'] = $data['ADMIN'];
			$_SESSION['uID'] = $data['ID'];
			
			echo '<META HTTP-EQUIV="Refresh" Content="0; URL=index.php">';   
			exit;
		}
		else
		{
			$err = 'Wrong username or password';
		}
	}
}
 
include 'includes/header.php';
?>
   <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Login with your in-game credentials!
                        </div>
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-lg-6">
                                    
									<form action="login.php" method="POST">
                                        <div class="form-group">
                                            <label>Username</label>
                                            <input type="text" id="pname" name="pname" class="form-control" placeholder="Username">
                                        </div>
										<div class="form-group">
                                            <label>Password</label>
                                            <input type="password" id="ppass" name="ppass" class="form-control" placeholder="Password">
                                        </div>
										<?php if(isset($err)): ?>
										<b class="help-block" style="color: red;"><?=$err?></b>
										<?php endif; ?>
										
										<button type="submit" class="btn btn-default">Login</button>
									</form>
										
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
