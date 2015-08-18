-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.5.42 - MySQL Community Server (GPL)
-- Server OS:                    Win32
-- HeidiSQL Version:             9.1.0.4867
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping database structure for exam
CREATE DATABASE IF NOT EXISTS `exam` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `exam`;


-- Dumping structure for table exam.exam
CREATE TABLE IF NOT EXISTS `exam` (
  `id` int(11) NOT NULL,
  `subjectId` int(11) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `totalMarks` int(11) DEFAULT NULL,
  `passingMarks` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `examHours` time DEFAULT NULL,
  `totalTime` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `examIsOfSubject` (`subjectId`),
  CONSTRAINT `examIsOfSubject` FOREIGN KEY (`subjectId`) REFERENCES `subject` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table exam.exam: ~0 rows (approximately)
/*!40000 ALTER TABLE `exam` DISABLE KEYS */;
/*!40000 ALTER TABLE `exam` ENABLE KEYS */;


-- Dumping structure for table exam.person
CREATE TABLE IF NOT EXISTS `person` (
  `ID` varchar(50) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `contactNumber` double DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `address` longtext,
  `password` varchar(50) DEFAULT NULL,
  `designation` varchar(50) DEFAULT NULL,
  `token` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table exam.person: ~62 rows (approximately)
/*!40000 ALTER TABLE `person` DISABLE KEYS */;
INSERT INTO `person` (`ID`, `name`, `contactNumber`, `email`, `address`, `password`, `designation`, `token`) VALUES
	('12326yx', '123', 123, '123', '123', '123', NULL, NULL),
	('1238jas', '123', 123, '123', '123', NULL, NULL, NULL),
	('123bzky', '123', 123, '123', '123', '123', NULL, NULL),
	('123f5cf', '123', 123, '123', '123', NULL, NULL, NULL),
	('123j3aq', '123', 123, '123', '1231', NULL, NULL, NULL),
	('123jenf', '123', 123, '123', '123', NULL, NULL, NULL),
	('123m3ss', '123', 123, '123', '123', NULL, NULL, NULL),
	('123m95z', '123', 123, '123', '123', '123', NULL, NULL),
	('123mkr6', '123', 123, '123', '123', NULL, NULL, NULL),
	('123n1bz', '123', 123, '123', '123', '12312', NULL, NULL),
	('123v2et', '123', 123, '1', '23123', NULL, NULL, NULL),
	('123xdfp', '123', 123, '1', '231', NULL, NULL, NULL),
	('aasd123', 'aasd123', 123, '123', '123', '123', NULL, NULL),
	('aknt gh', 'shriaknt ghuge', 123, '123', '123', NULL, NULL, NULL),
	('akntghu', 'shriaknt ghuge', 123, '123', '123', NULL, NULL, NULL),
	('ant ghu', 'shrikant ghuge', 123, '123', '123', NULL, NULL, NULL),
	('antghug', 'shrikant ghuge', 123, '123', '123', NULL, NULL, NULL),
	('asd6p92', 'asd', 123, '123', '123', '123', NULL, NULL),
	('asdg8jj', 'asd', 123, '123', '123', '123', NULL, NULL),
	('asdvhvd', 'asd', 2123, '123', '123', '123', NULL, NULL),
	('ghugefb', 'shriaknt ghugef', 123, '123', '123', NULL, NULL, NULL),
	('hriaknt', 'shriaknt ghuge', 123, '123', '123', NULL, NULL, NULL),
	('hrikant', 'shrikant ghuge', 123, '123', '123', NULL, NULL, NULL),
	('iaknt g', 'shriaknt ghuge', 123, '123', '123', NULL, NULL, NULL),
	('iakntgh', 'shriaknt ghuge', 123, '123', '123', NULL, NULL, NULL),
	('ikant g', 'shrikant ghuge', 123, '123', '123', NULL, NULL, NULL),
	('ikantgh', 'shrikant ghuge', 123, '123', '123', NULL, NULL, NULL),
	('kant gh', 'shrikant ghuge', 123, '123', '123', NULL, NULL, NULL),
	('kantghu', 'shrikant ghuge', 123, '123', '123', NULL, NULL, NULL),
	('knt ghu', 'shriaknt ghuge', 123, '123', '123', NULL, NULL, NULL),
	('kntghue', 'shriaknt ghueg', 123, '123', '123', NULL, NULL, NULL),
	('kntghug', 'shriaknt ghuge', 123, '123', '123', NULL, NULL, NULL),
	('nt ghug', 'shriaknt ghuge', 123, '123', '123', NULL, NULL, NULL),
	('ntghueg', 'shriaknt ghueg', 123, '123', '123', NULL, NULL, NULL),
	('ntghuge', 'shriaknt ghuge', 123, '123', '123', NULL, NULL, NULL),
	('ntghugq', 'shriaknt ghug', 123, '123', '123', NULL, NULL, NULL),
	('ramc27p', 'ram', 123, '123', '123', NULL, NULL, NULL),
	('riaknt ', 'shriaknt ghuge', 123, '123', '123', NULL, NULL, NULL),
	('riaknt8', 'shriaknt', 123, '1', '231', NULL, NULL, NULL),
	('riakntg', 'shriaknt ghuge', 123, '123', '123', NULL, NULL, NULL),
	('rikant ', 'shrikant ghuge', 123, '123', '123', NULL, NULL, NULL),
	('rikant1', 'shrikant ', 123, '123', '123', NULL, NULL, NULL),
	('rikantb', 'shrikant ', 123, '123', '123', NULL, NULL, NULL),
	('rikantg', 'shrikant ghuge', 123, '123', '123', NULL, NULL, NULL),
	('shriakn', 'shriaknt ghuge', 123, '123', '123', NULL, NULL, NULL),
	('shrie7n', 'shri', 125, '1', '3123', NULL, NULL, NULL),
	('shrikan', 'shrikant ghuge', 123, '123', '123', NULL, NULL, NULL),
	('shrkkdt', 'shrk', 123, '123', '123', NULL, NULL, NULL),
	('t ghuge', 'shriaknt ghuge', 123, '123', '123', NULL, NULL, NULL),
	('tghuge3', 'shriaknt ghuge', 123, '123', '123', NULL, NULL, NULL),
	('tghuge4', 'shriaknt ghuge', 123, '123', '123', NULL, NULL, NULL),
	('tghuge6', 'shriaknt ghuge', 123, '123', '123', NULL, NULL, NULL),
	('tghugea', 'shriaknt ghuge', 123, '123', '123', NULL, NULL, NULL),
	('tghugeb', 'shrikant ghuge', 123, '123', '123', NULL, NULL, NULL),
	('tghugec', 'shriaknt ghuge', 123, '123', '123', NULL, NULL, NULL),
	('tghugef', 'shriaknt ghuge', 123, '123', '123', NULL, NULL, NULL),
	('tghugeh', 'shriaknt ghuge', 123, '123', '123', NULL, NULL, NULL),
	('tghugen', 'tghuge', 123, '123', '123', NULL, NULL, NULL),
	('tghugep', 'shriaknt ghuge', 123, '123', '123', NULL, NULL, NULL),
	('tghuger', 'shriaknt ghuge', 123, '123', '123', NULL, NULL, NULL),
	('tghugex', 'shriaknt ghuge', 123, '123', '123', NULL, NULL, NULL),
	('tghugey', 'shriaknt ghuge', 123, '123', '123', NULL, NULL, NULL);
/*!40000 ALTER TABLE `person` ENABLE KEYS */;


-- Dumping structure for table exam.questions
CREATE TABLE IF NOT EXISTS `questions` (
  `examId` int(11) DEFAULT NULL,
  `Question` varchar(50) DEFAULT NULL,
  `Option1` varchar(50) DEFAULT NULL,
  `Option3` varchar(50) DEFAULT NULL,
  `Option4` varchar(50) DEFAULT NULL,
  `Option5` varchar(50) DEFAULT NULL,
  `Option6` varchar(50) DEFAULT NULL,
  `Option7` varchar(50) DEFAULT NULL,
  `Option8` varchar(50) DEFAULT NULL,
  `Answer` int(11) DEFAULT NULL,
  KEY `examinationQuestions` (`examId`),
  CONSTRAINT `examinationQuestions` FOREIGN KEY (`examId`) REFERENCES `exam` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table exam.questions: ~0 rows (approximately)
/*!40000 ALTER TABLE `questions` DISABLE KEYS */;
/*!40000 ALTER TABLE `questions` ENABLE KEYS */;


-- Dumping structure for table exam.registration
CREATE TABLE IF NOT EXISTS `registration` (
  `registrationNumber` int(11) NOT NULL AUTO_INCREMENT,
  `trainerId` varchar(50) NOT NULL DEFAULT 'DEFAULT',
  `subjectId` int(11) NOT NULL DEFAULT '0',
  `studentId` varchar(50) NOT NULL DEFAULT 'DEFAULT',
  PRIMARY KEY (`subjectId`,`studentId`,`trainerId`),
  KEY `trainerIsTraining` (`trainerId`),
  KEY `studentIsRegisteredTo` (`studentId`),
  KEY `registrationNumber` (`registrationNumber`),
  CONSTRAINT `studentIsRegisteredTo` FOREIGN KEY (`studentId`) REFERENCES `person` (`ID`),
  CONSTRAINT `subjectIsTeachedByAndTo` FOREIGN KEY (`subjectId`) REFERENCES `subject` (`id`),
  CONSTRAINT `trainerIsTraining` FOREIGN KEY (`trainerId`) REFERENCES `person` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=100000 DEFAULT CHARSET=latin1;

-- Dumping data for table exam.registration: ~0 rows (approximately)
/*!40000 ALTER TABLE `registration` DISABLE KEYS */;
/*!40000 ALTER TABLE `registration` ENABLE KEYS */;


-- Dumping structure for table exam.result
CREATE TABLE IF NOT EXISTS `result` (
  `registrationId` int(11) DEFAULT NULL,
  `examId` int(11) DEFAULT NULL,
  `score` float DEFAULT NULL,
  KEY `resultOfExam` (`examId`),
  KEY `resultofRegistrar` (`registrationId`),
  CONSTRAINT `resultOfExam` FOREIGN KEY (`examId`) REFERENCES `exam` (`id`),
  CONSTRAINT `resultofRegistrar` FOREIGN KEY (`registrationId`) REFERENCES `registration` (`registrationNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table exam.result: ~0 rows (approximately)
/*!40000 ALTER TABLE `result` DISABLE KEYS */;
/*!40000 ALTER TABLE `result` ENABLE KEYS */;


-- Dumping structure for table exam.subject
CREATE TABLE IF NOT EXISTS `subject` (
  `id` int(11) NOT NULL,
  `name` int(11) DEFAULT NULL,
  `description` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table exam.subject: ~0 rows (approximately)
/*!40000 ALTER TABLE `subject` DISABLE KEYS */;
/*!40000 ALTER TABLE `subject` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
