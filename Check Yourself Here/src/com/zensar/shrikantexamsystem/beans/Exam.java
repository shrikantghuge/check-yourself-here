package com.zensar.shrikantexamsystem.beans;

import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;
@XmlRootElement
public class Exam {
	private int id;
	private String moduleName;
	private int maxMarks;
	private List<Question> questions;
	private TimeTable timeTable;
}
