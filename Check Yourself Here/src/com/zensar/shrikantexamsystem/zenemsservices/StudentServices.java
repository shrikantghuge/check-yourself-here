package com.zensar.shrikantexamsystem.zenemsservices;

import java.sql.SQLException;

import com.zensar.shrikantexamsystem.beans.Student;
import com.zensar.shrikantexamsystem.exceptions.ServicesNotFoundException;

public interface StudentServices {
 public Student loginStudent(Student student) throws SQLException, ServicesNotFoundException;
}
