package com.zensar.shrikantexamsystem.zenemsdaoservices;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.zensar.shrikantexamsystem.beans.Student;
import com.zensar.shrikantexamsystem.beans.Trainer;
import com.zensar.shrikantexamsystem.exceptions.ServicesNotFoundException;
import com.zensar.shrikantexamsystem.serviceprovider.ConnectionProvider;

public class StudentDaoServicesImpl implements StudentDaoServices{
	PreparedStatement pstmt;
	ResultSet rs;
	Connection con;
	public StudentDaoServicesImpl() throws ServicesNotFoundException {
		con=ConnectionProvider.getConnection();
	}
	@Override
	public Student getStudent(Student student) throws SQLException, ServicesNotFoundException {
		Connection conn=con;
		Statement stmt= conn.createStatement();
		ResultSet rs=null;
		try {			
			rs = stmt.executeQuery("select * from student where Id='"+student.getId()+"'");
			/*if(rs.next()) return new Student(rs.getString(1), rs.getString(2), rs.getString(3), rs.getLong(5), rs.getString(6), rs.getString(4));
			else throw new ServicesNotFoundException("Student Does not exist");*/
			return null;
		} finally{
			if(rs!=null) rs.close();
			if(stmt!=null) stmt.close();
		}
	}	
	

}
