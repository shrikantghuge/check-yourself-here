package com.zensar.shrikantexamsystem.beans;
import java.util.HashMap;
import javax.xml.bind.annotation.XmlRootElement;
@XmlRootElement
public class Trainer {
	private int id;
	private String trainerName;
	private String speciality;
	private String trainerEmailId;
	private long trainerMobileNo;
	private String trainerPassword;
	private HashMap<Integer, Exam> exams;
	public Trainer(int trainerId, String trainerName, String speciality,
			String trainerEmailId, long trainerMobileNo,
			String trainerPassword, HashMap<Integer, Exam> exams) {
		super();
		this.id = trainerId;
		this.trainerName = trainerName;
		this.speciality = speciality;
		this.trainerEmailId = trainerEmailId;
		this.trainerMobileNo = trainerMobileNo;
		this.trainerPassword = trainerPassword;
		this.exams = exams;
	}	
	public Trainer(int trainerId, String trainerName, String speciality,
			String trainerEmailId, long trainerMobileNo, String trainerPassword) {
		super();
		this.id = trainerId;
		this.trainerName = trainerName;
		this.speciality = speciality;
		this.trainerEmailId = trainerEmailId;
		this.trainerMobileNo = trainerMobileNo;
		this.trainerPassword = trainerPassword;
	}

	public Trainer(String trainerName, String speciality,
			String trainerEmailId, long trainerMobileNo,
			String trainerPassword, HashMap<Integer, Exam> exams) {
		super();
		this.trainerName = trainerName;
		this.speciality = speciality;
		this.trainerEmailId = trainerEmailId;
		this.trainerMobileNo = trainerMobileNo;
		this.trainerPassword = trainerPassword;
		this.exams = exams;
	}
	public Trainer() {
		super();
	}
	public int getTrainerId() {
		return id;
	}
	public void setTrainerId(int trainerId) {
		this.id = trainerId;
	}
	public String getTrainerName() {
		return trainerName;
	}
	public void setTrainerName(String trainerName) {
		this.trainerName = trainerName;
	}
	public String getSpeciality() {
		return speciality;
	}
	public void setSpeciality(String speciality) {
		this.speciality = speciality;
	}
	public String getTrainerEmailId() {
		return trainerEmailId;
	}
	public void setTrainerEmailId(String trainerEmailId) {
		this.trainerEmailId = trainerEmailId;
	}
	public long getTrainerMobileNo() {
		return trainerMobileNo;
	}
	public void setTrainerMobileNo(long trainerMobileNo) {
		this.trainerMobileNo = trainerMobileNo;
	}
	public String getTrainerPassword() {
		return trainerPassword;
	}
	public void setTrainerPassword(String trainerPassword) {
		this.trainerPassword = trainerPassword;
	}
	public HashMap<Integer, Exam> getExams() {
		return exams;
	}
	public void setExams(HashMap<Integer, Exam> exams) {
		this.exams = exams;
	}
	@Override
	public String toString() {
		return "Trainer [trainerId=" + id + ", trainerName="
				+ trainerName + ", speciality=" + speciality
				+ ", trainerEmailId=" + trainerEmailId + ", trainerMobileNo="
				+ trainerMobileNo + ", trainerPassword=" + trainerPassword
				+ ", exams=" + exams + "]";
	}
}
