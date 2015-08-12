
/*Interpolate and evaluate setting for jsp*/
_.templateSettings = {
    interpolate: /\<\@\=(.+?)\@\>/gim,
    evaluate: /\<\@(.+?)\@\>/gim,
    escape: /\<\@\-(.+?)\@\>/gim
};

// Required helper function starting
Exam.loginRequestStudent = function(model) {
	console.log('before student login request');
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
	trainer.urlRoot = "./exam/trainer/login";
	trainer.save({},{		
		success:function(model){
			console.log('trainer logined successfully');
			//$("#mainSection").html("The admin logged in successfully!!");
			if(model.toJSON().id ==='dataNotFound' ){
				Exam.mainSectionRegions.show(new Exam.InvalidUserView());
				console.log("invalid user selected");
			}else if(model.toJSON().id ==='sessionError' ){
				Exam.mainSectionRegions.show(new Exam.InvalidSessionView());
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
				if(model.toJSON().id.trim()=="got error"){
					Exam.mainSectionRegions.show(new Exam.SignupView());
					$("#signUpError").css("visibility", "visible");
				}else{
					console.log("registrar has been saved successfully .."+model.toJSON().id);
					Exam.mainSectionRegions.show(new Exam.SuccessView({model: model}));
				}
			}		
        }
    );
};

	
	