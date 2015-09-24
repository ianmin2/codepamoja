package epp;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONException;

public class Tamshi{

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
    
}
    