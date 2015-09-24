<%@ page language="java" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONException" %>
<%!
   //!THE JSON PARSER METHODS
    
    public static JSONObject makeResponse( String resp, String mess, String comm ){
        JSONObject json = new JSONObject();
        JSONObject data = new JSONObject();

        try{
            data.put("message", mess);
            data.put("command", comm);

            json.put("response", resp);
            json.put("data", data);

        }catch(JSONException e){
            e.printStackTrace();
        }
        return  json;
    }
    
    public static JSONObject makeResponse( String resp, JSONObject mess, String comm ){
        JSONObject json = new JSONObject();
        JSONObject data = new JSONObject();

        try{
            data.put("message", mess);
            data.put("command", comm);

            json.put("response", resp);
            json.put("data", data);

        }catch(JSONException e){
            e.printStackTrace();
        }
        return  json;
    }
    
    public static JSONObject makeResponse( String resp, JSONArray mess, String comm ){
        JSONObject json = new JSONObject();
        JSONObject data = new JSONObject();

        try{
            data.put("message", mess);
            data.put("command", comm);

            json.put("response", resp);
            json.put("data", data);

        }catch(JSONException e){
            e.printStackTrace();
        }
        return  json;
    }

    public static JSONObject makeResponse( String resp, JSONArray mess, JSONArray comm ){
        JSONObject json = new JSONObject();
        JSONObject data = new JSONObject();

        try{
            data.put("message", mess);
            data.put("command", comm);

            json.put("response", resp);
            json.put("data", data);

        }catch(JSONException e){
            e.printStackTrace();
        }
        return  json;
    }
    
   
%>
<%
  
  /*
      Capture the required parameters
  */
  String uid = request.getRemoteUser();
  String act = request.getParameter("act");
  
  if(act != null && uid != null ){
   
   /* Establish A Database Connection  */
    Class.forName("org.postgresql.Driver").newInstance();
    Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/codepamoja", "root", "");
    Statement selector = conn.createStatement();
    
    /*!Sample strings to follow
    //ResultSet testResults = rStat.executeQuery( "SELECT * FROM codepamoja.feedback  WHERE username='" + uid + "' LIMIT 1 " );    
    //PreparedStatement tblCreate = conn.prepareStatement( "INSERT INTO codepamoja.feedback (username) VALUES ('" + uid + "') " );
    */
      
    //!FETCH THE MENU GENERATOR ITEMS
    if( act.equals("getMenu") ){
    
       //!Set the content type to JSON
       response.setContentType("application/json"); 
       
        ResultSet aptitude_tests = selector.executeQuery("SELECT test_title,test_id,pass_mark FROM aptitude_tests WHERE display='TRUE' ORDER BY test_title");
        
        /*
        //!FETCH THE USER'S COMPLETED TESTS
        SELECT aptitude_tests.pass_mark, aptitude_tests.test_id, aptitude_tests.test_title, aptitude_grades.grade as grade FROM aptitude_tests INNER JOIN aptitude_grades ON aptitude_tests.test_id = aptitude_grades.test_id WHERE aptitude_grades.user_id = ( SELECT entitys.entity_id FROM entitys WHERE entitys.user_name = 'root' )
        */
        
                        
        //PREPARE THE JSON RESPONSE OBJECTS
        JSONArray  mess = new JSONArray();
        JSONArray  comm = new JSONArray();
        JSONObject data;
        int i = 0;
        
        if( aptitude_tests.next() ){

            try{
                data = new JSONObject();
                data.put( "test_title", aptitude_tests.getString("test_title") );
                data.put( "test_id",    aptitude_tests.getString("test_id") );
                data.put( "pass_mark",  aptitude_tests.getString("pass_mark") );
                mess.put(i, data);
            }catch(JSONException e){
                e.printStackTrace();
            }
            i++;    

            while( aptitude_tests.next() ){

                try{
                    data = new JSONObject();
                    data.put( "test_title", aptitude_tests.getString("test_title") );
                    data.put( "test_id",    aptitude_tests.getString("test_id") );
                    data.put( "pass_mark",  aptitude_tests.getString("pass_mark") );
                    mess.put(i, data);
                }catch(JSONException e){
                    e.printStackTrace();
                }
                i++;   

            }
            
            /*
                SELECT DISTINCT aptitude_ongoing.test_id, aptitude_grades.grade FROM aptitude_ongoing INNER JOIN entitys ON entitys.user_name = aptitude_ongoing.user_id INNER JOIN aptitude_grades ON aptitude_ongoing.test_id = aptitude_grades.test_id WHERE aptitude_ongoing.user_id='"+uid+"' 
            */
            
            ResultSet ongoing_tests = selector.executeQuery("SELECT DISTINCT aptitude_ongoing.test_id FROM aptitude_ongoing WHERE aptitude_ongoing.user_id='"+uid+"' "); 
            
            //!FETCH THE USER'S ONGOING TESTS
            if( ongoing_tests.next() ){
                
                i = 0;
                try{
                    data = new JSONObject();
                    data.put( "test_id", ongoing_tests.getString("test_id") );
                    data.put( "test_grade", "ng");
                    comm.put(i, data);
                }catch(JSONException e){
                    e.printStackTrace();
                }
                i++; 
                
                while( ongoing_tests.next() ){
                    
                    
                   try{
                        data = new JSONObject();
                        data.put( "test_id", ongoing_tests.getString("test_id") );
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
            
            ResultSet graded_tests = selector.executeQuery("SELECT aptitude_grades.test_id, aptitude_grades.grade FROM aptitude_grades INNER JOIN entitys ON entitys.entity_id = aptitude_grades.user_id AND entitys.user_name = '"+ uid+"' ");
            
            //!FETCH THE USER'S COMPLETED TESTS
            if( graded_tests.next() ){
                
                i = 0;
                try{
                    data = new JSONObject();
                    data.put( "test_id", graded_tests.getString("test_id") );
                    data.put( "test_grade", graded_tests.getInt("grade"));
                    comm.put(i, data);
                }catch(JSONException e){
                    e.printStackTrace();
                }
                i++; 
                
                while( graded_tests.next() ){
                    
                    
                   try{
                        data = new JSONObject();
                        data.put( "test_id", graded_tests.getString("test_id") );
                        data.put( "test_grade", graded_tests.getInt("grade"));
                        comm.put(i, data);
                    }catch(JSONException e){
                        e.printStackTrace();
                    }
                    i++; 
                    
                }

            }
            conn.close();
            out.print( makeResponse("SUCCESS", mess, comm ) );
                
            

        }else{
            
            conn.close();
            out.print( makeResponse("ERROR","No tests are currently available.","") );

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
           ResultSet aptitude_test = selector.executeQuery("SELECT test_objectives FROM aptitude_tests WHERE display='TRUE' AND test_id='"+ test_id +"' LIMIT 1");

            //Show the results if any
            if( aptitude_test.next() ){

                String objectives = aptitude_test.getString("test_objectives");
                conn.close();
                out.print( makeResponse("SUCCESS", objectives, "") );

            }else{
                 conn.close();
                 out.print( makeResponse("ERROR","Failed to fetch the required test data.","") );

            }
       
       //EO - ENSURE THAT THE "test_id" is provided
       }else{
           
           out.print( makeResponse("ERROR", "Please provide a test identifier","") );
           
       }
        
    //EO - TEST DESCRIPTION GENERATOR        
    //! ACTUAL TEST GENERATOR
    }else if( act.equals("startTest") ){
        
        //fetch the test id
        String test_id = request.getParameter("test_id");
        
        //Ensure that the test id has been provided
        if( test_id != null ){
            
            //Fetch all the test data
            ResultSet aptitude_test = selector.executeQuery("SELECT * FROM aptitude_tests WHERE display='TRUE' AND test_id='"+ test_id +"' LIMIT 1");

            //ensure that such a test exists
            if( aptitude_test.next() ){
                           
                //!Create a user test folder
                String testPath = "build/webapps/baraza/feedback/"+uid+"/"+test_id;
                File testFolder = new File( testPath );
                
                //!Set up the project setup/review uri
                String uri = "http://" + request.getLocalAddr() + ":9090/cp/feedback/" + uid + "/" + test_id + "/index.jsp";
                
                //!Initialize the data storage strings
                String test_title   = "";
                String pass_mark    = "";
                String sample_jsp   = "";
                String sample_js    = "";
                String sample_css   = "";
                String sample_sql   = "";
                String test_objectives = "";
               
                //!Capture the sample startup content from the database
                test_title      = ( aptitude_test.getString("test_title") != null ) ? aptitude_test.getString("test_title") : "";
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
                    
                    //!Add the test to the "my_tests" ('aptitude_ongoing') table for easy resuming
                    PreparedStatement to_ongoing = conn.prepareStatement( "INSERT into aptitude_ongoing ( user_id, test_id ) VALUES ( '"+uid+"', '"+test_id+"' )" );

                    try{ 
                        Integer x = to_ongoing.executeUpdate();
                        conn.close();
                    }catch(Exception e){
                    
                    }
                    
                    
                    //!Initialize the necessary files                    
                    //jsp live
                    File jspFile    = new File( testPath + "/index.jsp" );
                    jspFile.createNewFile();
                    
                    //jsp text
                    File jspTFile   = new File( testPath + "/index.codepamoja" );
                    jspTFile.createNewFile();
                    
                    //js
                    File jsFile     = new File( testPath + "/app.js");
                    jsFile.createNewFile();
                    
                    //css
                    File cssFile    = new File( testPath + "/style.css");
                    cssFile.createNewFile();
                    
                    //sql
                    File sqlFile    = new File( testPath + "/db.sql");
                    sqlFile.createNewFile();
                
                    /*
                    //!Write the default content to the initialized files                    
                    //jsp live
                    PrintWriter fileWriter;
                    fileWriter = new PrintWriter( new FileOutputStream( testPath + "/index.jsp" ) );
                    fileWriter.print( sample_jsp );
                    fileWriter.close();
                    
                    //jsp text
                    fileWriter = new PrintWriter( new FileOutputStream( testPath + "/index.codepamoja" ) );
                    fileWriter.print( sample_jsp );
                    fileWriter.close();
                    
                    //js
                    fileWriter = new PrintWriter( new FileOutputStream( testPath + "/app.js" ) );
                    fileWriter.print( sample_js );
                    fileWriter.close();
                    
                    //css
                    fileWriter = new PrintWriter( new FileOutputStream( testPath + "/style.css" ) );
                    fileWriter.print( sample_css );
                    fileWriter.close();
                    
                    //sql
                    fileWriter = new PrintWriter( new FileOutputStream( testPath + "/db.sql" ) );
                    fileWriter.print( sample_sql );
                    fileWriter.close();
                    */
                   
                
                //EO - ensure folder does not exist
                }
                    
               //!close the database connection
               conn.close();
                  
               //!Serve the HTML LAYOUT TO THE USER.
                %>
                        
<!-- BEGIN SAMPLE PORTLET CONFIGURATION MODAL FORM-->
<div class="modal fade" id="codeExec" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="min-width: 90% !important;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
                <h4 class="modal-title"><i class="fa fa-laptop fa-2x"></i> <%= uid %> |  <%= test_title %> > Live Preview </h4>
            </div>
            <div class="modal-body" style="min-height:450px; !important;">
                <iframe src="<%= uri %>" id="iframe" style="width:100%; min-height:450px;" scrolling="false" frameborder="0" ></iframe>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn red" data-dismiss="modal">Close</button>
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
            <a href="#" onclick="save();" id="save" class="btn default yellow-stripe">
                <i class="fa fa-save"></i>
                <span class="hidden-480">
                SAVE</span>
            </a>
            <a href="#" onclick="run();" id="run" class="btn default yellow-stripe" data-toggle="modal" data-target="#codeExec">
                <i class="fa fa-play"></i>
                <span class="hidden-480">
                RUN</span>
            </a>
            <!--
                <button type="button" class="btn btn-info btn-lg" data-toggle="modal" data-target="#myModal">Open Modal</button> -->

            <a href="#" onclick="submit();" id="submit" class="btn default yellow-stripe">
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
                            <div class="portlet-title">
                                <div class="caption">
                                    <i class="fa fa-file-code-o"></i> index.jsp
                                </div>
                                <div class="actions">
                                    <a href="javascript:;" class="btn btn-default btn-sm fullscreen">
                                    <i class="fa fa-external-link"></i></a>
                                </div>
                            </div>
                            <div class="portlet-body fill">
                                <div class="table-responsive fill pamoja">
                                    <pre  class="editor" data-editor-lang="js" rows="13"  id="jsp" style="width:100%; " placeholder="JSP CODE GOES HERE" ><%= sample_jsp %></pre>
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
                            <div class="portlet-title">
                                <div class="caption">
                                    <i class="fa fa-file-code-o"></i> app.js
                                </div>
                                <div class="actions">
                                    <a href="javascript:;" class="btn btn-default btn-sm fullscreen">
                                    <i class="fa fa-external-link"></i></a>
                                </div>
                            </div>
                            <div class="portlet-body fill">
                                <div class="table-responsive fill pamoja">
                                    <pre  class="editor" data-editor-lang="js" rows="13" id="js" style="width:100%;" placeholder="JavaScript CODE GOES HERE"><%= sample_js %></pre>
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
                            <div class="portlet-title">
                                <div class="caption">
                                    <i class="fa fa-file-code-o"></i> db.sql
                                </div>
                                <div class="actions">
                                    <a href="javascript:;" class="btn btn-default btn-sm fullscreen">
                                    <i class="fa fa-external-link"></i> </a>
                                </div>
                            </div>
                            <div class="portlet-body fill">
                                <div class="table-responsive fill pamoja">
                                    <pre  class="editor" data-editor-lang="js" rows="13" id="db" style="width:100%;" placeholder="Table SQL CODE GOES HERE"><%= sample_sql %></pre>
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
                            <div class="portlet-title">
                                <div class="caption">
                                    <i class="fa fa-file-code-o"></i> style.css
                                </div>
                                <div class="actions">
                                    <a href="javascript:;" class="btn btn-default btn-sm fullscreen">
                                    <i class="fa fa-external-link"></i></a>
                                </div>
                            </div>
                            <div class="portlet-body fill">
                                <div class="table-responsive fill pamoja">
                                    <pre  class="editor" data-editor-lang="css" rows="13"  id="css" style="width:100%; " placeholder="CSS CODE GOES HERE" ><%= sample_css %></pre>
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

    //HANDLER TO SAVE THE WRITTEN CODE
    var prfx = "";
        //'<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>';

    var save = function(){

        $(function(){

            $.ajax({
               url: "tests_process.jsp",
               data: { act: "save", uid: "<%= uid %>/<%= test_id %>", jsp: $("#jsp").text(), js: $("#js").text(), db: $("#db").text(), css: $("#css").text() },
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
        iframe.contentWindow.location.reload(true);

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
                   r.html( prfx + resp.data.message ).fadeIn("fast");
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
                    jsp.text(result);
                }else if( jsp.text() == "" ){
                   jspPopulate(); 
                }           
                
            }
        });


        //JavaScript
        $.ajax({
            url : "feedback/<%= uid %>/<%= test_id %>/app.js",
            data: {},
            method: "POST",
            converters: {
                "text script" : function(text){
                    return text;
                }
            },
            success: function(result){
                
                if( result != "" ){
                    js.text(result);
                }else if( js.text() == "" ){
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
                    css.text(result);
                }else if( css.text() == ""){
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
                   db.text(result);
                }else if( db.text() == "" ){
                  dbPopulate();
                }
                
            }
        });


        /*
            PRE-POPULATE THE FIELDS IF THEY ARE BLANK
        */


        //jsp
        var jspPopulate = function(){
            
            if( jsp.text() === "" || jsp.text() != "null"){

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
                        jsp.text(result);
                    }
                });


            }

        };


        //js
        var jsPopulate = function(){

            if( js.text() === ""){

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
                        js.text(result);
                    }
                });

            }

        };

        //css
        var cssPopulate = function(){

            if( css.text() === ""){

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
                        css.text(result);
                    }
                });

            }

        };
        
        //db
        var dbPopulate = function(){

            if( db.text() === ""){

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
                        db.innerText(result) ;
                    }
                });


            }

        };


    });

    //SAVE ON CTRL + S
    $(".textarea").on("keydown", function(e){

        //something to do

    })

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
                
    //Embed the orion editor
    require(["orion/editor/edit"], function(edit) {
		edit({className: "editor"});
	});

</script>
<!-- EO RELEVANT DYNAMIC USER SCRIPT -->
                        
        <%
               
            //EO - Such a test exists
            //!Handle a non existent test    
            }else{
               
               
                //!close the database connection
                conn.close();
                
                out.print( makeResponse("ERROR", "The test you selected is no longer available", "") );
                
            //EO - Non -existent test
            }
           
            /*
            //!HANDLE User has taken the test before
            }else{
               
               //##
               ResultSet test_grade = selector.executeQuery("SELECT date_graded, grade, review_comment FROM aptitude_grades WHERE user_id='"+ user_id +"'"); 
                
                //!Fetch the data and store it appropriately
                test_grade.next();
                
                String date_graded = test_grade.getString("date_graded");
                String grade       = test_grade.getString("grade");
                String review_comment = test_grade.getString("review_comment");
                    
                test_grade.close();
                
                //!Parse the fetched data into a JSON object
                JSONObject data = new JSONObject();
                                
                data.put( "date_graded", date_graded );
                data.put( "grade", grade );
                data.put( "review_comment", review_comment );
                
                //!Return the data to the user
                out.print( makeResponse( "ERROR", data, "" ) );
                
            }
            */
         
        //EO - Ensure that the test id has been provided
        }else{
           
            
           //!close the database connection
           conn.close(); 
           
           out.print( makeResponse("ERROR", "Failed to identify the requested test", "") );
            
        }
    //EO - TEST GENERATOR
        
    //EO - CONTINUALLY CHAINED "if"    
    }
    
   
    
    //EO - ENSURE AN ACT IS DEFINED
    }else{
        out.print( makeResponse("ERROR", "Failed to fetch critical parameters" + uid, "") );
    }
%>
