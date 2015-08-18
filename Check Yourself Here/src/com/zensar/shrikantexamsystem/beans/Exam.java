package com.zensar.shrikantexamsystem.beans;

import java.util.List;
import javax.xml.bind.annotation.XmlRootElement;

/*
 * This class wrap the EXAM related information. And has Question , Timetable like classes.
 * 
 * @author Shriaknt Ghuge
 * @since v1.0
 * */
@XmlRootElement
public class Exam {
	private int id;
	private String name;
	private int maxMarks;
	private List<Question> questions;
	private TimeTable timeTable;	
	private Float obtainedMarks;	
	
	public Exam() {
		super();
	}
	public Exam(int id, String name, int maxMarks, List<Question> questions,
			TimeTable timeTable, Float obtainedMarks) {
		super();
		this.id = id;
		this.name = name;
		this.maxMarks = maxMarks;
		this.questions = questions;
		this.timeTable = timeTable;
		this.obtainedMarks = obtainedMarks;
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
	public int getMaxMarks() {
		return maxMarks;
	}
	public void setMaxMarks(int maxMarks) {
		this.maxMarks = maxMarks;
	}
	public List<Question> getQuestions() {
		return questions;
	}
	public void setQuestions(List<Question> questions) {
		this.questions = questions;
	}
	public TimeTable getTimeTable() {
		return timeTable;
	}
	public void setTimeTable(TimeTable timeTable) {
		this.timeTable = timeTable;
	}
	public Float getObtainedMarks() {
		return obtainedMarks;
	}
	public void setObtainedMarks(Float obtainedMarks) {
		this.obtainedMarks = obtainedMarks;
	}
	
	@Override
	public String toString() {
		return "Exam [id=" + id + ", name=" + name + ", maxMarks=" + maxMarks
				+ ", questions=" + questions + ", timeTable=" + timeTable
				+ ", obtainedMarks=" + obtainedMarks + "]";
	}	
}
