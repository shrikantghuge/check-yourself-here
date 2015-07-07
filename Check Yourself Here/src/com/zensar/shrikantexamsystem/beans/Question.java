package com.zensar.shrikantexamsystem.beans;
import javax.xml.bind.annotation.XmlRootElement;
@XmlRootElement
public class Question {
	private String question;
	private String option1;
	private String option2;
	private String option3;
	private String option4;
	private int answer;
	private int marks;
	private int negativemarks; 
	
}
