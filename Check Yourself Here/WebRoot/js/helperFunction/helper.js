
/*Interpolate and evaluate setting for jsp*/
_.templateSettings = {
    interpolate: /\<\@\=(.+?)\@\>/gim,
    evaluate: /\<\@(.+?)\@\>/gim,
    escape: /\<\@\-(.+?)\@\>/gim
};

// Required helper function starting
Exam.checkCredentials = function(model) {
	console.log('you are going to save the data');
	model.save({
		error : function() {
			console.log("there is error in storing");
		},
		success : function(model) {
			console.log("Politician updated successfully! response is: "+model);
		}
	});
};

Exam.checktrainerCredentials = function(trainer) {
	trainer.fetch({
		success:function(model){
			console.log('politician fetched successfully');
			//$("#mainSection").html("The admin logged in successfully!!");
			if(model.toJSON().trainerName ==='Shriaknt' ){
				Exam.mainSectionRegions.show(new Exam.InvalidUserView());
				console.log("invalid user selected");
			}
			else{
				Exam.mainSectionRegions.show(new Exam.TrainerHomeView());
				console.log("json id"+model.toJSON().id);
			}
		}
	});
};

/*Save new Trainer details and retrieve trainer Id    */
Exam.saveNewRegistration = function(trainer){
	console.log("into save trainer method"+trainer);
	trainer.save({},
		{
			error: function(){
	            
	        },		
			success:function(model){
				console.log("registrar has been saved successfully .."+model.toJSON().id);
				Exam.mainSectionRegions.show(new Exam.SuccessView({model: model}));
				
			}		
        }
    );
};

	
	