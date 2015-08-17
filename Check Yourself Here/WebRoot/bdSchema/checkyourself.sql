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


-- Dumping structure for table exam.student
CREATE TABLE IF NOT EXISTS `student` (
  `id` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `address` varchar(50) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `contactNumber` bigint(20) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table exam.student: ~3 rows (approximately)
/*!40000 ALTER TABLE `student` DISABLE KEYS */;
INSERT INTO `student` (`id`, `name`, `address`, `password`, `contactNumber`, `email`) VALUES
	('1230zx0', '123', '123', NULL, 123, '123'),
	('123dswj', '123', '123', NULL, 123, '123'),
	('tghugem', 'shriaknt ghuge', '123', '123', 123123123, '123');
/*!40000 ALTER TABLE `student` ENABLE KEYS */;


-- Dumping structure for table exam.trainer
CREATE TABLE IF NOT EXISTS `trainer` (
  `ID` varchar(50) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `address` longtext,
  `email` varchar(50) DEFAULT NULL,
  `contactNumber` double DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `token` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table exam.trainer: ~62 rows (approximately)
/*!40000 ALTER TABLE `trainer` DISABLE KEYS */;
INSERT INTO `trainer` (`ID`, `name`, `address`, `email`, `contactNumber`, `password`, `token`) VALUES
	('12326yx', '123', '123', '123', 123, '123', NULL),
	('1238jas', '123', '123', '123', 123, NULL, NULL),
	('123bzky', '123', '123', '123', 123, '123', NULL),
	('123f5cf', '123', '123', '123', 123, NULL, NULL),
	('123j3aq', '123', '1231', '123', 123, NULL, NULL),
	('123jenf', '123', '123', '123', 123, NULL, NULL),
	('123m3ss', '123', '123', '123', 123, NULL, NULL),
	('123m95z', '123', '123', '123', 123, '123', NULL),
	('123mkr6', '123', '123', '123', 123, NULL, NULL),
	('123n1bz', '123', '123', '123', 123, '12312', NULL),
	('123v2et', '123', '23123', '1', 123, NULL, NULL),
	('123xdfp', '123', '231', '1', 123, NULL, NULL),
	('aasd123', 'aasd123', '123', '123', 123, '123', NULL),
	('aknt gh', 'shriaknt ghuge', '123', '123', 123, NULL, NULL),
	('akntghu', 'shriaknt ghuge', '123', '123', 123, NULL, NULL),
	('ant ghu', 'shrikant ghuge', '123', '123', 123, NULL, NULL),
	('antghug', 'shrikant ghuge', '123', '123', 123, NULL, NULL),
	('asd6p92', 'asd', '123', '123', 123, '123', NULL),
	('asdg8jj', 'asd', '123', '123', 123, '123', NULL),
	('asdvhvd', 'asd', '123', '123', 2123, '123', NULL),
	('ghugefb', 'shriaknt ghugef', '123', '123', 123, NULL, NULL),
	('hriaknt', 'shriaknt ghuge', '123', '123', 123, NULL, NULL),
	('hrikant', 'shrikant ghuge', '123', '123', 123, NULL, NULL),
	('iaknt g', 'shriaknt ghuge', '123', '123', 123, NULL, NULL),
	('iakntgh', 'shriaknt ghuge', '123', '123', 123, NULL, NULL),
	('ikant g', 'shrikant ghuge', '123', '123', 123, NULL, NULL),
	('ikantgh', 'shrikant ghuge', '123', '123', 123, NULL, NULL),
	('kant gh', 'shrikant ghuge', '123', '123', 123, NULL, NULL),
	('kantghu', 'shrikant ghuge', '123', '123', 123, NULL, NULL),
	('knt ghu', 'shriaknt ghuge', '123', '123', 123, NULL, NULL),
	('kntghue', 'shriaknt ghueg', '123', '123', 123, NULL, NULL),
	('kntghug', 'shriaknt ghuge', '123', '123', 123, NULL, NULL),
	('nt ghug', 'shriaknt ghuge', '123', '123', 123, NULL, NULL),
	('ntghueg', 'shriaknt ghueg', '123', '123', 123, NULL, NULL),
	('ntghuge', 'shriaknt ghuge', '123', '123', 123, NULL, NULL),
	('ntghugq', 'shriaknt ghug', '123', '123', 123, NULL, NULL),
	('ramc27p', 'ram', '123', '123', 123, NULL, NULL),
	('riaknt ', 'shriaknt ghuge', '123', '123', 123, NULL, NULL),
	('riaknt8', 'shriaknt', '231', '1', 123, NULL, NULL),
	('riakntg', 'shriaknt ghuge', '123', '123', 123, NULL, NULL),
	('rikant ', 'shrikant ghuge', '123', '123', 123, NULL, NULL),
	('rikant1', 'shrikant ', '123', '123', 123, NULL, NULL),
	('rikantb', 'shrikant ', '123', '123', 123, NULL, NULL),
	('rikantg', 'shrikant ghuge', '123', '123', 123, NULL, NULL),
	('shriakn', 'shriaknt ghuge', '123', '123', 123, NULL, NULL),
	('shrie7n', 'shri', '3123', '1', 125, NULL, NULL),
	('shrikan', 'shrikant ghuge', '123', '123', 123, NULL, NULL),
	('shrkkdt', 'shrk', '123', '123', 123, NULL, NULL),
	('t ghuge', 'shriaknt ghuge', '123', '123', 123, NULL, NULL),
	('tghuge3', 'shriaknt ghuge', '123', '123', 123, NULL, NULL),
	('tghuge4', 'shriaknt ghuge', '123', '123', 123, NULL, NULL),
	('tghuge6', 'shriaknt ghuge', '123', '123', 123, NULL, NULL),
	('tghugea', 'shriaknt ghuge', '123', '123', 123, NULL, NULL),
	('tghugeb', 'shrikant ghuge', '123', '123', 123, NULL, NULL),
	('tghugec', 'shriaknt ghuge', '123', '123', 123, NULL, NULL),
	('tghugef', 'shriaknt ghuge', '123', '123', 123, NULL, NULL),
	('tghugeh', 'shriaknt ghuge', '123', '123', 123, NULL, NULL),
	('tghugen', 'tghuge', '123', '123', 123, NULL, NULL),
	('tghugep', 'shriaknt ghuge', '123', '123', 123, NULL, NULL),
	('tghuger', 'shriaknt ghuge', '123', '123', 123, NULL, NULL),
	('tghugex', 'shriaknt ghuge', '123', '123', 123, NULL, NULL),
	('tghugey', 'shriaknt ghuge', '123', '123', 123, NULL, NULL);
/*!40000 ALTER TABLE `trainer` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
