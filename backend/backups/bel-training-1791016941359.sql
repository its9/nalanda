-- MySQL dump 10.13  Distrib 9.6.0, for macos26.4 (arm64)
--
-- Host: localhost    Database: bel_training_management
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '844eeb4c-6b4b-11f1-a1ca-9ebcd1e3fe51:1-240';

--
-- Table structure for table `application_settings`
--

DROP TABLE IF EXISTS `application_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `application_settings` (
  `scope` varchar(100) NOT NULL,
  `settings_json` mediumtext NOT NULL,
  `updated_at` timestamp NOT NULL,
  PRIMARY KEY (`scope`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application_settings`
--

LOCK TABLES `application_settings` WRITE;
/*!40000 ALTER TABLE `application_settings` DISABLE KEYS */;
INSERT INTO `application_settings` VALUES ('attendance-settings','{\"requireApproval\":\"Require Approval for Nominations\",\"allowInternal\":\"Allow Internal Participants\",\"allowExternal\":\"Allow External Participants\",\"allowWaitlist\":\"Allow Waitlist\",\"allowMultiple\":\"Allow Multiple Nominations per User\",\"minimumParticipants\":\"Minimum Participants per Program\",\"maximumParticipants\":\"Maximum Participants per Program\",\"startDays\":\"Nomination Start Days Before Program\",\"endDays\":\"Nomination End Days Before Program\",\"defaultStatus\":\"present \",\"mandatory\":true,\"partialDay\":true,\"allowEarlyMark\":true,\"minimumCompletion\":\"80\"}','2026-10-03 08:28:46'),('general','{\"organizationName\":\"Bharat Electronics Limited (BEL)\",\"wing\":\"Quality mangement wing \",\"academicYear\":\"Academic / Calendar Year\",\"timeFormat\":\"Time Format\",\"recordsPerPage\":\"Records Per Page\",\"logo\":\"data:image/png;base64,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\"}','2026-10-03 08:17:14'),('notifications','{\"mandatory\":\"Mandatory Attendance\",\"minimumCompletion\":\"Minimum Attendance % for Completion\",\"partialDay\":\"Allow Partial Day Attendance\",\"markingMethod\":\"Attendance Marking Method\",\"allowEarlyMark\":\"Allow Faculty to Mark Attendance\",\"selfAttendance\":\"Allow Self Attendance (Employee)\",\"gracePeriod\":\"Grace Period (Minutes)\",\"defaultStatus\":\"Default Attendance Status\",\"checkAvailability\":false,\"allowOverlap\":false,\"programApproval\":true,\"newProgram\":true,\"newNomination\":true,\"attendanceReminder\":true,\"programCompletion\":true,\"hallConfirmation\":true,\"nominationDecision\":true,\"programReminder\":true,\"feedbackRequest\":true,\"systemAlerts\":true}','2026-10-03 08:18:23'),('program','{\"categories\":[{\"id\":3,\"name\":\"Leadership\",\"description\":\"Leadership and management\",\"status\":\"Active\"},{\"id\":4,\"name\":\"Behavioural\",\"description\":\"Soft skills and behavioural training\",\"status\":\"Active\"},{\"id\":5,\"name\":\"Domain Specific\",\"description\":\"Domain specific knowledge\",\"status\":\"Active\"},{\"id\":6,\"name\":\"Mandatory\",\"description\":\"Mandatory training programs\",\"status\":\"Active\"}],\"types\":[{\"id\":1,\"type\":\"Workshop\",\"description\":\"Hands-on training\",\"status\":\"Active\"},{\"id\":2,\"type\":\"Seminar\",\"description\":\"Knowledge sharing session\",\"status\":\"Active\"},{\"id\":3,\"type\":\"Training\",\"description\":\"Regular training program\",\"status\":\"Active\"},{\"id\":4,\"type\":\"Awareness\",\"description\":\"Awareness programs\",\"status\":\"Active\"},{\"id\":5,\"type\":\"Certification\",\"description\":\"Certification program\",\"status\":\"Active\"},{\"id\":6,\"type\":\"Orientation\",\"description\":\"New joiner orientation\",\"status\":\"Active\"}],\"rules\":{\"requireNominationApproval\":true,\"limitParticipants\":true,\"allowWaitlist\":false,\"allowExternalParticipants\":false,\"autoCloseNominations\":true,\"minimumParticipants\":5,\"maximumParticipants\":100},\"defaults\":{\"durationDays\":1,\"startTime\":\"09:00\",\"endTime\":\"17:00\",\"hall\":\"\",\"category\":\"\",\"type\":\"\"},\"codeFormat\":{\"prefix\":\"TRG\",\"categoryCode\":\"TECH\",\"year\":2026,\"sequenceLength\":3},\"statuses\":[\"Planned\",\"Ongoing\",\"Completed\",\"Cancelled\",\"Postponed\"]}','2026-10-03 08:16:26');
/*!40000 ALTER TABLE `application_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attendance`
--

DROP TABLE IF EXISTS `attendance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendance` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `program_id` bigint NOT NULL,
  `employee_id` bigint NOT NULL,
  `attendance_date` date NOT NULL,
  `status` varchar(20) NOT NULL,
  `hours` decimal(5,2) DEFAULT '0.00',
  `remarks` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `program_id` (`program_id`,`employee_id`,`attendance_date`),
  KEY `fk_attendance_employee` (`employee_id`),
  CONSTRAINT `fk_attendance_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_attendance_program` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance`
--

LOCK TABLES `attendance` WRITE;
/*!40000 ALTER TABLE `attendance` DISABLE KEYS */;
/*!40000 ALTER TABLE `attendance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `backup_history`
--

DROP TABLE IF EXISTS `backup_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `backup_history` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `backup_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `backup_path` varchar(500) NOT NULL,
  `file_size` bigint DEFAULT NULL,
  `created_by` bigint DEFAULT NULL,
  `status` varchar(20) DEFAULT 'SUCCESS',
  `remarks` text,
  PRIMARY KEY (`id`),
  KEY `fk_backup_user` (`created_by`),
  CONSTRAINT `fk_backup_user` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `backup_history`
--

LOCK TABLES `backup_history` WRITE;
/*!40000 ALTER TABLE `backup_history` DISABLE KEYS */;
INSERT INTO `backup_history` VALUES (1,'2026-10-01 18:56:25','./backups/bel-training-1790880984865.sql',135031,NULL,'SUCCESS','MySQL dump created'),(2,'2026-10-01 18:58:14','./backups/bel-training-1790881094089.sql',135197,NULL,'SUCCESS','MySQL dump created'),(3,'2026-10-01 19:02:50','./backups/bel-training-1790881370220.sql',135309,NULL,'SUCCESS','MySQL dump created'),(4,'2026-10-02 05:05:11','./backups/bel-training-1790917511455.sql',136251,NULL,'SUCCESS','MySQL dump created');
/*!40000 ALTER TABLE `backup_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `unit_id` bigint NOT NULL,
  `dept_code` varchar(20) NOT NULL,
  `dept_name` varchar(100) NOT NULL,
  `description` text,
  `status` varchar(20) NOT NULL DEFAULT 'ACTIVE',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unit_id` (`unit_id`,`dept_code`),
  CONSTRAINT `fk_department_unit` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (1,1,'QUALITY','Quality','Sample upload master data','ACTIVE','2026-10-01 17:49:27'),(2,1,'HR','HR','Sample upload master data','ACTIVE','2026-10-01 17:49:27'),(3,2,'PRODUCTION','Production','Sample upload master data','ACTIVE','2026-10-01 17:49:27'),(4,1,'ENGINEERING','Engineering','Employee import master data','ACTIVE','2026-10-01 17:54:46');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `documents`
--

DROP TABLE IF EXISTS `documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documents` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `program_id` bigint NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `file_path` varchar(500) NOT NULL,
  `file_type` varchar(50) DEFAULT NULL,
  `uploaded_by` bigint DEFAULT NULL,
  `uploaded_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_document_program` (`program_id`),
  KEY `fk_document_user` (`uploaded_by`),
  CONSTRAINT `fk_document_program` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_document_user` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documents`
--

LOCK TABLES `documents` WRITE;
/*!40000 ALTER TABLE `documents` DISABLE KEYS */;
INSERT INTO `documents` VALUES (13,4,'_netravati_peak.jpeg','program-folders/t3_test3_3/nikhil/_netravati_peak.jpeg','image/jpeg',NULL,'2026-10-03 06:18:05');
/*!40000 ALTER TABLE `documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `employee_number` varchar(20) NOT NULL,
  `employee_name` varchar(100) NOT NULL,
  `unit_id` bigint NOT NULL,
  `department_id` bigint NOT NULL,
  `designation` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `internal_phone_number` varchar(20) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'ACTIVE',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employee_number` (`employee_number`),
  KEY `fk_employee_unit` (`unit_id`),
  KEY `fk_employee_department` (`department_id`),
  CONSTRAINT `fk_employee_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_employee_unit` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
INSERT INTO `employees` VALUES (1,'12233','test1',1,4,'willl me add soon','test21234@gmail.com','8978828',NULL,'INACTIVE','2026-10-01 18:43:57');
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faculty`
--

DROP TABLE IF EXISTS `faculty`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faculty` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `faculty_name` varchar(100) NOT NULL,
  `designation` varchar(100) DEFAULT NULL,
  `organization` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `faculty_type` varchar(20) DEFAULT 'INTERNAL',
  `status` varchar(20) NOT NULL DEFAULT 'ACTIVE',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faculty`
--

LOCK TABLES `faculty` WRITE;
/*!40000 ALTER TABLE `faculty` DISABLE KEYS */;
/*!40000 ALTER TABLE `faculty` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedback`
--

DROP TABLE IF EXISTS `feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feedback` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `program_id` bigint NOT NULL,
  `employee_id` bigint NOT NULL,
  `rating` int DEFAULT NULL,
  `comments` text,
  `feedback_date` date DEFAULT (curdate()),
  PRIMARY KEY (`id`),
  KEY `fk_feedback_program` (`program_id`),
  KEY `fk_feedback_employee` (`employee_id`),
  CONSTRAINT `fk_feedback_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_feedback_program` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `feedback_chk_1` CHECK (((`rating` >= 1) and (`rating` <= 5)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedback`
--

LOCK TABLES `feedback` WRITE;
/*!40000 ALTER TABLE `feedback` DISABLE KEYS */;
/*!40000 ALTER TABLE `feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `halls`
--

DROP TABLE IF EXISTS `halls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `halls` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `hall_name` varchar(100) NOT NULL,
  `capacity` int NOT NULL,
  `facilities` text,
  `photo_data` longblob,
  `photo_content_type` varchar(100) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'AVAILABLE',
  PRIMARY KEY (`id`),
  UNIQUE KEY `hall_name` (`hall_name`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `halls`
--

LOCK TABLES `halls` WRITE;
/*!40000 ALTER TABLE `halls` DISABLE KEYS */;
/*!40000 ALTER TABLE `halls` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nominations`
--

DROP TABLE IF EXISTS `nominations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nominations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `program_id` bigint NOT NULL,
  `employee_id` bigint NOT NULL,
  `nomination_date` date NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'NOMINATED',
  `remarks` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `program_id` (`program_id`,`employee_id`),
  KEY `fk_nomination_employee` (`employee_id`),
  CONSTRAINT `fk_nomination_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_nomination_program` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nominations`
--

LOCK TABLES `nominations` WRITE;
/*!40000 ALTER TABLE `nominations` DISABLE KEYS */;
/*!40000 ALTER TABLE `nominations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `program_faculty`
--

DROP TABLE IF EXISTS `program_faculty`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `program_faculty` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `program_id` bigint NOT NULL,
  `faculty_id` bigint NOT NULL,
  `faculty_role` varchar(50) DEFAULT 'FACULTY',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `program_id` (`program_id`,`faculty_id`),
  KEY `fk_program_faculty_faculty` (`faculty_id`),
  CONSTRAINT `fk_program_faculty_faculty` FOREIGN KEY (`faculty_id`) REFERENCES `faculty` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_program_faculty_program` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `program_faculty`
--

LOCK TABLES `program_faculty` WRITE;
/*!40000 ALTER TABLE `program_faculty` DISABLE KEYS */;
/*!40000 ALTER TABLE `program_faculty` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `program_folders`
--

DROP TABLE IF EXISTS `program_folders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `program_folders` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `program_id` bigint NOT NULL,
  `folder_path` varchar(500) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `program_id` (`program_id`),
  CONSTRAINT `fk_program_folder_program` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `program_folders`
--

LOCK TABLES `program_folders` WRITE;
/*!40000 ALTER TABLE `program_folders` DISABLE KEYS */;
/*!40000 ALTER TABLE `program_folders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `program_halls`
--

DROP TABLE IF EXISTS `program_halls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `program_halls` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `program_id` bigint NOT NULL,
  `hall_id` bigint NOT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_program_hall_program` (`program_id`),
  KEY `fk_program_hall_hall` (`hall_id`),
  CONSTRAINT `fk_program_hall_hall` FOREIGN KEY (`hall_id`) REFERENCES `halls` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_program_hall_program` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `program_halls`
--

LOCK TABLES `program_halls` WRITE;
/*!40000 ALTER TABLE `program_halls` DISABLE KEYS */;
/*!40000 ALTER TABLE `program_halls` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `program_settings`
--

DROP TABLE IF EXISTS `program_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `program_settings` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `program_id` bigint NOT NULL,
  `max_participants` int DEFAULT '0',
  `min_participants` int DEFAULT '0',
  `allow_repeat` tinyint(1) DEFAULT '0',
  `is_active` tinyint(1) DEFAULT '1',
  `notes` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `program_id` (`program_id`),
  CONSTRAINT `fk_program_settings_program` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `program_settings`
--

LOCK TABLES `program_settings` WRITE;
/*!40000 ALTER TABLE `program_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `program_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `program_types`
--

DROP TABLE IF EXISTS `program_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `program_types` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `type_name` varchar(50) NOT NULL,
  `description` text,
  `status` varchar(20) NOT NULL DEFAULT 'ACTIVE',
  PRIMARY KEY (`id`),
  UNIQUE KEY `type_name` (`type_name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `program_types`
--

LOCK TABLES `program_types` WRITE;
/*!40000 ALTER TABLE `program_types` DISABLE KEYS */;
INSERT INTO `program_types` VALUES (1,'INTERNAL','Internal training program','ACTIVE'),(2,'EXTERNAL','External training program','ACTIVE');
/*!40000 ALTER TABLE `program_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `programs`
--

DROP TABLE IF EXISTS `programs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `programs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `batch_number` varchar(50) NOT NULL,
  `program_code` varchar(50) NOT NULL,
  `program_name` varchar(200) NOT NULL,
  `program_type_id` bigint NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `num_days` int NOT NULL DEFAULT '0',
  `total_hours` decimal(8,2) DEFAULT '0.00',
  `description` text,
  `status` varchar(20) NOT NULL DEFAULT 'PLANNED',
  `created_by` bigint DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `program_code` (`program_code`),
  KEY `fk_program_type` (`program_type_id`),
  KEY `fk_program_created_by` (`created_by`),
  CONSTRAINT `fk_program_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_program_type` FOREIGN KEY (`program_type_id`) REFERENCES `program_types` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `programs`
--

LOCK TABLES `programs` WRITE;
/*!40000 ALTER TABLE `programs` DISABLE KEYS */;
INSERT INTO `programs` VALUES (3,'2','tst','test2',2,NULL,NULL,0,0.00,NULL,'PLANNED',NULL,'2026-10-01 20:32:24'),(4,'3','t3','test3',1,NULL,NULL,0,0.00,'abcd','PLANNED',NULL,'2026-10-01 21:20:11'),(5,'4','4','test4',2,'2026-10-02','2026-10-09',8,64.00,'nnn','SCHEDULED',NULL,'2026-10-01 21:24:13');
/*!40000 ALTER TABLE `programs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reports`
--

DROP TABLE IF EXISTS `reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reports` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `report_name` varchar(150) NOT NULL,
  `report_type` varchar(50) NOT NULL,
  `program_id` bigint DEFAULT NULL,
  `file_path` varchar(500) DEFAULT NULL,
  `generated_by` bigint DEFAULT NULL,
  `generated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_report_program` (`program_id`),
  KEY `fk_report_user` (`generated_by`),
  CONSTRAINT `fk_report_program` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_report_user` FOREIGN KEY (`generated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reports`
--

LOCK TABLES `reports` WRITE;
/*!40000 ALTER TABLE `reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_permissions`
--

DROP TABLE IF EXISTS `role_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_permissions` (
  `role_id` bigint NOT NULL,
  `permission_code` varchar(100) NOT NULL,
  PRIMARY KEY (`role_id`,`permission_code`),
  CONSTRAINT `fk_role_permissions_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_permissions`
--

LOCK TABLES `role_permissions` WRITE;
/*!40000 ALTER TABLE `role_permissions` DISABLE KEYS */;
INSERT INTO `role_permissions` VALUES (1,'ATTENDANCE_MANAGE'),(1,'DASHBOARD_VIEW'),(1,'NOMINATION_MANAGE'),(1,'PROGRAM_CREATE'),(1,'PROGRAM_DELETE'),(1,'PROGRAM_EDIT'),(1,'PROGRAM_VIEW'),(1,'REPORT_VIEW'),(1,'ROLE_MANAGE'),(1,'SETTINGS_MANAGE'),(1,'USER_CREATE'),(1,'USER_DELETE'),(1,'USER_EDIT'),(1,'USER_VIEW'),(5,'PROGRAM_VIEW'),(5,'USER_VIEW');
/*!40000 ALTER TABLE `role_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `role_name` varchar(50) NOT NULL,
  `description` text,
  `status` varchar(20) NOT NULL DEFAULT 'ACTIVE',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'ADMIN','Full system access','ACTIVE','2026-10-03 06:48:20'),(3,'FACULTY','Faculty access','ACTIVE','2026-10-03 06:48:20'),(4,'HALL_MANAGER','Hall booking access','ACTIVE','2026-10-03 06:48:20'),(5,'EMPLOYEE','Employee access','ACTIVE','2026-10-03 06:48:20'),(6,'VIEWER','Read-only access','ACTIVE','2026-10-03 06:48:20');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `test_results`
--

DROP TABLE IF EXISTS `test_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_results` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `test_id` bigint NOT NULL,
  `employee_id` bigint NOT NULL,
  `marks_obtained` int NOT NULL,
  `percentage` decimal(5,2) DEFAULT NULL,
  `result` varchar(20) DEFAULT NULL,
  `attempt_date` date DEFAULT (curdate()),
  PRIMARY KEY (`id`),
  KEY `fk_test_result_test` (`test_id`),
  KEY `fk_test_result_employee` (`employee_id`),
  CONSTRAINT `fk_test_result_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_test_result_test` FOREIGN KEY (`test_id`) REFERENCES `tests` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `test_results`
--

LOCK TABLES `test_results` WRITE;
/*!40000 ALTER TABLE `test_results` DISABLE KEYS */;
/*!40000 ALTER TABLE `test_results` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tests`
--

DROP TABLE IF EXISTS `tests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tests` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `program_id` bigint NOT NULL,
  `test_type` varchar(20) NOT NULL,
  `total_marks` int NOT NULL,
  `passing_marks` int DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  KEY `fk_test_program` (`program_id`),
  CONSTRAINT `fk_test_program` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tests_chk_1` CHECK ((`test_type` in (_utf8mb4'PRE_TEST',_utf8mb4'POST_TEST')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tests`
--

LOCK TABLES `tests` WRITE;
/*!40000 ALTER TABLE `tests` DISABLE KEYS */;
/*!40000 ALTER TABLE `tests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `units`
--

DROP TABLE IF EXISTS `units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `units` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `unit_code` varchar(20) NOT NULL,
  `unit_name` varchar(100) NOT NULL,
  `description` text,
  `status` varchar(20) NOT NULL DEFAULT 'ACTIVE',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `establishment_year` year DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unit_code` (`unit_code`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,'BLR','Bengaluru','Military communications, network-centric systems, military radars, weapon systems, naval systems, airborne electronic warfare and avionics, strategic communication, unmanned systems, homeland security, cyber security, components, EVMs and solar products.','ACTIVE','2026-10-01 17:49:27',1954),(2,'GZB','Ghaziabad','Network-centric systems, radars, antennae, defence SATCOM and microwave components.','ACTIVE','2026-10-01 17:49:27',1974),(3,'PUN','Pune','Laser systems, combat systems, electronic fuzes, ammunition and security systems.','ACTIVE','2026-10-01 18:08:54',1979),(4,'MPT','Machilipatnam','Electro-optics including night-vision devices.','ACTIVE','2026-10-01 18:08:54',1986),(5,'PNK','Panchkula','Military communication equipment and encryption products.','ACTIVE','2026-10-01 18:08:54',1985),(6,'CHN','Chennai','Tank electronics, electro-optic fire-control systems, airborne EO/IR systems and gun upgrades.','ACTIVE','2026-10-01 18:08:54',1985),(7,'KTD','Kotdwara','Telecommunication systems, military communication systems and rail and metro solutions.','ACTIVE','2026-10-01 18:08:54',1988),(8,'HYD','Hyderabad','Electronic warfare systems.','ACTIVE','2026-10-01 18:08:54',1986),(9,'NVM','Navi Mumbai','Shelters for systems and homeland security systems.','ACTIVE','2026-10-01 18:08:54',1990);
/*!40000 ALTER TABLE `units` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_roles`
--

DROP TABLE IF EXISTS `user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_roles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `role_id` bigint NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`role_id`),
  KEY `fk_user_role_role` (`role_id`),
  CONSTRAINT `fk_user_role_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_user_role_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_roles`
--

LOCK TABLES `user_roles` WRITE;
/*!40000 ALTER TABLE `user_roles` DISABLE KEYS */;
INSERT INTO `user_roles` VALUES (2,1,3,'2026-10-03 08:26:20');
/*!40000 ALTER TABLE `user_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `employee_id` bigint DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'ACTIVE',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `fk_user_employee` (`employee_id`),
  CONSTRAINT `fk_user_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'12233','76e3e25c-0eea-4422-bd4c-f2216a251ac6',1,'test21234@gmail.com','ACTIVE','2026-10-03 08:26:02');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'bel_training_management'
--
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-03 14:12:21
