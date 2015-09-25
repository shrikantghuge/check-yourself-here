package com.zensar.shrikantexamsystem.controller;
import java.sql.SQLException;

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.zensar.shrikantexamsystem.beans.Trainer;
import com.zensar.shrikantexamsystem.exceptions.ServicesNotFoundException;
import com.zensar.shrikantexamsystem.exceptions.SessionExpireException;
import com.zensar.shrikantexamsystem.exceptions.TrainerNotFoundException;
import com.zensar.shrikantexamsystem.zenemsservices.ExamServices;
import com.zensar.shrikantexamsystem.zenemsservices.ExamServicesImpl;
@Path("/trainer")
public class TrainerResource {
	private ExamServices examServices;
	private static final Logger LOGGER = LoggerFactory.getLogger(ExamResource.class);
	public TrainerResource() {
		try {
			examServices = new ExamServicesImpl();
			LOGGER.info("inside Trainer Resource Constructor");
		} catch (ServicesNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
	}

	@POST
	@Path("newRegistration")
	@Produces(MediaType.APPLICATION_JSON)
	@Consumes(MediaType.APPLICATION_JSON)
	public Trainer getTraineer(Trainer trainer){
		String returnString="";
		try {			
			 returnString = examServices.acceptTrainer(trainer);
			} catch ( ServicesNotFoundException | SQLException e) {
				returnString = "got error";				
				LOGGER.info("We have got the sql exception ");
				e.printStackTrace();
			} catch (Exception e) {
				returnString = "got error";
				e.printStackTrace();
			}		
		return new Trainer(returnString, "", "", "", null, 0, ""); 
	}
	
	/*method to check trainer login credentials 
	 * input  : id, password
	 * output : trainer object
	 * */	
	@PUT
	@Path("login/{id}")
	@Produces(MediaType.APPLICATION_JSON)
	@Consumes(MediaType.APPLICATION_JSON)	
	public Trainer loginTrainer(Trainer trainer) {
		LOGGER.info("trainer object caught from client "+trainer);
		if(trainer!=null){
			try {
				trainer = examServices.getTrainerLoginDetails(trainer);
				if(trainer == null){
					return new Trainer("sessionError", "", "", "", null, 0, "");
				}
			} catch (TrainerNotFoundException e) {
				LOGGER.info("Trainer not found Exception");
				trainer = new Trainer("dataNotFound", "", "", "", null, 0, "");
				e.printStackTrace();
			} catch (ServicesNotFoundException e) {
				e.printStackTrace();
				trainer = new Trainer("sessionError", "", "", "", null, 0, "");
			}
		}else{
			trainer = new Trainer("sessionError", "", "", "", null, 0, "");
		}
		LOGGER.info("Trainer value in Resource Handeler :"+trainer);
		return trainer;
	}
	
	
	/*Method to fetch trainer's basic details
	 * input  : id, token
	 * output : the trainer object 
	 * */
	@PUT
	@Path("{id}")
	@Produces(MediaType.APPLICATION_JSON)
	@Consumes(MediaType.APPLICATION_JSON)
	public Trainer fetchTrainerDetails(Trainer trainer){
		Trainer trainerResult;
		try {
			trainerResult = examServices.getTrainerDetails(trainer);
		} catch (TrainerNotFoundException e) {			
			e.printStackTrace();
			return new Trainer("sessionError", "", "", "", null, 0, "");
		} catch (SessionExpireException e) {			
			e.printStackTrace();
			return new Trainer("sessionError", "", "", "", null, 0, "");
		} catch (ServicesNotFoundException e) {
			e.printStackTrace();
			return new Trainer("somethingWentWrong", "", "", "", null, 0, "");			
		} 
		return trainerResult;
		
	}
	
}
