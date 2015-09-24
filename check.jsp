<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="org.codepamoja.Aptitude" %>

<%
    //!Simple configuration
    Aptitude apt = new Aptitude();
    Connection c = apt.getConnection("192.168.0.9:5432/cp", "cp_user", "cp_invent");
    Statement sel = apt.Selector(c);
    String usr = request.getRemoteUser();

    try{

        ResultSet rs = sel.executeQuery("SELECT function_role FROM entitys WHERE user_name='"+usr+"' LIMIT 1");
        String function_role = "applicant";
        
        if( rs.next() ){

            function_role = rs.getString("function_role");
            System.out.println("The applicant role is " + function_role );
            
        }
        
        if(  function_role.equals("applicant") ){

            out.print("<script>window.location='index.jsp';</script>");

        }
        c.close();
        
        
    }catch(Exception e){
        
        e.printStackTrace();
        out.print("<script>window.location='index.jsp';</script>");
        System.out.println("fell into a trap while trying to authenticate user.\nUser was severely hurt in the process!");
        
    }
    
%>
<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8 no-js"> <![endif]-->
<!--[if IE 9]> <html lang="en" class="ie9 no-js"> <![endif]-->
<!--[if !IE]><!-->
<html lang="en">
<!--<![endif]-->
<!-- BEGIN HEAD -->
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
<link href="./assets/global/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>
<link href="./assets/global/plugins/simple-line-icons/simple-line-icons.min.css" rel="stylesheet" type="text/css"/>
<link href="./assets/global/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
<link href="./assets/global/plugins/bootstrap-switch/css/bootstrap-switch.min.css" rel="stylesheet" type="text/css"/>
<link rel="icon" href="./assets/images/logo.png">
<!-- END GLOBAL MANDATORY STYLES -->
<!-- BEGIN PAGE LEVEL STYLES -->

<!-- END PAGE LEVEL STYLES -->
<!-- BEGIN THEME STYLES -->
<link href="./assets/global/css/components-md.css" id="style_components" rel="stylesheet" type="text/css"/>
<link href="./assets/global/css/plugins-md.css" rel="stylesheet" type="text/css"/>
<link href="./assets/admin/layout/css/layout.css" rel="stylesheet" type="text/css"/>
<link id="style_color" href="./assets/admin/layout/css/themes/light2.css" rel="stylesheet" type="text/css"/>
<link href="./assets/admin/layout/css/custom.css" rel="stylesheet" type="text/css"/>
<!-- END THEME STYLES -->
<link rel="shortcut icon" href="favicon.ico"/>
<style>
    
    @media (min-width:700px){
       
    }
    @media (max-width:5000px){
        /*Class name*/{/*properties*/}
    }
    
    
    
    .editor{
        font-family: 'Courier New', Courier, 'Lucida Sans Typewriter', 'Lucida Typewriter', monospace;
        font-size: 16px;
        border: 0px;
        background-color: white;
        padding: 10px;
        min-height: 100% !important;
        height: 100% !important;
        display: inline-block;
        zoom: 1;
        *display: inline;
        background: url('./assets/images/bg.png') no-repeat !important;
        background-size: contain !important;
        background-position: center !important;
        color:blue !important;
        
        
    }
    .fill{
        min-height: 100% !important;
        height: 100% !important;
    }
    .pamoja{
        min-height: 320px !important;
    }
    .shadow{
        border: 1px solid;
        border-color: gainsboro;
        transition-duration: 0.5s;
        border-radius: 2%;
        text-shadow: 1px 1px yellow !important;
        opacity: 1 !important;
    }
    .shadow:hover{
         box-shadow: 1px 1px gainsboro;
         cursor: pointer;
         transition-duration: 0.5s;
         background-color: rgba(27, 163, 156, 0.8);
         text-shadow: 1px 1px black!important;
         color:orange;
         font-weight: bold;
         border-radius: 5%;
    }
    .shadow:hover font {
        font-size: 45px !important;
        color: white !important;
        text-shadow: 1px 1px black !important;
        cursor: pointer;
        transition-duration: 0.5s;
    }
    .tests{
        opacity: 0.7;
        text-shadow: 1px 1px 1px black;
        transition-duration: 1s;
    }
    .tests:hover{
        opacity:1;
        transition-duration: 1s;
    }
    .doTest{
        /* display: none !important; */
        opacity: 1;  
        transition-duration: 1s;
    }
    .doTest:hover{
        background-color: darkslategrey;
        color: white !important;
        transition-duration: 1s;
    }
    
    .pager{
       max-height:1200px !important; 
        overflow-y:auto;
    }
    .pager>portal {
      
    }
    ::-webkit-scrollbar { 
        display: none; 
    }
    @namespace url(http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul);

     scrollbar{
      -moz-appearance: none !important;
     }
                   
   .green{
   	background-color: #056937 !important;
   }
   
   .red{
   	background-color: #BE1723 !important;
   }
   
   .green-seagreen{
   	background-color: #056937 !important;
   }
   
   .orange{
   	background-color: #F39303 !important;
   	opacity: 0.7;
   }
   .black{
   	color: #000000 !important;
   	
   }
   .white{
   	color: #ffffff !important;
   	
   }

   
</style>

</head>
<!-- END HEAD -->
<!-- BEGIN BODY -->
<!-- DOC: Apply "page-header-fixed-mobile" and "page-footer-fixed-mobile" class to body element to force fixed header or footer in mobile devices -->
<!-- DOC: Apply "page-sidebar-closed" class to the body and "page-sidebar-menu-closed" class to the sidebar menu element to hide the sidebar by default -->
<!-- DOC: Apply "page-sidebar-hide" class to the body to make the sidebar completely hidden on toggle -->
<!-- DOC: Apply "page-sidebar-closed-hide-logo" class to the body element to make the logo hidden on sidebar toggle -->
<!-- DOC: Apply "page-sidebar-hide" class to body element to completely hide the sidebar on sidebar toggle -->
<!-- DOC: Apply "page-sidebar-fixed" class to have fixed sidebar -->
<!-- DOC: Apply "page-footer-fixed" class to the body element to have fixed footer -->
<!-- DOC: Apply "page-sidebar-reversed" class to put the sidebar on the right side -->
<!-- DOC: Apply "page-full-width" class to the body element to have full width page without the sidebar menu -->
<body class="page-md page-header-fixed page-quick-sidebar-over-content page-sidebar-closed page-sidebar-hide-logo ">

<!-- BEGIN HEADER -->
<div class="page-header md-shadow-z-1-i navbar navbar-fixed-top">
	<!-- BEGIN HEADER INNER -->
	<div class="page-header-inner">
		<!-- BEGIN LOGO -->
		<div class="page-logo">
			<a href="">
			<img src="./assets/images/logo.png" width="33px" alt="logo" class="logo-default"/>
			</a>
			<div class="menu-toggler sidebar-toggler hide">
				<!-- DOC: Remove the above "hide" to enable the sidebar toggler button on header -->
			</div>

		</div>

		<!-- END LOGO -->
		<!-- BEGIN RESPONSIVE MENU TOGGLER -->
		<a href="javascript:;" class="menu-toggler responsive-toggler" data-toggle="collapse" data-target=".navbar-collapse">
		</a>
		<!-- END RESPONSIVE MENU TOGGLER -->
		<!-- BEGIN TOP NAVIGATION MENU -->
		<div class="top-menu row">
		<div class="alert pull-left" style="display:none; " id="response">I AM A CLASSLESS RESPONSE</div>
			<ul class="nav navbar-nav ">



				<!-- BEGIN USER LOGIN DROPDOWN -->
				<!-- DOC: Apply "dropdown-dark" class after below "dropdown-extended" to change the dropdown styte -->
				<li class="dropdown dropdown-user">
					<a href="javascript:;" class="dropdown-toggle" data-toggle="dropdown" data-hover="dropdown" data-close-others="true">
					<img alt="" class="img-circle" src="./assets/images/favicon.jpeg"/>
					<span class="username username-hide-on-mobile">
					<%= request.getRemoteUser() %> </span>
					<i class="fa fa-angle-down"></i>
					</a>
					<ul class="dropdown-menu dropdown-menu-default">
					    <li>
							<a href="logout.jsp">
							<i class="icon-key"></i> Log Out </a>
						</li>
					</ul>
				</li>
				<!-- END USER LOGIN DROPDOWN -->
			</ul>
		</div>
		<!-- END TOP NAVIGATION MENU -->
	</div>
	<!-- END HEADER INNER -->
</div>
<!-- END HEADER -->
<div class="clearfix">
</div>
<!-- BEGIN CONTAINER -->
<div class="page-container">
	<!-- BEGIN SIDEBAR -->
	<div class="page-sidebar-wrapper">
		<!-- DOC: Set data-auto-scroll="false" to disable the sidebar from auto scrolling/focusing -->
		<!-- DOC: Change data-auto-speed="200" to adjust the sub menu slide up/down speed -->
		<div class="page-sidebar navbar-collapse collapse">
			<!-- BEGIN SIDEBAR MENU -->
			<!-- DOC: Apply "page-sidebar-menu-light" class right after "page-sidebar-menu" to enable light sidebar menu style(without borders) -->
			<!-- DOC: Apply "page-sidebar-menu-hover-submenu" class right after "page-sidebar-menu" to enable hoverable(hover vs accordion) sub menu mode -->
			<!-- DOC: Apply "page-sidebar-menu-closed" class right after "page-sidebar-menu" to collapse("page-sidebar-closed" class must be applied to the body element) the sidebar sub menu mode -->
			<!-- DOC: Set data-auto-scroll="false" to disable the sidebar from auto scrolling/focusing -->
			<!-- DOC: Set data-keep-expand="true" to keep the submenues expanded -->
			<!-- DOC: Set data-auto-speed="200" to adjust the sub menu slide up/down speed -->
			<ul class="page-sidebar-menu page-sidebar-menu-closed page-sidebar-menu-light" data-keep-expanded="false" data-auto-scroll="true" data-slide-speed="200">
				<!-- DOC: To remove the sidebar toggler from the sidebar you just need to completely remove the below "sidebar-toggler-wrapper" LI element "page-sidebar-menu-closed" -->
                 
				<li class="sidebar-toggler-wrapper">
					<!-- BEGIN SIDEBAR TOGGLER BUTTON -->
					<div class="sidebar-toggler">
					</div>
					<!-- END SIDEBAR TOGGLER BUTTON -->
				</li>
                   
                <li class="start ">
					<a href="javascript:window.close();">
                        <i class="fa fa-close"></i>
                        <span class="title">Leave</span>
                        <span class="arrow "></span>
					</a>
				</li>
                   
				
                   
			</ul>
           
                
                   
			<!-- END SIDEBAR MENU -->
		</div>
	</div>
	<!-- END SIDEBAR -->
	
	<!-- BEGIN CONTENT -->
	<div class="page-content-wrapper" >
	        	<div class="page-content" style="background: url('./assets/images/bg.png') no-repeat !important; background-size: contain !important; background-position: center !important; opacity: 1;">


			<!-- BEGIN PAGE HEADER-->
			<!--
                <h3 class="page-title">
                Codepamoja <small>| Aptitude Tests</small>
                </h3>
            -->

			<!-- END PAGE HEADER-->
			<!-- BEGIN PAGE CONTENT-->
			<div class="row">
				<div class="col-md-12" id="page_content">

                    <!-- CONTENT -->
                    <%
                    //fetch the test id and user_name
                    String test_id = request.getParameter("test_id");
                    String uid = request.getParameter("user_name");
                   
                    //Ensure that the test_id and user_name has been provided
                    if( test_id != null && uid != null ){

                        
                        Connection conn = apt.getConnection("192.168.0.9:5432/cp", "cp_user", "cp_invent");
                        Statement selector =apt.Selector(conn);
         
                        
                        //Fetch all the test data
                        ResultSet aptitude_test = selector.executeQuery("SELECT aptitude_test_name ,pass_mark,test_objectives FROM aptitude_tests WHERE display='TRUE' AND aptitude_test_id='"+ test_id +"' LIMIT 1");

                        //ensure that such a test exists
                        if( aptitude_test.next() ){

                            //!Create a user test folder
                            ServletContext context = request.getServletContext();
                            String testPath = context.getRealPath("")+ "/feedback/"+uid+"/"+test_id;
                            File testFolder = new File( testPath );

                            //!Set up the project setup/review uri
                           // String uri = "http://" + request.getLocalAddr() + ":7380/aptitude/feedback/" + uid + "/" + test_id + "/index.jsp";

                            //!Initialize the data storage strings
                            String test_title   = "";
                            String pass_mark    = "";
                            String test_objectives = "";

                            //!Capture the sample startup content from the database
                            test_title      = ( aptitude_test.getString("aptitude_test_name") != null ) ? apt.tjs(aptitude_test.getString("aptitude_test_name")) : "";
                            pass_mark       = ( aptitude_test.getString("pass_mark") != null ) ? apt.tjs(aptitude_test.getString("pass_mark")) : "";
                            
                            test_objectives = ( aptitude_test.getString("test_objectives") );
                            
                             ResultSet graderData = selector.executeQuery("SELECT entity_id  FROM entitys WHERE user_name='"+ request.getRemoteUser() +"' LIMIT 1");
                            
                             int graded_by = 0;
                            
                            if( graderData.next() ){
                                
                               graded_by = graderData.getInt("entity_id");
                                
                            }

                            //Ensure that the folder exists 
                            if( !testFolder.exists() ){

                                 conn.close();
                               //!Let the reviewer know that the user directory is no longer available
                                %>
                                    <br><br>
                                    <div class="green white portlet col-lg-12" style="font-weight:bold; text-shadow: 1px 1px 1px black; text-align:center;"> <h1><font color="white" style="text-shadow:1px 1px 1px red;"><%= uid %>'s </font> TEST IS NOT ON THIS SERVER.</h1> </div>
                                    <br>
                                   
                                                                        
                               <%


                               
                            //EO - ensure folder exists
                            }else{ 

                           //!close the database connection
                           conn.close();

                           //!Serve the HTML LAYOUT TO THE USER.
                            %>
            <script>
                          
                var sanitize = function( mytext ){
                       return mytext.replace(/(\r\n|\n|\r)/gm,"");      
                }                                
                var data        = {};
                data.test_id    = sanitize("<%= test_id %>");
                data.user_name  = sanitize("<%= uid %>");
                data.test_title = sanitize("<%= test_title %>");
                data.pass_mark  = sanitize("<%= pass_mark %>");
                data.graded_by  = sanitize("<%= graded_by %>");
                    
                localStorage.setItem("grading", JSON.stringify( data ));
            </script>
        
            <!-- BEGIN SAMPLE PORTLET CONFIGURATION MODAL FORM-->
            <div class="modal fade" id="instructions" tabindex="-1" role="dialog" aria-labelledby="CodePamoja_view_instructions" aria-hidden="true" style="min-width: 90% !important;">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
                            <h4 class="modal-title"><i class="fa fa-info-circle fa-2x"></i> &nbsp; CodePamoja Aptitude Tests |  Instructions </h4>
                        </div>
                        <div class="modal-body" style="min-height:450px !important; overflow:none; " id="instructionsBody">
                           <%= test_objectives %>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn green" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                    <!-- /.modal-content -->
                </div>
                <!-- /.modal-dialog -->
            </div>
            <!-- /.modal -->
            <!-- END SAMPLE PORTLET CONFIGURATION MODAL FORM-->
                
            <!-- BEGIN SAMPLE PORTLET CONFIGURATION MODAL FORM-->
            <div class="modal fade" id="codeExec" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="min-width: 90% !important;">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
                            <h4 class="modal-title"><i class="fa fa-laptop fa-2x"></i> &nbsp; <%= uid %> |  <%= test_title %> > Live Preview </h4>
                        </div>
                        <div class="modal-body" style="min-height:450px; !important;">
                            <iframe src="#" id="iframe" style="width:100%; min-height:450px;" scrolling="false" frameborder="0" ></iframe>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn green" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                    <!-- /.modal-content -->
                </div>
                <!-- /.modal-dialog -->
            </div>
            <!-- /.modal -->
            <!-- END SAMPLE PORTLET CONFIGURATION MODAL FORM-->

            <!-- Begin: life time stats -->
            <div class="portlet light">
                <div class="portlet-title ">
                    <div class="caption">
                        <i class="fa fa-graduation-cap"></i>Assessing <%= uid %> <span class="hidden-480">
                        |  <%= test_title %> </span>
                    </div>
                    <div class="actions row">
                        <a href="#" onclick="gradePane();" id="grade" class="btn red white ">
                            <i class="fa fa-check " ></i>
                            <span class="hidden-480">
                            GRADE</span>
                        </a>
                        
                        <a href="#" onclick="run();" id="run" class="btn green yellow-stripe" data-toggle="modal" data-target="#codeExec">
                            <i class="fa fa-play"></i>
                            <span class="hidden-480">
                            RUN</span>
                        </a>
                
                        <a href="#" onclick="javascript:window.close();" id="cls" class="btn red white ">
                            <i class="fa fa-times" ></i>
                            <span class="hidden-480">
                            DONE</span>
                        </a>
                       
                    </div>
                </div>

            </div>
            <!-- End: life time stats -->
            <GradePanel class="col-lg-12"></GradePanel>
            <!-- PRIMITIVE CODE EDITOR -->
             <div class="portlet-body">
                <div class="tabbable">
                    <ul class="nav nav-tabs nav-tabs-lg">
                        <li class="active">
                            <a href="#tab_1"  data-toggle="tab">
                            JSP </a>
                        </li>
                        <li>
                            <a href="#tab_2" data-toggle="tab">
                            JavaScript </a>
                        </li>
                        <li>
                            <a href="#tab_4" data-toggle="tab">
                            CSS </a>
                        </li>
                        <li>
                            <a href="#tab_3" data-toggle="tab">
                            DB Table </a>
                        </li>
                    </ul>
                    <div class="tab-content">
                        <div class="tab-pane active" id="tab_1">

                            <!-- Editable content -->
                            <div class="row">
                                <div class="col-md-12 col-sm-12 pamoja">
                                    <div class="portlet green-seagreen box">
                                        <div class="portlet-title green">
                                            <div class="caption">
                                                <i class="fa fa-server"></i> index.jsp
                                            </div>
                                            <div class="actions">
                                               <a href="javascript:;" data-toggle="modal" onclick="showInstructions()"; data-target="#instructions" class="btn btn-default btn-sm" title="instructions">
                                                    <i class="fa fa-question-circle help"></i>
                                                </a>
                                                <a href="javascript:;" class="btn btn-default btn-sm fullscreen">
                                                <i class="fa fa-external-link"></i></a>                                    
                                            </div>
                                        </div>
                                        <div class="portlet-body fill">
                                            <div class="table-responsive fill">
                                                <textarea class="editor" data-editor-lang="jsp" rows="13"  id="jsp" style="width:100%;  " placeholder="JSP CODE GOES HERE" ></textarea>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- eo editable content -->

                            
                            
                            

                        </div>
                        <div class="tab-pane" id="tab_2">
                            <div class="table-container">

                            <!-- Editable content -->
                            <div class="row">
                                <div class="col-md-12 col-sm-12 pamoja">
                                    <div class="portlet green-seagreen box">
                                        <div class="portlet-title green">
                                            <div class="caption">
                                                <i class="fa fa-code"></i> app.js
                                            </div>
                                            <div class="actions">
                                               <a href="javascript:;" data-toggle="modal" data-target="#instructions" class="btn btn-default btn-sm" title="instructions">
                                                    <i class="fa fa-question-circle help"></i>
                                                </a>
                                                <a href="javascript:;" class="btn btn-default btn-sm fullscreen">
                                                <i class="fa fa-external-link"></i></a>                                    
                                            </div>
                                        </div>
                                        <div class="portlet-body fill">
                                            <div class="table-responsive fill">
                                                <textarea class="editor" data-editor-lang="js" rows="13" id="js" style="width:100%;" placeholder="JavaScript CODE GOES HERE"></textarea>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- eo editable content -->

                            <!-- Comments go here 
                            <div class="row">

                                <div class="col-md-6">
                                </div>
                                <div class="col-md-6">
                                    <div class="well">
                                        COMMENTS GO HERE
                                    </div>
                                </div>
                            </div>
                            comments end here -->

                            </div>
                        </div>
                        <div class="tab-pane" id="tab_3">

                            <!-- Editable content -->
                            <div class="row">
                                <div class="col-md-12 col-sm-12 pamoja" >
                                    <div class="portlet green-seagreen box">
                                        <div class="portlet-title green">
                                            <div class="caption">
                                                <i class="fa fa-database"></i> db.sql
                                            </div>
                                            <div class="actions">
                                               <a href="javascript:;" data-toggle="modal" data-target="#instructions" class="btn btn-default btn-sm" title="instructions">
                                                    <i class="fa fa-question-circle help"></i>
                                                </a>
                                                <a href="javascript:;" class="btn btn-default btn-sm fullscreen">
                                                <i class="fa fa-external-link"></i></a>                                    
                                            </div>
                                        </div>
                                        <div class="portlet-body fill">
                                            <div class="table-responsive fill">
                                                <textarea class="editor" data-editor-lang="sql" rows="13" id="db" style="width:100%;" placeholder="Table SQL CODE GOES HERE"></textarea>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- eo editable content -->

                            <!-- Comments go here 
                            <div class="row">

                                <div class="col-md-6">
                                </div>
                                <div class="col-md-6">
                                    <div class="well">
                                        COMMENTS GO HERE
                                    </div>
                                </div>
                            </div>
                            comments end here -->

                        </div>

                        <div class="tab-pane" id="tab_4">

                            <!-- Editable content -->
                            <div class="row">
                                <div class="col-md-12 col-sm-12 pamoja">
                                    <div class="portlet green-seagreen box">
                                        <div class="portlet-title green">
                                            <div class="caption">
                                                <i class="fa fa-css3"></i> style.css
                                            </div>
                                             <div class="actions">
                                               <a href="javascript:;" data-toggle="modal" data-target="#instructions" class="btn btn-default btn-sm" title="instructions">
                                                    <i class="fa fa-question-circle help"></i>
                                                </a>
                                                <a href="javascript:;" class="btn btn-default btn-sm fullscreen">
                                                <i class="fa fa-external-link"></i></a>                                    
                                            </div>
                                        </div>
                                        <div class="portlet-body fill">
                                            <div class="table-responsive fill">
                                                <textarea class="editor" data-editor-lang="css" rows="13"  id="css" style="width:100%; " placeholder="CSS CODE GOES HERE" ></textarea>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- eo editable content -->

                            <!-- Comments go here 
                            <div class="row">

                                <div class="col-md-6">
                                </div>
                                <div class="col-md-6">
                                    <div class="well">
                                        COMMENTS GO HERE
                                    </div>
                                </div>
                            </div>
                            comments end here -->

                        </div>

                    </div>
                </div>
            </div>
            <!-- EO VERY PRIMITIVE CODE EDITOR -->
                <%
                
                            }
                        }
                    }else{
                        
                        %>
                            
                        <script>
                            console.log("\n\nFailed to capture the applicant\'s username and test id which are required to load tehe code for review!\n\n");
                        </script>
                        
                        <%
                    }
                
                %>
                
                    <!-- EO CONTENT -->

				</div>
			</div>
			<!-- END PAGE CONTENT-->
		</div>
	</div>
	<!-- END CONTENT -->
</div>
<!-- END CONTAINER -->
<!-- BEGIN FOOTER -->
<div class="page-footer">
	<div class="page-footer-inner">
		 2015 &copy; <a href="http://codepamoja.com" title="Codepamoja" target="_blank"> Codepamoja </a>
	</div>
	<div class="scroll-to-top">
		<i class="icon-arrow-up"></i>
	</div>
</div>
<!-- END FOOTER -->
<!-- BEGIN JAVASCRIPTS(Load javascripts at bottom, this will reduce page load time) -->
<!-- BEGIN CORE PLUGINS -->
<!--[if lt IE 9]>
<script src="./assets/global/plugins/respond.min.js"></script>
<script src="./assets/global/plugins/excanvas.min.js"></script>
<![endif]-->
<script src="./assets/global/plugins/jquery.min.js" type="text/javascript"></script>
<script src="./assets/global/plugins/jquery-migrate.min.js" type="text/javascript"></script>
<!-- IMPORTANT! Load jquery-ui.min.js before bootstrap.min.js to fix bootstrap tooltip conflict with jquery ui tooltip -->
<script src="./assets/global/plugins/jquery-ui/jquery-ui.min.js" type="text/javascript"></script>
<script src="./assets/global/plugins/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<script src="./assets/global/plugins/bootstrap-hover-dropdown/bootstrap-hover-dropdown.min.js" type="text/javascript"></script>
<!-- END CORE PLUGINS -->

<!-- BEGIN PAGE LEVEL SCRIPTS -->
<script src="./assets/global/scripts/metronic.js" type="text/javascript"></script>
<script src="./assets/admin/layout/scripts/layout.js" type="text/javascript"></script>
<!-- END PAGE LEVEL SCRIPTS -->
    <!-- Cut out JS GOES HERE -->
    <script>
    //HANDLER TO EXECUTE THE WRITTEN CODE
                     
    jQuery(document).ready(function() {

        /*
            Initialize core page components
        */
        Metronic.init();
        Layout.init();


        /*
            CREATE ACCESS VARIABLES FOR THE VARIOUS CODE WRITING COMPONENTS
        */
        //"jsp" component
        var jsp = $("#jsp");
        var jspc = '';

        //"js" component
        var js = $("#js");
        var jsc = '';

        //"css" component
        var css = $("#css");
        var cssc = '';

        //"db" component
        var db = $("#db");
        var dbc = '';

        /* FETCH THE USER's SAVED FILES */

        //Java Server Pages
        $.ajax({
            url : "feedback/<%= uid %>/<%= test_id %>/index.codepamoja",
            data: {},
            method: "POST",
            converters: {
                "text script" : function(text){
                    return text;
                }
            },
            success: function(result){

                if( result != "" ){
                    jsp.val(result);
                }else if( jsp.val() == "" ){
                   jsp.val("##THE APPLICANT LEFT THIS TAB BLANK")
                }           

            }
        });


        //JavaScript
        $.ajax({
            url : "feedback/<%= uid %>/<%= test_id %>/app.codepamoja",
            data: {},
            method: "POST",
            converters: {
                "text script" : function(text){
                    return text;
                }
            },
            success: function(result){

                if( result != "" ){
                    js.val( result );
                }else if( js.val() == "" ){
                   js.val("##THE APPLICANT LEFT THIS TAB BLANK")
                }

            }
        });

        //CSS
        $.ajax({
            url : "feedback/<%= uid %>/<%= test_id %>/style.css",
            data: {},
            method: "POST",
            converters: {
                "text script" : function(text){
                    return text;
                }
            },
            success: function(result){

                if( result != "" ){
                    css.val( result );
                }else if( css.val() == ""){
                   css.val("##THE APPLICANT LEFT THIS TAB BLANK")
                }                
            },
            error: function(){
                css.val("##THE APPLICANT LEFT THIS TAB BLANK")
            }
        });


        //Structured Query Language
        $.ajax({
            url : "feedback/<%= uid %>/<%= test_id %>/db.sql",
            data: {},
            method: "POST",
            converters: {
                "text script" : function(text){
                    return text;
                }
            },
            success: function(result){

                if( result != "" ){
                   db.val(result);
                }else if( db.val() == "" ){
                   db.val("##THE APPLICANT LEFT THIS TAB BLANK")
                }

            }
        });

        
    });
    
                       
    //!SHOW THE TEST INSTRUCTIONS
    var showInstructions = function(){
          
       // $("#instructionsBody").html( JSON.parse( localStorage.getItem("grading") ).test_objectives );
        
    };
    
    //Timeout Clearer
    var clearTimeouts = function()
    {
        var id = window.setTimeout(null,0);
        while (id--)
        {
            window.clearTimeout(id);
        }
    }

    //Class setter
    var classify = function( resp, obj ){

        if( resp === "SUCCESS" ){
            obj.removeClass("alert-danger");
            obj.addClass("alert-success");
        }else{
            obj.removeClass("alert-success");
            obj.addClass("alert-danger");
        }

    };

                   
     //!Allow the administrator to grade the applicants              
    var gradePane = function(){
      
        var gradepanel = '<div class=" col-lg-12 "><div class="portlet light"><font style="font-weight:bold;" >CodePamoja Aptitude Tests | Grade Panel</font><div class="pull-right red white" style="padding: 7px; font-weight:bold; cursor:pointer;  border-radius:20%;" id="x">X</div><hr><div class="portlet" light><div class="row" style="padding:10px;"><div class="col-lg-4" style="text-align:right;"><b>Grade</b></div><div class="col-lg-8"><input type="text" id="graded" class="btn col-lg-7" style="min-height:30px; background-color: transparent !important; text-align:left;" placeholder="Applicant\'s Grade"></div></div><div class="row" style="padding:10px;"><div class="col-lg-4" style="text-align:right;"><b>Comment</b></div><div class="col-lg-8"><textarea type="text" class=" col-lg-7" style="min-height:70px; text-align:left; background-color: transparent !important; text-transform: none !important;" cols="50" rows="4" id="review_comment" placeholder="Comment on the applicant\'s code goes here"></textarea></div><div class="col-lg-12"><button class="btn green white pull-right" id="addGrade">SUBMIT GRADE</button></div></div></div> </div></div>';
        
        $(function(){
            
            
            $("GradePanel").hide(100).html(gradepanel).fadeIn(2000);
            grade.focus();
            $("#x").on("click", function(){
                $("GradePanel").fadeOut("fast");
            });
            
            $("#addGrade").on("click", function(){
                
                var grade = $("#graded");
                
                //console.log("Grading started!" + grade.val() );
                
                if( grade.val().length != 0 && !isNaN( grade.val() ) ){
                
                    var grading = JSON.parse(localStorage.getItem("grading"));

                    //console.log("Captured data for grading.");
                    
                    $.ajax({
                        url: "tests_process.jsp",
                        data: { 
                                act: "addGrade", 
                                uid: "root",
                                grade: grade.val(), 
                                graded_by: grading.graded_by,
                                review_comment: $("#review_comment").val(),
                                user_name: grading.user_name,
                                test_id: grading.test_id
                            },
                        method: "POST",
                        success: function( resp ){
                            
                           
                           var r =  $("#response");
                           clearTimeouts();
                           classify( resp.response, r );
                           r.html( resp.data.message ).fadeIn("fast");
                           setTimeout(function(){ r.fadeOut("fast") },7000);
                            
                            console.log( "\nGrading Done!" );
                            console.log( resp );
                            $("GradePanel").html("");
                        }
                    });
                
                }else{
                    
                    console.log( "There was an error trying to assess the grade " + grade.val() );
                    
                }
                
            });
            
        })
        
    };
                   
   var run = function( ){
       
       var iframe = document.getElementById("iframe");
       iframe.src = "http://" + document.location.host + "/aptitude/feedback/<%=uid%>/<%=test_id%>/index.jsp";
       
   };
         
               
   
    //INITIALIZE THE PAGE LAYOUT
    (function(){
       // reinit();
    })();
    </script>
<!-- END JAVASCRIPTS -->
</body>
<!-- END BODY -->
</html>