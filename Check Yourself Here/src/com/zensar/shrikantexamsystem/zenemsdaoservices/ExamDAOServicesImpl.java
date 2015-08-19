package com.zensar.shrikantexamsystem.zenemsdaoservices;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import com.zensar.shrikantexamsystem.beans.*;
import com.zensar.shrikantexamsystem.exceptions.ServicesNotFoundException;
import com.zensar.shrikantexamsystem.serviceprovider.ConnectionProvider;
public class ExamDAOServicesImpl implements ExamDAOServices{
	PreparedStatement pstmt;
	ResultSet rs;
	Connection con;
	public ExamDAOServicesImpl() throws SQLException, ServicesNotFoundException {
		con=ConnectionProvider.getConnection();
	}
	/*
	@Override
	public String insertExam(Exam exam) throws SQLException {
		try{
			pstmt=con.prepareStatement("insert into Exam(examName) values(?)");
			pstmt.setString(1, exam.getExamName());
			pstmt.executeUpdate();
			return exam.getExamName();
		}
		finally{
			if(pstmt!=null)	pstmt.close();
			if(con!=null) con.close();
		}
	}
	@Override
	public boolean insertSection(Exam exam,Section section) throws SQLException {
		try{
			pstmt=con.prepareStatement("insert into Section(sectionName,maxMarks,startTime,endTime,day,month,year,examId) values(?,?,?,?,?,?,?,?)");
			pstmt.setString(1, section.getSectionName());
			pstmt.setInt(2, section.getMaxMarks());
			pstmt.setDouble(3, section.getTimetable().getStartTime());
			pstmt.setDouble(4, section.getTimetable().getEndTime());
			pstmt.setInt(5,section.getTimetable().getDate().getDay());
			pstmt.setInt(6, section.getTimetable().getDate().getMonth());
			pstmt.setInt(7, section.getTimetable().getDate().getYear());
			pstmt.setInt(8, exam.getExamId());
			pstmt.executeUpdate();
			return true;
		}finally{
			if(pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}
	}
 	*/
	@Override
	public String insertTrainer(Trainer trainer) throws Exception {
		String trainerOrStudent=trainer.getEmail().split("#")[1];
		trainer.setEmail(trainer.getEmail().split("#")[0]);
		int result;
		if(!trainerOrStudent.equalsIgnoreCase("trainer") && !trainerOrStudent.equalsIgnoreCase("student")) throw new Exception("You are not authorised person to signup");
		try{
			pstmt=con.prepareStatement("insert into person(ID,name,address,email,contactNumber,password,designation) values(?,?,?,?,?,?,?)");
			pstmt.setString(1, trainer.getId());
			pstmt.setString(2, trainer.getName());
			pstmt.setString(3, trainer.getAddress());
			pstmt.setString(4, trainer.getEmail());
			pstmt.setLong(5, trainer.getContactNumber());
			pstmt.setString(6, trainer.getPassword());
			pstmt.setString(7, trainerOrStudent);
			result = pstmt.executeUpdate();
			if(result>=1){
				return trainer.getId();
			}else {
				return "got error";
			}			
		}
		finally{
			if(pstmt!=null)	pstmt.close();
			//if(con!=null) con.close();
		}
	}

	/*	
	@Override
	public boolean insertQuestions(List<Question> questions,Section section)
			throws SQLException {
		try{
			for (Question question : questions) {
				pstmt=con.prepareStatement("insert into Question(question,option1,option2,option3,option4,answer,marks,sectionId) values(?,?,?,?,?,?,?,?)");
				pstmt.setString(1, question.getQuestion());
				pstmt.setString(2, question.getOption1());
				pstmt.setString(3, question.getOption2());
				pstmt.setString(4, question.getOption3());
				pstmt.setString(5, question.getOption4());
				pstmt.setInt(6, question.getAnswer());
				pstmt.setInt(7, question.getMarks());
				pstmt.setInt(8, section.getSectionId());
				pstmt.executeUpdate();
			}
			return true;
		}
		finally{
			if(pstmt!=null)	pstmt.close();
			if(con!=null) con.close();
		}
	}

	@Override
	public boolean insertTrainee(List<Trainee> trainees,Exam exam) throws SQLException {
		int traineeId=0;
		try{
			for (Trainee trainee : trainees) {
				pstmt=con.prepareStatement("insert into Trainee(traineeName,traineeMobileNo,traineeEmailId,traineePassword) values(?,?,?,?)");
				pstmt.setString(1, trainee.getTraineeName());
				pstmt.setLong(2, trainee.getTraineeMobileNo());
				pstmt.setString(3, trainee.getTraineeEmailId());
				pstmt.setString(4, trainee.getTraineePassword());
				pstmt.executeUpdate();
				pstmt=con.prepareStatement("select max(traineeId) from Trainee");
				rs=pstmt.executeQuery();
				if(rs.next()) traineeId=rs.getInt(1);
				pstmt=con.prepareStatement("insert into traineeexam(traineeId,examId) values(?,?)");
				pstmt.setInt(1, traineeId);
				pstmt.setInt(2, exam.getExamId());
				pstmt.executeUpdate();
			}
			return true;
		}
		finally{
			if(pstmt!=null)	pstmt.close();
			if(con!=null) con.close();
			if(rs!=null) rs.close();
		}
	}

	@Override
	public Exam retrieveExam(int examId) throws SQLException {
		Connection conn=con;
		Statement stmt= conn.createStatement();
		ResultSet rs=null;
		try {
			HashMap<Integer, Trainee> trainees = new HashMap<Integer,Trainee>(); 
			HashMap<Integer, Section> sections = new HashMap<Integer,Section>();
			rs = stmt.executeQuery("select * from exam where examId="+examId);
			for (Iterator<Trainee> iterator = retrieveTrainees(examId).iterator(); iterator.hasNext();) {
				Trainee trainee = (Trainee) iterator.next();
				trainees.put(trainee.getTraineeId(), trainee); 
			}
			for (Iterator<Section> iterator = retrieveSections(examId).iterator(); iterator.hasNext();) {
				Section section = (Section) iterator.next();
				sections.put(section.getSectionId(), section);			
			}
			if(rs.next()) return new Exam(examId, rs.getString("examName"), trainees, sections);
			return null;
		} finally{
			if(conn!=null) conn.close();
			if(rs!=null) rs.close();
			if(stmt!=null) stmt.close();
		}
	}

	@Override
	public List<Exam> retrieveExams(int trainerId) throws SQLException {
		Connection conn=con;
		Statement stmt= conn.createStatement();
		ResultSet rs=null;
		try {
			ArrayList<Exam> exams = new ArrayList<Exam>();
			rs = stmt.executeQuery("select e.examId from exam e inner join trainerexam t on e.examId=t.examId  where t.trainerId="+trainerId);
			while(rs.next()){
				exams.add(retrieveExam(rs.getInt(1)));
			}
			return exams;
		} finally{
			if(conn!=null) conn.close();
			if(rs!=null) rs.close();
			if(stmt!=null) stmt.close();
		}
	}

	@Override
	public List<Section> retrieveSections(int examId) throws SQLException {
		Connection conn=con;
		Statement stmt= conn.createStatement();
		ResultSet rs=null;
		try {
			ArrayList<Section> sections = new ArrayList<Section>();
			rs = stmt.executeQuery("select sectionId from section where examId="+examId);
			while(rs.next()){
				sections.add(retrieveSection(examId, rs.getInt("sectionId")));
			}
			return sections;
		} finally{
			if(conn!=null) conn.close();
			if(rs!=null) rs.close();
			if(stmt!=null) stmt.close();
		}
	}
	@Override
	public List<Trainee> retrieveTrainees(int examId) throws SQLException {
		Connection conn=con;
		Statement stmt= conn.createStatement();
		ResultSet rs=null;
		try {
			ArrayList<Trainee> trainees = new ArrayList<Trainee>();
			rs= stmt.executeQuery("select t.traineeId from trainee t inner join traineeexam te  on t.traineeId=te.traineeId  where te.examId="+examId);
			while(rs.next()){
				trainees.add(retrieveTrainee(examId, rs.getInt(1)));
			}
			return trainees;
		} finally{
			if(conn!=null) conn.close();
			if(rs!=null) rs.close();
			if(stmt!=null) stmt.close();
		}
	}

	@Override
	public Section retrieveSection(int examId, int sectionId)throws SQLException {
		Connection conn=con;
		Statement stmt= conn.createStatement();
		ResultSet rs=null;
		try {

			HashMap<Integer, Question> questions = new HashMap<Integer,Question>();
			rs= stmt.executeQuery("select * from question where sectionId="+sectionId);
			while(rs.next()){
				questions.put(rs.getInt("questionId"), new Question(rs.getInt("questionId"), rs.getString("question"), rs.getString("option1"), rs.getString("option2"), rs.getString("option3"), rs.getString("option4"), rs.getInt("answer"), rs.getInt("marks")));
			}
			rs = stmt.executeQuery("select * from section where sectionId="+sectionId+"and"+"examId="+examId);
			if(rs.next()) return new Section(sectionId, rs.getString("sectionName"), rs.getInt("maxMarks"), questions, new TimeTable(rs.getDouble("startTime"), rs.getDouble("endTime"), new Date(rs.getInt("day"),rs.getInt("month"), rs.getInt("year"))));
			else return null;
		} finally{
			if(conn!=null) conn.close();
			if(rs!=null) rs.close();
			if(stmt!=null) stmt.close();
		}
	}*/

	@Override
	public Trainer retrieveTrainer(String traineeId)throws SQLException {
		Connection conn=con;
		Statement stmt= conn.createStatement();
		ResultSet rs=null;
		try {			
			rs = stmt.executeQuery("select * from person where Id='"+traineeId+"'");			
			if(rs.next()) return new Trainer(rs.getString(1), rs.getString(2), rs.getString(5), rs.getString(4), null, rs.getLong(3), rs.getString(6));
			else return null;
		} finally{
			//if(conn!=null) conn.close();
			if(rs!=null) rs.close();
			if(stmt!=null) stmt.close();
		}
	}
	@Override
	public boolean setToken(Trainer trainerResult, int randomNum) throws ServicesNotFoundException {		
		try {
			Statement stmt = con.createStatement();
			 if(stmt.executeUpdate("insert into person(token) values("+randomNum+")")>0){
				 return true;
			 }else{
				 return false;
			 }
		} catch (SQLException e) {			
			e.printStackTrace();
			throw new ServicesNotFoundException("Service Not found");
		}		
	}

	/*@Override
	public boolean updateExam(Exam exam) throws SQLException {
		try {
			pstmt = con.prepareStatement("update exam set examName=? where examId = ?");
			pstmt.setString(1, exam.getExamName());
			pstmt.setInt(2, exam.getExamId());
			pstmt.executeUpdate();
			for (Integer sectionId : exam.getSections().keySet()) {
				updateSection(exam.getSections().get(sectionId));
			}
			return true;
		} catch (SQLException e) {
			System.out.println("update EXAM: "+e.getMessage());
			throw e;
		} finally {
			if(con!=null) con.close();
			if(pstmt!=null) pstmt.close();
		}	
	}

	@Override
	public boolean updateTrainer(Trainer trainer) throws SQLException {
		try {
			pstmt = con.prepareStatement("update Trainer set trainerName=?,speciality=?,trainerEmailId=?,trainerMobileNo=?,trainerPassword=? where trainerId=?");
			pstmt.setString(1, trainer.getTrainerName());
			pstmt.setString(2, trainer.getSpeciality());
			pstmt.setString(3, trainer.getTrainerEmailId());
			pstmt.setLong(4, trainer.getTrainerMobileNo());
			pstmt.setString(5, trainer.getTrainerPassword());
			pstmt.setInt(6, trainer.getTrainerId());
			pstmt.executeUpdate();
			return true;
		} catch (SQLException e) {
			System.out.println("Update Trainer"+e.getMessage());
			throw e;
		} finally {
			if(con!=null) con.close();
			if(pstmt!=null) pstmt.close();
		}
	}

	@Override
	public boolean updateSection(Section section) throws SQLException {
		try {
			pstmt = con.prepareStatement("update section set sectionName=?,maxMarks=?,startTime=?,endTime=?,day=?,month=?,year=? where sectionId=?");
			pstmt.setString(1, section.getSectionName());
			pstmt.setInt(2, section.getMaxMarks());
			pstmt.setDouble(3, section.getTimetable().getStartTime());
			pstmt.setDouble(4, section.getTimetable().getEndTime());
			pstmt.setInt(5, section.getTimetable().getDate().getDay());
			pstmt.setInt(6, section.getTimetable().getDate().getMonth());
			pstmt.setInt(7, section.getTimetable().getDate().getYear());
			pstmt.setInt(8, section.getSectionId());
			return true;
		} catch (SQLException e) {
			System.out.println("Update Section "+e.getMessage());
			throw e;
		} finally {
			if(con!=null) con.close();
			if(pstmt!=null) pstmt.close();
		}
	}

	@Override
	public boolean deleteExam(Exam exam) throws SQLException {
		try {
			pstmt = con.prepareStatement("delete from exam where examId=?");
			pstmt.setInt(1, exam.getExamId());
			return true;
		} catch (SQLException e) {
			System.out.println("Delete exam "+e.getMessage());
			throw e;
		} finally {
			if(con!=null) con.close();
			if(pstmt!=null) pstmt.close();
		}
	}

	@Override
	public boolean deleteSection(Section section) throws SQLException {
		try {
			pstmt = con.prepareStatement("delete from section where sectionId=?");
			pstmt.setInt(2, section.getSectionId());
			return true;
		} catch (SQLException e) {
			System.out.println("Delete sections "+e.getMessage());
			throw e;
		} finally {
			if(con!=null) con.close();
			if(pstmt!=null) pstmt.close();
		}
	}

	@Override
	public boolean deleteQuestions(int sectionId) throws SQLException {
		try {
			pstmt = con.prepareStatement("delete from question where sectionId=?");
			pstmt.setInt(1, sectionId);
			pstmt.executeUpdate();
			return true;
		} catch (SQLException e) {
			System.out.println("Delete questions "+e.getMessage());
			throw e;
		} finally {
			if(con!=null) con.close();
			if(pstmt!=null) pstmt.close();
		}
	}

	@Override
	public boolean deleteStudents(int examId) throws SQLException {
		try {
			pstmt = con.prepareStatement("delete from traineeExam where examId=?");
			pstmt.setInt(1, examId);
			pstmt.executeUpdate();
			return true;
		} catch (SQLException e) {
			System.out.println("Delete student "+e.getMessage());
			throw e;
		} finally {
			if(pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}
	}
	@Override
	public Trainer retrieveTrainer(Trainer trainer) throws SQLException {
		Connection conn=con;
		Statement stmt= conn.createStatement();
		ResultSet rs=null;
		try {
			HashMap<Integer, Exam> exams = new HashMap<Integer,Exam>();
			for (Iterator<Exam> iterator = retrieveExams(trainer.getTrainerId()).iterator(); iterator.hasNext();) {
				Exam exam = (Exam) iterator.next();
				exams.put(exam.getExamId(), exam);			
			}
			rs= stmt.executeQuery("select * from trainer where trainerId="+trainer.getTrainerId());
			if(rs.next()) return new Trainer(trainer.getTrainerId(),rs.getString("trainerName"), rs.getString("speciality"), rs.getString("trainerEmailId"), rs.getLong("trainerMobileNo"), rs.getString("trainerPassword"), exams);
			else return null;
		} finally {
			if(stmt!=null) pstmt.close();
			if(con!=null) con.close();
			if(rs!=null) rs.close(); 			
		}
	}
	@Override
	public boolean insertStudentDetails(String filePath) throws SQLException,IOException {
		// TODO Auto-generated method stub
		return false;
	}
*/}

//TODO: Connection pool
//TODO : Excelsheel reading method 
