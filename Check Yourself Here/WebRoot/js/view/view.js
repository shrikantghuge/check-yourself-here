// All the views declaration staring 
	Exam.TopHeaderView = Marionette.ItemView.extend({
		template : '#top-header-template'
	});
	Exam.TopmenuView = Marionette.ItemView.extend({
		template : '#top-menu-template',
		tagName : 'ul'
	});
	Exam.MainSectionView = Marionette.ItemView.extend({
		template : '#main-section-template',
		events :{
			"click #trainerSignUpbutton" : "openTrainerSignupTemplate",
			"click #studentSignUpbutton" : "openStudentSignupTemplate"
		},
		openTrainerSignupTemplate : function(){
			Exam.mainSectionRegions.show(new Exam.TrainerSignupView());
			
		},
		openStudentSignupTemplate : function(){
			
		}
	});
	
	Exam.TheFooterView = Marionette.ItemView.extend({
		template : '#the-footer-template'
	});
	Exam.TheStudentLoginView = Marionette.ItemView.extend({
		template : '#studentLogin-template',
		events : {
			"click #submitStudentLogin" : "setCredentialsinModel"
		},
		setCredentialsinModel : function() {
			console.log("now starting to load data into the model");
			var newStudent = new Exam.Student({
				username : $("studentId").val(),
				password : $("studentPassword").val()
			});
			Exam.checkCredentials(newStudent);
		}
	});
	Exam.TrainerLoginView = Marionette.ItemView.extend({
		template : '#trainerlogin-template',
		events:{
			"click #submitTrainerLogin" : function() {
				console.log("setting credentials in model are.."+  document.getElementById("trainerId").value+" and "+document.getElementById("trainerPassword").value);
				var trainer = new Exam.Trainer({
					id: document.getElementById("trainerId").value,
					trainerPassword : document.getElementById("trainerPassword").value					
				});
				Exam.checktrainerCredentials(trainer);
			}			
		}
	});
	Exam.TrainerHomeView = Marionette.ItemView.extend({
		initialize : function() {
			
		},
		template : '#trainerLoggedInMain-Template'
			
	});
	Exam.InvalidUserView= Marionette.ItemView.extend({
		template : '#invalidUser-template'
	});
	
	/*Trainer Signup View*/
	Exam.TrainerSignupView = Marionette.ItemView.extend({
		template : '#trainerSignUp-template',
		events :{
			"click #submitNewTrainer" : function() {
				console.log("new trainer registration started : into  TrainerSignupView view");
				var trainer = new Exam.Trainer({					
					name : document.getElementById("trainerName").value,
					contactNumber: document.getElementById("trainerContactNo").value,
					email: document.getElementById("trainerEmail").value,
					address: document.getElementById("trainerAddress").value,
					trainerPassword: document.getElementById("trainerPassword").value
				});
				Exam.saveNewTrainer(trainer);
			}
		}
	});