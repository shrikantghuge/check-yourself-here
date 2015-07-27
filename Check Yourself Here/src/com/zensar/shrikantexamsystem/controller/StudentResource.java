package com.zensar.shrikantexamsystem.controller;

import java.sql.SQLException;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import com.zensar.shrikantexamsystem.beans.Student;
import com.zensar.shrikantexamsystem.exceptions.ServicesNotFoundException;
import com.zensar.shrikantexamsystem.zenemsservices.StudentServices;
import com.zensar.shrikantexamsystem.zenemsservices.StudentServicesImpl;

@Path("/student")
public class StudentResource {
	StudentServices studentServices;
	public StudentResource() {
		try {
			studentServices = new StudentServicesImpl();
		} catch (ServicesNotFoundException e) {			
			e.printStackTrace(); 
		}
	}
	
	@POST
	@Path("login")
	@Produces(MediaType.APPLICATION_JSON)
	@Consumes(MediaType.APPLICATION_JSON)
	public Student loginDetailsRetrival(Student student){				
		try {
			return studentServices.loginStudent(student);
		} catch (SQLException | ServicesNotFoundException e) {		
			e.printStackTrace();
			return new Student("error", "" , "", 0, "", "");
		}
	}
}
