package com.zensar.shrikantexamsystem.beans;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class Student {
	private String id;
	private String name;
	private String address;
	private long contactNumber;
	private String email;
	private String password;
	
	public Student() {}
	public Student(String id, String name, String address, long contactNumber,
			String email, String password) {
		super();
		this.id = id;
		this.name = name;
		this.address = address;
		this.contactNumber = contactNumber;
		this.email = email;
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


	@Override
	public String toString() {
		return "Student [id=" + id + ", name=" + name + ", address=" + address
				+ ", contactNumber=" + contactNumber + ", email=" + email
				+ ", password=" + password + "]";
	}
}
