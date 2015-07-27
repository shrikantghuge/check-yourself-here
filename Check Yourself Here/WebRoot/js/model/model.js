//Models Section
	Exam.Student = Backbone.Model.extend({
		urlRoot : './exam/student/login',
		defaults : {},
		initialize : function() {
			console.log("Student object is initialized!");
		}
	});
	
	Exam.Trainer = Backbone.Model.extend({
	urlRoot : './exam/trainer/newRegistration',
		initialize : function(){
			console.log("Trainer model has been initialized");
		}
	});
	