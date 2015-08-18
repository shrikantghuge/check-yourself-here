package com.zensar.shrikantexamsystem.beans;

import java.util.Map;

import javax.xml.bind.annotation.XmlRootElement;

/*This class contains subject taught by Trainer or Subject learn by Student
 * 
 *    @author Shriaknt Ghuge
 *    @since v1.0
 * */
@XmlRootElement
public class Subject {
	private int id;
	private String name;
	private String description;	
	private Map<Integer, Exam> exams;
	private Map<String, Student> students;
		
	public Subject() {
		super();
	}
	public Subject(int id, String name, String description,
			Map<Integer, Exam> exams, Map<String, Student> students) {
		super();
		this.id = id;
		this.name = name;
		this.description = description;
		this.exams = exams;
		this.students = students;
	}
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public Map<Integer, Exam> getExams() {
		return exams;
	}
	public void setExams(Map<Integer, Exam> exams) {
		this.exams = exams;
	}
	public Map<String, Student> getStudents() {
		return students;
	}
	public void setStudents(Map<String, Student> students) {
		this.students = students;
	}
	
	@Override
	public String toString() {
		return "Subject [id=" + id + ", name=" + name + ", description="
				+ description + ", exams=" + exams + ", students=" + students
				+ "]";
	}	
}

