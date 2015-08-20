
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
			console.log("student login response is: "+model);
		}
	});
};

Exam.checktrainerCredentials = function(trainer) {
	trainer.urlRoot = "./exam/trainer/login";
	trainer.save({},{		
		success:function(model){			
			//$("#mainSection").html("The admin logged in successfully!!");
			if(model.toJSON().id ==='dataNotFound' ){
				Exam.mainSectionRegions.show(new Exam.InvalidUserView());
				console.log("data not found for user");
			}else if(model.toJSON().id ==='sessionError' ){
				Exam.mainSectionRegions.show(new Exam.InvalidSessionView());
				console.log("session expired");
			}
			else{
				console.log("trainer logined successfully json id"+model.toJSON().id);
				localStorage.setItem("uId",model.toJSON().id);
				localStorage.setItem("password",model.toJSON().password);
				console.log("The Items stored in HTML local are :"+localStorage.getItem("uId")+"and pwd is :"+localStorage.getItem("password"));
				new Exam.TrainerRouter({
					controller : new Exam.TrainerHomeController(model)
				});
				
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

/*This fetches the trainer basic details for Home view 
 * input: localStorage (uId and Password)
 * returns : trainer object
 * */
Exam.getTrainerHelper = function() {
	var result=null;
	var trainer = new Exam.Trainer({	
					id : localStorage.getItem("uId"),
					password : localStorage.getItem("password")
				});
	trainer.urlRoot = "./exam/trainer";
	console.log("before fetch");
	trainer.save({},{
		async: false, 
		success: function(model){
			console.log("Trainer fetched successfully "+model.toJSON().id);
			result=model;
		}
	});
	console.log("after fetch"+result);
	return result;
};

	
	