package com.zensar.shrikantexamsystem.serviceprovider;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import com.zensar.shrikantexamsystem.exceptions.ServicesNotFoundException;
public class ConnectionProvider {
	private static Connection con=null;
	public static Connection getConnection() throws  ServicesNotFoundException{	
		Properties properties = new Properties();
		try {
			//properties.load(new FileInputStream(new File("/WEB-INF/properties/shrikantexamsystemresources.properties")));
			
			if(con==null){
				/*Class.forName(properties.getProperty("driver"));
				con=DriverManager.getConnection(properties.getProperty("url"), properties.getProperty("username"), properties.getProperty("password"));*/
				Class.forName("com.mysql.jdbc.Driver");
				con=DriverManager.getConnection("jdbc:mysql://localhost:3306/exam","root", "root");
			}
		}  catch (SQLException e) {
			e.printStackTrace();
			throw new ServicesNotFoundException("service not found");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			throw new ServicesNotFoundException("service not found");
		}	
		return con;
	} 
}
