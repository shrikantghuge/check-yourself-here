package com.zensar.shrikantexamsystem.beans;

import java.util.Map;

import javax.xml.bind.annotation.XmlRootElement;
/*
 * The student details container in following fashion :
 * Student 1->* Trainer  1->* Subject 1->* Exams --->
 * 
 * @author Shriaknt Ghuge
 * @since V1.0
 * */
@XmlRootElement
public class Student {
	private String id;
	private String name;
	private String address;
	private long contactNumber;
	private String email;
	private String password;
	private Map<String, Trainer> trainers;
	private Map<Integer, Exam> exams;
	
	public Student() {
		super();
	}
	public Student(String id, String name, String address, long contactNumber,
			String email, String password, Map<String, Trainer> trainers,
			Map<Integer, Exam> exams) {
		super();
		this.id = id;
		this.name = name;
		this.address = address;
		this.contactNumber = contactNumber;
		this.email = email;
		this.password = password;
		this.trainers = trainers;
		this.exams = exams;
	}
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public long getContactNumber() {
		return contactNumber;
	}
	public void setContactNumber(long contactNumber) {
		this.contactNumber = contactNumber;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public Map<String, Trainer> getTrainers() {
		return trainers;
	}
	public void setTrainers(Map<String, Trainer> trainers) {
		this.trainers = trainers;
	}
	public Map<Integer, Exam> getExams() {
		return exams;
	}
	public void setExams(Map<Integer, Exam> exams) {
		this.exams = exams;
	}
	
	@Override
	public String toString() {
		return "Student [id=" + id + ", name=" + name + ", address=" + address
				+ ", contactNumber=" + contactNumber + ", email=" + email
				+ ", password=" + password + ", trainers=" + trainers
				+ ", exams=" + exams + "]";
	}	
}
