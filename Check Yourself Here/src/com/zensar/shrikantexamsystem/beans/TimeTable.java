package com.zensar.shrikantexamsystem.beans;
import javax.xml.bind.annotation.XmlRootElement;
@XmlRootElement
public class TimeTable {
	private double startTime;
	private double endTime;
	private Date date;
	public TimeTable(){}
	public TimeTable(double startTime, double endTime, Date date) {
		super();
		this.startTime = startTime;
		this.endTime = endTime;
		this.date = date;
	}
	public double getStartTime() {
		return startTime;
	}
	public void setStartTime(double startTime) {
		this.startTime = startTime;
	}
	public double getEndTime() {
		return endTime;
	}
	public void setEndTime(double endTime) {
		this.endTime = endTime;
	}
	public Date getDate() {
		return date;
	}
	public void setDate(Date date) {
		this.date = date;
	}
	@Override
	public String toString() {
		return "TimeTable [startTime=" + startTime + ", endTime=" + endTime
				+ ", date=" + date + "]";
	}	
}
