package com.zensar.shrikantexamsystem.beans;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class Score {
	private int traineeId;
	private int obtainedMarks;
	private Section section;
	private String status;
	public Score() {
		super();
	}
	public Score(int traineeId, int obtainedMarks, Section section,
			String status) {
		super();
		this.traineeId = traineeId;
		this.obtainedMarks = obtainedMarks;
		this.section = section;
		this.status = status;
	}
	public int getTraineeId() {
		return traineeId;
	}
	public void setTraineeId(int traineeId) {
		this.traineeId = traineeId;
	}
	public int getObtainedMarks() {
		return obtainedMarks;
	}
	public void setObtainedMarks(int obtainedMarks) {
		this.obtainedMarks = obtainedMarks;
	}
	public Section getSection() {
		return section;
	}
	public void setSection(Section section) {
		this.section = section;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	@Override
	public String toString() {
		return "Score [traineeId=" + traineeId + ", obtainedMarks="
				+ obtainedMarks + ", section=" + section + ", status=" + status
				+ "]";
	}
}
