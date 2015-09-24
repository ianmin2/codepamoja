package org.codepamoja;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONException;
import java.sql.*;
import org.postgresql.Driver;
import java.io.*;


public class Aptitude{

//!THE JSON PARSER METHODS      1
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
    
//!THE JSON PARSER METHODS      2
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
    

//!THE JSON PARSER METHODS      3
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

//!THE JSON PARSER METHODS      4
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
    
    
//!THE DATABASE CONNECTION HANDLER
    public static Statement Selector( Connection conn ){
        
        try{
           
            Statement selector = conn.createStatement();
            return selector;
            
        }catch(Exception e){
            
            e.printStackTrace();
            return null;
            
        }
         
        
        
    }
    
//! Create a database connection
    public static Connection getConnection( String connPars, String usernom, String userkey  ){
       
        try{
            
            Class.forName("org.postgresql.Driver").newInstance();
            return DriverManager.getConnection("jdbc:postgresql://" + connPars, usernom, userkey);
            
        }catch(Exception e){
            
            e.printStackTrace();
            return null;
            
        }
        
    }
    

//!Close a database connection
    public static void closeConnection( Connection conn ){
        
        try{
            conn.close();
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    //!Simple reccursive filewriter
    public static void writeFiles( String[] file_names, String[] file_content, String filePath){
        
        PrintWriter fW;        
        
        for( int i = 0; i < file_names.length; i++ ){

            try{
                
                //System.out.println( file_names[i] + "\n");
                fW = new PrintWriter( new FileOutputStream( filePath + "/" + file_names[i] ) );
                fW.print( file_content[i] );
                fW.close();
                
            }catch(Exception e){
                
                e.printStackTrace();
                
            }
            
            
        }
        
    }
    
    //!Simple File deletion handler
    public static void rmFile( String[] file_paths ){
        
        File f;
        
        for( int i = 0; i < file_paths.length; i++){
            
            try{ 
            
                f = new File( file_paths[i] );
                f.delete();
                
            }catch( Exception e ){
                
                e.printStackTrace();
                
            }
            
        }
        
    }
    
    //!Simple String newline eradicator for javascript
    public static String tjs(String string) {
         return (string != null) ? string.replaceAll(" ", "") : null;
     }
    
}