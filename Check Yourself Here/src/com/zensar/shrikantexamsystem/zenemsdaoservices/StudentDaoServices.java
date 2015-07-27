package com.zensar.shrikantexamsystem.zenemsdaoservices;

import java.sql.SQLException;

import com.zensar.shrikantexamsystem.beans.Student;
import com.zensar.shrikantexamsystem.exceptions.ServicesNotFoundException;

public interface StudentDaoServices {	
 public Student getStudent(Student student) throws SQLException, ServicesNotFoundException;
}
