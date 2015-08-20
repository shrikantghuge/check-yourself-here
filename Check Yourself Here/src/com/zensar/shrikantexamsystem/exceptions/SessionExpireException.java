package com.zensar.shrikantexamsystem.exceptions;

@SuppressWarnings("serial")
public class SessionExpireException extends Exception{

	public SessionExpireException() {super();}

	public SessionExpireException(String message, Throwable cause,boolean enableSuppression, boolean writableStackTrace) {
		super(message, cause, enableSuppression, writableStackTrace);
	}

	public SessionExpireException(String message, Throwable cause) {super(message, cause);}

	public SessionExpireException(String message) {super(message);}

	public SessionExpireException(Throwable cause) {super(cause);}
}
