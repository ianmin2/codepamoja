<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONException" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.codepamoja.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>



<%
    String uid =  request.getParameter("uid");
    String act = request.getParameter("act");

    Aptitude apt = new Aptitude();
    Connection connn = apt.getConnection( "192.168.0.9:5432/cp", "cp_user", "cp_invent" );
    Statement selector = apt.Selector( connn );

    ServletContext context = request.getServletContext();
    String home = context.getRealPath("");

    //ENSURE THAT ACT IS DEFINED
    if( act != null && uid != null ){
        
        String upath = context.getRealPath("") +"/feedback/"+ uid; //"build/webapps/baraza/feedback/" + uid;
        System.out.println("An applicant is making changes at the path : " + upath );
        //HANDLE FILE SAVE REQUESTS
        if( act.equals("save") ){

           
           //!Ensure that the test is not already submitted
           File fin = new File( upath + "/fin.fin" );
            
           if( fin.exists() ){
               
               out.print( apt.makeResponse("ERROR", "YOU HAVE ALREADY SUBMITTED THIS TEST. <br><br><font color='black' style='padding:5px; background-color:white;'> You cannot edit already submitted code. </font>", "") );
               
           //EO - Test is not already submitted
           //!Save User Submitted content
           }else{ 
            
                //!Write to the relevant files
                String[] files = {"index.codepamoja","index.jsp","app.codepamoja","app.js","style.css","db.sql"};
                String[] records = {request.getParameter("jsp"), request.getParameter("jsp"), request.getParameter("js"),request.getParameter("js"), request.getParameter("css"), request.getParameter("db") };

                apt.writeFiles( files, records, upath );                    

                    //CREATE THE REQUESTED TABLE;
                    try{

                        Class.forName("org.postgresql.Driver").newInstance();
                        Connection conn = DriverManager.getConnection("jdbc:postgresql://"+ request.getLocalAddr() +":5432/aptitude", "aptitude", "codepamoja");
                        PreparedStatement tblCreate = conn.prepareStatement( request.getParameter("db") );

                        int i = tblCreate.executeUpdate();
                        
                        if( i > 0 ){
                            
                            out.print( apt.makeResponse("SUCCESS", "Project Successfully saved.", "") );

                        }else{

                            out.print( apt.makeResponse("SUCCESS", "Project saved With no extra table configuration. <br><br><div style=' width:100%; min-height: 10px; padding:5px; background:black; text-align: center; color:red !important;'>Ensure that the SQL provided is valid</div>", "") );

                        }

                        apt.closeConnection( connn );
                        conn.close();

                    }catch(Exception e){
                       
                        out.print( apt.makeResponse("ERROR","Project Saved with a database error <br><br><font color='black' style='padding:3px; background-color:white;'>" + e.getMessage() +"</font>" , "") );
                        apt.closeConnection( connn );
                        
                    }
               
             
                        
           //EO - Save Submitted User content
           }

        //EO - act.equals("save")
        }

        //HANDLE FILE RUN REQUESTS
        else if( act.equals("run") ){
           // out.print( apt.makeResponse("SUCCESS", "You are now running a file", "") );
            apt.closeConnection( connn );
        }

        //HANDLE FILE SUBMIT REQUESTS
       else if( act.equals("submit") ){

           //String path = "build/webapps/baraza/feedback/"+ request.getParameter("uid");
          
           String path = context.getRealPath("") + "/feedback/" + request.getParameter("uid");
           
           File fin = new File( path + "/fin.fin" );
           File file;

           //!Check if project is already submitted
           if( !fin.exists() ){
                             
               /* To be re-considered
                //BUILD A JSON OBJECT 
                JSONObject message = new JSONObject();
                JSONObject emailObj = new JSONObject();
                JSONObject json = new JSONObject();
                JSONArray  email = new JSONArray();
               
                String  text = "The user "+ uid +" has submitted their aptitude tests for submission.  Please visit http://"+request.getLocalAddr() +":9090/cp/reviewers.jsp  to grade them.";
                */
               
               //!Insert a table record into 'aptitude_grades'
               Class.forName("org.postgresql.Driver");
               Connection conn = DriverManager.getConnection("jdbc:postgresql://192.168.0.9:5432/cp", "cp_user", "cp_invent");
               
                           
              //!Fetch the entity_id from the table entitys for the given user
              Statement rStat = conn.createStatement();
              ResultSet entitySearch = rStat.executeQuery( "SELECT entity_id, org_id  FROM entitys WHERE entitys.user_name='" + request.getRemoteUser() + "' LIMIT 1 " );
               
               int entity_id;
               int org_id;
               Date today = new Date();
               
                //!Ensure that the user is logged in
               if(  entitySearch.next() ){
                   
                   entity_id = entitySearch.getInt("entity_id");
                   org_id    = entitySearch.getInt("org_id");
                                                
                 //DELETE THE RECORD FROM ONGOING TESTS
                 PreparedStatement delete_from_ongoing = conn.prepareStatement( "DELETE FROM aptitude_ongoing WHERE aptitude_test_id = '"+request.getParameter("tid")+"' AND user_id='"+ request.getRemoteUser() +"'" );
               
               //!UPDATE THE APTITUDE TESTS GRADES TABLE
               PreparedStatement submit_results = conn.prepareStatement("INSERT INTO aptitude_grades ( user_id, aptitude_test_id, date_taken, org_id  ) VALUES ( '"+entity_id+"', '"+ request.getParameter("tid") +"', '"+today+"', '"+org_id+"' )");
               
               try{
                   
                   int i = submit_results.executeUpdate();
                   Integer x = delete_from_ongoing.executeUpdate();
                   fin.createNewFile();
                   
                   out.print( apt.makeResponse( "SUCCESS", " Congratulations,<br><br> you have successfully submitted your codepamoja aptitude test.", "" ) );
                   conn.close();
                   apt.closeConnection( connn );
                   
               }catch( Exception e ){
                   
                   fin.createNewFile();
                   out.print( apt.makeResponse("ERROR", "<i class='fa fa-frown-o'></i> <br>We failed to Submit your project.<br>Please ensure that you have not taken this test before. <br><br>", "") );
                   conn.close();
                   apt.closeConnection( connn );
                   
               }
               
               
        
        //EO - ensure that the user is logged in
        }else{
           
            response.sendRedirect("logout.jsp");
           apt.closeConnection( connn );        
        }
                            
              
           }else{
              
               //EO - check if the project is already submitted 
               out.print( apt.makeResponse("ERROR", "YOU HAVE ALREADY SUBMITTED THIS TEST", "") );
               apt.closeConnection( connn );
               
           }
           
           
        //EO - act = "run"
        }
        //HANDLE PAGE INITIALIZATION REQUESTS
        else if( act.equals("init") ){

            Integer times = Integer.parseInt( request.getParameter("tests") );
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection("jdbc:postgresql://192.168.0.9:5432/cp", "cp_user", "cp_invent");
            Statement rStat = conn.createStatement();
            ResultSet testResults = rStat.executeQuery( "SELECT * FROM codepamoja.feedback  WHERE username='" + uid + "' LIMIT 1 " );
            String t1 = "ungraded";
            String t2 = "ungraded";
            String t3 = "ungraded";


            if( testResults.next() ){

               t1 = ( testResults.getString( "test1" ) == null )? "ungraded": testResults.getString( "test1" ) + " %";
               t2 = ( testResults.getString( "test2" ) == null )? "ungraded": testResults.getString( "test2" ) + " %";
               t3 = ( testResults.getString( "test3" ) == null )? "ungraded": testResults.getString( "test3" ) + " %";

            }
            
            String[] grades = new String[3];
            grades[0] = t1;
            grades[1] = t2;
            grades[2] = t3;

    String concat = "<center><div class='' style='padding:30px; color: black; font-weight: bold; font-size: 20px; text-shadow: 1px 1px white;'>Welcome to the CodePamoja Aptitude Test portal</div></center><div class='col-lg-12'>";

            for( Integer i = 0; i < times; i++ ){

               concat += "<div class='alert col-lg-3 shadow' onclick='test("+ (i+1) +");' style='min-height:150px; padding:50px; text-align:center; margin:45px;'> <font style='font-weight:bold; font-size:40px; color:#1BA39C;'>Test "+ (i+1) +"</font><br>" +  grades[i] + "</div>";

            }

            concat += "</div>";
            out.print( apt.makeResponse( "SUCCESS", concat , "") );
            conn.close();
            apt.closeConnection( connn );

        }else if( act.equals("addGrade") ){
                        
            int grade               = Integer.parseInt( request.getParameter("grade") );
            int graded_by           = Integer.parseInt( request.getParameter("graded_by") );
            String review_comment   = request.getParameter("review_comment");
            String user_name        = request.getParameter("user_name");
            String test_id          = request.getParameter("test_id");
            Date date_graded        = new java.util.Date();
            
            
            Class.forName("org.postgresql.Driver");
            Connection conn = apt.getConnection("192.168.0.9:5432/cp", "cp_user", "cp_invent");
            
            int eid = -1; 
            
           selector = apt.Selector( conn );
           ResultSet get_e_id = selector.executeQuery("SELECT entity_id FROM entitys WHERE user_name='"+ user_name +"'");
            
            if( get_e_id.next() ){
                
                eid = get_e_id.getInt("entity_id");
                
            }
            
            
            PreparedStatement submit_grade = conn.prepareStatement("UPDATE aptitude_grades SET grade='"+ grade +"', graded_by='"+ graded_by +"', review_comment='"+ review_comment +"', date_graded='"+ date_graded +"' WHERE  aptitude_test_id='"+ test_id +"' AND  user_id='"+ eid +"'");
               
               try{
                   
                   int x = submit_grade.executeUpdate();
                   conn.close();
                   out.print( apt.makeResponse("SUCCESS", "<b><font color='white'>" + user_name + "'s</font></b> grade successfully updated to <font color='white'>" + grade + "%</font>." , "") );
                   
               }catch( Exception e ){
                   
                   conn.close();
                   e.printStackTrace();
                   out.print( apt.makeResponse("ERROR", "Failed to update <font color='white'><b>" + user_name + "'s</b> </font> grade for that test.<br><div style='background-color:black; padding:10px;' >Please ensure that the user has already submitted it.</div>" , "") );
                   
               }
          
        //!Handle the request to unsubmit a test
        }else if( act.equals("redo") ){
            
            //!Fetch the passed parameters
            String test_id = request.getParameter("test_id");
            String user_id = request.getRemoteUser();
                        
            //!Ensure that the test is not graded
            selector = apt.Selector(connn);      
            
            
            ResultSet is_graded = selector.executeQuery("SELECT aptitude_grades.grade AS is_graded, aptitude_grades.aptitude_grade_id FROM aptitude_grades JOIN aptitude_tests ON aptitude_grades.aptitude_test_id = aptitude_tests.aptitude_test_id JOIN entitys ON entitys.entity_id = aptitude_grades.user_id      LEFT JOIN entitys grader_entity ON grader_entity.entity_id = aptitude_grades.user_id WHERE entitys.user_name = '"+ user_id +"' AND aptitude_tests.aptitude_test_id = '"+ test_id +"' GROUP BY aptitude_grades.aptitude_grade_id");
            
            System.out.println("\nWorking as:\nUser:\t"+ user_id + "\nTest ID: "+ test_id );
            
            if( is_graded.next() ){
                
                int numGrades = is_graded.getInt("is_graded");
                int gradeId   = is_graded.getInt("aptitude_grade_id");
                
                if(  numGrades < 1 ){
                    
                     PreparedStatement to_ongoing = connn.prepareStatement( "INSERT into aptitude_ongoing ( user_id, aptitude_test_id ) VALUES ( '"+user_id+"', '"+test_id+"' )" );

                    PreparedStatement from_grades = connn.prepareStatement( "DELETE FROM aptitude_grades WHERE aptitude_grade_id='"+ gradeId +"'" );
                    
                        try{ 
                            
                            Integer x = to_ongoing.executeUpdate();
                            
                            Integer y = from_grades.executeUpdate();
                            
                            out.print( apt.makeResponse("SUCCESS","TEST RE-TAKE GRANTED","") );
                            
                            apt.closeConnection( connn );
                            
                            String[] finFile = { home + "/feedback/" + user_id + "/" + test_id + "/fin.fin" };
                            
                            apt.rmFile( finFile );
                                                        
                        }catch(Exception e){
                            
                            out.print( apt.makeResponse("ERROR", "Failed to process your re-take request.<br><br> Please try again later.", "") );
                            System.out.println("Failed to completely update switch grade status ");
                            
                            e.printStackTrace();
                            
                            apt.closeConnection( connn );
                            
                        }
                    
                    
                }else{
                    
                    out.print( apt.makeResponse("ERROR", "You have already been graded","") );
                    
                }
                
                
                
            }else{
                
                System.out.println("\nFailed to free test for an invalid candidate at  " +  home + "/feedback/" + user_id + "/" + test_id + "/fin.fin \n" );
             
                 /* String[] finFile = { home + "/feedback/" + user_id + "/" + test_id + "/fin.fin" };
                            
                 apt.rmFile( finFile ); */
                
                 out.print( apt.makeResponse("ERROR","TEST RE-TAKE DENIED!","") );
                
            }
            
        }
        //HANDLE UNSUPPORTED REQUESTS
        else {

            //TO DO ERROR CODE HERE
            out.print( apt.makeResponse("ERROR", "THE APPLICATION MADE AN INVALID REQUEST", "") );
            apt.closeConnection( connn );
            
        }

    }else{
        
        out.print( apt.makeResponse("ERROR", "The Application Failed to capture a critical parameter", "") );
        apt.closeConnection( connn );
    }
 %>
