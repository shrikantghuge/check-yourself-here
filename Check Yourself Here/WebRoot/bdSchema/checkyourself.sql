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
	('1231230', '123123', 123, '123', '123', '123', 'Trainer', NULL),
	('1231235', '123123', 123, '123', '123', '123', 'Trainer', NULL),
	('1231237', '123123', 123, '123', '123', '123', 'Trainer', NULL),
	('1231238', '123123', 123, '123', '123', '123', 'Trainer', NULL),
	('123123a', '123123', 123, '123', '123', '123', 'Trainer', NULL),
	('123123c', '123123', 123, '123', '123', '123', 'Trainer', NULL),
	('123123f', '123123', 123, '123', '123', '123', 'Trainer', NULL),
	('123123g', '123123', 123, '123', '123', '123', 'Trainer', NULL),
	('123123j', '123123', 123, '123', '123', '123', 'Trainer', NULL),
	('123123o', '123123', 123, '123', '123', '123', 'Trainer', NULL),
	('123123q', '123123', 123, '123', '123', '123', 'Trainer', NULL),
	('123123u', '123123', 123, '123', '123', '123', 'Trainer', NULL),
	('123123y', '123123', 123, '123', '123', '123', 'Trainer', NULL),
	('123123z', '123123', 123, '123', '123', '123', 'Trainer', NULL),
	('123swmp', '123', 123, '123', '123', '123', 'Trainer', NULL),
	('amrutab', 'a b', 7709555566, 'amru@cisco.com', 'shriaknt ghuge', '123', 'Trainer', 1069546089);
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
