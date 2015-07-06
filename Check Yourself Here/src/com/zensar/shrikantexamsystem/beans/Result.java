package com.zensar.shrikantexamsystem.beans;

import java.util.ArrayList;

import javax.xml.bind.annotation.XmlRootElement;
@XmlRootElement
public class Result {
	private String grade;
	private double percentage;
	private int totalMaxMarks;
	private int totalObtainedMarks;
	private ArrayList<Score> scores;
	public Result() {
		super();
	}
	public Result(String grade, double percentage, int totalMaxMarks,
			int totalObtainedMarks, ArrayList<Score> scores) {
		super();
		this.grade = grade;
		this.percentage = percentage;
		this.totalMaxMarks = totalMaxMarks;
		this.totalObtainedMarks = totalObtainedMarks;
		this.scores = scores;
	}

	public String getGrade() {
		return grade;
	}

	public void setGrade(String grade) {
		this.grade = grade;
	}

	public double getPercentage() {
		return percentage;
	}

	public void setPercentage(double percentage) {
		this.percentage = percentage;
	}

	public int getTotalMaxMarks() {
		return totalMaxMarks;
	}

	public void setTotalMaxMarks(int totalMaxMarks) {
		this.totalMaxMarks = totalMaxMarks;
	}

	public int getTotalObtainedMarks() {
		return totalObtainedMarks;
	}

	public void setTotalObtainedMarks(int totalObtainedMarks) {
		this.totalObtainedMarks = totalObtainedMarks;
	}

	public ArrayList<Score> getScores() {
		return scores;
	}

	public void setScores(ArrayList<Score> scores) {
		this.scores = scores;
	}

	@Override
	public String toString() {
		return "Result [grade=" + grade + ", percentage=" + percentage
				+ ", totalMaxMarks=" + totalMaxMarks + ", totalObtainedMarks="
				+ totalObtainedMarks + ", scores=" + scores + "]";
	}
	
	
	
}
