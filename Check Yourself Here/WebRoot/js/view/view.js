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
			"click #signUpbutton" : "openSignupTemplate",			
		},
		openSignupTemplate : function(){
			Exam.mainSectionRegions.show(new Exam.SignupView());
			
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
			console.log("student login model creation in view file started");
			var newStudent = new Exam.Student({
				username : $("#studentId").val(),
				password : $("#studentPassword").val()
			});
			Exam.loginRequestStudent(newStudent);
		}
	});
	Exam.TrainerLoginView = Marionette.ItemView.extend({
		template : '#trainerlogin-template',
		events:{
			"click #submitTrainerLogin" : function() {
				console.log("setting credentials in model are.."+  document.getElementById("trainerId").value+" and "+document.getElementById("trainerPassword").value);
				var trainer = new Exam.Trainer({
					id: document.getElementById("trainerId").value,
					password : document.getElementById("trainerPassword").value					
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
	Exam.SignupView = Marionette.ItemView.extend({
		template : '#signUp-template',
		events :{
			"click #submitNewsignUp" : function() {
				console.log("new registration started : into  TrainerSignupView view");
				var trainer = new Exam.Trainer({	
					
					name : document.getElementById("signUpName").value,
					contactNumber: document.getElementById("signUpContactNo").value,
					email: document.getElementById("signUpEmail").value+"#"+$("#trainerOrStudent").val(),
					address: document.getElementById("signUpAddress").value,
					password: document.getElementById("signUpPassword").value
				});
				Exam.saveNewRegistration(trainer);
			}
		}
	});
	
	/*Trainer successful signup template */
	Exam.SuccessView = Marionette.ItemView.extend({
		template : "#signUpSuccessTemplate"		
	});
	
	/*Session Expire, Page Reload , Back Button Session Expire*/
Exam.InvalidSessionView = Marrionette.ItemView.extend({
	template : "#sessionExpireTemplate"	
});