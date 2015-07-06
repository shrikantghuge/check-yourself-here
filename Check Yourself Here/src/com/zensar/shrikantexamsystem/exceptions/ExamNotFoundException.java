package com.zensar.shrikantexamsystem.exceptions;
@SuppressWarnings("serial")
public class ExamNotFoundException extends Exception {
	public ExamNotFoundException() {super();}
	public ExamNotFoundException(String message, Throwable cause) {super(message, cause);}
	public ExamNotFoundException(String message) {super(message);}
	public ExamNotFoundException(Throwable cause) {super(cause);}
}
