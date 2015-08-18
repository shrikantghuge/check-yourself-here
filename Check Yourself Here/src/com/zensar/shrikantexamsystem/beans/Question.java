package com.zensar.shrikantexamsystem.beans;


import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;

/*
 * This class wrap the questions for an examination
 * 
 * @author Shriaknt Ghuge
 * @since v1.0
 * */
@XmlRootElement
public class Question {
	private String question;
	private List<String> options;
	private int answer;
	private int marks;
	private int negativemarks;
	
	public Question() {
		super();
	}
	public Question(String question, List<String> options, int answer,
			int marks, int negativemarks) {
		super();
		this.question = question;
		this.options = options;
		this.answer = answer;
		this.marks = marks;
		this.negativemarks = negativemarks;
	}
	
	public String getQuestion() {
		return question;
	}
	public void setQuestion(String question) {
		this.question = question;
	}
	public List<String> getOptions() {
		return options;
	}
	public void setOptions(List<String> options) {
		this.options = options;
	}
	public int getAnswer() {
		return answer;
	}
	public void setAnswer(int answer) {
		this.answer = answer;
	}
	public int getMarks() {
		return marks;
	}
	public void setMarks(int marks) {
		this.marks = marks;
	}
	public int getNegativemarks() {
		return negativemarks;
	}
	public void setNegativemarks(int negativemarks) {
		this.negativemarks = negativemarks;
	}
	
	@Override
	public String toString() {
		return "Question [question=" + question + ", options=" + options
				+ ", answer=" + answer + ", marks=" + marks
				+ ", negativemarks=" + negativemarks + "]";
	}	
	
}
