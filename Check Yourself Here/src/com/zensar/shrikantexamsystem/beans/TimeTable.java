package com.zensar.shrikantexamsystem.beans;
import java.util.Date;

import javax.xml.bind.annotation.XmlRootElement;

/*
 * this class have contains schedule for an examination
 * 
 * @author Shrikant Ghuge
 * @since v1.0
 * */
@XmlRootElement
public class TimeTable {
	private float startTime;
	private float endTime;
	private Date date;
	
	public TimeTable() {
		super();
	}
	public TimeTable(float startTime, float endTime, Date date) {
		super();
		this.startTime = startTime;
		this.endTime = endTime;
		this.date = date;
	}
	
	public float getStartTime() {
		return startTime;
	}
	public void setStartTime(float startTime) {
		this.startTime = startTime;
	}
	public float getEndTime() {
		return endTime;
	}
	public void setEndTime(float endTime) {
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
