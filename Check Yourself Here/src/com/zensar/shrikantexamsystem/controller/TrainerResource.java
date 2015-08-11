package com.zensar.shrikantexamsystem.controller;
import java.sql.SQLException;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;

import com.zensar.shrikantexamsystem.beans.Trainer;
import com.zensar.shrikantexamsystem.exceptions.ServicesNotFoundException;
import com.zensar.shrikantexamsystem.zenemsservices.ExamServices;
import com.zensar.shrikantexamsystem.zenemsservices.ExamServicesImpl;
@Path("/trainer")
public class TrainerResource {
	private ExamServices examServices;

	@POST
	@Path("newRegistration")
	@Produces(MediaType.APPLICATION_JSON)
	@Consumes(MediaType.APPLICATION_JSON)
	public Trainer getTraineer(Trainer trainer){
		String returnString="";
		try {
			examServices = new ExamServicesImpl();		
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
	public Trainer loginTrainer(@PathParam("id") String id, @QueryParam("password")String password) {
		Trainer trainer = new Trainer(id, "", "", "", null, 0, password);
		if (trainer.getId()==null && trainer.getId()!="")trainer.setId("error");		
		System.out.println(trainer);
		return trainer;
	}
	
}
