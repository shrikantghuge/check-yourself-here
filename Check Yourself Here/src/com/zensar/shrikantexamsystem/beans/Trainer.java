package com.zensar.shrikantexamsystem.beans;
import java.util.HashMap;
import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;
/**
 * @author shghuge
 *
 */
@XmlRootElement
public class Trainer {	
	private String id;
	private String name;
	private String address;
	private String email;	
	private List<Subject> subjects;	
	private long contactNumber;
	private String password;
	
	public Trainer() {
		System.out.println("Trainer is initialized");
	}
	public Trainer(String id, String name, String address, String email,
			List<Subject> subjects, long contactNumber, String trainerPassword) {
		super();
		this.id = id;
		this.name = name;
		this.address = address;
		this.email = email;
		this.subjects = subjects;
		this.contactNumber = contactNumber;
		this.password = trainerPassword;
	}


	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
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
	public List<Subject> getSubjects() {
		return subjects;
	}
	public void setSubjects(List<Subject> subjects) {
		this.subjects = subjects;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public long getContactNumber() {
		return contactNumber;
	}

	public void setContactNumber(long contactNumber) {
		this.contactNumber = contactNumber;
	}

	@Override
	public String toString() {
		return "Trainer [id=" + id + ", name=" + name + ", address=" + address
				+ ", email=" + email + ", subjects=" + subjects
				+ ", contactNumber=" + contactNumber + ", trainerPassword="
				+ password + "]";
	}
}
