package com.zensar.shrikantexamsystem.serviceprovider;
import java.io.*;
import java.util.Properties;
import com.zensar.shrikantexamsystem.exceptions.ServicesNotFoundException;
import com.zensar.shrikantexamsystem.zenemsdaoservices.ExamDAOServices;
public class ExamDAOServicesProvider {
	public static ExamDAOServices getPayrollDAOService() throws ServicesNotFoundException{
		FileInputStream fileInputStream;
		try {
			fileInputStream = new FileInputStream(new File(".\\resources\\shrikantexamsystemresources.properties"));		
			Properties properties = new Properties();
			properties.load(fileInputStream);
			return (ExamDAOServices)Class.forName(properties.getProperty("examdaoserviceprovider")).newInstance();
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
