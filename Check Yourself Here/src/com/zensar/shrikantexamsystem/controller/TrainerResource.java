package com.zensar.shrikantexamsystem.controller;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import com.zensar.shrikantexamsystem.beans.Trainer;
@Path("/trainer")
public class TrainerResource {
	@GET
	@Path("{id}")
	@Produces(MediaType.APPLICATION_JSON)
	public Trainer getTraineer(@PathParam("id")int id){
		return new Trainer(101, "$HR!K@X+", "se er", "prashant@cisco.com",582219, "shri");
		//return null;
	}
	
}
