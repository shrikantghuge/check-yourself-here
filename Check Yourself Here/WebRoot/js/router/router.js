//Controllers Section
	Exam.PortalController = Marionette.Controller.extend({
		initialize : function() {
			console.info("PortalController is initialized!");
			Exam.topHeaderRegions.show(new Exam.TopHeaderView());
			Exam.topMenuRegions.show(new Exam.TopmenuView());
			Exam.mainSectionRegions.show(new Exam.MainSectionView());
			Exam.theFooterRegions.show(new Exam.TheFooterView());
		},
		showTrainer : function() {
			console.info('this section for  trainer view');
			Exam.mainSectionRegions.show(new Exam.TrainerLoginView());
		},
		showStudent : function() {
			console.info('this section for student');
			Exam.mainSectionRegions.show(new Exam.TheStudentLoginView());
		},
		showHome : function() {
			console.info('this section for home');
			Exam.mainSectionRegions.show(new Exam.MainSectionView());
			
		}	
	});
	
	/***************Controllers for trainer home***************/
	Exam.TrainerHomeController = Marionette.Controller.extend({
		initialize : function(model) {
			console.log("Trainer Controller has been initialized with data id :"+model.toJSON().id);
			Exam.topMenuRegions.show(new Exam.TrainerHomeHeaderView());
			Exam.mainSectionRegions.show(new Exam.TrainerHomeMainView({model: model}));
		},
		showTrainerHome : function() {
			var model = Exam.getTrainerHelper();
			console.log("the model fetched successfully is :"+model);
			if(model.toJSON().id=="sessionError"){
				Exam.mainSectionRegions.show(new Exam.InvalidSessionView());
			}else if(model.toJSON().id=="somethingWentWrong"){
				Exam.mainSectionRegions.show(new Exam.SomethingWentWrongView());
			}else{
				console.log("Display trainer home");
				Exam.mainSectionRegions.show(new Exam.TrainerHomeMainView({model: model}));
			}	
		},
		showTrainerProfile : function() {			
			var model =Exam.getTrainerHelper();
			console.log("trainer profile :the model fetched successfully is :"+model);
			if(model.toJSON().id=="sessionError"){
				Exam.mainSectionRegions.show(new Exam.InvalidSessionView());
			}else if(model.toJSON().id=="somethingWentWrong"){
				Exam.mainSectionRegions.show(new Exam.SomethingWentWrongView());
			}else{
				console.log("Display trainer profile");
				Exam.mainSectionRegions.show(new Exam.TrainerHomeEditInfoView({model: model}));
			}				 
		},
		showTrainerStudentDetails : function() {
			
		},
		showTrainerTraining : function() {
			
		},
		showTrainerLogout : function() {
			
		}
	});
	
	
  // ALL ROUTERS
	/*Main router before login activities*/
	Exam.MainRouter = Marionette.AppRouter.extend({
		appRoutes : {
			'home' : 'showHome',
			'student' : 'showStudent',
			'trainer' : 'showTrainer'
		}
	});
	/*Trainer  routers, after trainer login activities*/
	Exam.TrainerRouter = Marionette.AppRouter.extend({
		appRoutes : {
			'trainerHome' :  'showTrainerHome',
			'trainerProfile' :	'showTrainerProfile',
			'trainerStudentDetails' :	'showTrainerStudentDetails',
			'trainerTraining'	:	'showTrainerTraining',
			'trainerLogout' :	'showTrainerLogout'	
		}
	});
	
	
  
	