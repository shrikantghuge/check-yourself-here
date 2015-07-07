package com.zensar.shrikantexamsystem.beans;
import java.util.HashMap;
import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;
@XmlRootElement
public class Trainer {
	private int id;
	private String address;
	private String email;	
	private List<Subject> subjects;	
	private long mobileNo;
	private String trainerPassword;
}
