package com.zensar.shrikantexamsystem.zenemsservices;
import java.sql.SQLException;

import com.zensar.shrikantexamsystem.beans.Trainer;
import com.zensar.shrikantexamsystem.exceptions.ServicesNotFoundException;

public interface ExamServices {
	public String acceptTrainer(Trainer trainer) throws ServicesNotFoundException, SQLException, Exception;
	/*public boolean acceptExam(Exam exam) throws  ServicesNotFoundException,TrainerNotFoundException,ExamAlreadyPresentException;
	public boolean acceptSection(Exam exam,Section section) throws ExamNotFoundException,SectionAlreadyPresentException;
	public List<Exam> getAllExamDetails()throws ServicesNotFoundException;
	public Exam getExamDetails(Exam exam) throws ExamNotFoundException,ServicesNotFoundException;
	public List<Section> getAllSections(Exam exam) throws ExamNotFoundException,ServicesNotFoundException,SectionNotFoundException;
	public List<Trainee> getAllTrainees(Exam exam) throws ExamNotFoundException,ServicesNotFoundException,TraineeNotFoundException;
	public List<Question> getAllQuestions(Exam exam,Section section) throws ExamNotFoundException,ServicesNotFoundException,SectionNotFoundException,QuestionsNotFoundException;
	public boolean removeExam(Exam exam) throws ExamNotFoundException,ServicesNotFoundException;
	public boolean removeSection(Exam exam,Section section) throws ExamNotFoundException,SectionNotFoundException,ServicesNotFoundException;
	public boolean removeStudents(Exam exam) throws ExamNotFoundException,StudentsNotFoundException, ServicesNotFoundException;
	public boolean removeQuestion(Exam exam,Section section)  throws ExamNotFoundException,ServicesNotFoundException,SectionNotFoundException;
	public boolean updateExam(Exam exam) throws  ExamNotFoundException,ServicesNotFoundException;
	public boolean updateSection(Exam exam,Section section) throws ExamNotFoundException,ServicesNotFoundException,SectionNotFoundException;
	public boolean updateStudentList(Exam exam) throws ExamNotFoundException,ServicesNotFoundException;
	public boolean updateQuestionList(Exam exam,Section section) throws ExamNotFoundException,ServicesNotFoundException,SectionNotFoundException;
	public Trainee getTraineeDetails(int traineeId,int traineePassword) throws TraineeNotFoundException,ServicesNotFoundException;
	public boolean getTrainerLoginDetails(Trainer trainer) throws TrainerNotFoundException,InvalidPasswordException,ServicesNotFoundException;
	public boolean getTraineeLoginDetails(int examId,Trainee trainee) throws TraineeNotFoundException,InvalidPasswordException ,ServicesNotFoundException;
	public boolean giveExam(Trainee trainee,Exam exam,Section section,List<Question> userPaper) throws ExamNotFoundException,ServicesNotFoundException,SectionNotFoundException,QuestionsNotFoundException;
*/}
