//Models Section
	Exam.Student = Backbone.Model.extend({
		urlRoot : 'http://shghuge-ws01.partnet.cisco.com:8080/WebServicesRef/test/one/examDemo',
		defaults : {
			name : 'shrikant',
			password : 'shri',
			subject : 'marathi'
		},
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
	