package com.zensar.shrikantexamsystem.serviceprovider;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Properties;
import com.zensar.shrikantexamsystem.exceptions.ServicesNotFoundException;
import com.zensar.shrikantexamsystem.zenemsservices.ExamServices;
public class ExamServicesProvider {
	public static ExamServices getPayrollService() throws ServicesNotFoundException{
		FileInputStream fileInputStream;
		try {
			fileInputStream = new FileInputStream(new File(".\\resources\\shrikantexamsystemresources.properties"));		
			Properties properties = new Properties();
			properties.load(fileInputStream);
			return (ExamServices)Class.forName(properties.getProperty("examserviceprovider")).newInstance();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			throw new ServicesNotFoundException("Service Not Found", e.getCause());
		} catch (IOException e) {
			e.printStackTrace();
			throw new ServicesNotFoundException("Service Not Found", e.getCause());
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			throw new ServicesNotFoundException("Service Not Found", e.getCause());
		} catch (InstantiationException e) {
			e.printStackTrace();
			throw new ServicesNotFoundException("Service Not Found", e.getCause());
		} catch (IllegalAccessException e) {
			e.printStackTrace();
			throw new ServicesNotFoundException("Service Not Found", e.getCause());
		}
	}
}
