// All the views declaration staring 
	/*********************************************MAIN PAGE VIEWS : START***********************************************************************/
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
			 window.location.hash = 'signUp';			
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
	/*********************************************MAIN PAGE VIEWS : START***********************************************************************/
	/********************************************************ERROR VIEWS : START***************************************************************/
	/*View to show invalid user credentials */
	Exam.InvalidUserView= Marionette.ItemView.extend({
		template : '#invalidUser-template'
	});
	
	/*Session Expire, Page Reload , Back Button Session Expire*/
	Exam.InvalidSessionView = Marionette.ItemView.extend({
		template : "#sessionExpireTemplate"	
	});
	/*Something went wrong view*/
	Exam.SomethingWentWrongView = Marionette.ItemView.extend({
		template : "#somethingWentWrongtemplate"
	});
	/********************************************************ERROR VIEWS : END***************************************************************/		
	/*********************************************TRAINER VIEWS : START***********************************************************************/
	/*Trainer Login */
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
	
	
	/*Trainer Home Header*/
	Exam.TrainerHomeHeaderView = Marionette.ItemView.extend({
		initialize : function() {			
		},
		template : '#trainerHeadBannerTemplate'			
	});
	
	/*After Trainer Log in this view will get render first*/
	Exam.TrainerHomeMainView = Marionette.ItemView.extend({
		initialize : function(){
			
		},
		template : "#trainerHomeTemplate"		
	});
	
	/*Trainer is able to edit profile information with the help of the View*/
	Exam.TrainerHomeEditInfoView = Marionette.ItemView.extend({
		initialize : function(){
		},
		template : "#trainerEditTemplate",
		events : {
				"click #tEditSubmit" : function(){
					var newTrainer = Exam.Trainer({
						id : localStorage.getItem("uId"),
						name : $("#tEditName").val(),
						contactNumber : $("#tEditContactNumber").val(),
						email : #("#tEditEmailId").val(),
						
						
					
					});
					
				}
		}		
	});
	
	/*Here trainer will be able to see the details of the students, subjects and Examinations*/
	Exam.TrainerHomeStudentDetailsView = Marionette.ItemView.extend({
		initialize : function() {			
		},
		template : "#trainerStudentDetailsTemplate"
	});
	
	/*Training activities management main section of Trainer */
	Exam.TrainerHomeTrainingsectionView = Marionette.ItemView.extend({
		initialize : function() {
			
		},
		template : "#trainerTrainingSectionTemplate"
	});
	
	/*Trainer will be able to add or remove the subjects here*/
	Exam.TrainerTSAddRemoveSubjectView = Marionette.ItemView.extend({
		initialize : function(){
			
		},
		template : "#trainerAddRemoveSubjectTemplate"
	});
	
	/*Section to Add or Remove Students*/
	Exam.TrainerTSAddRemoveStudentView = Marionette.ItemView.extend({
		initialize : function(){
			
		},
		template : "#trainerAddRemoveStudentTemplate"
	});
	
	/*Scheduling and Rescheduling of an Examination */
	Exam.TrainerTSScheduleRescheduleView = Marionette.ItemView.extend({
		initialize : function(){
			
		},
		template : "#trainerScheduleReScheduleExamTemplate"
	});
	
	/*Reschedule Examination from here*/
	Exam.TrainerTSReScheduleView = Marionette.ItemView.extend({
		initialize : function(){
			
		},
		template : "#trainerTrainingReScheduleExamTemplate"
	});
	/*********************************************TRAINER VIEWS : END***********************************************************************/
	