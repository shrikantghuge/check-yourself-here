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
			console.info('this section for hjome');
		}
	});
	
	
  // All routers 
	Exam.MainRouter = Marionette.AppRouter.extend({
		appRoutes : {
			'home' : 'showHome',
			'student' : 'showStudent',
			'trainer' : 'showTrainer'
		}
	});
  
	