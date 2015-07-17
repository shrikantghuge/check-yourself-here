<!-- author : shriaknt ghuge
contact No :7709582219 -->

<!DOCTYPE HTML>
<html lang="en">
<head>
	<meta charset="utf-8" />
	<title>Zensar Exam System</title>
	<link rel="stylesheet" href="css/main.css">
	
	<!--  JavaScript -->
	<script src="js/jquery-1.9.1.js">	
	</script>
	<script src="js/underscore-1.7.js">	
	</script>
	<script src="js/backbone-1.1.2.js">	
	</script>
	<script src="js/backbone.marionette-1.8.js">	
	</script>
	<script>
		Exam = new Marionette.Application();
		//Add Region Section
		Exam.addRegions({
			topHeaderRegions : '#topHeader',
			topMenuRegions : '#topMenu',
			mainSectionRegions : '#mainSection',
			theFooterRegions : '#theFooter'
		});	
	</script>
	<script src="js/model/model.js"></script>
	<script src="js/router/router.js"></script>
	<script src="js/view/view.js"></script>
	<script src="js/helperFunction/helper.js"></script>
	<script>
		//Required for application to start 
		Exam.on('initialize:after', function() {
			new Exam.MainRouter({
				controller : new Exam.PortalController()
			});
		});
		Exam.on('start', function() {
			console.info("exam is started");
			Backbone.history.start();
		});
		$(function() {
			Exam.start();
		});
	</script>
</head>
<body>
	<header id="topHeader"> </header>
	<nav id="topMenu"></nav>
	<article>
		<section id="mainSection"></section>
	</article>
	<footer id="theFooter"> </footer>


	<!--  Templates Starts from here -->
	<script type="text/template" id="top-header-template">
		<h1>ZENEMS System</h1>
	</script>
	<script type="text/template" id="top-menu-template">
			<li><a href="#home">Home</a></li>
			<li><a href="#student">Student Login</a></li>
			<li><a href="#trainer">Trainer Login</a></li>
	</script>
	<script type="text/template" id="main-section-template">
		<div>
			<input type="button" value="Sign UP" id="signUpbutton"/> 
		</div>
		<div id="trainerSigninLink">
			<label>Click <a href="#trainer">here</a>  to login </label>
		</div>
		<div id="traineeSigninLink">
			<label>Click <a href="#student"> here </a> to login </label>
		</div>
	</script>
	<script type="text/template" id="the-footer-template">
			 Copyright Zensar Technologies. 
	</script>
	<script type="text/template" id="studentLogin-template">
		<form>
		<label for="studentId">User Id :</label>
		<input type="text" placeholder="Enter Id" id="studentId">
		<label for="studentPassword">Enter Password :</label>
		<input type="password" id="studentPassword"> 
		<input type="button" value="Submit" id="submitStudentLogin">
		</form>
	</script>
	<script type="text/template" id="trainerlogin-template">
		<form>
		<label for="trainerId">Trainer User Id :</label>
		<input type="text" placeholder="Enter Id" id="trainerId"></br>
		<label for="trainerPassword">Enter Password :</label> 
		<input type="password" id="trainerPassword"> </br>
		<input type="button" value="Submit" id="submitTrainerLogin"> <input type="button" value="Sigh Up" id="signUpTrainer">
		</form>
	</script>
	<script type="text/template" id="trainerLoggedInMaintopmenu-template">
			<li><a href="#addDetails">Add Details</a></li>
			<li><a href="#viewDetails">View Details</a></li>
			<li><a href="#modifyDetails">Modify Details</a></li>
			<li><a href="#trainerLogOut"> Logout </a> <li> 
	</script>
	<script type="text/templet" id="trainerLoggedInMain-Template">
		<div id="exam">
		<label for="exam"> Add Exam  : </label><br>
		<label for="examName">Exam Name:</label>
		<input type="text" placeholder="Exam Name" id="examName">
		<button type="button" id="examSubmit"> Submit</button>
		<div id="selectExamDiv" style="visibility: hidden;">
		<label for="selectExamLabel">Select Exam</label><br>
		<select id="examList">
			<option value="select"> Select</option>
		</select>
		</div>
		</div>
		<div id="section" style="border-top:2px ; border-top-color: black; visibility: hidden;">
		<label for="section">Add Section to Exam :</label><br>
		<label for="sectionName"> Section Name</label>
		<input type="text" placeholder="Section Name"><br><br><br>
		<label for="sectionCompelsion">The following Details are compelsory: </label><br>
		<label for="questionSet"> Select Question's File</label>
		<input type="file" id="questionSet"><br>
		<label for="timeTable">Enter Timetable Details</label><br>
		<label for="selectDate">Enter Start Time</label><input type="date" placeholder="Enter Exam Date" id="examDate">
		<label for="startTime">Enter Start Time for Exam</label><input type="time" placeholder="Exam Start Time" id="examStartTime">
		<label for="endTime">Enter End Time for Exam</label><input type="time" placeholder="Exam End Time" id="examEndTime"><br>
		<label for="appearingStudent"> Select Student's File</label>
		<input type="file" id="appearingStudent"><br>
		<input type="button" id="sectionSubmit" value="Submit Details">
		</div>
	</script>
	<script type="text/template" id="invalidUser-template">
		Your Username or Password is not correct
	</script>
	<script type="text/template" id="signUp-template">
		<div>
			<label>You are a </label>
			<select id="trainerOrStudent">
				<option id="0" selected="selected">Select One..</option>
				<option id="trainer">Trainer</option>
				<option id="student">Student</option>
			</select>
		<div>
		<div>
			<label for="signUpName">Enter Name :</label>
			<input type="text" id = "signUpName">
		</div>
		<div>
			<label for="signUpContactNo">Enter Mobile Number :</label>
			<input type="number" id="signUpContactNo">
		</div>
		<div>
			<label for="signUpEmail">Enter Email Address :</label>
			<input type="text" id="signUpEmail">		
		</div>	
		<div>
			<label for="signUpAddress">Enter Address :</label>
			<input type="text" id="signUpAddress">
		</div>
		<div>
			<label for="signUpPassword">Enter Password :</label>
			<input type="password" id="signUpPassword">
		</div>
		<div>
			<label for="signUpPasswordConfirm">Re-enter Password :</label>
			<input type="password" id="signUpPasswordConfirm">
		</div> 
		<div>
			<input type="button" id="submitNewsignUp" value="Submit">
		</div>
		<div>
			<label for="signUpError" id="signUpError" style="visibility: hidden; color: red;">Error In Storing, Please Try again!!</label>
		</div>
	</script>	
	<script type="text/template" id="signUpSuccessTemplate">
		<label> Your ID is : <@= id  @> </label> </br> 
		<label> click <a href="#home">HERE</a> to login!!</label>
	</script>
	<label for="signUpError" style="visibility: hidden; color: red;">Enter Address :</label>
</body>
</html>