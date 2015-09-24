import java.io.*;

public class T{
   
    public static void main(String args[]){
        
        System.out.println("Hello there!");
        
        String[] files = {"index.codepamoja","index.jsp","app.js","style.css","db.sql"};
        String[] data  = {"index.codepamoja","index.jsp","app.js","style.css","db.sql"};
        
        writeFiles( files , data , "/home/ian/Bureau");
        
    }
    
    
    
}

