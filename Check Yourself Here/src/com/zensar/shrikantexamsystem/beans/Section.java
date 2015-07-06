package com.zensar.shrikantexamsystem.beans;

import java.util.HashMap;

import javax.xml.bind.annotation.XmlRootElement;
@XmlRootElement
public class Section {
	private int sectionId;
	private String sectionName;
	private int maxMarks;
	private HashMap<Integer,Question> questions;
	private TimeTable timetable;	
	public Section(){
	}	
	public Section(String sectionName, int maxMarks,
			HashMap<Integer, Question> questions, TimeTable timetable) {
		super();
		this.sectionName = sectionName;
		this.maxMarks = maxMarks;
		this.questions = questions;
		this.timetable = timetable;
	}

	public Section(int sectionId, String sectionName, int maxMarks,
			HashMap<Integer, Question> questions, TimeTable timetable) {
		super();
		this.sectionId = sectionId;
		this.sectionName = sectionName;
		this.maxMarks = maxMarks;
		this.questions = questions;
		this.timetable = timetable;
	}

	public int getSectionId() {
		return sectionId;
	}

	public void setSectionId(int sectionId) {
		this.sectionId = sectionId;
	}

	public String getSectionName() {
		return sectionName;
	}

	public void setSectionName(String sectionName) {
		this.sectionName = sectionName;
	}

	public int getMaxMarks() {
		return maxMarks;
	}

	public void setMaxMarks(int maxMarks) {
		this.maxMarks = maxMarks;
	}

	public HashMap<Integer, Question> getQuestions() {
		return questions;
	}

	public void setQuestions(HashMap<Integer, Question> questions) {
		this.questions = questions;
	}

	public TimeTable getTimetable() {
		return timetable;
	}

	public void setTimetable(TimeTable timetable) {
		this.timetable = timetable;
	}


	@Override
	public String toString() {
		return "Section [sectionId=" + sectionId + ", sectionName="
				+ sectionName + ", maxMarks=" + maxMarks + ", questions="
				+ questions + ", timetable=" + timetable + "]";
	}
	
	
	
}
