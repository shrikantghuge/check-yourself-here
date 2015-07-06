package com.zensar.shrikantexamsystem.beans;

import java.util.HashMap;

import javax.xml.bind.annotation.XmlRootElement;
@XmlRootElement
public class Exam {
	private int examId;
	private String examName;
	private HashMap<Integer,Trainee> trainees;
	private HashMap<Integer, Section> sections;
	public Exam() {
		super();
	}
	public Exam(String examName, HashMap<Integer, Trainee> trainees) {
		super();
		this.examName = examName;
		this.trainees = trainees;
	}
	public Exam(int examId, String examName,
			HashMap<Integer, Trainee> trainees,
			HashMap<Integer, Section> sections) {
		super();
		this.examId = examId;
		this.examName = examName;
		this.trainees = trainees;
		this.sections = sections;
	}

	public int getExamId() {
		return examId;
	}

	public void setExamId(int examId) {
		this.examId = examId;
	}

	public String getExamName() {
		return examName;
	}

	public void setExamName(String examName) {
		this.examName = examName;
	}

	public HashMap<Integer, Trainee> getTrainees() {
		return trainees;
	}

	public void setTrainees(HashMap<Integer, Trainee> trainees) {
		this.trainees = trainees;
	}

	public HashMap<Integer, Section> getSections() {
		return sections;
	}

	public void setSections(HashMap<Integer, Section> sections) {
		this.sections = sections;
	}

	@Override
	public String toString() {
		return "Exam [examId=" + examId + ", examName=" + examName
				+ ", trainees=" + trainees + ", sections=" + sections + "]";
	}
	
	
	
	
	
}
