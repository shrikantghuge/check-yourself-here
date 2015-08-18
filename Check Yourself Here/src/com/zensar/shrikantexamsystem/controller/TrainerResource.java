package com.zensar.shrikantexamsystem.controller;
import java.sql.SQLException;

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import com.zensar.shrikantexamsystem.beans.Trainer;
import com.zensar.shrikantexamsystem.exceptions.ServicesNotFoundException;
import com.zensar.shrikantexamsystem.exceptions.TrainerNotFoundException;
import com.zensar.shrikantexamsystem.zenemsservices.ExamServices;
import com.zensar.shrikantexamsystem.zenemsservices.ExamServicesImpl;
@Path("/trainer")
public class TrainerResource {
	private ExamServices examServices;
	public TrainerResource() {
		try {
			examServices = new ExamServicesImpl();
			System.out.println("inside Trainer Resource Constructor");
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
				System.out.println("We have got the sql exception ");
				e.printStackTrace();
			} catch (Exception e) {
				returnString = "got error";
				e.printStackTrace();
			}		
		return new Trainer(returnString, "", "", "", null, 0, ""); 
	}
	
	@PUT
	@Path("login/{id}")
	@Produces(MediaType.APPLICATION_JSON)
	@Consumes(MediaType.APPLICATION_JSON)
	//public Trainer loginTrainer(@PathParam("id") String id, @QueryParam("password")String password) {
	public Trainer loginTrainer(Trainer trainer) {
		//Trainer trainer = new Trainer(id, "", "", "", null, 0, password);;
		//if(id != null && password != null){
		System.out.println("trainer object caught from client "+trainer);
		if(trainer!=null){
			try {
				trainer = examServices.getTrainerLoginDetails(trainer);
			} catch (TrainerNotFoundException e) {
				trainer = new Trainer("dataNotFound", "", "", "", null, 0, "");
				e.printStackTrace();
			} catch (ServicesNotFoundException e) {
				trainer = new Trainer("error", "", "", "", null, 0, "");
			}
		}else{
			trainer = new Trainer("error", "", "", "", null, 0, "");
		}
		System.out.println("Trainer value in Resource Handeler :"+trainer);
		return trainer;
	}
	
}
