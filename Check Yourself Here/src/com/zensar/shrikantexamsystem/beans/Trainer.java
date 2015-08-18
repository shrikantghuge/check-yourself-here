package com.zensar.shrikantexamsystem.beans;
import java.util.Map;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * Will contain the trainer value in following fassion :
 * Trainer 1->* Subject 1->* Students 1 ->* Exams ---->
 * 
 *@author Shrikant Ghuge
 *@since v1.0
 */
@XmlRootElement
public class Trainer {	
	private String id;
	private String name;
	private String address;
	private String email;	
	private Map<String, Subject> subjects;	
	private long contactNumber;
	private String password;
	
	public Trainer() {
		super();
	}
	public Trainer(String id, String name, String address, String email,
			Map<String, Subject> subjects, long contactNumber, String password) {
		super();
		this.id = id;
		this.name = name;
		this.address = address;
		this.email = email;
		this.subjects = subjects;
		this.contactNumber = contactNumber;
		this.password = password;
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
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public Map<String, Subject> getSubjects() {
		return subjects;
	}
	public void setSubjects(Map<String, Subject> subjects) {
		this.subjects = subjects;
	}
	public long getContactNumber() {
		return contactNumber;
	}
	public void setContactNumber(long contactNumber) {
		this.contactNumber = contactNumber;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	
	@Override
	public String toString() {
		return "Trainer [id=" + id + ", name=" + name + ", address=" + address
				+ ", email=" + email + ", subjects=" + subjects
				+ ", contactNumber=" + contactNumber + ", password=" + password
				+ "]";
	}	
}
