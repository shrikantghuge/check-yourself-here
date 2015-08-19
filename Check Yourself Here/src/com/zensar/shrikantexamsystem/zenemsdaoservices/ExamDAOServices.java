package com.zensar.shrikantexamsystem.zenemsdaoservices;
import java.sql.SQLException;

import com.zensar.shrikantexamsystem.beans.Trainer;
import com.zensar.shrikantexamsystem.exceptions.ServicesNotFoundException;

public interface ExamDAOServices {
	public String insertTrainer(Trainer trainer) throws SQLException, Exception;
	/*
	public String insertExam(Exam exam) throws SQLException;
	boolean insertSection(Exam exam, Section section) throws SQLException;	
	boolean insertQuestions(List<Question> questions, Section section)throws SQLException;
	public boolean insertTrainee(List<Trainee> trainees,Exam exam) throws SQLException;	
	public Exam retrieveExam(int examId) throws SQLException;
	public List<Exam> retrieveExams(int trainerId) throws SQLException;
	public List<Section> retrieveSections(int examId) throws SQLException;
	public List<Trainee> retrieveTrainees(int examId) throws SQLException;
	public Section retrieveSection(int examId,int sectionId) throws SQLException;*/
	public Trainer retrieveTrainer(String traineeId) throws SQLException;	/*
	public boolean updateExam(Exam exam) throws SQLException;
	public boolean updateTrainer(Trainer trainer) throws SQLException;
	public boolean updateSection(Section section) throws SQLException;	
	public boolean deleteExam(Exam exam) throws SQLException;
	public boolean deleteSection(Section section) throws SQLException;
	public boolean deleteQuestions(int sectionId) throws SQLException;
	public boolean deleteStudents(int examId) throws SQLException;
	public Trainer retrieveTrainer(Trainer trainer) throws SQLException;
	public boolean insertStudentDetails(String filePath) throws SQLException, IOException;	
*/
	public boolean setToken(String id, int randomNum) throws ServicesNotFoundException;}
