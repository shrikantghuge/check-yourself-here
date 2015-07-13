package com.zensar.shrikantexamsystem.zenemsservices;

import java.sql.SQLException;
import java.util.List;
import java.util.Random;

import com.mysql.jdbc.exceptions.jdbc4.MySQLIntegrityConstraintViolationException;
import com.zensar.shrikantexamsystem.beans.Trainer;
import com.zensar.shrikantexamsystem.exceptions.ServicesNotFoundException;
import com.zensar.shrikantexamsystem.zenemsdaoservices.ExamDAOServices;
import com.zensar.shrikantexamsystem.zenemsdaoservices.ExamDAOServicesImpl;

public class ExamServicesImpl implements ExamServices{
	ExamDAOServices emsdaoServices;
	public ExamServicesImpl() throws ServicesNotFoundException {
		try {
			emsdaoServices = new ExamDAOServicesImpl();
		} catch (SQLException e) {
			e.printStackTrace();
			throw new ServicesNotFoundException("Service not Found", e);
		}
	}
	@Override
	public String acceptTrainer(Trainer trainer) throws SQLException{	
			String id = getTrainerId(trainer,0);
			trainer.setId(id);
			emsdaoServices.insertTrainer(trainer);
		return "error";
	}
	/*@Override
	public boolean acceptExam(Exam exam) throws ServicesNotFoundException,
			TrainerNotFoundException, ExamAlreadyPresentException {
		// TODO Auto-generated method stub
		return false;
	}
	@Override
	public boolean acceptSection(Exam exam, Section section)
			throws ExamNotFoundException, SectionAlreadyPresentException {
		// TODO Auto-generated method stub
		return false;
	}
	@Override
	public List<Exam> getAllExamDetails() throws ServicesNotFoundException {
		// TODO Auto-generated method stub
		return null;
	}
	@Override
	public Exam getExamDetails(Exam exam) throws ExamNotFoundException,
			ServicesNotFoundException {
		// TODO Auto-generated method stub
		return null;
	}
	@Override
	public List<Section> getAllSections(Exam exam)
			throws ExamNotFoundException, ServicesNotFoundException,
			SectionNotFoundException {
		// TODO Auto-generated method stub
		return null;
	}
	@Override
	public List<Trainee> getAllTrainees(Exam exam)
			throws ExamNotFoundException, ServicesNotFoundException,
			TraineeNotFoundException {
		// TODO Auto-generated method stub
		return null;
	}
	@Override
	public List<Question> getAllQuestions(Exam exam, Section section)
			throws ExamNotFoundException, ServicesNotFoundException,
			SectionNotFoundException, QuestionsNotFoundException {
		// TODO Auto-generated method stub
		return null;
	}
	@Override
	public boolean removeExam(Exam exam) throws ExamNotFoundException,ServicesNotFoundException {
		try {
			getExamDetails(exam);
			return emsdaoServices.deleteExam(exam);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new ServicesNotFoundException("Service Not Found", e);
		}
	}
	@Override
	public boolean removeSection(Exam exam, Section section)throws ExamNotFoundException, SectionNotFoundException,ServicesNotFoundException {
		try {
			getSection(exam, section.getSectionId());
			return emsdaoServices.deleteSection(section);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new ServicesNotFoundException("Service Not Found", e);
		}
	}
	@Override
	public boolean removeStudents(Exam exam) throws ExamNotFoundException,StudentsNotFoundException, ServicesNotFoundException {
		try {
			getExamDetails(exam);
			return emsdaoServices.deleteStudents(exam.getExamId());
		} catch (SQLException e) {
			e.printStackTrace();
			throw new ServicesNotFoundException("Service Not Found",e);
		}		
	}
	@Override
	public boolean removeQuestion(Exam exam, Section section)throws ExamNotFoundException, ServicesNotFoundException,SectionNotFoundException {
		try {
			getSection(exam, section.getSectionId());
			return emsdaoServices.deleteQuestions(section.getSectionId());
		} catch (SQLException e) {
			e.printStackTrace();
			throw new ServicesNotFoundException("Service Not Found", e);
		}		
	}
	@Override
	public boolean updateExam(Exam exam) throws ExamNotFoundException,ServicesNotFoundException {
		try {
			getExamDetails(exam);
			return emsdaoServices.updateExam(exam);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new ServicesNotFoundException("Service Not Found", e);
		}		
	}
	@Override
	public boolean updateSection(Exam exam, Section section)throws ExamNotFoundException, ServicesNotFoundException,SectionNotFoundException {
		try {
			getSection(exam, section.getSectionId());
			return emsdaoServices.updateSection(section);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new ServicesNotFoundException("Service Not Found", e);
		}
	}
	@Override
	public boolean updateStudentList(Exam exam) throws ExamNotFoundException,ServicesNotFoundException {
		//TODO: Update student in dao
		return false;
	}
	@Override
	public boolean updateQuestionList(Exam exam, Section section)throws ExamNotFoundException, ServicesNotFoundException,SectionNotFoundException {
		//TODO:Update Question list
		return false;
	}
	@Override
	public Trainee getTraineeDetails(int traineeId, int traineePassword)throws TraineeNotFoundException, ServicesNotFoundException {
		// TODO Auto-generated method stub
		return null;
	}
	@Override
	public boolean getTrainerLoginDetails(Trainer trainer)throws TrainerNotFoundException, InvalidPasswordException,ServicesNotFoundException {
		try {
			Trainer trainer2 = emsdaoServices.retrieveTrainer(trainer);
			if(trainer2==null) throw new TrainerNotFoundException("There is no trainer associate with Id :"+trainer.getTrainerId());
			if(trainer2.getTrainerPassword()==trainer.getTrainerPassword().trim()) return true;
			else return false;
		} catch (SQLException e) {
			e.printStackTrace();
			throw new ServicesNotFoundException("Service Not Found", e);
		}
	}
	@Override
	public boolean getTraineeLoginDetails(int examId,Trainee trainee)throws TraineeNotFoundException, InvalidPasswordException,ServicesNotFoundException {
		try {
			Trainee traineeLogin = emsdaoServices.retrieveTrainee(examId, trainee.getTraineeId());
			if(traineeLogin==null) throw new TraineeNotFoundException("There is no trainee associated with "+trainee.getTraineeId());
			if(trainee.getTraineePassword().trim().equals(traineeLogin.getTraineePassword())) return true;
			else return false;
		} catch (SQLException e) {
			e.printStackTrace();
			throw new ServicesNotFoundException("Service Not Found", e);
		}
	}
	@Override
	public boolean giveExam(Trainee trainee, Exam exam, Section section,
			List<Question> userPaper) throws ExamNotFoundException,
			ServicesNotFoundException, SectionNotFoundException,
			QuestionsNotFoundException {
		// TODO Auto-generated method stub
		return false;
	}
	public Section getSection(Exam exam,int sectionId){
		return null;
	}
*/
	private String getTrainerId(Trainer trainerParam,int index) throws SQLException{
		Trainer trainer = new Trainer("", trainerParam.getName(), "", "", null, 0, "");
		String resultString="";
		do{
			String nameWOSpaces=trainer.getName().replaceAll("\\s+", "");			
			System.out.println("Name without spaces is :"+nameWOSpaces);
			if(nameWOSpaces.length()<7){
				RandomString randomString = new RandomString(7-nameWOSpaces.length());
				resultString= nameWOSpaces +  randomString.nextString();
			}else if(nameWOSpaces.substring(index,nameWOSpaces.length()).length()<7){
				//getTrainerId(new Trainer("", nameWOSpaces.substring(index,nameWOSpaces.length()), "", "", null, 0, ""), index);
				trainer.setName(nameWOSpaces.substring(index,nameWOSpaces.length()));
			}else{
				resultString = nameWOSpaces.substring(index,index+7);
				index++;
			}			
			System.out.println("The result string is "+resultString +" And data retrived"+emsdaoServices.retrieveTrainee(resultString));
			
		}while(emsdaoServices.retrieveTrainee(resultString)!=null);
		return resultString;
	}
}

