package com.zensar.shrikantexamsystem.zenemsservices;

import java.sql.SQLException;

import com.zensar.shrikantexamsystem.beans.Student;
import com.zensar.shrikantexamsystem.exceptions.ServicesNotFoundException;
import com.zensar.shrikantexamsystem.zenemsdaoservices.StudentDaoServices;
import com.zensar.shrikantexamsystem.zenemsdaoservices.StudentDaoServicesImpl;

public class StudentServicesImpl implements StudentServices{
	StudentDaoServices studentDaoServices;
	public StudentServicesImpl() throws ServicesNotFoundException {
		studentDaoServices = new StudentDaoServicesImpl();
	}	
	@Override
	public Student loginStudent(Student student) throws SQLException, ServicesNotFoundException {
		return studentDaoServices.getStudent(student);
	}

}
