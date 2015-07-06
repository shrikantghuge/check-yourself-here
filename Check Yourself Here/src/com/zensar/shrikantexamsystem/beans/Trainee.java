package com.zensar.shrikantexamsystem.beans;
import javax.xml.bind.annotation.XmlRootElement;
@XmlRootElement
public class Trainee {
	private int id;
	private String traineeName;
	private long traineeMobileNo;
	private String traineeEmailId;
	private String traineePassword;
	private Result result;
	public Trainee(int traineeId, String traineeName, long traineeMobileNo,
			String traineeEmailId, String traineePassword, Result result) {
		super();
		this.id = traineeId;
		this.traineeName = traineeName;
		this.traineeMobileNo = traineeMobileNo;
		this.traineeEmailId = traineeEmailId;
		this.traineePassword = traineePassword;
		this.result = result;
	}
	public Trainee(String traineeName, long traineeMobileNo,
			String traineeEmailId, String traineePassword, Result result) {
		super();
		this.traineeName = traineeName;
		this.traineeMobileNo = traineeMobileNo;
		this.traineeEmailId = traineeEmailId;
		this.traineePassword = traineePassword;
		this.result = result;
	}
	public Trainee() {
		super();
	}
	public int getTraineeId() {
		return id;
	}
	public void setTraineeId(int traineeId) {
		this.id = traineeId;
	}
	public String getTraineeName() {
		return traineeName;
	}
	public void setTraineeName(String traineeName) {
		this.traineeName = traineeName;
	}
	public long getTraineeMobileNo() {
		return traineeMobileNo;
	}
	public void setTraineeMobileNo(long traineeMobileNo) {
		this.traineeMobileNo = traineeMobileNo;
	}
	public String getTraineeEmailId() {
		return traineeEmailId;
	}
	public void setTraineeEmailId(String traineeEmailId) {
		this.traineeEmailId = traineeEmailId;
	}
	public String getTraineePassword() {
		return traineePassword;
	}
	public void setTraineePassword(String traineePassword) {
		this.traineePassword = traineePassword;
	}
	public Result getResult() {
		return result;
	}
	public void setResult(Result result) {
		this.result = result;
	}
	@Override
	public String toString() {
		return "Trainee [traineeId=" + id + ", traineeName="
				+ traineeName + ", traineeMobileNo=" + traineeMobileNo
				+ ", traineeEmailId=" + traineeEmailId + ", traineePassword="
				+ traineePassword + ", result=" + result + "]";
	}
}

