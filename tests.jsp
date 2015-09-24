<%@ page language="java" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONException" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.codepamoja.*" %>
<%
  
  /*
      Capture the required parameters
  */
  String uid = request.getRemoteUser();
  String act = request.getParameter("act");
  Aptitude apt = new Aptitude();
  Connection connn = apt.getConnection( "192.168.0.9:5432/cp", "cp_user", "cp_invent" );
  Statement selector = apt.Selector( connn );
  
  if(act != null && uid != null ){
   
   /* Establish A Database Connection  */
    //Class.forName("org.postgresql.Driver").newInstance();
    Connection conn = DriverManager.getConnection("jdbc:postgresql://192.168.0.9:5432/cp", "cp_user", "cp_invent");
    //Statement selector = conn.createStatement();
         
    //!FETCH THE MENU GENERATOR ITEMS
    if( act.equals("getMenu") ){
    
       //!Set the content type to JSON
       response.setContentType("application/json"); 
       
        ResultSet aptitude_tests = selector.executeQuery("SELECT aptitude_test_name, aptitude_test_id, pass_mark FROM aptitude_tests WHERE display='TRUE' ORDER BY aptitude_test_name");
        
              
                        
        //PREPARE THE JSON RESPONSE OBJECTS
        JSONArray  mess = new JSONArray();
        JSONArray  comm = new JSONArray();
        JSONObject data;
        int i = 0;
        
        if( aptitude_tests.next() ){

            try{
                data = new JSONObject();
                data.put( "test_title", aptitude_tests.getString("aptitude_test_name") );
                data.put( "test_id",    aptitude_tests.getString("aptitude_test_id") );
                data.put( "pass_mark",  aptitude_tests.getString("pass_mark") );
                mess.put(i, data);
            }catch(JSONException e){
                e.printStackTrace();
            }
            i++;    

            while( aptitude_tests.next() ){

                try{
                    data = new JSONObject();
                    data.put( "test_title", aptitude_tests.getString("aptitude_test_name") );
                    data.put( "test_id",    aptitude_tests.getString("aptitude_test_id") );
                    data.put( "pass_mark",  aptitude_tests.getString("pass_mark") );
                    mess.put(i, data);
                }catch(JSONException e){
                    e.printStackTrace();
                }
                i++;   

            }
                      
            ResultSet ongoing_tests = selector.executeQuery("SELECT aptitude_ongoing.aptitude_test_id FROM aptitude_ongoing WHERE aptitude_ongoing.user_id='"+uid+"' "); 
            
            i = 0;
            
            //!FETCH THE USER'S ONGOING TESTS
            if( ongoing_tests.next() ){
               
                try{
                    
                    data = new JSONObject();
                    data.put( "test_id", ongoing_tests.getString("aptitude_test_id") );
                    data.put( "test_grade", "ng");
                    comm.put(i, data);
                    
                }catch(JSONException e){
                    
                    e.printStackTrace();
                    
                }
                i++; 
                
                while( ongoing_tests.next() ){
                    
                    
                   try{
                       
                        data = new JSONObject();
                        data.put( "test_id", ongoing_tests.getString("aptitude_test_id") );
                        data.put( "test_grade", "ng");
                        comm.put(i, data);
                       
                    }catch(JSONException e){
                        e.printStackTrace();
                    }
                    i++; 
                    
                }
            
            //EO - FETCH USER'S ONGOING TESTS
            //!USER HAS NO ONGOING TESTS
            }         
            
            ResultSet graded_tests = selector.executeQuery("SELECT aptitude_grades.aptitude_test_id, aptitude_grades.grade FROM aptitude_grades INNER JOIN entitys ON entitys.entity_id = aptitude_grades.user_id AND entitys.user_name = '"+ uid+"' ");
            
            //!FETCH THE USER'S COMPLETED TESTS
            if( graded_tests.next() ){
                
                try{
                    
                    data = new JSONObject();
                    data.put( "test_id", graded_tests.getString("aptitude_test_id") );
                    data.put( "test_grade", graded_tests.getInt("grade"));
                    comm.put(i, data);
                    
                }catch(JSONException e){
                    e.printStackTrace();
                }
                i++; 
                
                while( graded_tests.next() ){
                    
                    
                   try{
                        data = new JSONObject();
                        data.put( "test_id", graded_tests.getString("aptitude_test_id") );
                        data.put( "test_grade", graded_tests.getInt("grade"));
                        comm.put(i, data);
                    }catch(JSONException e){
                        e.printStackTrace();
                    }
                    i++; 
                    
                }

            }
            conn.close();
            apt.closeConnection( connn );
            out.print( apt.makeResponse("SUCCESS", mess, comm ) );
                
            

        }else{
            
            conn.close();
            apt.closeConnection( connn );
            out.print( apt.makeResponse("ERROR","No tests are currently available.","") );

        }
    
    //EO - MENU ITEM GENERATOR
    //! FETCH THE TEST DESCRIPTION
    }else if( act.equals("getIntro") ){
        
       //!Set the response content type to JSON
       response.setContentType("application/json");
     
       //Fetch the test id
       String test_id = request.getParameter("test_id");
        
       //Ensure that a test id is provided
       if( test_id != null ){    
      
           //Fetch the requested test description
           ResultSet aptitude_test = selector.executeQuery("SELECT test_objectives FROM aptitude_tests WHERE display='TRUE' AND aptitude_test_id='"+ test_id +"' LIMIT 1");

            //Show the results if any
            if( aptitude_test.next() ){

                String objectives = aptitude_test.getString("test_objectives");
                conn.close();
                apt.closeConnection( connn );
                out.print( apt.makeResponse("SUCCESS", objectives, "") );

            }else{
                 conn.close();
                 apt.closeConnection( connn );
                 out.print( apt.makeResponse("ERROR","Failed to fetch the required test data.","") );

            }
       
       //EO - ENSURE THAT THE "test_id" is provided
       }else{
           
           apt.closeConnection( connn );
           out.print( apt.makeResponse("ERROR", "Please provide a test identifier","") );
           
       }
        
    //EO - TEST DESCRIPTION GENERATOR        
    //! ACTUAL TEST GENERATOR
    }else if( act.equals("startTest") ){
        
        //fetch the test id
        String test_id = request.getParameter("test_id");
        
        //Ensure that the test id has been provided
        if( test_id != null ){
            
            //Fetch all the test data
            ResultSet aptitude_test = selector.executeQuery("SELECT * FROM aptitude_tests WHERE display='TRUE' AND aptitude_test_id='"+ test_id +"' LIMIT 1");

            //ensure that such a test exists
            if( aptitude_test.next() ){
                           
                //!Create a user test folder
                ServletContext context = request.getServletContext();
                String testPath = context.getRealPath("")+ "/feedback/"+uid+"/"+test_id;
                File testFolder = new File( testPath );
                
                //!Set up the project setup/review uri
                String uri = "/aptitude/feedback/" + uid + "/" + test_id + "/index.jsp";
                
                //!Initialize the data storage strings
                String test_title   = "";
                String pass_mark    = "";
                String sample_jsp   = "";
                String sample_js    = "";
                String sample_css   = "";
                String sample_sql   = "";
                String test_objectives = "";
               
                //!Capture the sample startup content from the database
                test_title      = ( aptitude_test.getString("aptitude_test_name") != null ) ? aptitude_test.getString("aptitude_test_name") : "";
                pass_mark       = ( aptitude_test.getString("pass_mark") != null ) ? aptitude_test.getString("pass_mark") : "";
                sample_jsp      = ( aptitude_test.getString("sample_jsp") != null ) ? aptitude_test.getString("sample_jsp") : "";
                sample_js       = ( aptitude_test.getString("sample_js") != null ) ? aptitude_test.getString("sample_js"): "";
                sample_css      = ( aptitude_test.getString("sample_css") != null )? aptitude_test.getString("sample_css") : "";
                sample_sql      = ( aptitude_test.getString("sample_sql") != null ) ? aptitude_test.getString("sample_sql").replace("tableName", uid+"_"+test_id ).replace("tablename", uid+"_"+test_id ) : "";
                test_objectives = aptitude_test.getString("test_objectives");
                                
                
                //Ensure that the folder does not exist already
                if( !testFolder.exists() ){
                    
                    //!Create the directories that are not yet existent
                    testFolder.mkdirs();  
                    
                    ResultSet times = selector.executeQuery("SELECT count(*) FROM aptitude_grades  INNER JOIN entitys ON aptitude_grades.user_id = entitys.entity_id WHERE entitys.user_name = '"+ uid +"'  AND aptitude_grades.aptitude_test_id = '"+ test_id +"' ");
                    int isThere = 0;
                    if( times.next() ){
                        
                        isThere = times.getInt("count");
                        
                    }
                    
                    if( isThere <= 0){
                        
                        //!Add the test to the "my_tests" ('aptitude_ongoing') table for easy resuming
                        PreparedStatement to_ongoing = conn.prepareStatement( "INSERT into aptitude_ongoing ( user_id, aptitude_test_id ) VALUES ( '"+uid+"', '"+test_id+"' )" );

                        try{ 
                            Integer x = to_ongoing.executeUpdate();
                            apt.closeConnection( connn );
                            conn.close();
                        }catch(Exception e){
                            e.printStackTrace();
                            apt.closeConnection( connn );
                        }
                        
                    }
                    
                    //!Write to the relevant files
                    String[] files = {"index.codepamoja","index.jsp","app.codepamoja","app.js","style.css","db.sql"};
                    String[] records = {"", "", "", "", "","" };

                    apt.writeFiles( files, records, testPath );  
                    
                                   
                //EO - ensure folder does not exist
                }
                    
               //!close the database connection
               apt.closeConnection( connn );
               conn.close();
                  
               //!Serve the HTML LAYOUT TO THE USER.
                %>
                                   
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
    <div class="portlet-title">
        <div class="caption">
            <i class="fa fa-graduation-cap"></i>CodePamoja <span class="hidden-480">
            |  <%= test_title %> </span>
        </div>
        <div class="actions row">
            <a href="#" onclick="reinit()" id="goHome" class="btn orange">
                <i class="fa fa-home white"></i>
            </a>
            <a href="#" onclick="reload()" id="reload" class="btn orange">
                <i class="fa fa-refresh white" data-trigger="hover" rel="popover"></i>
            </a>
            <a href="#" onclick="save();" id="save" data-trigger="hover" rel="popover" class="btn green yellow-stripe">
                <i class="fa fa-save"></i>
                <span class="hidden-480">
                SAVE</span>
            </a>
            <a href="#" onclick="run();" id="run" class="btn green yellow-stripe" data-toggle="modal" data-target="#codeExec">
                <i class="fa fa-play"></i>
                <span class="hidden-480">
                RUN</span>
            </a>
            <!--
                <button type="button" class="btn btn-info btn-lg" data-toggle="modal" data-target="#myModal">Open Modal</button> -->

            <a href="#" onclick="submit();" data-trigger="hover" rel="popover" id="submit" class="btn red yellow-stripe">
                <i class="fa fa-send"></i>
                <span class="hidden-480">
                SUBMIT</span>
            </a>
            <a href="#" onclick="redo();" data-trigger="hover" rel="popover" id="redo" class="btn yellow-stripe" style="display:none;">
                <i class="fa fa-send"></i>
                <span class="hidden-480">
                UNDO SUBMIT</span>
            </a>
        </div>
    </div>
    
</div>
<!-- End: life time stats -->

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
                        <div class="portlet green box">
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
                                    <textarea class="editor" data-editor-lang="jsp" rows="13"  id="jsp" style="width:100%;  " placeholder="JSP CODE GOES HERE" ><%= sample_jsp %></textarea>
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
            <div class="tab-pane" id="tab_2">
                <div class="table-container">

                <!-- Editable content -->
                <div class="row">
                    <div class="col-md-12 col-sm-12 pamoja">
                        <div class="portlet green box">
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
                                    <textarea class="editor" data-editor-lang="js" rows="13" id="js" style="width:100%;" placeholder="JavaScript CODE GOES HERE"><%= sample_js %></textarea>
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
                        <div class="portlet green box">
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
                                    <textarea class="editor" data-editor-lang="sql" rows="13" id="db" style="width:100%;" placeholder="Table SQL CODE GOES HERE"><%= sample_sql %></textarea>
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
                        <div class="portlet green box">
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
                                    <textarea class="editor" data-editor-lang="css" rows="13"  id="css" style="width:100%; " placeholder="CSS CODE GOES HERE" ><%= sample_css %></textarea>
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

<!-- RELEVANT DYNAMIC USER SCRIPT -->
<script>

    //!The simple on reload click display handler
    $(function() {
        $("#reload").popover({
            title: 'CodePamoja Aptitude Tests', 
            content: "We are refreshing the page contents.<br><br>Please be patient"
        });  
    });
    
    var reload = function(){
        
        test( JSON.parse(localStorage.getItem("active")).test_id );
        
    };
    
    //HANDLER TO SAVE THE WRITTEN CODE
    var prfx = "";
        //'<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>';

    var save = function(){

        $(function(){

            $.ajax({
               url: "tests_process.jsp",
               data: { act: "save", uid: "<%= uid %>/<%= test_id %>", jsp: $("#jsp").val(), js: $("#js").val(), db: $("#db").val(), css: $("#css").val() },
               method: "POST",
               success: function( resp ){
                   //stop all running timeouts
                   var r =  $("#response");
                   clearTimeouts();
                   classify(resp.response, r);
                   r.html( prfx + resp.data.message ).fadeIn("fast");
                   setTimeout(function(){ r.fadeOut("fast") },7000);
               }
            });

        });

    };

    //HANDLER TO EXECUTE THE WRITTEN CODE
    var run = function(){

        var iframe = document.getElementById("iframe");
        iframe.src = "http://" + window.location.host + "<%= uri %>";
        //iframe.contentWindow.location.reload(true);

    };

    //HANDLER TO SUBMIT THE WRITTEN CODE
    var submit = function(){
        $(function(){

            $.ajax({
                url: "tests_process.jsp",
                data: { act: "submit", uid: "<%= uid %>/<%= test_id %>", id: "<%= uid %>", tid: "<%= test_id %>" },
                method: "POST",
                success: function( resp ){
                   var r =  $("#response");
                   clearTimeouts();
                   classify(resp.response, r);
                    
                    if( resp.response == "ERROR" ){
                        $("#submit").hide();
                        $("#redo").show();
                    }
                    
                   r.html( prfx + resp.data.message ).fadeIn("fast");
                   setTimeout(function(){ r.fadeOut("fast") },7000);
                }
            });

        });
    };
                
    //!Request to "unsubmit" request
    var redo = function(){
        $(function(){
            $.ajax({
                url: "tests_process.jsp",
                data: { act: "redo", test_id: JSON.parse(localStorage.getItem("active")).test_id, uid: "adminFunction" },
                method: "POST",
                success: function( resp ){
                   $("#submit").show();
                   $("#redo").hide();
                   var r =  $("#response");
                   clearTimeouts();
                   classify(resp.response, r);
                   r.html( prfx + resp.data.message ).fadeIn("fast");
                   setTimeout(function(){ r.fadeOut("fast") },7000);
                }
            });            
        }); 
    }; 

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
                   jspPopulate(); 
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
                   jsPopulate();
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
                   cssPopulate();
                }                
            },
            error: function(){
                cssPopulate();
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
                  dbPopulate();
                }
                
            }
        });


        /*
            PRE-POPULATE THE FIELDS IF THEY ARE BLANK
        */


        //jsp
        var jspPopulate = function(){
            
            if( jsp.val() === "" || jsp.val() != "null"){

                $.ajax({
                    url : "templates/jsp.txt",
                    data: {},
                    method: "POST",
                    converters: {
                        "text script" : function(text){
                            return text;
                        }
                    },
                    success: function(result){
                        jsp.val( result );
                    }
                });


            }

        };


        //js
        var jsPopulate = function(){

            if( js.val() === ""){

                $.ajax({
                    url : "templates/js.txt",
                    data: {},
                    method: "POST",
                    converters: {
                        "text script" : function(text){
                            return text;
                        }
                    },
                    success: function(result){
                        js.val(result);
                    }
                });

            }

        };

        //css
        var cssPopulate = function(){

            if( css.val() === ""){

                $.ajax({
                    url : "templates/style.txt",
                    data: {},
                    method: "POST",
                    converters: {
                        "text script" : function(text){
                            return text;
                        }
                    },
                    success: function(result){
                        css.val(result);
                    }
                });

            }

        };
        
        //db
        var dbPopulate = function(){

            if( db.val() === ""){

                $.ajax({
                    url : "templates/db.jsp",
                    data: { uid: "<%= uid %>", test : "<%= test_id %>" },
                    method: "POST",
                    converters: {
                        "text script" : function(text){
                            return text;
                        }
                    },
                    success: function(result){
                        db.val( result );
                    }
                });


            }

        };


    });

     //SAVE ON CTRL + S
       $(window).keypress(function(event) {
           
        if (!(event.which == 115 && event.ctrlKey) && !(event.which == 19)) return true;
           
        save();           
        event.preventDefault();
           
        return false;
           
       });

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

</script>
<!-- EO RELEVANT DYNAMIC USER SCRIPT -->
 
                        
        <%
               
            //EO - Such a test exists
            //!Handle a non existent test    
            }else{
               
               
                //!close the database connection
                conn.close();
                
                out.print( apt.makeResponse("ERROR", "The test you selected is no longer available", "") );
                
            //EO - Non -existent test
            }
                    
        //EO - Ensure that the test id has been provided
        }else{
           
            
           //!close the database connection
           conn.close(); 
           apt.closeConnection( connn );
           out.print( apt.makeResponse("ERROR", "Failed to identify the requested test", "") );
            
        }
    //EO - TEST GENERATOR
    }else if( act.equals("sample") ){
        
    %>
        <!-- BEGIN SAMPLE PORTLET CONFIGURATION MODAL FORM-->
<div class="modal fade" id="codeExec" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="min-width: 90% !important;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
                <h4 class="modal-title"><i class="fa fa-laptop fa-2x"></i> &nbsp; CodePamoja Sample Test > Live Preview </h4>
            </div>
            <div class="modal-body" style="min-height:450px; !important;">
                <iframe src="http://aptitude.codepamoja.org/aptitude/sample" id="iframe" style="width:100%; min-height:450px;" scrolling="false" frameborder="0" ></iframe>
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
    <div class="portlet-title">
        <div class="caption">
            <i class="fa fa-graduation-cap"></i>CodePamoja <span class="hidden-480">
            |  Sample Test </span>
        </div>
        <div class="actions row">
            <a href="#" onclick="reinit()" id="goHome" class="btn orange">
                <i class="fa fa-home white"></i>
            </a>
            <a href="#" onclick="reload()" id="reload" class="btn orange">
                <i class="fa fa-refresh white" data-trigger="hover" rel="popover"></i>
            </a>
            <a href="#" onclick="save();" id="save" class="btn green yellow-stripe">
                <i class="fa fa-save"></i>
                <span class="hidden-480">
                SAVE</span>
            </a>
            <a href="#" onclick="run();" id="run" class="btn green yellow-stripe" data-toggle="modal" data-target="#codeExec">
                <i class="fa fa-play"></i>
                <span class="hidden-480">
                RUN</span>
            </a>
            <!--
                <button type="button" class="btn btn-info btn-lg" data-toggle="modal" data-target="#myModal">Open Modal</button> -->

            <a href="#" onclick="submit();" id="submit" class="btn red yellow-stripe">
                <i class="fa fa-send"></i>
                <span class="hidden-480">
                SUBMIT</span>
            </a>
        </div>
    </div>
    
</div>
<!-- End: life time stats -->

<!-- PRIMITIVE CODE EDITOR -->
 <div class="portlet-body">
    <div class="tabbable">
        <ul class="nav nav-tabs nav-tabs-lg">
            <li class="active">
                <a href="#tab_1" " data-toggle="tab">
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
                                   <a href="javascript:;" data-toggle="modal" onclick="sampleInstructions()" data-target="#instructions" class="btn btn-default btn-sm" title="instructions">
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
                                   <a href="javascript:;" data-toggle="modal" onclick="sampleInstructions()" data-target="#instructions" class="btn btn-default btn-sm" title="instructions">
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
                                   <a href="javascript:;" data-toggle="modal" data-target="#instructions" onclick="sampleInstructions()" class="btn btn-default btn-sm" title="instructions">
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
                                   <a href="javascript:;" data-toggle="modal" data-target="#instructions" onclick="sampleInstructions()" class="btn btn-default btn-sm" title="instructions">
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

<!-- RELEVANT DYNAMIC USER SCRIPT -->
<script>

    //!The simple on reload click display handler
    $(function() {
        $("#reload").popover({
            title: 'CodePamoja Aptitude Tests', 
            content: "When on an actual test, this button will refresh the test pane."
        });  
        $("#save").popover({
            title: 'CodePamoja Aptitude Tests', 
            content: "When on an actual test, this button will save your current progress."
        });  
        $("#submit").popover({
            title: 'CodePamoja Aptitude Tests', 
            content: "When on an actual test, this button will submit your test for grading."
        });  
    });
    
    var reload = function(){
        
        //test( JSON.parse(localStorage.getItem("active")).test_id );
        
    };
    
    //HANDLER TO SAVE THE WRITTEN CODE
    var prfx = "";
        //'<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>';

    var save = function(){

        $(function(){

           var r =  $("#response");            
           classify("ERROR", r);
           r.html( "<font style='color:red; padding:2px; background:white;'>You cannot make changes to the sample test</font>" ).fadeIn("fast");
           setTimeout(function(){ r.fadeOut("fast") },7000);

        });

    };

    //HANDLER TO EXECUTE THE WRITTEN CODE
    var run = function(){

        var iframe = document.getElementById("iframe");
        iframe.contentWindow.location.reload(true);

    };

    //HANDLER TO SUBMIT THE WRITTEN CODE
    var submit = function(){
        $(function(){
             
           var r =  $("#response");            
           classify("ERROR", r);
           r.html( "<font style='color:red; padding:2px; background:white;'>You cannot submit the sample test</font>" ).fadeIn("fast");
           setTimeout(function(){ r.fadeOut("fast") },7000);
            
        });
    };

        
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
        

                

        /*
            PRE-POPULATE THE FIELDS IF THEY ARE BLANK
        */


        //jsp
        var jspPopulate = function(){
            
            if( jsp.val() === "" || jsp.val() != "null"){

                $.ajax({
                    url : "sample/calc.codepamoja",
                    data: {},
                    method: "POST",
                    converters: {
                        "text script" : function(text){
                            return text;
                        }
                    },
                    success: function(result){
                        jsp.val( result );
                    }
                });


            }

        };


        //js
        var jsPopulate = function(){

            if( js.val() === ""){

                $.ajax({
                    url : "sample/calcjs.codepamoja",
                    data: {},
                    method: "POST",
                    converters: {
                        "text script" : function(text){
                            return text;
                        }
                    },
                    success: function(result){
                        js.val(result);
                    }
                });

            }

        };

        //css
        var cssPopulate = function(){

            if( css.val() === ""){

                $.ajax({
                    url : "sample/calc.css",
                    data: {},
                    method: "POST",
                    converters: {
                        "text script" : function(text){
                            return text;
                        }
                    },
                    success: function(result){
                        css.val(result);
                    }
                });

            }

        };
        
        //db
        var dbPopulate = function(){

            if( db.val() === ""){

                $.ajax({
                    url : "templates/db.jsp",
                    data: { uid: "sample", test : "1" },
                    method: "POST",
                    converters: {
                        "text script" : function(text){
                            return text;
                        }
                    },
                    success: function(result){
                        db.val( result );
                    }
                });


            }

        };


        //SAVE ON CTRL + S
       $(window).keypress(function(event) {

        if (!(event.which == 115 && event.ctrlKey) && !(event.which == 19)) return true;

        save();           
        event.preventDefault();

        return false;

       });

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
        
     var sampleInstructions = function (){
        
        $("#instructionsBody").html('<div class="well portlet">When on actual tests,<br><br> this will display the steps that you ought to follow before submitting the test for grading. </div>');
        
    };
        
      jQuery(document).ready(function() {

        /*
            Initialize core page components
        */
        Metronic.init();
        Layout.init();
            
        /* FETCH THE USER's SAVED FILES */
        jspPopulate();      
        jsPopulate();
        cssPopulate();
        dbPopulate();

        

    });
        

</script>
<!-- EO RELEVANT DYNAMIC USER SCRIPT -->
  
        
    <%   
     //EO - SAMPLE TEST GENERATOR   
    //!TEST GRADING PANEL
    }else if( act.equals("doGrading") ){
        
     apt.closeConnection( connn );
    //EO - TEST GRADING PANEL
    //EO - CONTINUALLY CHAINED "if"     
    }
      
  

   
    
    //EO - ENSURE AN ACT IS DEFINED
    }else{
        out.print( apt.makeResponse("ERROR", "Your session is expired. Please login to continue" , "") );
        apt.closeConnection( connn );
    }
%>
