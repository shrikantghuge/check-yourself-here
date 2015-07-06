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
			properties.load(new FileInputStream(new File(".//resources//shrikantexamsystemresources.properties")));
			
			if(con==null){
				Class.forName(properties.getProperty("driver"));
				con=DriverManager.getConnection(properties.getProperty("url"), properties.getProperty("username"), properties.getProperty("password"));
			}
		} catch (IOException e) {
			throw new ServicesNotFoundException("service not found");
		} catch (SQLException e) {
			throw new ServicesNotFoundException("service not found");
		} catch (ClassNotFoundException e) {
			throw new ServicesNotFoundException("service not found");
		}	
		return con;
	} 
}
