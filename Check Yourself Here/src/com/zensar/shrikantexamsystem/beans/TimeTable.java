package com.zensar.shrikantexamsystem.beans;
import java.util.Date;

import javax.xml.bind.annotation.XmlRootElement;
@XmlRootElement
public class TimeTable {
	private float startTime;
	private float endTime;
	private Date date;
}
