<head>
<meta charset="utf-8"/>
<title>Codepamoja | Aptitude Tests</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<meta http-equiv="Content-type" content="text/html; charset=utf-8">
<meta content="CodePamoja Aptitude Tests" name="description"/>
<meta content="Bixbyte" name="author"/>
<!-- BEGIN GLOBAL MANDATORY STYLES -->
<link href="http://fonts.googleapis.com/css?family=Open+Sans:400,300,600,700&subset=all" rel="stylesheet" type="text/css"/>
<link href="../assets/global/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>
<link href="../assets/global/plugins/simple-line-icons/simple-line-icons.min.css" rel="stylesheet" type="text/css"/>
<link href="../assets/global/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
<link href="../assets/global/plugins/bootstrap-switch/css/bootstrap-switch.min.css" rel="stylesheet" type="text/css"/>
<link rel="icon" href="./assets/images/logo.png">
<!-- END GLOBAL MANDATORY STYLES -->
<!-- BEGIN PAGE LEVEL STYLES -->

<!-- END PAGE LEVEL STYLES -->
<!-- BEGIN THEME STYLES -->
<link href="../assets/global/css/components-md.css" id="style_components" rel="stylesheet" type="text/css"/>
<link href="../assets/global/css/plugins-md.css" rel="stylesheet" type="text/css"/>
<link href="../assets/admin/layout/css/layout.css" rel="stylesheet" type="text/css"/>
<link id="style_color" href="../assets/admin/layout/css/themes/light2.css" rel="stylesheet" type="text/css"/>
<link href="../assets/admin/layout/css/custom.css" rel="stylesheet" type="text/css"/>
<!-- END THEME STYLES -->
<link rel="shortcut icon" href="favicon.ico"/>
<style>
    textarea{
        font-family: 'Courier New', Courier, 'Lucida Sans Typewriter', 'Lucida Typewriter', monospace;
        font-size: 16px;
        background-color: white;
        border:0px;
        border-left: 1px solid gray;
        color:darkblue;
        padding: 10px;
        min-height: 90% !important;
        height: 98% !important;
    }
    .fill{
        min-height: 100% !important;
        height: 100% !important;
    }
    .pamoja{
        min-height: 400px !important;
    }

</style>

<%@page import="java.util.Date" %>
<body>
<div class = "portlet Light">
  	<div class ="row">
  		<div class="col-lg-12 center">
  		<div class="pull-left">
  			<img src="../assets/images/logo.png" width="50px" alt="logo" class="logo-default"/>
  		</div>
  	<H1><font color="green">SIMPLE </font><font color="red">CALCULATOR</font></H1>
  	</div>
	</div>
	
	<div class="col-lg-12">
		<div class="pull-right">
		<%
 	try{
 		Date x = new java.util.Date();
 	
 		String name;
 	
 			if(x.getHours() > 3 && x.getHours() < 12){
   	%>
 		Good Morning <font color="green"><%=request.getRemoteUser()%></font>  
 	
 	<% }
 
 			else if(x.getHours() > 12 && x.getHours() < 18){
 	%>
 	  	Good Afternoon <font color="green"><%=request.getRemoteUser()%></font>  
	<%  }  

			else if(x.getHours() > 18 || x.getHours() < 3){
 	%>
 	  	Good Evening <font color="green"><%=request.getRemoteUser()%></font> 
	<%  }

}
finally {
   
}
 %>
		</div>
	</div>
  	
   	
 
  
  <hr>
  <div class="col-lg-12 ">
  	<div class="col-lg-6 col-lg-offset-3 portlet colorb" >
  		<div class="col-lg-12 center" style="padding-top:7px;">
  			<b><center>Select an Operator</center></b><br>
  		</div>
  		
  		<div class="col-lg-12 center">
  			<div class="col-lg-12 "  >
  			<center>
  				<input type="radio" id="r1" name="r1" value="add" checked>Addition</input> &nbsp;&nbsp;
  				<input type="radio" id="r2" name="r1" value="mul">Multiplication</input>&nbsp;&nbsp;
  				<input type="radio" id="r3" name="r1" value="div">Division</input>
            </center>
            </div> 
        <br>		
  		
  		</div>
  	</div>
  </div>

 
  
  	<div class="portlet light">
  	<center>
  	Value1 <input type="number" id="v1" name="v1" value="" required><br>
  	Value2 <input type="number" id="v2" name="v2" value="" required><br>
  	Result&nbsp; <input type="number" id="res" name="res" value=''><br>
  	</center>
	</div>
</div>
</body>
<!-- END FOOTER -->
<!-- BEGIN JAVASCRIPTS(Load javascripts at bottom, this will reduce page load time) -->
<!-- BEGIN CORE PLUGINS -->
<!--[if lt IE 9]>
<script src="../assets/global/plugins/respond.min.js"></script>
<script src="../assets/global/plugins/excanvas.min.js"></script>
<![endif]-->
<script src="../assets/global/plugins/jquery.min.js" type="text/javascript"></script>
<script src="../assets/global/plugins/jquery-migrate.min.js" type="text/javascript"></script>
<script src="calc.js"></script>
<!-- IMPORTANT! Load jquery-ui.min.js before bootstrap.min.js to fix bootstrap tooltip conflict with jquery ui tooltip -->
<script src="../assets/global/plugins/jquery-ui/jquery-ui.min.js" type="text/javascript"></script>
<script src="../assets/global/plugins/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<script src="../assets/global/plugins/bootstrap-hover-dropdown/bootstrap-hover-dropdown.min.js" type="text/javascript"></script>
<!-- END CORE PLUGINS -->

<!-- BEGIN PAGE LEVEL SCRIPTS -->
<script src="../assets/global/scripts/metronic.js" type="text/javascript"></script>
<script src="../assets/admin/layout/scripts/layout.js" type="text/javascript"></script>

<!-- END PAGE LEVEL SCRIPTS -->
    <!-- Cut out JS GOES HERE -->
<!-- END JAVASCRIPTS -->
</html>
