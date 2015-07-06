package com.zensar.shrikantexamsystem.exceptions;
@SuppressWarnings("serial")
public class ExamAlreadyPresentException extends Exception {
	public ExamAlreadyPresentException() {super();}
	public ExamAlreadyPresentException(String message, Throwable cause) {super(message, cause);}
	public ExamAlreadyPresentException(String message) {super(message);}
	public ExamAlreadyPresentException(Throwable cause) {super(cause);}
}
