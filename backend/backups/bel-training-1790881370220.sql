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

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '844eeb4c-6b4b-11f1-a1ca-9ebcd1e3fe51:1-106';

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `backup_history`
--

LOCK TABLES `backup_history` WRITE;
/*!40000 ALTER TABLE `backup_history` DISABLE KEYS */;
INSERT INTO `backup_history` VALUES (1,'2026-10-01 18:56:25','./backups/bel-training-1790880984865.sql',135031,NULL,'SUCCESS','MySQL dump created'),(2,'2026-10-01 18:58:14','./backups/bel-training-1790881094089.sql',135197,NULL,'SUCCESS','MySQL dump created');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documents`
--

LOCK TABLES `documents` WRITE;
/*!40000 ALTER TABLE `documents` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `halls`
--

LOCK TABLES `halls` WRITE;
/*!40000 ALTER TABLE `halls` DISABLE KEYS */;
INSERT INTO `halls` VALUES (8,'test124',90,NULL,_binary 'ÿ\Øÿ\à\0JFIF\0\0H\0H\0\0ÿ\á\0|Exif\0\0MM\0*\0\0\0\0\0\0\0\0\0\0\0V\0\0\0\0\0\0\0\Z\0\0\0\0\0\0\0d\0\0\0\0\0\0\0l(\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0Galaxy A54 5G\0\0\0\0H\0\0\0\0\0\0H\0\0\0ÿ\Û\0C\0\n\n\n		\n\Z%\Z# , #&\')*)-0-(0%()(ÿ\Û\0C\n\n\n\n(\Z\Z((((((((((((((((((((((((((((((((((((((((((((((((((ÿ\Â\0\Õ\à\"\0ÿ\Ä\0\0\0\0\0\0\0\0\0\0\0\0\0ÿ\Ä\0\0\0\0\0\0\0\0\0\0\0\0ÿ\Ú\0\0\0\0ú\Ðw\×\ó®l±°\Æ\Û&\Ø”˜l¤l‡\0p`l¥F)‡3a\Ì\È\Åp\Ø`\ì*T•Á\0Q†Øƒl\r±Š†\Æ#\ÈG\ÊÁlde\ØÀ€ÀbA˜Ž1\\PÍ¡Š‘\ò“mX`6R±Ž\Æ\Û\00–DÌ¢\ì—†2*¸l r˜¡™)3#\å\ä+L01Â’\n4\è`\Êp™€	\ÆŒ„|„rŒ8`@\Ã\r”\Ãd\Ãe\ÔF1ŽÁ\ÃQŽUL%\Ê\ÐÍ‡Ë†¥\Ì|¤`0©Y¢£á‚¤\0l`A†+†\ÈGÉ†(J\Ã4\Éc\'W*F\Z“aÀÁ €®b*ºƒ”b¤£H”(\Æ\Ûla±¶\Ð1†Á#\r\Ã\å\Ô\Æd\äE\Ù0\í2P\Ë-‚aÀÉŠ\âšxg‰-¤FB¡3#eÁ\r”¸€l0pÁ\ÊF*F#“hº»L—UR\Í\"C*»\n­3(F\nGx’ºx¡‘©¡\00v01Ô¸€0\Ç0l.8\Û`Wáƒ°\Ø\ØÀ\ÆÀfÁÁƒ³\nŽ¢Œ*M¶!b\r°YJ\ÐÎ\Ølb¸a±­\n”\0e\ÊÁÄ¢–U0N\Æ!¶r…N31\ÄÁ„.:”:s&J™°\Ø¡ )ÀØƒ6&¬¦\r†”€0V¥¡N4#C•a\"–U2W.R6À`	©*•1R;Í†8ŠN1\Øcƒ±blDb\rmv¢¯ l†eÀl¸g›A2”f™(dB§b)\Ø,„¢JN\Z\0+–œ\Í\Ç`\Ðv\ÊF\È\Æ#le`\Ùr¹“6G¤]jS\ÊÁ°J‘ŠŒF†Ë¨\à*O¦e\ò\å|¸l0p&+Š°ù1”ƒ\Ãl†	V	@p\Ã…(Œ\r†–y4>\\¸%@\å\ÅJˆ\\p™Á±\Âí•ef\\30\Äp\Øa²‘°!©\0;(\Úx\ó\ÖmŠb¸\ìlp„€áƒ†	†\Ú6\Ø$=.:3)m€\ã0‹LEmª:º$\í©Y\ÚP‰™\Öˆ›b\Ø\n¶V6*p¥°as\"“±#lW\r—\r—\0l¸\ó²\ë.G)–™1L0 \Ø\Z\Ç4):¶&Ž`@\r3¨‡\ÈFGSEM@#8›eG)”Í‘\Øb¤`\n\à\Ø\Ø\àm†Œ1\\0\0`0pa‚6À#`\åÁ\Ã#‚¤aSG‡­””“\ÓÃ™‘\Ì\ñs&¡‡3`•&ª‹€Á1LšLxÐ¶@®»#\åeG%2TÍ‡(V…\Å8`€€©\0l˜|˜|¸l¸ d \0•\å\Ã!À.¯7!FË†À+e\ÃeÃ”Ã™‘\ò°Ã´\Ü,†(b\Ã\éŠc2QT‡.\0Gyb\ì`*:ŠA¡ˆ1V‡+†i1L˜®“-4\ñL„#™0\àce\Ãe…\È\Ù0\áp\Ù@\ÙAL˜|¸|¸8j\ó05ˆ!8¢†\n§`\íŒ\n@‚W\Ò%´X-<TÄ2\Å4\ñLŒ	Š‚7*\Ñ%•Z pfVŸ +¢Á\ÙG(Gišf\Ï\Ó#\é\âºD¨Bll‚©§¢šD¦žª\Ãe#Ã™‚ºE8²|š¦G\Ê²•l¸b¸ ‘s3’z€™8P\ØU¢Š\Û&\Û)d(ÌŒ;L\År•/<[H”E@¨Ê£™‚\ÚD®ž*“\Ò\ÅtÁ]-h’¢z›&(..¦GÊ¥4\Øla9bm¶‹C\ä\Ô\æx¦ž*dJ™1M<WO3\Å4\ñP˜p¡)Ž\0\0#`”#•\Å\Z¸–.\"J‰e A#ª…`ª•2\ËS\"WHŽf\né’ù@\Ù@ùù\Ù\Ä\àCŽ\0|ˆ)‰U™R=(œ¢\Èq•Ša\òa²‚†yk¤R\ÚF«§Šé’šx¦L9ž J˜±]\"PO\ÈFÉ†+‡‚0(.(WÉ†‚\0!\Ï\Ó\ÅIS,T\È\Åt\É@˜|„s2S!(fJ#´˜¦L9BP¡G*¥A\á\âšx|€|™\\\Ï3\ÉM2SL”25STÈ”3#\åÁÁF)‡\Ó%4\ñM<”\Ó\ËM1W\Ð\Ò[K4\ò\ÐL\Ò\ÅÁ]\ÑÅ´MWK1%L‰]<T\Í\à”4\Å9ž(fJb\ÆT\ÉK·9:™Žƒ\ÎK˜d\ñJi¦)†É†)‡É‡É‡(F3Ã™ê¡žJ˜•³s²\\Ä–\Ô\Údl s2>L6\\6\\\0\Ù>˜)§‡\È\Ó@€}3\r—\r“dJb\Æ$³\'M>±H•ÀM¨\à£\Þ=\ð½/…\æ\ïh\ñ±\É\\f\Ó3b%dpŽÐ¼C¹NU\ì\Z\÷,qnµ^sr‘6-\\KX‘\'>¸#¬\Ô\"j&\Ù$,*e\ô.£Tµ‰\Òl\å\Ýz^%\ìC”t\ã›tcœ\\DE\Ê\ó\ë’\ë´rÓ¹\Ï*>¢H\õ:	¾’’ü\ßO«Z\ógžŒUˆ\ëu\ÜÞŠ=^³¯t\ÆI>°\÷‡B·?DŽq0\ç·5]§RstIns¥ŒšV!¬„&$LE²ƒœTb¬„3T\õLGTR\"œ€FË†3\Ï>:41UL8PÁUYas<«\é·l%º-/;\"e|þ\Ê14²œü\Ñ8¹=Y?G“\Ö9\íS,RŸJP\î\ç²i%\r$•,¬\âŸDX”t“/3g \ê\ãQ³M¡gi\ÒM…‘\Ô°\Ã!#µ˜\Å&|LU“™zA\Ìz\rsns\ë–¦©\ë´r”X5D=“ª:š}™Õ\ZR\órŒ\r89\åÒµ\Äý.-NŒp6\ó¨Ç£‰2GWta\ÎY8Ežž\à\è5¹\ÄW\ë9}[\ö\Ë\ò…—Yl¥N$l¹L3\ÒjL\äž|!&”–$V\ÅlªXˆ\\\"œÐ¥….\æ\å—\Ò3\æc_o\çü-1¯®\êø±›ú;~m\ìk?]#\é\ôÏ\ÛzK­Œ¹³˜\â¯6\Ø`°\0\àER¤¸ûx+\Ï4\ÖJ®#\Ý4‰¤€¬‡_­Á\Ù/V\Ú_Ž/^˜ƒP’©\Öde…Å•]ž\ÄZ‚&¸B\ÚUÎ \É(\è<2\Ã\Ô>*fû­\ó°\Ë\éy|\Îúœ\ÜC\è’\Í\ì\çç–µxº\ê®k\'5\ßB\'RDŸtiÅ½n<ÿ\0³\à\ô{gÒ§\'E”*Gd`BA©\08†\n0€C,“V^$\î[ /#‘]Nh\Ö\Ñ\Ðnù\ÞW8Ÿ6o¶K²[Yˆ!9ls\çùüµ\ï\òü\êq×·\Í\ã?-\öÃ•s{\ã\Ó\Ü,`\ò4¶´6j-)•”\çm˜TÍ˜‰\Ñ\Ñ\'5šJÏ¢\Ú\õ=û¡n®Î²7½,\ç{\01eb0\ÅHJ‘Š²1†\0­)‚b\niVK9¹³™{(y\ï\ÞO;¢\åd\ï…\Ç\'\Ã\îœ\ï¹\õt?+M\çq\ó¾\÷?\Ï\ó\ñ×«Á&\ãª\ìÚ¤-O‹B#\ât\"‹—Ì„zVÙ½kÃ¤\'ì²¥+™:¾\ÌF—-¾¤|a«Þ¼²Þ½o¦øZ\ê~‡oúÎ™\ë¤_r\æX®Mk˜‚\æXÍ‡da²‘²\à\áŒ\n¦+†\ÊG(U\Ì\ÊS)S\à1R\0\ÙF6Züü/3=S\ó\'\Ë]\ñŽ¦\ì\Ù.q33bEª	’ª­¶ˆ\ÝÀ˜W\Ã3.Á•­µ\é7Ph\Ùkœ\Ü\ÝsŽ… *-ƒ=*^§3\õ{ýÿ\0=\ê\÷Ï£Nn‘\ó%“]ƒY\ÙYÔŽP—”„©p°LT©\ÊFi’†x¦L>@SOfi™>Mc*ƒ\ò\ó}\ð\Ô\ÇH™\Ø\\ú\åTQS5:\Õ\ìI\Ô\ÌFwˆ¯IŽV\ì\ÒB‚qE’WBÁV\ÂJ¬²º\áXª•5\nR•\Ó\Û\Í\évnù\õv‡¦MeÄŠ¹‘J•¡G	F)))1\n0B¤À\òŠ\òa\ò\òaŠd¡˜*i\ô\ñù\Þ\Íç‰š•\ím§%/¹µU\")§ûy:û©\Ï<·\è\\L\ñX\êŸ*WT -²\ÌUpAÁ\nJª¢\ÝTÁ\ê­\Îb\æ\":\éÁ_\Ðùþ½¾ƒ§\Ç\ëúg¢Ñ¶\ã\n(•g\ÄÌ„|¸l0\Øa°ÁÀ˜`‡l¹X\n§®&..F\ÊÉ©\Â\à\å\ÉùÈ¢ü\Z\È\Éj¥\èœ\Ó\ô´y\r\ï1\ættGnt\Ì\é^i\×R\ò\ëo4ùu0P6\\\Ì\0\Êe\"†Ê§›.È§B°·V;}\Ï\ßú¡\Ó\×e#…Q\Âa\Êe|0ùr>\\®	R`p\Èr \á0ÁTl‚©¦\niè¦™§\È)‘²\àÚ£Î²\èC%ÓšQÖ¼t«¬T¢\Ím¦Dª\îf¶\Ú\nt‘}\ËJ¶4v¿–5}3\ä\ã\Õ_(W§/?¡lW¢B\×\\I30…Œ ql\ÇKj\òS«§kû~W§\ÞvÓž»\Í \ÂH\\Á‹¼ªP(ÌŽP­0(Já²‚€¨Q²je˜¢¨¦.)FÀ‡|Lü„øu\ìC\Î6\öOžz¾‡N\è\ókl™iŒÁÐ±1M:–‰-\É\ÏK\ôIæ·¬s<\ì\òz=\'+ulDª> $@ÍµWM5®›\ó?K\ÐR\Ûs¦þ?¥¹\ê×—£¦LUºƒu\0•\0\Ó¤\ÅZlP¦(™F\0\"\ÑTT¨‘(ªŠÁr6\\¶3tfž)¦\nˆ°\áqùjÃ©¤\ÜJ²Ä…M@Ú‡;\ö\ç“vS3–´\ç9jb\ÝsRúIiF‰•\ÙC‘¢FLZ­*\r\ëš\Î7m~.:œ\ÓNué¦‰\Ýg\ÞhXm5¥w(¬$YU¸”U-išmD:-L2  \ÐJLF\\S..(faÀZb„¡G?.~\ñ\ñ\ïŠÕ’$\éÐ¼­\Þøœ\Õv\ÌG³f%\'²¦\ÚLB\ÖÉ«MŸW\î\ñ\Î\ÔH}%Š,9›K—\nÅªÅ­\Õ=\Ï\Ù\Òý\Ôj§rúœ\ð¼+¢þoe_¥:,ÀÀ&2\Î%Û€¯uymc\æ`£\äÃ™0F+MAT@@¤\0¨(Q\Â6¡°??B\Þ}ƒt\Ð\ç\è;A©¨,®Dutžt:N	Ù­,\'™A0<\Òz¸¡;Aa œ°\ÆmnG\n\ÏzþGwW¥Y7wF–\Ô©R\ïN«.\óÕ¨°´\ç\í’\ð5¨#\Ô\ÐtDºÉŠi°\Å0\ë”	’\Å\ÃÒ U°‹U\àXz\Æ\Ð\õ\0Œ•\ð\ÖZy—ž‰`º&c#T•BšUj\æj•æ£ \í%Qr”aFM6A«F\ÌTs¡3[(\"\Ç:ê¶žÛ®\ð\õzª•\í8›¡ªWG²½™\æ…RL\åª\ôÀ\ÅžZV/c+’*\ò\r KÃ´\Ø+g³™ºTƒWZLDe\Z¥@ÄŒË +J¾_§Í¼]6lI6H\0jÚ–}	Q¼\Z\Ú\0s\É]‚‹´4²Jºj›avÌƒ\Ý%\Ï5+9¥µ[t:§ \ô¹;z^ÿ\0B}]²ea\Ðr\Ù9·KR£s\Õ\ÖU4\'Š\Ë\Ó)½–\ÊUÅ„Í…•’²Ž\ÑbÔ“¥m\ÏR\Ç1y¤\ÅLEK¹¢y\ñt\êø\ô\É\å0W±‰±\"†Rj\õ¨nŒB”\Ñc\Ö)\rh\Úw2ii2Z\î¶\ÉÖ‡)\ë1ÌŠ¼ƒ·»«\È\ë\õzz\ß.ž¤¶\Ý<\×Ü©WÜ“½‰“\Z—O*¯G1Ž´#RÖœ­YÖ‹.†°¶q¬s©É¬*\È\ö\æs³+’\r5T(QV¦r¨\õ`¢\êM\ó\nN>KùD¢¤6\\>™H”h‚f›Œ_˜¼$úrÓ¢Z»1’5£ª[>%)•·2/[\ð=¾¿w\è\õžˆ˜ú-\ç&\Õr)©º¹k§@ˆ±\ã§P\ã\è\ñ\óª\ÛÍ´¾\ä4u—\Ü\Ú^ƒ\Ì\õÒ²T\í·-´©‹¥Z-U\0\n!«3\Çk\Ë&žÁJUyß¤£P7JJr¶O^:ùv\Æ®„F1ltŒûC‘@·s M)\Ë4:1U(¨\ÂkB°²Zý\ìz^\'E\ô\äž\Õ|K\îú‡„\í\Þ<\ä®\á\äÞ‡\îx’È/\Ð(¯Lp\òzÜ²\ÂÜµZÓ’‰\Ûh*\ð½Œ\ê\Ö>˜*Q‚	\'×ºbt!ªh\Û9³16q\0…2•¬C†?;Žo2•€\Õ\êmÓ™:¬\ä¬Ö§=k\"›˜\ÃÎ‚\ÔzZH=V6ˆ‡\Ò\Ô\áR\Û\ÆdÖœ¤|¡kN)W¡´“\ê\ä\'\\\Ö=k\ß\Ë:¾¤\åN\Ñ7Û¿\Ì\ïšy\êšúœ\Ý}38t\Ì\ñùý^<\ÞKi\Ë\ê4:5+e¾¡g)\Î-©$\ZJ‘\Ùx8êª”\Ú\ï‹´	P€`5ˆ¸”Rqù–~¯6Ã¤¾$š’ŠŽt«NBÚ‰T-JH”H\å\Ó$Q€…Qfú¬ª\Ã0i\n\Ä\ÍLª-N{Ï¥\än·k\Ì\Ý\ñ«tù—\Îožy%\ë¦\ôü{\ô¾»\ò\öt•«t\îr·F²N–¨Ëªu\Å>\Ô\Í\ãªs\õn»5	³b+)\ÕE|\å\n(\Ï\Îk¤IÊ´£0£\r±¡¶M¶>f<£\Êb™U\í\ÏGËžµYr’ºH2‘ht•Y\"ú²¨¯?DfØ˜\Ì-€hGcl\Ë4±j­W>¬²z±\ë\å cÞ¶pT?k\Ñ\Ñý½K)\ëœ\Ä\ê#†&—9¡X\ë’U\Å6 \Äa\Ô\0`\â¤ÁÔ…¨´3‘ÁF\nT²°\Äj#d\Ø\ó…­ü»\Ë^‰\Â\ÒS-0ƒj;\Æ0&6˜2\ÛA:#¾F‘Tµ¬E²V£\å\ÒNg©#\ÍÝª\ÐÕ†¹Ý\ì\è\è\òmÓ´eî®žo¯\É\Ý\Õg+¼\å]£²²m*”•Œ\É]œAT2\Ö\ÄF*B	Aª-‘c\ó l!|+©	\Â61\Øø\ä\Ü\0§2\ÈÁUH-J\âe\"\æ\Ð]Óž·A\ô\ß\r>†Hn\ë\ËÁNÅ…¤„\\DÅ‡>®…ˆª¦el­´úS\Ô\ëa\Ø\÷\ë<þWUz%Jb©©p§Lµ›V\Ç”fÁt¡•À¡À\0Œ\ìJ¬È‚…`jKe\Ç-0Å‰›B“¨@N?3W] )7Q3\êC–Œ\î\æ´[&•jp\Ó\ÐX•L\ä«A%\ë^mVY²\ÇUT8\ZµŽvº‘v°\Ð\îN¿GÁž\ß[Ÿ\ö{\Õj/Fw}DrúŽ¦\Ø\ÖV\0„\Õ$ˆ™Ø›3*\Ê1Â“€	›\0’r(mK˜˜«ŽO\ÍWo*²«R­\ç{=I\ÛA-±(\ÐX¨€·¤\ñ’\ó˜¦iêªŠD\Þ\Ö9®g-\Ìº\"­\Õ(MO=t,\ÞÊ¢\ÊÛ·9Ž”=\Ztú¿?\Ù\ô=¶\ä¿X\í7Ðº¶¡\ÄY\Å\0Ä‹›\06\Ø8²±¶\Æ\Ûp	ŽM¶\\­¶@?6µg\äPÊ¶Rbv\ÓM£l\æ[R8\×Ðºù\ÙÇ½pyÖ¡\â\Ó\×	\è\ç\rL\0\Ê\Íh¢$Wž\ô®F\'dG»X\Ôû%ß¥^m\Ñn¨\ÓSª±¿I˜\Ìs\0³Ò¹ Í…Í…\Ç› 9•N\Æ;\0\âmˆ1\Æ\Ûl`p1À\ÇmfKù°\Ô\ò“—}¥\òº=EŽ{m$¥§\'¥h\Ä\ÒÚ’™b¤0C™›ºU\Ê\ðë©·N9ž‚¡\Ï\ê\r<Iû\\;¯*\ôiæž§\'v\è\èlkJÍ¤»7F\Ì\ìw”,Er\ôj\Ì	Ž\ÆH¤\ás`@q8°¹°1\"\æ\Â\æ\"g\ç¹²ü2Àx\÷ IGÉ‚F\\\ê\öd|.%v9\ZœªÅ;E\ÑSÍŽ\É\òF½=\ç\ê\ô§\ÍR‰JtE\È\è¸Ï´\ÞÆ‚\ßi\Î*j]]B\ÓSµ1\Øb0H! \Ñ\0\ìH	\"\æ\"\"\æ\"\æ\"\Â\ç\Â\Â\ç\0Í…Ä‹ŠŒÜ¼\Ñ\ð®“[2Á\ÊÁi¥¶TQšZ¨‰;z*I\Æ\Õ\Ñ^|t/8.‹†¿>‹´ŒXE \Þ\nw\ôy/·½o\Ð\ì\ì&¡.\õ\ï¨)« \ÇXv5±\"’Lq¬Ib.l\Ø\à€F	\â\å\Í\õ\×>\å\ïošL¾¤|—<}¢|/./\Û\Ã\â\ß°\çù=/·\ç\ðn\ô\ó\ç/£¸:rf\ç®q«5W~g€TUE:E­r”E@\ôF˜\é©KŒ\Æt\Ò\ÑgP£¼t\\1\ÉC\Ép]µ_•\ÏO\Úùn‹>\Óx>\ç\Õ>\ë5\ìØš)b)$µ\Â1X;\É\ç\Å\÷\Ï\Ëpbý¼þ›¸\àù\Îû¼þ7W7­³c\\©Œ\í.\ç\éi&:§R3±¬•\æ\èt,´U\Õ\ÐG9}\Z-u±U\Ê(\à”û(h£H™)”Zh„+œL¤i/ly±}Â­\É\Z\r‚W_¡\äU>Ï¿\áþƒ\èž\Û%>˜H6c\ÍÉ›êŸœŽO\Ï\ò>o;\÷Ÿ)^og\Í\ãlVsr\ÖrR3ç·¢\ÙQ/9KZM¡ZMO&’]\ãIv)s”m\Èä¥¬7FdQJ,Z¹\â¿	®\É-\äR\Zm«ZH\Zª@r)\Ì@ÖŠ£U0lÌ¬b:Ë«fjF\á\ZrehT\éAVF\É\ßu\ærž»G\r\É=.ÏN®\÷\ò†mL šEŒg]z0;#\ÍrŠ e¿!\\µEW¨ªø\ÍK\×y\"\õ˜¡\ÐG\ÐÔ±f\Ê7&¥@Fš¤•›Uy\ZÁlx\ÚfU\é4;‰ç¯¡k|ºv‰9e\Ú\Çz9\á\án}*\ÐFŽ¶\Ü==5§#¡\'A\Õ9l®¤n‡=\öœ½]=y\Ý]V\Å\å~\äÌ¡£ª|\ì>\çjt\äÚ·MBN­*£LA™\ò\Õ4Ü¢\ñ\ô\'D¡XØšƒ\õs\Å\ç¨“jÀ\Ý­oD\Ä# Z*\ò\\\÷\Ó%)KUd\ËV›\í~#—U9(t,L´y¶D2²\Ô¾•\âUk\În°rOµE\ôA\ç\Ë\Ð:rÔ˜A\×SÏ·@•m[ÉŒr\Ö\Ñ\áX\ÃÍµY\é\ÓÌ¬¨Õ±\õ’D‡\ãkÔ®Ž2.%’„\ó•`\ÐtÅ”™úªº™£™º¦‘j¤+;,\nKLhÕ‚5\Ýh:\É/+\äj\Ö\ÊhœkX\çc¥gŠ˜[Ñ¸\î\\Í³¨§Q†#\"\ð\é\ê\'UN#|\ôUR$uz%\È5hý!9\õ\ì¼|¾¯0•fZQ:S†\ç5*ú}ˆ‹T§\Ø&¯3\Z6^;^65q…\Ý2I\\\Ù2RX“º’v\ç¥Rj’„5¤¤€Á\él)Y%Ï“\Õ6bº¡@jqz±¶n”ž¹\Êk¥«m\Îj\Ü\êa¤T¬‚ºe\ÏY\Z\ðãŽ¨\ÊÚ¼\ävj ¬±]	™”+\ó½¥iOC.Æ¬è™>ÄŽz?-5\Ò\é&\èHi.…}JÁ“3;\\Y+‰\Ò-A/§y-\ï&Ê“…\ËÊˆ©©ÎŒ\Íj\æ¦.¶^f¤\Åm^\æ^J\ÖzE¢Òˆ\ÕOi’Y$\í\Æv\"\Ý!.‚@½jt“sÙ—‹¢º\á’tÉ¦\ÊlV«,\ð\ÅG¦dmµ%[fl\òy\É\é6¯/u&‰cM u„H²a¢®2\ÔE\é\ä0j\Û\Ïl!gf%x\Ð>o®«\ç\ö]Sx]3oB\'-³®\Ü\Ã*\ó\Ý\õwBSžHP’«€´Q\Ö\ÈLSŸt\ò\ê\õÁ§•T¬jd¤\ËnN€+B\Úâ™ \ô\í\Í\Ñ)ºŽ…\ã\êužÈš¯)\ÏM2tÜ‚\Òe\ðžWU•YeXMI\ÖJ ÎyÞ·\ÑNb¥Ÿš\ö8ú-\Ë\ÔNkN²\ó\í\Ü\Ô\Þk2§¥\Z…A$”{\"Z\ë%z$§YPT\í9Õ3/Su\æª2\0º‹qC®c\nt\ÑU9Oj\Ù1U”0%\Ö\ç>®—¼›r\ô\Ö28¤fŒ„Ä’´\Õ\â½x«¾4Š\éæ¬+Y+\ËIdf¼\×\ë]8{@ŸCG\êUg¢D\r¼³¶±•—\æ\í–u]3d\ó\Ó\ôy5\Öü½9¥j*µ\÷VsÎ½#t”u/5\çŒ2· G%@vbOhš…9:„‹¥[F\ÆA‰DŠ\ö:%\Öu\ÔD\Í\ÅYUJ,±\é•yýH·=Lm\Ï¤\ÅS¢Y4Ã“\Í=ºŒšøj½œýœt‰\Ï.†YE\'\Z\Õø\Ã\Ën›c~p’W\Å\æsÍ²Ž•ÓŸ \Ò2¶–f¢¥«,£=ºJ\Ï`\Çj6\Ú;U\Ólš›\"tm™Ám·V›Em·9\ÎûTŸj \Û*&\ÒÇ¯m¶\Çb¼;l{5H\í%¡¶\ÝuÛ“6\ÄF\ÖÃ£m!]Ž™m!\çÙ¨“©v9º¶Š.\Èk%M¥\Çee\ÛdsÜ—n™¿VØ®Ù¬›\\¶ƒ\Ð\Û)\Ãm[y;/ÿ\Ä\0.\0\0\0!1 \"0@A2P`#B3pCÿ\Ú\0\0ÿ\0\ð\Õþº¿\×W\õw\öo\ó\ïû\ë,¿Î¿\î/\ße–_å¯»\Ù\Ùeÿ\0I~\÷ø—ý\Êû‹·\öWú5ý¥\Û\í¤W\Þ_þe—\ì_\ë‹\òo\òWú\ö.—ÿ\0˜Wú\Ò\ö\×TQBEu_\êW²Š_\êv_Ý²ÿ\0¾¿Ê¿e—\Òeÿ\0¡±}¥\öºÿ\0\Ó/«,¿kÿ\0F¿¼»Bû\÷ý\Í\÷€‹/\í\ß\ä\ß\õ·øW\ì¿Â¿·f\ËüJü›\ö?uý›,¿Ç¾¯\ó\ë\ì\Ù~\ë,~\Ûü/û\Û,²\Ë,¾\ï\ß~\Ûü¤»—O»\÷_\ôWÝ–_Ü¾\ï\ò\Ø\âcùv_\ô7ù\õù—\Õ\÷\ëWÕ—\Ý\÷e–_Ù¿m—\ö¯\í\Ùe–Ye–Ye–Y‡}_\â\Ùe–Ye–Y}\Ùe–Ye—Õ–_W\Ò\í}¥³}Ye–Ye—øWÕ—Ý—øVYe–Ye–Ye–Ye–Ye–Ye—\ÕûŸW\Ò(„D\â>1ª\÷Ye—ý}œH¦(Žtº¾©Q@\Ä\ÄI˜ŽKŽŠ\ö4Q‰F%”Q^\ê(¢Š(¢Šü\Z(¢Š(¢Š(¢Š(¢…=1pž™€\à8‹Ž\ÏL\ã\á=:c—Q[’\Õ\â³\ÓW$‘\Ç+iu.Ÿ‰u¡\õEQEbbbbQE{(¢Š(¢Š(¢Š1(¢Š\êŠ(¢Š(k\í\Ñ†\â¾Xƒd¸\Ù§\Òúdz)ˆQ¢zF,P\Üx\Ç<o%ÆŒhc+kBR/vr\'\Ó\ê\Ëü\Z(¢ŒLLJ(¢Š(¢Š(¯ÁG‰\é\ê<bƒID\\{¢Š\ZÃ‰Ä¬\\h\\i.š$†b!D\ð9ŽI“-\ô‹/Þ‘EuE~5\õe–Ye–Yeû\ñ#|\\iu”%\ì¯c!\Æ\Î5N>\Ç\ÓDŠˆ\ãvK§\Õ]¶_TWh]V¨}5\ö,²\Ë/\ì\ÑE}º\öbQ\ïÂŽ\Èý–>¨Q}\ì}LŠ¢\ÉHs,´d‰lc\ênNO\ö/§ù4QEQE\ÕbQ]\":#²*¾\ÛE•\öÉ³##\"r,L\ô\Ê+pã³•\í³\"\Ë\÷W\å½¿Y\ôü-“úb?]\ôìƒ\"q%(Š²1¯\Èd\Ç\ä“ê„„X\Ùg,„R\î\Ë/¥\Õ{\ë\ð\ë«]þŸ\Ô\ð\"__ÀŽO\òr\'\õÿ\0S1\å)F=9ŸO\õ\Ü\Ü\Ô\ðý@¢`(þL‘È›(¡q¶zT`b2†/0Òƒû±û(®«\î\Ð\ç’úž4K\ê\ä?¨\äfRe\ä\ã€þ¤—7;mrH\\(\ô‘\éÀJ4\ÛGý¬\\bI\rØ“>›‰·\ô\Òj)\ß\å4b>3F‰\"K§\Ö$QÆ¬Š®\â¬ÀÄ¯m\ö¼’\õø\Ç\õPÕ\ê\æ\Ê\ä\Ôr²R“\ê\Ñh\ÏNR0 ŒøË‘±)³\ÓB¨\ô“¢JBúD\Å\ÃBã³‡Žˆ¡hL¿Íú‘Bˆ AW²\Êû²\ç\ã‰/«D¾«‘’\å›,²\ËE¢\ËC\äFsbÉ”\Ê\é\Û˜E¿È \ÅÀŒUA„…¥P¿9ag¦(\n%{¬e—\îrQ\'\õpDþ®l”œ‡4‡\Ï+E1\Øå¸¡.\ò‰’\í\Ò2creY”bP i\õ\"T™9\\8\Å\Äq\ñ‰]\×å±”Qˆ‘E\íÍ™³6f\ÌÙ™™š2Dþ¢9~±ž¦^ÏTQB‰‰K©dbº©	>\×b(Ø ŒJk©N	z°=h\æþžP\ä†\"Bº\Ëüªü\'\É?©²S“1l\\qJ\ã›•(r6 Wu\Ú]h\òD\Ñ\åR4\"K¤\"\\‰šLžS^›g¥\ñ|r\ÉqRnqM\õœ\×\Ç\ÉH.¬¾\ì²\Ëþ–\Ë\ê\\‘ÿ\0\"\ÉNr+\ÙEW½F\ÌR$\Ï\äR^\Æ\ËlBŒ™ˆ¨f,\Ä\ÄÇ»\ë*Žg‹\ê\È\ÈB\í²\ËK\ò¯\ì·D¹R\'\É\Ë\"<IWU\Õbº¡\è\ØûP\ë\Ï[M£b¡û|”h\Ð\ÚG¨Œ¢F˜¢(\ïS‚\"\Å\Ó(¡!KMŠ%w]W·\÷¿fØ©QVU\r\È\ô\ÛR$\Ò\ê\Ë,²Ì‹\ö¾¡GBŠ$H¡QbŠ\í²\ÍIFg©/R(\É¼dzb\ãCqFH\õ3\"Ì‹ûQF$x\÷5p\Ñue–Y\Óþ¼ûlo«Ì‰>©\È\â\áP>R#\ÅFE¡\Ìse²úß¾\Ë,¾¬³#1M23 \È\ÈR/ú\ÊE™ÕŠ†\è»o¦Í·\ÇÀ\Å\Æ\Å\"\Ë,±·\ö¬¿e\ô¶[\ö\Ò#iÇ—)\Ù\Æ\Ä.¨¢¿:þË³bmŸ¬‰\ò\ãäœ¡\ôü—\è\ñ²ŒM–d9\'\î²úiýý£6qJ\ß	A}\ßÚ¾°“\ÏAR\à\âB\Ñe\Ä\Ì\ÌÈ²\Ë\ö_\Ù\ßU\Õý§\Òd5\É\Ç\"\î\Ë/\óo\ì\à\Ìb‹ÖŒ‘“,¾¬¾¯\Ù}lß¶\Írn‹\"3\È\ÙT\'o\ÝE›g\Ó\ñn\"\îú²\Ë,_ˆþý3%9™ŽB¶9$²‘\ê#$e·!\ò£lsFbL|‰<­\çC–›\ælÍŸ§Dš=I»¤ˆÁŠ4œ\n\ö£0\Æ\È1>\Û22,Bü[ûùX\åFFgªzÇª\ÜýF\Öe™46Ø¼)Ds”£\âYm\ÎLºNVoªg‡g\íBG¤\Ù§‰¤b\Ù\â_µ\"…$%Q2$]r²,±²\Ë,DW\à\Ùe—\ï_i\ò\ä\\\ÚZ3?[\ZT\õ£v\îß„¬\Ã^œM!DPg¤\Å\ÃF—j\'ƒR…oª\êº|‡©´\Ëb}2ú\â\ñŸUb†\â¿û\ì¿eý«\õ¾¿K]S+¤²=;=&.#…Hf%”WO»¢\ï\Ü\ä91\Ê\Ï$aGyC}Ã\ã\Å¬HDK\í_½û\ßß±&Q[?OªH\ñ\ÑEPeQ+\Zdx\äbQi£.\ò>Rà¾¯¦\ÆQED[³Ž¦\Î>;tG¦Š »}_\à¿cû\ôzl\ô\è¥F,\Æ\ÌEcE\n&I\Õu}_iH\Â\Ö«e\ô\Ù\çÛ«\ô\ì\\[‚¡GT%b!+\é]1±²\Æ\Å#\"\Åù«¤†1\ô (wV$‹2\ö?c[ÄŠ\éÈ²\Æe\Õû?FŒ\Å\"/kihR\éKc\"\íE¦úcccbbbeý§\Õý\Ú(¯ccÙ‰3\Å™F\×\é\ÉD¬NB¿f‰I!\Î\Ê5b\÷Z§D9™©\Ò,±«8£B\í”?,‘BBB\ê\Ëû\r—\÷c\Ò\öQBNè²›„+.º®œ¨\õc,]X\Ùe\ëøžz\ñÖº\òŠ4WXœQ#¢$!‰DB}¶X\ÊÔ‘B^\Û/»\ö¾«\Ù^\ÔWk§ÒŒŒINˆÜ•%Ö†\Å}]Ÿ¥f.°bIue–‹,}~×±‹\ÙC±v˜™ÄŠž\×Qe–WR}_l¢º²\Ë\ö\Ð\âQ‰E{—K\Øú²¬\æŠQ[*‡-\ã&RGž®‡¿f^\Ú(c6yOY]ykŒQ®›ffQ®\á\Æ\Ù\Ç\ÃBUf#\é.\Û\éùR\êB\é{\éýš\ö?j\÷_\\¼ËŒŒù\'\ÄFFj#{/­\rÐ¤\íwb\öY‘š¿=QTUž›0ˆ©Y¡\È}q\ÊDvqDG\è]I‰C\ë‰EŒ^\Ë\é\ô\Ë,¾—µû\ë´WlýÇŽ0“R/¿ˆ’£Ó”‘h¡.¶PÇ•¥!AŠ%T,¾¯«21ÀŒZ8\ÑÆŠ(®\è¢NŒŒ„\Æ\Æ\ÆY}!}¥\ìBý\ëª\öPÐ‘˜\Ùf\ÊU­ú\ò\ðF%2Š(¢Š11\éÎŒ¤Å¡wL¢†4(X¸\Î>1p‘\ãÄ²„Š\êcŸTL¿°ºqzK\Ù¦>\èK¥\í®¨¤Z,\Û\ê½\í{’\"\\±C\åf\Ùã¤™G\êŒ‰€¸ˆp‹‰1q¢‰B\êºccc{r!-’(^\õ\ìc\öYb\ð>Ÿk¦E	Wµ\ôŠ(¥\Ó\ö\ÙctE\õL¨ÄŸ0Û“Q(ýE•BW²\ìD)‰{]!ue’$MÑ¸È½9Õ–YbûL]&/\é”QB\ö1+¬\Öú½ee\÷¢\Ê(\Ò)¶\ðÄ“FDQ‹e	\nŒŒŒ‡.¢FG9‘‘‘~\Û,±“tr\ÈR#=\Ù&dfdY}.¬O\íF\"\ö$$QE/±‘}¹P\æ+¶\öX½™Ð®FF&I\'8›f;®“o§¾¯·fúR£2´gc‘ŠE–dddfJG3d¤d~×†‰Æ†\÷~“V.—ºŠ\ÜcªêºŠ\êŠ+\í+<”y?](³.®”\Å\Æe]\ìZ<\öŒ‹\Û\ê\Ë\êº~<ª¢\÷}BB˜¦f9\Ðù\ÈJ\ß\"9V\Ð\Î/þcVJ‡e\"?\"\íû’T!}û(ª\é×\Ìs”Q“c]$Ä¬¡G»¶y\é\ë¯Ú—kcF\Ð\â8²2\"ú”P\\ºnÈ½»¾\'¶r­\Õ\àþ44r­¶Y\Ç!HBB(¡ûbG\ñ<Z›‘‚„–(lmŠ2f1FD¶ec?^D’o¤\Æ_µY¶(‹>N4Èˆ¾¢W¨‰ñš®¬“¶\Å\"$…±iÝ’“…œ|nøc]²qw8‘\"µ	wE¸‘\êý\÷\÷c\Çb¨›b‹¼’Fvf†\ìlŽ\äF,ª,s,R/­—¾’\í	8Ä’‰„SÄ—	¢C­Y?\åº!*qv££qZ£P\ÇÓ‰GD…\í}®¬±{—\ÛP²Ä¦RFD¤9\ß_ú’B\Ú\ÂÚ¤Ü‡=·bc-Ý—\ÚE\Ý\Z\ì\òQ\"¯¨JLq%\ñ,Ë²3\×”ˆD®×ž\Ú1(¡-\Å{\ßk«\ê\Ë\ê\Ëû¶[fCz)•\ÕR\ÂL\Â(³;/O«³fTXÝ¦™Q4\"\öx?NÍ˜Ì¢6P¥ˆ©B\Òø\Ã\ÄG\ó‰~Ö½”P—\Üe}\É:.\Ï\Ò<µceD§FM¾®\Å\á–K\ÌvEYûm\'•¸\ÂG„X„h²\Ëê†‡üùN&,Žˆ´IþUN18 \Ü\Ê+\Ú\ÑEW\Ü~äº¯»\ê	Ø¼úV(G¬Œ‹fCEž]>¼ŸùÁ\é¦l\\VG9(«b¶it½´20ÁŒg‘\"p±* …\ÆO‹|o|h¡}\Úû\íH¯Àÿ\0Ž\ÏNÈ¿e(Tc\ó‹¯Žl¤%§³Áû\é!DÀÄ¯e#ˆŒE0ø\à%Nq==\ñ\õ}¯zû´Wk\Ù]WÚ²\Ç\Ý\õ\á3mR¤«©=¯\ä\ÊUX©\r¾Ÿ‘;##À(E}³E”\ÄM\ÒLQ#\rN&;B+Ü½µ\÷(H¯\Çz\é³ÀüE›cF!DT‡-§e\nŒ¥Õ™][,\È\È\È\ÈÈŠWZK©«M²ú_‰E\Õu_…\äýù]y$x$l“b¶EFD¤l\\Sb„bk§FFT6\Ë,¾“\é3\É^\Å×…¨”N>xL²KØŠ+\ìW¾º¯\É{1Vú¢‘±´f/£F‘‘Rg¤.5\Ú-E©E—\Ó\ò¯¥‰C\î\÷f«c\ë‹\ê%\Æq\òÇ’Et¾\Õý\ê´n\Û-”(\"6a¨\Æ\"¤\ì\ðzŠ‹\ëb¢ûVF,P>&E—¡¦6d1=É™o+,q±h\âú‚\r5ývº®±F\ô\ÙpRÊŒ™E¤\ò«¦e«}x,¥\Ô6(\ZE–##\õ¾\ä‡hˆû¶&EÑŠ“À\â¸™eH¸\ä\Ú\á=(¢¸\Ñ\êŸ9\Z²·}7]~˜‡\Ç	˜L\ÂuMŠ-Š4Ye¾©‹E\õûºC£\ì\òx“\"\Ùw\ÔQ/}	H\æd\ßT›“¡\ìE•b„©pH\ô\è\ñ¡FQFfc’5\Ó\ð\Ç\Ç\Ç!\è\òmzkTÄ»Mc\óZf\Å\Z#0\Ö:‡H\õ–\é\"\ÏS[‘³\ÑG§]Y‘‘\çÙ—Š´R\ãX\õ-ž‘c¼Lw‚=;\'\ÄY)GcDbF4\ñ±D]4+ …ýbù†l_Oq\ñ¡xl½\ä6d]›\ê…\è\Å\Òv…³k¦†µ\ÍÂ¹P\ÑFŒ¢¡´>8²\\3!P\à(˜‰tºHŠî¿ªl³\"\Ì\Ë,\òQ‰}%M,Bé–’dh\Ñb•ŒM\ÖÇ³bdM3`(˜\êºýP‘%ýke—Õ›\Ò‹}<WTx\ë#o¯ý]\nJ\ò]j®U[›m<}F.T)Ù¦xt!v†QBBBþ§$Z\â‡\õhŸ\ÖqE¹QmŸ¡ŽúN¥b¡±¡ørÚ[\ÏnB{´]™+3r?\òU,µ\ò…$z¸\äLEt„WI	IhsŠ\Öq!}	?\òJ/üŒq\æú\ÎY?W–ýiŽEŸª0˜‰¤­­Ÿ¿	4gO-\ä&\ÍR\ð\ÆdIÛ«»\ÎC{´\ÖÌµR¨ü–\Ñ	³›Q©*\êºE~?\ìQÆù\ÜW?«\âŠÿ\0\Åÿ\0¡—ùÿ\0\"\Èý}K—ü‡#O\ëy¤rs\òI¶\ÛQ²…H\õÙœ‘ro9\Ü\\\å,]\íŒOtŸ[,·\Ò.\Þ%±S+,S,¢¬ÀŠ\Ó.†ŠŸ&ª\Ó{´˜žKR—\Ê.­>u!{\â\ÊqŠ[ÂŽO\ò\'ü\îK\æú\Î~IË‘·ƒ´’.)7«/YJÒ‘ŒÙŒ„†¬\ðK\â-•£\õo¬D¤\Õixm\ÊÕ—OÁt6Ø¢\ÍR¦µoÏ—YuŠ?\òüyuEÑ´-¦™´di}\"\ìm1\Î2žW’\Ñ?R\àBq\ä_h—4\"\Ï\á\Éÿ\0’€ÿ\0\É2_\Ë#×‘.G36‡%/SD\ål”	$ˆÀ\Ä\Ñ}7gÉ‰›2\Ä\Î\Ë?‰)\"2X\â\Ô\îG¨\ë$1lze›<c‹1cÐ¼\î˜\ö¬UNÆ”£\ÌQJ.<b±“tF\'ƒ‘üaÈ¥\Õ\âb‘¤±¡F‡\ò!<NMý7\Ô.e\ö[IK\ê8¢K\ë8\â\åþAa?\ò3¹ýo+ožm[c±93‹*ý)\í<•¤\Å;W¨¶ˆ\æ\Å\å\ÝEY²sq\"\ó0\Û\æU/šŒIE!Ø¢˜\ãH\ÎJ*RefI\Ûýu&\ÊK§H¹±¦<Ï™\à—\ñ¦l‹‘—W\Ò{QvÍ¾›C\äˆ¶ž®“6h²2©2¬p\Æ1–\'Ž«\Ôv»Ÿ,\"O\ë8\Ò\ä‹ÿ\0!;Ÿ\Ôr\Î1’¥1K#’6x2O¬·’2\ÉE\Ë,EI|G6l­X®*³\"§mIE<Ir1&TPÏ‘\é,ý8X\ÒKF6\\F\æ\år\Æ\î7\ðX¥r2’T\ä8£ù\ñ£*N	¸ùM’v›l\Ü\\¤ž°\"\êTV¶9\ï)6b.#\är¸úr\åYg¹|†byŒ…F„±\"}?Ô¾3—\ëµÿ\0#•¹}O#=A\Ê\ÌI<M‘h»/[¢V\ã±m\ÒJS¢?\Æ;t†\á¶¿U\ñ‰\'(\ÉJQ‹’.-*¿\Þú{u‘ƒµD\ê³h\Îú”¤\ÈE\ÛtÜ\ê\ÛlŒ\È\Êg•9úd9b…\Z¹9\çú‹¥9\âÿ\0š¥K$8\ò\\r4Se*ª\Ý\n#œ.\\‘·\È>E†œ§\ÄÔ±ùG\ÊM8FMúTaÆ•\"\âx6\Õ$ge¥™Pü\æ$4˜\Ñ)P¹3“1’r‚r|u(\Ïy|qLý4šn1ŽV>G\'¤$““LUu6¢))i´x\"†\É[g“\õh´žv²l\Ç~‰¹Ã¯F(ù7\ó7v\ÅLT³d\Ô\íFŠ“1±A”iË’NµZ©E9K/”ŒY.L^t9I¦‘Fc[D[‘\Ç\Æ\ëÓ‚4–FH–E\ïÀ§efL\Í\Öl\Û¢\ÓQY7fR$·¤¢\ò„\Ù8G*Š\õ˜\ók5\ÑZiD9$:.ˆÁIµ¸Ž&’\ÏP\Ð\â%­U£\Ô26=‘\ãQ#ø\äz[pw\è«\ô\õ‰éž™[P·\ò©R““dc#\Ñ\Å\Ú&&\Æ\ÔT$\ä)\î\íÉ´Úœ\ÅÃ§\ô\é%„\Z¿$x¥KŠu\é¡Y\ðˆ\æ‹\È\ÅV’M]’}-Ÿ™q·54\ÝeR·^IE‰P“µ!Î¤••N­cÉ–¢œ\Ñnm\ãü”£±ù¼…•\á©BR8ø\ñ\éª[¨xÈ½§i´5cø¨\ä%C‹2¢\õ¦«$dŠM\ãzh\Å(H\ô\Çs‡#~›G\ê´\ÜLl\ô‘(¸¥\"|3›Œ—\É\Êg\ògAc5]>Ij¹:•U–\Ý\ä6®-\"m6ùw–cg¦ª<*¦Œ•\\RU*N;-þBŠ1ˆì‚¥\'4\É8\ÔycPt|e)\Ô/–Vˆ\í\r:,\äR‘\Ç\Å$Ú¡º\"\Ýø\íNŒr7R¨‹E!GU‹f\ê\Ì\Ç/Œ]™ZtbŒ-z{\ôb—£¬Wr\ãŒ\È\ðZ\\QüF\ñ2\ÖnKR<G‘\íxm\r¢*#w¤znR…DÜŸ™kr\î9È’µ$“rXm–‹f\ÔsÉ£Â“lN†L\Ñ«pÚŠ\Ë\Âh‹´\ÒKÊ¤ÏU»\'>üÒ‹·U\Z’v\ÌYZ´\òV‘‘\êkþ\É\áÞ«<LlJ1?·v&de·µŠ0”X\ÝG\É\Êq²±#ü«wI\íþ³ŒG67!d<¦%©[Q›Dv¢3MQ)\å•FE\É\òÏ“Qé¼°DÕ¤’Y¤Kq©˜»Œf\Ý3\"µ±bht‹…‰xq>W1w\ñFT7d\ö¢šwFx™‘•˜Z‡\Æ4\Ó\Ç\'\ânŒ·”I|Œq¡=\èM!lnH\Éb4‹3Ü¹.i5\ñ1±ºYj\öKFQp\Ó$\ÛR‘E”aM#|’L¤O‰)(\ê¢Rc\äDd¢¿›\ÇI’’i\ñ«_\ò\È\âOQ<š‰\Û\Æ)	\ëb•E\Ì\ÎÜ™Vb\êÍž¡_È“y¨?&nÿ\0{M\Æ2Š„D’4@¸–>CÔµã­›\ZqXrÍ¨c¶\Í\Únéœ„|>A\òSœ\ä…ÉšŽP?|pH”©nB™I)e!\É\Ý\ÆXE¾8\Ì\\j\Ý\Ó_qŠYQ>iMŽI9I¨Á&¹`’‚µC˜\÷/Èº-(¡Á)-t£ˆÕ´4Êx£§B¡«j\ä«8\Û\çI\òNWR%-S1m¥¶þ9¹=(:pÝ½ªÓ¼x\×\ÅË’RŠÈ¦š²*‰[”¥>·~µÅ¼hs¸Á»•µ¯\ç,(±Žh»Š¶·„b‘\ÉÉ»H\ä…\Æ<jFºå”…å·”¾Lº2qM\ë\÷’<¹\éd\Ñ©G\ZŽ\"œRmSg“ŽŸ_¼˜“BŽ¯rh\ñC\Ð\Ò\ÖF&%1“¾œi¦””µ¡)9.;O\â\Ó\ÛeI\ÉA%‚\ZQj_+\Ú\ð©\ÆT@o¬P†\Ô](\"‘t9\êY3D¤9·:LºŽc\ãl\Å$\ÓbŒ£3ø§St¢B“²S¡Ü£%Beb\ÓÈ”uTž\Å\Æ\ÚQy6\ÉY\Çs^r3£Ž3\ä#\ÄoV+¯\ßRH·—Èˆ\ì\Ëv”²%‘m)-¡ID[9#c¶G‰\Å}>P”\ì­zdqF‘tJZSbi­A6\êwžE\Ç!q†\"hrC\çY)IŠ\Ð\ë§=ã“š¦š£Ÿ¨AŠ(Â*ºy¹j²1Q\\±Sj1ŠÚ’©)r	º½:cˆ\Ú\ÉÑ¢\Ç#\Ô?QI/™¦R6aiuVl\ÒN6\ìÉ·\Ã\Â\õ\Ë1DŽ\ê\\[\â‹\Æ6ÿ\0‹qd>D ”\â’j“ÿ\0\×stºL§OÌ“(œ+¯2\Û!Š\ãÄº2l”\õú´£–®,“Ô¥‰&\Ú\Ù¾=qaœ~1W‘›·›™I\É\Æ\Ä\ã\Ñ\ê\ï1H\Ê\ã\à\ÓhÅ±CyD\Í\ÌÅ¢0T\èkoŒpe,V(\\š\ó/M5¨+Ê‡¦‡Äž\Ô£»§\ò\Éx_ü\Üh‚HB“j\È\Ý\ã)G\å6>+Q\ã\ã‰db“o{Ç5\Éx­8\×ÁA¢\ñq‹\ÂZB\ÛP·I\rbe\ñ\ãLÁÞ‘b±2ŒË²-±\Ø\Üj)£Ô‰\Ç?Œ¥*‹·¦£§ˆ\ñ‰K(¦\åÌ¤ˆ\â‰\Â3Q\ã‡–I´‡\Ê3$\ÔD›\'<dÒŠU„\â\Çb“¬’&\÷v\"1È’\Ät\Í\'¡*›wd	uX¯\×\òXÔ½1c\ß\Íx\Ë\âØ¦fdG’\Í†\ÊQÿ\0\ÜVM½\äˆ\â\Ôu\÷m\ñ·PŒ\õ\rJ:\\þ¿\å\Ç=“–\ß ¤\í¼º›(\Í¶\ñ®¥\È\ÅY~ù`\æzqR\ð¤³_ª¨¹²\å’\ã–6e*Šw8²¤¢\ág„d”¦Ÿ)ŠÈ–S\\|O,~Y#i\Æ\ÊX\î¥Ž6.4…Šh¶2’¦– \ÕF*C¤T`–9)6ü»m\Çqþ1~dJ22ùü¯\äF«ù1\Å\Ê8$’\Ôv¹<¿Ì²9wˆ¤9&=9JŽIü¸\ß\Æ\ìwvœ\"\ê\änM\ß<\ç•ŽI9$²”‰*>eQ•Ž˜\ãd®\n2,ÒŠ¢%”Œ-\é­!I1\òi\É\ãe–B\í£f:P•¹ºn\ÈüO/\r%ˆ´6ª/\ä\éÚ‹¡½¸±:\ávNTœ1(\Ãþ\ÅWƒd[\Z¸\í)*iQ-­\É?”šÄ‡\ó\ÇODª¥¶ˆ\Ï\æ¥\ñI\Å\ËøK\äJ¥½\Ïùr\òþQº‚¼fQ*\Å\í\ÏE@lŸ\Ì\ã\á£µ”b!Lø¢N$¹’«\Äij+&\Å)¡<œ¹7ž\ôU¸\ÔE\"ÜB\ÛJ“†BQJ´\ìTˆCjQÀY(•FG“d£ˆ\Ó ¨SùOsK\äÕ˜e,¾r¶rVJ\"I´9DŸ\ñŒ¾<2m\Å\âb²ÿ\0ùø½A5)\ËÀùÿ\0\ôœv·\ß\ëùz„ªryND¿\ëiA$ÿ\0i6\å+µ\ò!Le\Ôr$§)4\ãhøe\å\Ëm)7Q?NJ1M‹øÎŒL)’\Ñ—‰d¢\än&\Ù&‘rm\äbbªþI»œ¨—\ÔÓ—!Vÿ\0\õ\'¤¬\áƒs¿„¡\òŠ\Ä\ô\ÒV‘“R†\ã\Çu\Çl‚d›,%%Ÿ&9/\á\'¤\ë	2QqmYü¥&\Éi)T¸\Ð\Û\'r‹\nŠG)\Ç4\ÈJ\ÉY›\æOMF1ù’¥œÖ¥\ÆyR…\ÆR†\Ï):\ÌR ¬~TF[˜¸¾YbJNM,UVJ?”K¾µ³ù~“\Úù\n:$\ÎGQ‡\\‘\r\"rÐ›my|®\Ûw\Ç\Å§o\â\ê\á\æ_ø†§_&¨š¥\Ç\â/)ÿ\0\ê2\Æ9b\ßÿ\04ˆ·N?‰g—,ü¿\áP{š\ÑU\É\'·&\Ûþ)\\h\æ“\\su?”oþ\Èÿ\0\Ù\Æ\à£¦Z_Â·_o<r\ÜD”£{\áÿ\0\ë¨\òNX´\×Ó¯?ÿ\Ä\0\"\0\0\0\0\0\0\0\0\0\0 0@P1Ap€ÿ\Ú\0?ÿ\0vT–Iadø\\\î¬x!´B³ž\Ëd´´B‡\Ýih´:1\Ñ­‹\Ìt~r\Åù,c\ö¡\nˆE¥¢S\Ïh„-¸¸¸x/Œu~#\Çû\î<\Õ\ä/6*¼\×üz…Þ¼D!B¼$!x\ÈB¥¢gic\Å\æ\ð{_\âX¿><5„I<OzÖ¹ž¨¬\ÍP¨ˆŽu¢4ª<3Ôª¨«\ö,#s\ÛN_DH¤\ÒrŸšG\Å`Œ>ÿ\Ä\0)\0\0\0\0\0\0\0\0\0 !1@0AQ2apqÿ\Ú\0?ÿ\0\Ó\ÈB„&a8O‚fÀW‘\î!ú§º\Åê”¾<\Ì\ã¿O\é\ïhGù\ZGý\èÑ«\è~¦¶Fû‹IJ\\%M¦•<\Í^¶”?\èC\õ5¼m6œip¨…\åj\õt¡ú\í\ö¦ùÑ²”zŠFÍ‚HZ„\ï\õ¤?XÕ­¼ß†›³K,]|{‹\Æ¦\ã©Bfˆ\Ò/&f‡¬ÝˆBs„!¥š_“Q½á¹Hm\'\Ë\r=B„\Ä–l6Ù¶Š\\Á#O\í›\r¢\Òm!t:Ü‘\î\àýCx\ó…>]7Ç¬\î6R2s)ap^>\ò\Ò\Ãx\ÙxC°\õ™	\ÇK—¸o„!”¹\\i’\ß*WÁa—ŠF”\"y\r\Þk	R!²—‚4¯6â›ŠRŠ“¦\"\ÒAy³„ý/\æ¬\Ìh\×ú\\¬²\â—Â„\'$L^iÁj(™¸¾D:4¿\ÖuE¢‹¯\âQ¼\ÌS©ˆN(\ÜQ¡	‹Œ\ð¦)xB|iD\ÊAKÇ¨¿ý—….‘´B\ó\î)M\Ï„\ÂbŸB^}Q»3•\Ê\ÖÑ§Zx^e!	\Â\òH„¥‰ø\õ\ñ\èR”¥ø$$!x\õ‹‰\ñÁD&\ñ\ç\Ë1DÐ´‰0^6\å\ðB’m\Z}U\÷\à\ïFý\'»§\ô\÷´ú4úGý\÷\õ1\ë\ÔÎ¬Ÿ,\ç§[\ÒhÖµ|4\÷4þ\×\Ò?\èüC\õµ1úš¿K\Å\ær¿$!sþ\è\ôý_§úPým#þÁúúsW\é^\Ã3s·•&&nc\Ó¸^£JŸNS\å¨\Üo7Š,\ö\Ì\Ü=f­E\Ä\Ä\'\Æ\ð¯®¹,NT\ÜR›\ÍÅ¸¯§	†\Êu;rœ/\Z,¢\â\ðkŒ—\ËiJ&Šw!Kž¥\Åø	—¦pZ¡HBs) \ñ_*w.r¸AN	epë„³Ü¸¸y\\\Í*¹_\nf\áp‚\é\Æ|\éÁu;Eø®&o²åŸ\r\ÇRŒ¸\Ý\\\Ü\÷\Â\áØ¥\ÅÆœ\'™„Rbeq\è^3+©	‹\Â¡‡|v¸\éb\â°û¶X\ð‡„i\î>‚ø>†}ŸFž\Ø\êq\÷4\÷\÷Ÿ£Os\ìGÿ\Ä\0<\0\0\0\0!1\"AQa 2Pq‘0¡±Á@BR`r\Ñ\á#bp‚\ð\ñ3C’°ÿ\Ú\0\0?ÿ\0úq·\òÕ©?È\Ý$ŸB\ß\ÉSÿ\0W§þƒ\Ì\r‹\ñv\Ã\'ÿ\0gÁ\ãT}\ðƒbN?”.Ÿ=“ø\Ø>H\\X¿§	“\ð‘?©O\'üu\êU\æKc\Äe\ê\õf3¦?\ÄÁÊ¸ß‡7\ð­ü†|žq\"{øŒ¸Q>\ç}‰Uù¤\âOcý¿\ÃU\õ‚2IŸ\Z¯\õbU¤\â_“\Ä[\ìeÀª~\î6%R0ŽB}Ž¦e3+ù\ô“\É\âû‡\ä„\Â]>Á™q)±zA>%~TœD\"\ã2£pxqûÁ-…	\\K\îB\"Už}N<ÿ\0\Äþ†\\$6Bq¯\ÏÑ„oRT\ñ-b>\ælKˆ\ð‘\ßu\'\Ï3+z™_}ÊªI\Ïþ\ÅÖš¯±cjr\ïè…•}‹©rTŒ?þ‰\Å\ö%U}\Ï\ò^³_\çW\"K¦UZÜ²všÁ$2—¨„,ZI¡h\íšB\'\É8p’‹…7A1a¶þq”\ß\ÔÌ«D#\n‘…Ô»,K\ß\Ò#“z\Í \Ý{r§È²O\Í\'\ñ0/°É‰½\ÇD\Ó±u¦Ø¯\ò&,6_2Í‰Œ©\ò\\—_\Ø%Z›\öJ†\ç\ö?µ/KR\É\ñVtù%)E¶\óFFNGUuìŸ¡n\èrd’+±ou3+\Ön\ËzBùŒ¯Öµ`ýH¤\Ö“û„©e\÷ú\Ð]ü\îÕ‚úXu\î½%‘/\ô\àµ0X³b\"—\ìÒ—ýŽ<\Ö{/\Ùb]M0¡¿¯\ìpJ\ö^·£8\Ë\æš|Õ¬?N?\ÐÌ¸\ñ*§`Â‰\õ\í\õ­X,7™F%œjYýTË…‰_Øµ­“\èÛºD\çË´C2ž?\Å.Gv½\Ö.\Åû!)sA’–UˆWJ\Ì}9\òù-\ô\íKRq”Ø”V46Ž«&eW,\\‰S1ý\É\"‘\ßù¦”bl†\Ä\'ÊŒ<’¤¬pey\ò–9:\ÔUJÞŸ¡+\ðYH¿\Éf\õ¤º…)>yq\Ó¹\Å8%#’\É^Z}‘\Ý)¦Ä‘\ÔY\rIu\èm\Þ\ÊB“\æpÞ¦h¤9\È\Ìs\ÛcCBHBk$wAr>kOe±)Y\íu\ó	\ìÒ—	!*ÿ\0F	u\ì·Òž\Æ\ò\ëR\õÐ‚0¿­-Y#²Ý“H¤©o©o;wú¶\ìŸ\Øc\Î\'·sný)±\í\Þ\É\ô\åÚ²žk¥mI•ZA¥©nù#\ö\ó5ýV–ù4C“cšZK¤¿u¾‹?u»c\Ív2\Ò	£³YƒS^\ß\îA4‚È¥ˆ\óe\éTr!w\ñ1*\ðƒ`Oƒ2^·7¤}¥»\öÁ¡3\Ý8Nœ.Lúý+\Ö\Ý\Ú\öÊ›ú\÷\Ìù\Ö\Åþ¥«nù!’OÒŸ<Ð¹ý\È\í¿|©”‘i=\Ú&E$\ÊsH6\èG\òû^\é\î’Æ”\ØÜžÙ¬\Ò\Æ\Å\ç7ì†¬“\ß\nMoI¯\ä+RÝ»ž\ä\ÒL¢uâfú6^\Ëv_\öL>Scbý³NvCø}G\ñ)¡\ôf‰¬¯e¾´y¶U\ÉFN{?¹˜\ÊjjkH,I§cWT­¾Å‹\Òq›ý\ÈÁ\òx£úLÊ†U¤“V#½|©\ÈI7&)—J8\ë²NMˆJjj†µ¿mÉ’\È[\à‡82©,6)MÈ£+§#*5&¯\å³	É••%k¥‰•&¹˜µ!;%Ë’jŸ£©¥4¢þ„’§#,\r‹¶<º\ô×²$¼“Ncb\Z¥#»\õ/\îk\ÝcR\ÊxW\äœ$·\èn3ŽÃŠXtµQ|º	#\ìJŒ’L\Z©•’›z“]{/KA\"jfVú\í\à\Ø\Ðb+ú8“\ÌnY\Ë7¹üUŠi\Þ\ÚzB¡¹˜^œ>\ô‚V‘\ô_¿d-\rdq¼»2¢R\öB\É5\â’kIY ºª\ÉIý†\ÄQ»_Ë¯\ß\Í6\ÉsJ\"9”Þ–/Y#\ò-\Ó\êf\ÄAný*¬‚y¼\Ö\Ç4½nl•\ÊJ\Ó~\ÉR²;5-\Ý(pBù²1,E/\òj<\ÖT\âºeG\à\Í!µf—\íÿ\0=\ö¥Ö³>¦\Ë\æz­ z\âR\ô•d\"Ô±Ÿ~iR\ÄýFºrE\ö\ó,iOÑ™i™¤±ª‘…	Q\íM«=\öbTµ$Œ_)¥\'³ŠMSª\Äy|-,\\tOs\ÂOJ \È\ê¤#RM)$ª>Œ†¦´Ô„%$…W9$„¥\ÍMˆ¬G8\ï\÷ Ÿ.Ø•\'ûù2¡vB]HdJpo\Øÿ\0¨ŒB}\Ø\ð\ãø3\"\ö21\Ò	-XµWjqÛ©>e\éº\Óznk\îhœ5\öBÇ…\r>\riuOsšOH‘Mý\r©§cþÏ­lsI«y}\ÉcøP‡c*9¢z™”±µ4­\ÏüR)þ(°… Ô‚Q…ú\î™N\è\òøu63b_c\Âþ³ß¯\Å%Ef¬)þi–’ˆYFe\õ\"ž.•\Ýœr¨Jv\É\çM¡z\ï\Ùv ±c\Â5.qDZ_\î$„*\Ó\ÅH_\ä	#²Ý’1¹NKMGo¹\áO™+\nj2,‹§^“‰#«\ÎI®¥†£þ´‹ú	Õˆ°‘*ZNxì“\Å\È\â5ýU%MN–û—8¤yl©‹:Ar%L¨½B.\Ã\çUW¹š–®K¤$ ¤\ðå’—dJp]Å†#\ó!g\äL\×R\Âú\\F/&ŠjLž%ý—\î£\Ã\ÓT\ätU¤ßƒ0þA8¸™\ö”VÜ„U2aùY\ÈD\Â$ž\"q)\à\Ü\Ê2H°X±h.\ã°Â¢BC{\Z\æ\Èfg!Tr–’UË¯Ic\÷EEl>‚*¿~d%5§\ä\Ç\ö¹¡\n¢2!¨øU?\îQz’UøQ×©|D\rŠ1~\Ôê§ˆÿ\0oÈ¶A%›b/IW.\ÈX“sÂ¥W#]‹Jª‘H&DD6\ô ·É¡«“4G[\è[\î;üŠ\ê\æX\÷\ZKÿ\0¢U_c›Å­œ‹¥\ÜYaþ\ê\'\æ£\"›!zYOB|Bµ\ÈU\öªu¬¥\Ä\êœ#\áWOØ•\ñ\"1q[\nŠ\Ø^”?ù12rB›`\Í\'\è&SB\ÝFfm$ŠÁ™XƒB	CÔ›-&\ÜtAaEucw!~!2\á6\ö¢Ia2’‚x‹,ÿ\0•_Ô¹\Z Ø¿#\÷Q\ñBþ„\Ø\ÊhY†‘U¡62 \ëˆy\÷\ð¢–ø7lKx¬\Ë\ôIÆ‚\ë\èF2¤ªªú+E\ÆjJ%‹@øL\÷¤[Ð“.þ\Ä*©¸ú­O\Ì|B›ÕŒ\Òlx_bÄ—c+uj\ãcR\ä\à†¥Ô¸ªŠƒ\â\Æ\ì2X|Jü\ß\á	\Æ]s\ñO\Ã\Z%&Ž‹#²:\ñK’n2AˆoQ+\îx½\Éù,\ÔeZr><:™To\Äù\íœIL¸\\FÀƒ.8#JÉ¥—<E²–±7~FG2—r\ê,\ð\"2Ñ®=WG¢LªA\íGQ{\")„É·®¤aD\çA\ÕQIEOa°\Î!\ñýÌ¸_Ô•DOSt§\ï(\Ý=\Ï	FY°\Ëb\\A\á¬J†˜¿B\Ç\èa<$¬SOd-\òJ7 ÿ\0™Ò¤©c‚m¡\î!0\äÍ°\â\"\Îý´žO#.?_B)s\é9„ š/J\Ò\æee$u!$´rL›\"#	•\ÉqX‡3,¡§½x¢ž¥\äjB\Æ\ÈYp¹ý\ÍýË§²\n²Ûˆ—NTùB$œ^\È4 \Ø·$…DB]D|7°\Ý$¶A:\Õý	F,*Yy7\ô4q™‰D2™{ª®YÐ”Oq\×C+@­rQN)¢\Z‡…\ÈBKŒˆ§¨\çˆ\èÆ”Ce¤c°¬x„\Ë\àŒ*6\Ü‚¦”,2¡\Ï\"‹µ2ú©#¡sj\ÊˆIb£¤zŸº]Q8\Z\È*™q2’°#?¹sÃ‰yý66\õ72™YGT#\ñ#\ÐLOÔ»™U\\‹GÊ›©¢rhI3\è>£,ŒÌ»ukº’xDE\Än#\"RQ?AKû¤Š\ØM\é,t¢\Ö\È\ôÍ‡±‡R\\bFDAY\Èœ7 ýDz¦†„S(°\ô]Æ¢¢ \Ç\ä¹sþ$*üR\Å\Õ=\rV]\ëK›\'©x\Ù5?€œ+uŸfÂ†ˆž£u9\áDÃº\êYf5\÷~^©\Ð\édq\ÕY\öT‡W6\Æi\äÌ¹xl)*JÈ½G\è)•\Ã\Ö(†ˆr2)\ç#-\Ç\Å\âÞŒ\ã\â±ÀºŠ\ðD’¬—\"\â0\ër	2 \ë¡­84$W\"\Ä\ßAf\ãâº’#\Ä \ã\È\Ë\òzD¥Û²\Ôÿ\05…D$ð¨ž¦u#¹ Ø—\à‡aúc›p\"š`MË›*Oø\'\Ô\ØO)#b4Ü¹#\"pJ±•œº9úS2Á	\è3\çˆDH\äq·°‚±$@ú8½#\n>‚\É•aÚŠ\ä®&\ãEBP\ÊX›Qˆ\Z\ä¡*\ôFlÅ«¹¶Þ¨+xˆr!¡x!ˆ¤~CØ†¤VÆ¤Ôƒ\Å\ö!p/Á|h…Ô„RKReiÈ”\ØQ\î2RlB°6bnA¹\Í/4\äVD|$Q	ª*\Â’¤¬‡&Œ&\ÈA\Ébis0\â\"X}ªŒtÕ”Š¨Äžb0¡dBzMù%1.L‘IDr	‰rV!~K¨Ôº*’fe]‹+phˆ6\Ãa“\÷.L´\à°ø­±EFKÀ”EÂ‘H¤—7-4™q\Z\ê5ŒªK‹Ò„È’AIjhz’‘ISšIŠ±µ$[¡tb\r\ÍEŽnYX\ð¨\ëªx©¢b\Üÿ\0!©(Z¶UAzDUw\Ð|Lpeq5Z\\Xù’\ÔAE]dWûHMV6Ä°\ÖAXt\ÔvƒdA–Ô”uAtMˆª.•¼ƒÁ8•H.oEÚ‰Á=®\âM Å†YIª\Æc‘+É”W\ÄA \ê\ô†rqb\ö!\ñz’\ØP\Ýy4#\ò7\ö!½Ä–^C,—55nLO*ZK9(\Ü‰$J©dd\n\Ñ7T\n–”:™”´ž\æSº‚EÄ¦[Š\Ò\'U\ÎGR,q\Å!\'q¾\ã\\Gµ:R\Ä’A6¬R\Ç‹ˆ”d ›\r„¼—ƒªˆ®A\ËQ\à‘Pµ§#aNŒ¯Ø‰6_BVw66\öm‡\Ô\ÝH£Ú—„%F.L„\âC-\ÅÐ»}\Ôn¥\ö:pü=B¿‰R\È]h½V\áGÃ ‰jp‚‰±”Kš%2œœ˜z\ÜF\ÒQµ\ìa\ñV\ÒE$»\Öh\éXŒ>¥¢OQ\é%…Q°g\'z\ðZ5¤A(¤X’\Ç\æh\ÄX˜\"ŽfX,B)\ÜV5˜¼¡o\ð?\îŒ\\Fù%s\Ôúœ\r‡\ä|7?\Ü,J\Ñ\àAU)s2Ž¤Žªãª²\ÒxT’T·g$¨\ãª\ÑrU3%_\÷DT„sšjf¸\Â6„·8mE\ébT¼\ÜQPµ\È‚FiV¹\âþ\Ä\É%\ÕK)c\ó«’IIujx…\ê:nG\È\è\ê¢<Y‡Rý8DWœ[•\é•=‡²GÁ\Í=OA&F¥¨\Ã&zŒ·¹\ërU\Æ X‚Q=\ëvr\È\Æ\óG,fQi,d\ä´\ÒNP”\ô\Èn# ÊªªZÃ±\Z«Š‡X\õ9„s-Œ^±GK	\ë$\æ_C\ÂX\à•,Y‹|‚\Ä$²X\ñIª:\Ê\èfù`b\ìdG\äbGU\ö3;ˆ’<°\ßaX\ÍqV­„u\ô#ASB—¢l=\Íe2¡±r\ä‘,–9½\ÅT\ÔX%düD\ô¤Xz©È»UÌ°¦\Ü\êÄŠZ\ö=‰f¸·‘O\ÈX\"\ÄÌ´VØ´:9;,BŠjN\"\"¹I,*¯ÁbMIK¨\ÆRÂˆ¬\è2¤Š\Ð\âpB9\"*]\Ä\ê#\Ô\ò!	\î&IŠ¸ˆ’›\Ñ\ZŒ\÷/%\è\õ|V\ÑrS->\âˆBr¢œ\×\n5!&Ž†\Z\Ôâ™¦K˜®M¶`w•y/;\ì\Æ,-¨Ÿ‘‹s&´(­³\Â\î\"·#/‹AY3FEš[\æˆ\ìúù„\êRy!D\ÐfX¥\ÑL\ÕTD\ð™P\é\Ô|J„f\"\åœN¥\õ‰‰³ƒ´Ž¢µqW«È‚1#h”‚,N¤Œˆ;QRÚŽšœ\ì$°»E]=©\Ô\"bÔ—a\Õ\Ça¬ºŒ\Æ]Hƒf:Q\Äü\Èø1*+p6LýN„CÇ ©†\Ö0úQv\æ\Ãn3\ê\æ\Å8°â¸½Z…	F&K—¡\Õh\ë\"u\"I¡ot	“/Éº\ÑXýD cr\äQ\ÔQŒÅ“ÔœUŠÏ±	q†¢ŠÄ©§\'\".£j9\Ë	\Õû\Ç6nFƒúÀŠcB$\Å\ðu/ºŠzŽ\Î\èÃ’aE²«†NGAz’\r\åM•\Ì(þŠu[t1´ \ÔG0\Â\Ï\æ,¶$Rn\Ô\ÂF‚¯\ØÊ„¨\ê£(\×:‰$k“…Ž”±¿j&»~i\èzRIƒu®aˆA:µ¬B$‹Ž£ ½HZ°’2\Ø\\0_ÿ\0t¼ŒaT:SA\ÓBS1i\Â\"œ“\ð6\'¹uC$5Æº‘q®«(2ª‡Gs‘y0\â1«\Ù\ÚPÂ‚*xNbmuS«*f12&T„Q\×ú…_a~\æ6$EDa`\Û\rÇƒ\ÐV:tHr[Q\ÝM‹‘\"–Ü‡UÜ¼\ä©Q\ÕT¼‰\"\õŠf-1\ÅJX±\ê\'JQGž\Þ\rû.ht‰c285\ä\ËaT\Ë}Nt¹Xw\ö*\áQ X&úvu.«*B\Ê\'È»XU•smÌ«c0\Ët?\âb6\Ô\Ãw•AQ\Íz‹z˜\Óø‡¶\æ\'˜0«\ÜDÅ»˜±&ª5•¿A0\é‰EÅ°¸q/±‰·\Ð|:ý„L¶:?Mw¢\ì6\Z\È\ÃhXÅ£¸t\î*Q…]Wsb7’ŒÂº=aZF„Õ»,…Ï^E\ÅjaAVâ¦†.c\î7üD\Â\È/¨¸Yx\Ø}\ÐLO\ì~ °\æ,+±‰\íÀ»˜œEÖˆúb¢(¿7©;©Ó¼½xR\ÆPT\ÚG?¨\Ã\è‚\Â@˜\ÕF?\Ô\ÛCÁøx4\\,cD³8éª˜\ÙCÿ\Ä\0)\0\0\0\0\0\0!1AQaq ‘¡0±Á\Ñ\ð\á\ñ@ÿ\Ú\0\0?!h„ó¡®°„øÒ‰\õÿ\0À\ßEü^\Îz¯\àd\êúC’|P„R‰ÿ\0ø\×Kü}iJR”½TR‹¥9«\êúSž“ø˜þ¤\ëAü¨Ÿ\ð?\ãbeW\Ñü)JR\õ¥)JQ\ã\à˜\ß\Ò)|ŸE\ð_¢ü/\ÍucøR”c\ê\÷\Ò\ô¥)F\Ä\ÊR”LL¿¾ø©J_\à]/K’”¥þ\ÑJQ|—ª\è\Æ?‹ùß…\éDË‚\ô\'\Õub\ñ?…/D\Ëü\ÔE\êúQ¸Q”L½\éJ\\‹¨¥(\ÇÒ‰\õÁK\ñl¥\é¡\"‰\ô[/KÕ±12\ôk­ê…®‰\õ½XºO\á¥\ÙJR‰”¢\r—§%Au\Ê_…)z=\õ}.zR\ô_E¿ú\\‰\ô{) º²\õ])J&6R”¢O“(†\Ê^´¥ù¢\ôAt)J_/\ò.—­ZR‰\ôZRˆ¥\ègKÒ‰”¥\è¾½¢\ðB|W\ñR—¥8)Dú®¬}WU\Õ3žˆ\äa?\ê†8\è\Ã\Ê\×Á—¢\óü\á?‘ü\ÙK‚\ô½W\Ñ\ô_Ñ“¢\è°/’œ]Tln—¡t‡$Í¿„ø>­tLB}`\×Â”\à£(>\àžEÒŒ·\à¾(_P¿‰K\Ñ\ôLO¯\óHHŸ4p5ž”¥ÁrQœ”l½x\'\Âh%\Ñ¢\é>\ôB ±\ð]JQ\ô½WG\Ñ\ôB\è´qü¦¿‰|©DBüiD\Ë\Æ\ð=t„!È…\Ñü˜ú®‹å¢—\äŸJ\'\Õ\õB(ž3\Ñ\nø.‹øyþ)G\Ñ\õ¥/\ð&Sd\érZ1F\Ê!BG\êþp‚ø7G\ðBè¿Šü\ð&R—¥Ÿ4\ËÒ\çz¢F2ŒR\ç©<™	—¥ùÎ³øx\èº.‹­þ*_…)~w\áEÒ”½Jqü¯\"\èþHB.\Ñt½(™K\ð„\é>\rv …\Ñ¢\Íè¿Šüo\òxT-\ô\r\rH‚G\Ë\è—HB|8Š/š!Bª\ê¾w\çz_\ãŸ\óBDI\ð£\Z\èƒ©!: \Ð\×XO‚}M\ôVIÓƒ\ä¿;\ÖüiK\Ñ|\×E\Õ\"|“\èˆN†5\ð>‚	\×Dº1\ô¢\è\×Á/\àBù^—«ù\'\Ò\à¿\Ö\ô¢e)K\ó\ßU\ódFú—¢Â‰ÞŒ¢\rŒ]F\Äþ,\ÏGÿ\0\à¿þ:R‰\à¥)z\ÙÐ³\ð_7²”¥)J\'ÓŽ™¥\èl¥6\è½Cb\è¾/¥~7¥/K\ð¥)JR—\á~T¿*^”¥/D\ËÖ›\êÏ¢Á”¹)J^ŽR‰\ôe½)K:D\ðQ2\õ¿%¿ƒKÒ”£e)zÞ”¥\ëzRÿ\0)K\ñB}(ºp67‚ˆ¥É¾´¦\Â}ˆ.¯¡\ôyùÞ”¥)K\Õ¥~4¥)z\Ñt}oÁ¿*^—¥)z®·¢”l½\Éz^—\äÛ©—£D&	ßª\ëD)JR”L¥JQ”¥)zR\ô¥\éJR”½)~_\ÉJQ2\ô6Q\nR”¥)K\ñ¥S\Ñzr>‘­\èc)JR—¥)JR”¢JR\ôR”£/ZR”¥ø/\âfºÞ”L½iJ6R\ôR—e/D%Ò–¡\éF)z\ëD\ÊR”¥)JRˆQ”¥)JRã¢”¥)J^¥\ëz\'\ó_$hBk\âú.—¥/HN­}	\ôll”¥/E)NÒ—\à)JR”£e)JR”¥\éJRˆSb—\ãJR—\áKü/\áº!>L½D\ÊR‰\õo£x/E)JR”¥)JR”½J\\—¥/Áu¢)E’\r¡²´R—¥)JR”Eø^´¥/V\Ë\Òü\è\ÊQ2‹!u¡±G\Ð\Ø\ßJQ>ŠR—¢”½x=t¥/JRÿ\0L`”\ËnŠ^ŠR”½	\ô¥)JR”¥(™JR—¥\è\Ç\ñ]hœ¥\ê1JQ²”¥)K\ÑDú)K\Ò\ô¥† —F„³.´¥)JR”¥)JR”¥)JR\ô!JRü\ïGÖ”¥/ÅŒ½)J^ŠR”¥)JQ2ü(…üpk\æ½)JR”¥)JR—\áJ^‹\ÑK\ÑJR”¥øÞ”¥)JQ²\ô¥)JR”¢e)KÒ‰\ô¥)J&R”¥(ŸZ7Ò”¥)JR”¥)JR”¥)JR£e/E\êR\ôRüB”¥)J^ŠR—©JR”¥(ŸE\éJR”¥/\Ä4þ!)JR—­)JR”¥\èLB”¥/GÖ”½)JR”¿\Æ\0Rÿ\0ø\ÑJ¥\ê{/KÒ”¥è†¿_¥)JR”¥)JR”½¡\n\'Ô¥)JR‰”¥)JRÿ\0ú@\0\0L\Óud¨¦\É:/E\Z³)‡´N)­z\Z\Ùø%ÑŠøR\ô¥)Kü4½D)F\Ê^·ø_\ð¿”(Œª\ê«xrv\Ø3HCC‡\Ñ\à\Äl\Í \æ\È\ÖÄ‘„)la‹G£‹“A¨\Ä5\Ðt?‚\Ð\Í\ôBHKø€Ÿ%\ð„!	ü\Ïÿ\0}}X6H²\È\Ña\"fŒ\ä:¬l\nil\ò*®HB‡\àüC(2v1\è\Õ(r†‘dª²;9\";Š2\n•6\Ä_\ïù»)O€\ÌD\ê º3Öµ\Òtƒ\ë‚“Y%N\r\Ã\"Li^F‡1U`q¤-=a!›\Ö\ÚÒ¡‹Aº\É`‹hÌº\n\Ó\èZ!\Ö\çÙ±˜n›|\n‹\ói|`‘\Òú‰\ëA5<:“­*)F†¾l¥…·Q	\È\âvH{(;¨O[F\Å=ª…½\ó°\Â\Ñ\Â	`ÀN\Å:(V\ônb(¢H\Ø\Ê\àwGÀX¼¥V1·bˆú¬=tTŒI‰2t}`Ì••Œ6W\ÂW\È\â\Ñr›\Ý	#z !\"|§\r¡—ƒ\ñ	Ž‰tBtLÀ?°™\í#‚\Zg&|µg¥\ÉÐ³®„\ÏDÁ‹¤ºdˆˆŽ\ÙA|BŠ(¿2|d!	\ð„\è}%\\J„–(Àb…\ðCaª3\â\Ñuc\è\Ìh\Ò!!œ¢\Ù;\æ‡Cg\È- ˆ.ˆLLX\è{Oœ ‘	\ðd\'H?‰\Ýt¾’FÃ´7C8!\'J‚\ÎLˆEú\"ü\Z.lCB\×\Â\ô}GX9q¾¥¹Œ\î5\Ö!\ô\Ø\Øé¼º²éˆ…ü¦ú\'^>Ÿ8$B\Z!„I’\öpœ\Ò8\õ\ï?\ìØ³!=©\Ë\Ñ7 \Ù\ìs‰\Ñ#B\è¾P‚ù±Ž8\õ˜œ\ÙQ¶Ø­	Bh‡[CC\ê0\ÈLÁ±\à\ÇK\Ò>„—HB!‰\Õ.°…v0·\Ùÿ\0\Ç\n=O\É£7„¹c™J\á_\ôZª»Ÿ\äMÏ¶\ß\è\Ðúý™w\Ëc\ÂxPk­²rJg\Ìþ\Ü§m\àŸ°µ.q^˜\ê\'¢ ¦…\"B\ê…\ñÑ¾¬hÀT…¼3DH.˜!µ‡\ÐuŒcJ\Ä!S&,I\ôA.„!B®\Ç\î¸H—û8\r\ç#v…\ô7û\Ï¹3+¶Lþ\â\Ä@2\ðjÿ\0fÁþ“D›j\öG	­\Ò\ð<_jU¤‡\ÆŸ¥ˆ¬Rÿ\0“G\'ß’µ\æ›l^6\ÓkI{\nJˆA!|W\Ê\ô6B‹¥[£Œ#¡Dªlo¶\É=^•!tz6»º0ø>„z4B„\Z%\ä\Ñ\0×¦~˜Kc\ÜC?\Ì\éý6?üY¸u\è\Ç)\å\Ó3I<³‡\Þv´wdk4^H[I\Çc>k\Ù\É\'b-(\ßx)ý#¯\òW\ñ\n–ú\Ã-\÷ZˆˆQ;jKÙŠ\ì\Å\ÂKxÁ\Ú¡B‹¢þ7\ñ]\ëD‡Ñƒ\ëL\Ô+³ŽºB„!:/ƒÂ¯»8+v\ÌCs\ö7@\Ø\Ðû\á-\ï¤Ý¢O°K_\Ñ\ÍS¾Ÿ\à;0\ðF\å~\Ïge\öÿ\0‘_I	\Ý˜\Ã|\ðI\ö¢[\àm`£¥¿\Ù\ÌI	[y\÷ù!†\Éy¥¥Á\ÄhLo^ˆ]Z_\êúÞˆ_1³.‚ÌŽ\ñ$\ôb‚\èšHI28’\r/U\Ñ\nªS\Ê\ðg\á\õOù±\åi\ç&„0›}™1>?\È\Ý\îx\Ö\Åÿ\0‘ŒÁ\Ûþw!\ÉxJ{K»¸”yk\éž;‰še\ó\ôƒwH\õ‚X!\Ñ\èh\â\óþˆV\ï<aøÿ\0bvŸ„D=l\'\Ç\è\Í3’{d}Á}	\rF\ôˆÿ\0¼JsC‰¼Œhƒ\Êž„h‚/\à_þ-ÌD`JèžˆN«¸y!\äc´Ož„³¡„§\ð/µ;-±\Þ\Þá•¾ž\í\á\àP\ð\\›\ã\ñƒH”=™\çB9_’\Z\ÉdÄ§°“«–g¿qUø¶¯F.ÿ\0Pw›?Cœÿ\0\nŽ’ì—\r\ë\ÞrÄ‰jÎ¼	\áž\ì‰l5g]˜\Ð\ëu\í\ìÿ\0c\Úý\Å\Ïúƒ”«\ìj)\öˆ\àB]JR”½J^«\æú7\ð_6¯Tù>´]/Zn]\ô)šœ}q—\ö\âÿ\0¢c¶‘À\ÒIA·y\ì-\è\Å#û¯\ô9m\Î\é%þ+•\íÓŽX§ÿ\0E‘<Ï±Gc¨—ùB \õ‹DŒ\Zy®3\\¼\"¶\òÉ±Xº—ÀJ&—”Û­Ñ¯\Â/‘—d½–\Ê	Jm¹ßŸ/CQ<š\ä\\,a”)/·\ôU\Ér˜H\Þ\Ê\ÂØœ²I±À\Ðb‹¡J>‚!¥\éK‚—¯%/ZQ?‹}zR—\ãewè¾ ^Ï±·…ùå½‚\Ö\é1›\ô}\ÏQv¨cš2Ï²\ñW\Ñ\õû4°©·\"Š}	J¯\ØWEŽ\ïB{¼œ¶\ïd7t.û²L\ÛÀ«v¸6‚žg…ù-Ý†\ä\×ù!OŸ\òmr\÷ƒOFp\ÓK\Ú\òmÆ§\ßhI”ŒÊ›&^ûºû„Ø©®T7BC\ÇAÿ\0^—¢\éG\ð½hŠR\ô¥\è¥/\Â\ôF\Ì\Ã,\ö“ýA\ãk±·h$^D\ÄüŒ-ž\ÆN\ä\áL’—\rû|\Ój\Ï\ÐÖ¢\Z\òÿ\0i%¼Š\è\ö$j¨†‹²!,!\Îp!\ìË²y\ÙvšJL\Â\'ùl\É\r\ö5”eŸ\ä9dp¿\÷§†qEü3\ç‚\Ë\É\ã\'\Ó]\Ü\ïN:[\ð	”½o\Â\ôÒ”¹)J6^”¥\éJR–Z˜ \î£ü\rÁ‰`ý²z\Æ<Ÿ\àb\÷X\ò\Ë<ŸúÞˆj\Ë\rÛ‹}\n7[‹\Ù\Z46¹š‚\Ü~\à—°\Ô»?¤šj¥~N—\Ýø#‘¯]˜\ßÿ\0…lu¾:3\ò\ñ\n¦Uƒ\ÆØ’K\"\ï²*\\\Ñ%\ÑÄ½/H&Rü\ïÂ\ô£\ëJR\õ¥(\ÊR—¢—¤^Ê–\Ìý°»žH\ìb•\\þL–\Ú%6\ò6\ð\"v\ö%|>·Y¬T~‡\ä2y¾†¼ý!xýµ=±\Þ\Þø\Ë\Ë\îÌŽnÆœÖˆ\óLtûžŠž\Ï\Ð\ÙS\á´7Ùúh¾Ã¾\â¶F\Ã$¡ÀˆO\äJ!|¯Å¿‹/KÖ”¥/J&R”¥)V\Ì%\ô4gÀ\ñ²¬\rq.\ÊjO\Ð\ð®1\à\ð\Þoº‚i\Zù\ñ\ö:§—…\èžr«·Ý‹º=a*BXˆ|\ô\è=Aå—Ÿcenzx\É6~z}Ÿsb7‘4y\â\ðbE³xúgsf\n(¢N™(„,\õ¢ùÞ“\å\Ñ¥\ëzÑ²—\à»\÷\ÐkZ\Í\ë©W—“{2¬`½Žš\×a“\"PKa\Í|+DI6‡Â¸\ÇX˜\ñi)\r\ß&Q_×³=²l·ƒ\ð{\íú\'\è\ð²\Þ\Å\È\ß(}‚\öþ…\ò¤1¡\'v5\Ýú8+k*ù6l\ê¯\òH\å\Ñ&\ã\ÖzTJ›ˆ,\Å\Õ¿\ð¥/V>´¥)K\ÑF^´½6\Ø\âXl\Îs\r\';™U‡|‡rã¸–rþÇ§\Ç3	\å\ã\ö¥]¶Ä¶t\ÙDJ\Âÿ\0#\ò\Ç§q¢\Ây;Œ\ö2a~ËŸ\ôx§%‹e_c\Çh}\ì½\Ó9Ÿý\î™š^…b1|û=¯Á½Ÿg\ä\ÃYÉ \óÂ„ÿ\0\èž\ÒûŠ~¡-1—¡„—\Æüi‘\õl¥/E(ƒe/JR—<fƒ¯\Ù\ÏSºÿ\02\Ñ\õŸ·\ö\nµ¾xE\Å\Z-`l\ßúùþ±·u\è½ËŒþ\Ë\ô$‰ªV\÷‚³x„Í½&e\Ç\Ú*y%Ý»\Ó\Øje‘eW\ðU©=Š‹ÊŒiXký?\ìg‘úD\ì7|}Š,F½±iÖ«XC\ö\ð9\ä\Ô\ÐEøZRü¯\ð¶6^”¥(\Ùz)JR—ªv×°k\ÓW\Ç\Øv’W°\È\Ú<—©\Ö\Þú\÷ù0\Äg§Fþ.H»þŠ—ø=\Ý\ÙG\èer\ß\Ð\ß|¢‚¼\ç\ÐÓŸ¥+k\óbLCbp%\÷	¸²-O\ðƒV¯\ìX¤§û\"†`X\ÎDÁ\ô+F‡\noBž\â¢´\ÊD\è\\t£\rü\Èl”¥)~\õ¥\ÊRc£eJR\õ\çªn\ñ\ìw¹>\çûd\ö\ÇÙ“\Ò3a¹!w4„ù\Zv\çK-\àŽ?d!\Æ{	\ëi\áŸGú#L­í‚–½\Úv\ç\ÙQB·\Ü\Ô&O.ø\ÉÈ¤ý˜ƒƒn|½\ÈyŠ™\ô5cYÑ…\Å\Çq6%ËŠd\å>\\¬M‘¿-¸\ð]\ÄJŸ–!å”±1\Í#]±sb~t,0B\íI$=rAg¥J\" ƒQ°R—ªøR”¥(\Ù{£¥(‹\ðK\âûÄº1M´4£XQ7ø!aŽ\í\ìvã€0ü\ô”þÀ½û›G·“û…nØ»SbŠ²0Leiœ¹ù\ò{\àÁ-cÒ‰Q\Z%Ûœžo\ö<\í¼\òø\Z\Ö?\ä[¸ÿ\0bÿ\0Ë²OF\Z\ß\Ýÿ\0\ç\ák\"I\èM\Å\ìÐ‰¤\Ø\ð\ã¥?¢?=û(×“:\Ô\"	CvEFI\ätB\Ë(+\è¤>ŒlEz²”e}EJ&i\Ñ¥)F\Ê.´\0%…N«oÝŽÈ­{\ç,\Ã]Ž\ÎSge`\Æ\ò\ð$–¼Oiš¨\ñÁZ™F–M	}i8{º\ær1Š\ãÇ¢¢\Ç\ÜOzKÚ›\õ‚.[\ÞO\÷­š3\áM\Ï\"M‰{hK¸\×b›D\\¿\ã\î\Ì\Èy\ðl@—G0\ôEKt\ÂC=£ýQp,%VMµ³¾\r}:C\rˆ¹\Ä0$hz\ÉK‘112\ô¸VÀ\Ø\ÙJQ\ô\ê…)J6R\õKqGÙŸ\Ø\ì\òL¸\ÛK»k»-\Ã\Èu\ìwe=žGu—\ÈÕµ:\"M\í‘a=²°¢Š\'øY6„\ï/}š[\àia2x$\×	\Ñ*\ÐP¼\n4¡\Þ4–È˜bØn<‰w\ÞbÍ¾\Ç8³3‘q\î\ãªCš\ÇV¹œì’¯Øžš<:2ºƒ“k\È\Þ\à€XF¤EZŽà¤„ŠQ±\ô\äLLA2—£c}£Ð¾\n.\ô¥½(\ßJQ2\È0©Kˆ§„^Ì¶¯s~DIe„¦™”þ\ÃÐ„\Ö|\è.ú±GŸ`\Ôx]:ü}	Q\ö˜\é\Ø\ó\Û¬žËœ\×\è\Ã	¤¼\×\ÜË›\r\"_²\õª?û\"\ËlÁÀ†m,#Ù¯e\\\'›m¡\Ý\åw†²T`e‰1£fyœ8	=t\Ñ(º4.z)J1tB)rQ\ôd£À\Â1\ÖÐŠR”¥)D.›\ÅOˆaÄ¢|š\'ù%·\äÝ¹\öCq{˜¸.\ã\ò½\ßqn/D\ÇÙ™î‰˜U£/\ÈG¨—‚y\ìû\\ý‚*¿\á±\ñ\Ç\Ù\Â%\äO³\òKüIiÏ“  mÑL\òw\É…¡+­‘’·±2ø;¶\ê`y‚$2}M~@\\†2Š^”§\è\Ø\÷Ò”eJ.”¥È‘–ÝŠJ§ù¼¶³\Å\Î\Ó\ð;f\ïX¢%¸\à›oB\Ñ}\Ä\Õ!\Óxp^3\àLewL\Ë\×Ù–Å¯&ýSþx\r­,™\'ù,`Xnú?\ìi\Ï\ìMm‹\ö>Šl^Bjw*s“h•}…b\Ñ\ëCW¸ˆ0‰‚ÝŒ—9Hzw¤c¼‰±\Ãg\ÅÒ?\rr\ÊR”·£}b”\ßÂˆ¥\è„4\è\â}\Ù	„Ÿ“x±\Ã\ö;R}‰W‘š\ÂiY\ã\Ör\ë²-&qù\Z\\þÄœ³¢R\ð \ò\ëØ·\Ã\÷‘\â\Õy*¥“Ÿ#|1¤6‚J\ô`Š\Ï)‰¥/\ö7v>¡|\Åú0»•ý\ç>®\'\'¥\Î²i±-w5‰¸pf\ÎA\Ã\Ð!¡±Bu9tÞŒB”d6R\ô¥/A†\Ê\'\Ñ\õ)z0Œ„°1•Š§±_þŽB<¿C•ˆRI.\ä—zDE³\ð†‚¶»;”#\Û\n¿Cû¼³Ì“\ÖG¼ýQjOÁ/^GmeO\"Y¹Ïa„©ÿ\0¤¡­°\éqD–\Íz3\ê4&˜\ïr//Ø’†|~\r7\öD\Ð\ò©©\ëü™¸\Êz½²{„\Ú\á\rB\î0c\ô›/A\ð6ŽOD1±u6)p1±!¢\ruË¡T\Å\ð,k‹ƒ±Á~Œ‹»b¶ü+\Ûm{ÐŒ–_f-\Û\Z?x9i\ÌD„\Ó\'\àm\à\ñ\ØUŽ/BW#\ð.\ò\Ä\ã\å\Ûc§—‘£–4µú87K\ðibüNšF¹\Ç\Ý\'º6–\åoP¦ $Y­\÷fM\ë\"B*x\'u‚$f\ô©ˆ·\È\ìHZ=‚\Í\r\Í\éIþFEIf\ëú]eIQ™¤]¸\Æ>¸!¢•\Ñ\"\ã#\Ð\ê\ô1<y<Ì’\ÊcG\";Œ\\’…|Ž5Lm-/¸w“û¢«À\ÞÖ´ŽÀùÁf?±··KW4®\ßTi=³\õ\r\×a·/b\Å\á“?\Ç		vüˆ\á\r\÷2oùÀi\Í>\ÄRŽ{ƒu¹e8\ö·’b`Œƒ^¬‰¢`– T„é¨‘œ‘x\Ù\ÆFyt¨a‡´w	ˆ\ã¡n\Ì\Ä1`B\Z\ÇDTè„‚\×D„t6&FW»b›\Ø>¯\ÉMÄ¿ý1K\Ïþœ\ïýc\Ö\ä¡f®\â¹Ybk*\Ñg\r2\ð/?Ñ™þ\Çÿ\0\Ð\Ó7\ÛD\å\×q¡\â7ª*ý’¸?¡[+\ò\'\\o¬ž£\î\ò%$\ÙþƒhIzCvùƒ¬\Æ\Ë\Ø\Ó\Ó\Ï\Ú;\Ó?\ò4û\äB$\è\ó­\ö0\å	!Cm½‰Œ\rv\ZKb„1Á•!\ó\àØ±\ö\ôL‰`[\èo …½	ˆK]M¢ ‚PbÞ¨(•\ÃZo-ü”\î\Ð3†\æËœ’1±\r&‘\örˆûŒÌŸ\ä#\äË»\öS~I\Üa·¡\Z\Öü\Z0\÷\ðŠ•Ï“>\ïÿ\0„\Ü\Ù\ÜüƒWüÛ£\é•4‡xqúH¾\Ç\ØEa\Ç\äkp™”i1\ô\ðXp]Y\×F3±\ÒÉŽ}=\r\òmŒ\àz6„Œ®„!u˜\ÏCÁ\ÏG\Ñž\ÇIž‡·\ÐLw£-X$º/+Á‡.ü$D\å\"~JùÀü‚§#‡¬\î\ÅÁù4\'‡\àÌ’<…†\È\ïfvSÉ¿Ÿ¡û\Ïa_\Z3\Ü\òB\Ö\×\Ù\â\'tW[\ñ\Ð6^F\ÃEà»¥d„P}BÒ¦\r²f…diÐ„A\Ú“=[t\Z„\Ñ\r\ðXn‹#\î8‡\èK$ÀÐ—D Ñ‘¥\í?b\æ¹;\Ð\ôQ©\Ù\öz\Éx\ì‘\ÒÀ\Ô_øaqE­O\æu¿$Z\"\çûG\à\ã’†ú’\òp\Æ\Ì\ö˜.\no\Þ¶O\ðV\÷ž\Ê´\"\â\÷fzM”\Ëþ\ÊQ\Õ\ä\íý°½Mc\ìÁM\âBªv$\\˜5%²A§C~z˜f,\r’X™)D\Ê-ˆcž“=F„\áDFc&†j\\	\ôRšL},%\ð\ÓD½ªÐ“†y{ø¯¢\'\"#˜)ù\"o“	b	\éž/\ðE2¯\ì¢Èž’&[o\é!l2E­V\Ô/—ø<\ñ\öHl¼?\"\Ëy‘û7Ð§\Z4\'\ã%›!}¡\à\íT\ÆE\×!dI£cNŒ>ƒ™G\êN\ËÐŽ‚\Ìz„&&R”c\Ø\ô/a»Œ\ÍÒ¹\à ™	‘:Ithe\ë\é+\È\ð?BÌ¿l\Ép¯,ƒ\Z¢M\ò+\ìlˆ¶qvdY\å\×\Ù\Ìq+\Øv&‚¤–^X¼OG{\ôÐ°]\Æ~\Í\Ý²¸‘²};1ýS¥\rùc´*\÷À\É7˜6\Ð%\ð2†«Fb¾‹\"bpg\ÈyH9³¸`\ZueÑ’\Çç¨¢}À\Õ$62\äH†\Æ\Û\éC¾)Y\n\è\ÙFþ\rkX\ô\Ûý	–¼\à\å\ö\æ+\ð3UgûŽDœ\Ê\Þ\âK\ß\ì\îiœ\"f¼–v¥TlˆK»FN\ð\å³\Ù}\Û\Z	3ÆŒ¥\rø\Ì4mO£_/BT\ó–,/ƒ…Ý±rŸ\çc-Ñ„\äS%‘µ½yf\ãN\ß#=\á\×Z\ò\ô\'d\ó\"\á\É-F!È‹È¾\ä½´¡\"\ìªdUo¸š\ä­/\Ñs`\Ð\èW\Ð\ç%\ènŽQ¿ƒ\nú®„º¤\èY\ôB£\è°6$¦1\äh«í–Š\òd{[\ìKXNÈ³„¬\Z¶zW\æK:T¸\È\Ñ4Bu‡;¬zOù¦‹O#}Z-¯‹\n·—v‰|OÀ®µšk¶\Þ\Þu\ìe-TpÒ£\ðK\r\Ù\ä»Þ†¹ù*\æ\ïe\îýÿ\01\Ïý™œÁM—±ÿ\0«\Ú¦S\ôTÁ\ÔU<A¨J[\ÐÆ°7¦4¢\"\â©\ä»\ò`\É\Ìž\äa¨ã‘«\é`·\ÒÄŠ.”E‘ŒA¡„5Iüq&\æ×·\r\n{¨d\Ã}˜L·®;=6%\Âiz€Ácû<\Ùk(Î’\ò\Ø\È*3Zþ‘ly~G\\\çÁ\ï\ì†?Þ¿C\"8ü	\Ój¼ª2\å\æc\èm(“\È\Ò.øC‰’úŸ¹²\ðýˆo\É\ßC\Ý7úUKý\à¾V<ˆh|IýŸÁ%fyLªŠ07\Ì\ß#{\Ð\îb¶Ñ›3Ž\ÝKB¡NÁ‚\ÏC“\ê20B	\Z)É¥¤2tB)J6^\ãj\Å\ànU\àgz\òPfy\Ö\ËF\î\Ï\"B\Æ|i\ô¾ŒH’|\rn/)r~p,xzRœ™5\ÄÀ­2a_.2\í\â	`™\ö\\¦YNŸ\ïÝŒ$µn™\ô\ã\Üa”»}”¦)S\Ý\ß}™—L\ÉUˆ™{„\ñ†;[¹\ÚB\íýhY“ý¾‡´.\ÄbT?·b]¦+;¿¢ù\Ç\÷/@\Åÿ\0±\ÜB­6ü\Ø|\\\ö=\ÅP\ÐF\ÜvNŒAKÃ¢œ\"ÁD\é!Ž…FhQ†\ÄQ	—\Å)¿Šê“—,\ÒS†P¡¥\ä\\^\à\Û1[²Ðž^D\ÖR\á\'\ÉH\Ò%\ÜxeŸ\ô!§Jw¢\ä0I\ð\ö!##F\Â\È\ãü8¯Á\äDÿ\0\'\çþD¯/À˜\ôÿ\0Á_\à\ÛÍ½È¥c‘µøTj\÷žÙ‹iYE\èkˆ|‰7%Ä¤\É`¼\Z4T|MþJ\î\ð\ådc\ÝøÀ\ò\Ó\Ç#œÿ\0\ÆÀ\ÒL_\ðC[²¯û\é2\Å<q\É…l¢SÀ\ÑPÔ™`•	´43lK\"I¡p9:hNœ\õ1!2\'C.>‹\â¿\Â\õ¨»Á5¹e_B\á~Y«T‡°…iR\ï¡\ÆÔ®+B\Ñ2\ò	\Ö\Ë\Îµ¿m1c0Z¢\çwn\ÂZ\Ïb+Iç™±­Zc°M>\âŸ/\Æ\Å\Ò>ã”°,‡‚6\ËOUú#KI^\ÂNÿ\0“¹…\ç%¶\ãÿ\0\"Lf	\'ÿ\0ÁIPhÞ¿\'fÊ­\é\ìNxv\\3<wf\äq#2¹\Î\Ìsb\îšÀ\áVD\Ñá‰–m\\¼\Ïa—#\Öi³h2\Zˆh\\\á5\Ð\Ìr.…ƒ­6%Ðˆ,è¢Ô¢þ9U¡\ö\ØÛ\È\Ûÿ\0\nW\Ë\Ïc#\Æ7)ŽŸ\äUø<h\íœN\âS:\ò9yˆ>D!ä¿“%·w?ft§¢\à\öÙ\Ü4_{xCrz”m\ñ\â\ðd§\Èj\×\ô	Â¾\ÑrˆýR—s+¨N?\Ñ\Ùüxƒ	\Ýz\Z\å\ö!|\ñ“.\ÄJ\Zn\Ø*\Ôoq)ª+\È\æbx\É2hkÉ…\Éw\\jn\÷¡<r8º·¾Kg\Û:’Z\éB\r	.ºf/‚8(Ä„‡¡©\ÇD&!.‹\â_\Õ]¼>Â’£^‹£¥ù2;\ÛG0ü%Zql?Ð“HMš—rbKû\ËW\ÜY\Ìhi‚\ßü©üž\\µEO•\äf\ðW·b’Bk’¬´+ŒQ‚\ï´\Z —·þ\rV\æ\ñ±r9r&­{+¶\r³ûqp`«S\É\\h»\ÈÍ®/’Õ–„\Õ\å›^h¼›a\á\ÜJ\r\äC,®\Æ\Z‰®ü‰\ÊÔ¡,zy.§\àRx?Àž/\ÏÐ²\ß\Â1-›\'S‡R	|ýˆ}\rg¤!:¡,\Z/E\Ñ|šG³¼{†X»¾È¤U\÷šß¢\ð“\ô°a¶½!\ñüžŒ\Ó/Ø™Õƒ¦Wr®QØ¿d3¯F\ßo¡»}»½\ÈkO¶´k\í§)_›¢&+a‰–;U\ævb68?ÂŠ‹v.M²¹ _f!\èIû\äKµ#k\öVµ\èz­\Æ]+Q\çì†´©†\Ò[\"­‹CV\éT±ý\rh\î1¬ë°‡œŸ‘°P°Ž”À\Æ\ò%\Õ\õ¢}\'Cé¿‚\Ø\ÖH5žŽBDM\ôB\ê¾*8ok …¯\Ò\ZLþL\ÏEn\ö\îJ\à\ãG„\Z§I®\ìiUþ\Î\ÃDŽgrR½†\ñ±\Ô,<½	)1\ìS’\å\Ó\åy3\Ò\óEP\æ¯6®\àÊŸ¶\ávb|\"›É´\Å{=ÿ\0BIÌ˜y)\Þ,`p\ö$\ZHÇƒ\r\â?±$\Ó9k—4\\\àMb!*¢¨\Ýþ†¢\"[¾˜¶&‹Ž†\Äþ1\õ.¬ƒ \Å\Ò	 \Ñ:	\Ñ:!>K¥\ã#m\äv\ôç±¨¿\Ò-Y†®þ\Ë\ÂTil_A\Ü\â\ö\ZQ?\n‡ú\Í;\ã\ß²<V\æ\Å\à\Ü\ð7\ô[¤Y·\é™¿¢,wlL\ë?ÁUp»(&–\âþ\ÎGoì³±yc´·\èq$\Ý|\ß\áB·µù!9ÑžR#’GiÙ%£n)yØ‘œ¯%\í:‹d?bL>L“\ö‹µÒŠ\Ñ5‘;	‚VE†^Œ†‚F†…³B\èú¡“=BcDE\Ò£\'\ðc?\ì©L\'\îh·yþ\Êsû\áÿ\0Mk¬%\'r-\ç|A\'§blŸ\ÕÇ„…¡DüŒ\ætk\í\öY\n—\ÉL2\òÄ¼K+\ði&W\àac~Yq\"\ÞD¡xý\r\ô…>r.\ñ¹ž´\ÃíŸ‡£\\˜p‹[×±gfE}ÁP\Ö\r“\à]B!e\Ò\ÆÀºL‰=_M‚8\'H$AtHÉb¢	üy\Ë\r/8\ÈtQŸ€\õWº\Z‹)\Þ\ôœ•\Ãú\ÙU\Ý\Ø\ÑVÿ\0BL­\Ùì‘En1¡,\ã„M]v®¹M›\\Â¶?f)\Í/\Ø\ÄB\ãb†¹3\â3ª,¹.\ÞF5s\Ë\ö8\î}P\Û\îý†pÿ\0E\Û\Û\ö3µ#\Ã\ô{\"-eš\Ô\÷‹œ\è\n\ó\èU¯±»G`\Ò_\"hxêŸ\'\Ñ„ˆBN„ˆB|!:/”\É>¤3d¨›\îºq‘/\'\ïIS\ï\"e²vE\Ña{&üŸ“ÖŒ™­\öDX»HY?1–•\ìŒ]\îÉœ+„+!;µý	pÛ¸\Z\ÄÁLš\Ý\÷¯\è\ÃI;\ÜÈ³˜=C¥²»µ\÷‘ž\ë\ò;>\âüzšw\éŒÿ\0C	‘Sx\ô7Ù™—^\Æ\ØÑŠ¿\Ó}\Ù5Œ½)ø\á97A&„0ø7\Òu„\ê$$%\ñŸ\ÅÀ¾„—Y\Ò\"TŸ\ö7\Âo±\â\Ã}­\Û\Å&-¤QezÈ¥¼,!a”›\Ðü\É%ˆ\Ý_l•\å±c°\Ø\êýU\")i\àm=Œ\ê4‰!º©¯]\Ê\å\ìy\ÊýQ¹{!;\Ä\ö\"*»\r<}\ÌB\Î?:¦Vÿ\0\'n\ë\Þ\Ë\ËÉ‡3<®Lb\ÄúN2ASm^%\ØN¶~\ÆLbG·‚§\ícÉ3\î\ä¢tÐ‹\ðDø!!\"„\'\ò\Âø\'N>\r6}‰¿XYÏ»3$#û\Ó?:Ut»:\Ï(\\h{“~?\È\Ý\ß\ì„\ì#W\Å\\\áv¦\"U^2iÜ¿Èº°Ê¶\îfß´‡½‰¤\Ä{fž[-š\ÞM/ HL\ð\×nÅ©q‰+\÷v5\ä2\òCˆ\Ü\ö\Éo„\'¤}\ö,\Í\ß%›b‰\ån\Äl\Ò\åpˆÛµ¦xyO‘§|\Ñl\Ã\ð5\ðX–gf/$ZZ\Ð\æ=‹}‚]\Å‰üIú4ˆú1\Ô7\ã\'„=¢\î2°Çº¶Ÿ°Wý\çø8b\'Ws¬Œa\ÊbÊ­ÿ\0A.\õ\èm¯±W“‹~FS/d†\è\Ë/\ä1\Ëí˜¸\ìù_\â<\Ï\Ã9|\òžLXüŠgþ:Á\æ1\'\É<Ÿg»0wp\Þ\ö^\ï\ò„\Úg’Ü£\Ñ—Ž\èKmk,	<\÷N®#zE\Ò%p5\Ë§¡i•]„°šŽ\òa\ô%\èzú/„\ê\'\ÊuŸþœºc\Äd5^i\rU\ÜQ\ë~F7c_¡\ð\ã]\Ã\ÝS#š\ö\í\è\ÈDºimoy\n\Ü]$¦¾ÿ\0Ð²ÿ\0\ð0\ôƒÿ\0\Ømœ\Î(\ôV\ßQùdV½NF›^\Ò4‰q¾\n‘´»	f{dEw\÷Y?1h\ØxUý\rg¹L±\ö47M¥Ê¡–\æ~o\èI­\'\å>O\Ú\îEÁO‘\Û\È×†;‹\÷’;\nL§œ]Å»‡¹\\Š…$ê„‰ŸŒø\Ïÿ\0[\ÎÂ±•\ÓLùß€h\ð\Ãx”®U\ôZ6)ž\\z1m½¢r\ßv8n—\\^G—w‘­J\ç‘V—\ç­¿%S\î\Ø|»6°\ò‡&ûþLO±¿B\Ý\Ñd”LV…€¬’y\ß%xm…\àD¸…\Ý¶G\Ã\àUI\àH×¬`\ì\Z‚\ß^\Æ\Ý`l\×ˆœ\÷\Ó\r\ö;Œ\Ú\ò\"Q\Çg“À\àÉ°\äJ™\'Á¾	ƒœf;‚“¬è¿•ø§I\ÕµGn\Ävÿ\0&$\ë\ÏÀ\××‹Àg…ž”:ÀU´\ÏozÉ†š3Ù¾\â\Ö+ô…·Š\ê‰F¼¢¯”IŒ¸\'d\É*Z\Z]™\ö#Bý†Á\ÇaZ?´dŠ>Ý¯µL<}ŒMS^²%½\ì0ý£ ,\ÜÍµœH\ôŠ…)•($\Ë\ðdf\Í42ølÁod_te)LHLøø^‘:\è¿ü)\é:Î„!B$B¿\ðB±S^\Æ\Ó>WB­¯y2‘Uý’ª\ðm\"y#‘\Æ\Æ\\Œ’ \×w–a„À\Í,5|˜\å¨\Ü;,«š\'ø!\ÜO\Ñ\ÚÛS\É.¶:l^d,&ÏŠL\å1\Í\Üø(ø\Zo(\Óm¾Q1˜\ôCº²?GžGO	Qº’B‹²\ôb\÷|\ÄbÀûvDIÀra!&\ðZ0|R_\Å\Ï\Æ!	\Òta	\Ö!:M\ð˜CmªŒ²‘ùCvfý\n¶±\äi–4C_\Û+3=ü…s\è‚J¿|ŠU_\ådy\äú\òo„œre\'üÅˆç¡¯‡?Ð¹¹ZR¤¼’3®C&A¦`¬Á\ã-™\ôCi–;d–Uþ\ÎÐ½\Ö\Èý8™C4\Ú\ßHb’¥\æ&%g\ô4ù^ †\ã\è\àd2¹\Ìû\Zl¸%º¥GV_„þXN!N„\'I\ó£Gš\ñíˆ¯\î4\ÓKqx>|\nG„rŸ‘6ømŽ\ÔI¯!)w®2i§¿²†R\äiqC7W.\åwÀ‡\ã\Ò4yÅ„3á•±\Í\ÎH›Rs\ãbWúv7•ƒÉ‚\òfn=˜¢$ûs\ô7\á®r\ÅÍ¢Sˆ£\Æ\ÙuR\Ã|\ÖÛ³\é\n\ä¼(oOa7R<ù%à¿¢¡¤šgxL9¥¾;k,‚±¶=“!\Æ\Ì\"N¤º/\àK\ã	\Òø3l›ø*ú:ee\Çuv3O\Ç\Æ;3‰†8ý\í\ßc\ÉþF\ïn¾Œ§Š\ï\àIR\Ï9le¶—¬\r¦\ðC®Ï©E2…!*&$\Ùv\Ã\'N%\ä¯\ZŸ€/i\\¬\ÃAxR´É­\ßC{y7\èµ\ÒI·¨ûf\åÚµ[g\"§¤½þû›ks¢\Øûgb8¸À\ðe²F\"Î\ËL‹Á‰(\\\×FE¢\Ø%ÁZ£x\ÙU\"\Ãx0e™Ý­mCmŠpUù\Ã=\Øs	\ä+\n\ö<š|ž&®„ ™ùBtB]\'\Îuª#imš\ñ¾OA\È\ÚHÌ¢o0\×>_\Ñ7ƒ«\Å^09ÁŸÀmb=/¥þI,¤\ÆI	Ir‘“7~\Ð]lø<\ÒMr)“\Øt\ç<\è\ï	2†’6s…ƒ*\Ùs\ìÊ˜\ëU.\èK\ìz~W?cV\ê]¥Ø’ø\òm¿5—þrYŸ¡xK\Æ\Ä\õ…\ì\ØÛÕ¿H\Ú\Åø-Ø‹5«*™”\Ý\ËZ¼‘=`\ËC_\ãOC{\Z\ÌÀ\Å%\ËcL›D\Ü\ö*R\Þ16¨–+CL±Ž\è$™;\äqk\óD’*\åxÿ\0f\r\ß*\n’Xm·)ýš+\Ó\Ê\Ó\Ð\ÉKŒ»ÿ\0B²’¾ý\Í9N\÷,mVG8\Ùf¶\÷û):Šd{\ðu{\ÞH\êc)kû9\Éø/9×“ŠsÁ/ý€„!\ëA\"¤ ¿‚¢a¤V•\é	i+\ÞX»\Ûs\\``¤\âx!•Kg6&R±i\÷5	OÈŒ²\ð\\©;Ñº…‘6D\êjÏ¿“!k\Â\æ\òd\ÉÑŠ\ó|vZ×•ÿ\0\Ó“CˆePD¬G¤Z\ß\äs¸¼w*N#«0§ua¯%5\Æ3‘\ÎO\É\áGd¼Áq]sƒk\Ú\r<¤«+G%úÀ–Ÿc\öøÀ\ò”\ÂÁ\÷4v’oA>B\óªc“c5\äÎ­\ãû\ÒG\à&“N·:\ñV50ZÀ!B\ÏM•¯\íÎ‡þ\ÈÜ å³¾Â˜\Ý\ò,u\ãÙ¤“8\\û¦’\ä,“o#*–\ïÁ\ôž\Î+‘žs¦MªžXƒŽ\ç3\ÆQœ«±HO^´{‰RŠ4¼1r/¢G …\Òt„ù¶–Ù«(Ç¡¦Y¡S¼+G;2\íùª6±8.´`¡vIÇ‘<•C\í$¬\è½;Š7W\Â\ÑKRNÍ¢\ÛÈ²¶b¡¨B´\ó±až8of‰=\ð˜šs9•’GPˆn/%[ITÙ£Q¹È“±\É[M¬²#\ÆLdüâ§š8\à¥È²™žûh\Æ\õ¡•\Å\âÿ\0Ñ³>Œü•’k+\íþÍˆ£ýY4.k•“b\Û/\ÌYc\É\Ú&¸B\ÄY·Ã¦a²^ŒµM6\Ób¼U\Üþè­¦™v>2\Åk6šÀ\äoq.E‚¡ý\Ï\Ç\Ð\áŒœ`‡jY[\î>\Ú9\"­O— \Úyk\áþ…2Uy2™ø\á™1›³M2\÷D\Òa—-\Í23\'\î”T³¬\'N_\à\Ñc\Â\îdV\õ–QZ¶r1\åþ	«ro(\\A1žK‘4¸R{B\ßE\óº\"!ï¸²/›x&¶ \Ñ?}\n¼\ó°‰F\Øi2ÿ\0\Çÿ\0ƒ¢\ØPm3ƒb\ÑY\î ÝÆ¼\r-‡\ÜSg€‘\Åa—n+1¹\Ø\Ìa\Ü%¦j¬®Pºse¶*\ô½ØŒ\ËB\î>F•qØ‰³i\Z+•6U\÷%f›yOOÁ…®\"K±X8[uLˆ²\ì\Ô.ø\'Éˆ\ØrªN\èrsÀ\ì<— új6f\í½vþ)R\ZM\Ù\í%\Z^Æ—\ö+›½‰`úf[Àùù\àqÍÞ•¹ù<B\Æ9²	˜ˆ´ûAb\ì¢M!Ó£¼\ÐÙ§\Íûÿ\0\Ã$\Ä~2&F\Ã\î\ô4Ù½\ÚÁ¼&}\ÆM0nw\Zi)\ìy¥‡[|¡¼¼\ÛÖ¢G‚§;1°ùM¨“œ\ñ<Ä–p‹^Ny*~¡,^\ÕRvw\Ëû,’1¥0t\Ã/\Û#B)|7\ôZXT´K#X¨~\ö•\Âo”T]¿\Í\Ý\òŠh–\Ø†%<ZndØ¬A\Ò\\z¨\\o\\Hi\Ô\"£Xƒ\ö9\Ê\ß†#\î\ËÄ§˜\öhA2\ðhsm^4Ž\÷\Z‘Ÿ´aU…Á\Â\ãl^ý\ð†\ë—s,áµ\\2L\Z¬´KFHN\ßi\ÙN+?¡\Z´\\$&\Í#§LÕ–SM+\ì\ÜÐ­lý!\ö(®9,\ZF\ÃUÜ‹‘cý(®\Ø\ë­V²þKÂµ…8&\ö\r›IzF¹}\Ì\ZiWÃ‘cf³¦3aÝˆ­>\æk¸¶6Æœ®2¡5i\Øwc+°—FY«	wŠ-¸\÷{²!\èJûÇ“Æˆ \ÓzAW\ÉøêžŽ4iOtI*\õ{ƒk\áb#N\ÉlV\à‚›\Ô\'\æ`’a­¹\">Ù§ž\æM³w,‹\áJX\Ù\ò0Œ”N\ØÁ+\î.D¯ž„——³U$\á¸ž§±h¦\\P\År]„i‰Ý²1\Å#‘\÷n\Z¹ZB\Çø¥G¶p<z¬\ã•Y½L’\á£NM~\n8ýŠD\ÊU\á\nfiÀÒ¥†Ì\ð+wh„Åµ­\à©8’‘\áL\Û3Ë½!ˆ\ÎG™ü™F£\êpÃ</Ø°9¯\Øø«£¹cUœY\Ç<!m›¹¡­–>\ðe¾¤ ”(\Þ\éjw2»\r\æ\õÀ‹3Ž.)”\÷\ØÀ‘y#°aLr\íEU}Œ¾Ð™\í\ì$3\Þ\n²È¶SoW\ò5iŠ6·M¦\Ë\Ù\Í\Èß‘9<‘j’Q\÷%Î“\ÊáŠ®4Ÿ(¼W“&»½\ñ]\Ý]¡€XÑ±4{—“\Â\ÃY\å˜\Ö‹\É1Ù©Nhˆ\ß\á‡\àÈŽ\Ì{\Ö&á«‘*\Ð\å¹^\ã\öqþ\î\ÃD\áF9¿\í™\ËÐµ)y«\áÁ\"Ù’…½-“–8|\ß-š3«r\×\"}øm¯Ñ‰078_e´\Ø\ß\ö\Ìv™&¸Yhi[8,zmý½‰Å§œ¨µ\ÖnÂ¼‰¥lqL	²9¸2ˆZz2˜SM\Éa¬¥i4\ÇU1h©\Ê±\î\n\Z¯’\Ä)5•_F\Û\ä‘ «]\æ=	\ÑV\Ïth.B\×\å¦H²¿\È\Ý<^[#¼\ß(¡p™6W\ÊKor\ÒT¼jª•0kFµR^+\Û\ØÂŽOÑ¦\Ä\âl;\ÂiŽe^h\Ýb\'s6<Y¸\ÏbJÇ–­?\ð*\é’\Í\"†K\È\ÕwR§\àgQm [Bm¨\ë\Ò#£Gý\ôO‰ªB:Cº\'3ÀPiVA\"s?\ì¸\ÑJª¼lz’\ÛÁI4\ð\Ò4\à5\r\ê¾{¡z<::\ös\ö8\È\Ü\Æf\Ç5B]\Õ\ïØ§ q4#nwC”þ\ÃGj\ö*Z]\ÎTý¶&\Ì}2“\ì®\àX\ZqU3e(\Û\ò7hbH¡v7r–>\ëž\ãl\îh‘³P¡;µ¸_~\ÃK‚KyÈ©†\ò\Ù\"‘r–\Ì-\Ë\ô–ýýJš\Z2~8\ÒÀý[¼·þÙŒX6ˆ¹&™\î$\á³\ÏbB\Ç\Æ\Øµ\óžN|4ùcJ,ü:¬\Õ\ZZG\Â‡i,p`ÕžŽ¹¤Lžµ±\ô##.ß²\ÊSE8µ\Ü\\X¸\Ò\ó²\Ñ6\É1¯w#\ÉLÓ\Ô+¥\â\î*#‰\Â\í\\\Õ\Øv1^° ¯©’\ãK·±™T„\Ñ]\í¸üˆpþJ†”\Ò0·’W\rq³C¡\r\è\Â\×q†y°\ÞpC•TO\èB	d6 \î&A¸©ª>N\ã\Â–V›*É‚\ØQw\Ù«9\äp¹jµ\í·Dªm¸Y6‰7\'o	wHX™w$=)m´\Ðù\r \ÊoU’\nz=\òE¤»‹\'^NV	G¿$2\î\ö5Fý\rž7 ¢-Û°N4\ó\Î\r8E\ÈÎ€ªì¤ªª~©ÇŸF)\ówp\ñ\àQµž\ÃÍ–\ÙY`\ò\á2a\È\ÈW*Ð†\'\ð‡\ò\Üe1ƒ\Û\ó~Œ^JûEº\\{!{z\äq‘µšhù(‡–\Ü!c§®f\\x\àw„\ÞpFrš|•©ar?\"\'	¿\òTM°I4m\Ýtß›\Ç)pUþDœ\Ã\íh„j“\ò;Æ¼µ\ÛC¢L¬Ô„\Æ2‹C\ÅI¤Ó¦0¯Ý¯\ð\ZbrE(\Ó\Æ?Ø½\Å\Ú\ò4­”mw\îWTD±ùb&b`j´ r\Ú.\Æ\Í6Ë²À—¡“yþŠr£sÅ­=°±U\r\ì|\ÙS×¢\r¯‰ý–+.{\ÒiV\ï\È\ö§‚”©}‘fh»\ð^!V\'\ìj\ßqbwÁ5fjQ\Å}›#Q‘\Ç+ƒF%}˜›Ð—Ÿ¸\Ócü–S\Ò¥q{h\ðZc7X\\r{«-‹„½†\æi\Ü(\Êh\Ð\'\âü\r(¾Y^\Ä4ze]Ü¡[’š\ìU5\ëlK7µ\ËeIcÁ2}\ZË‡qÈ—–¢^²\Ì\ZCú#\\<\'‚·\ö\"ƒ\à>^Œ\ë‘+t3²s„$œ?¶P±k\ßV$|d¬Ny\ß\Ø^9ÿ\0„9þƒ’ù‚£\ãÏ‹‚\Õ\öX\nQ\ÂWƒ9/‘B\òG.¶ÁjBš\Z3)\Ë•‹§c%ŠkbSøc\Â\\\ìR(þ‰8\õgq-5)³\Ñ=–\ó¶aù);ß£\öL·\Æ\ß&J°\Ð*¦kth|7\ä‰)\Î.?Q\"f\ô*\Éc}	\é}\Æqº¸\Ú9\â7x02\à\ß#m£X&X;À\Ö\å¦ÉXˆI8yÏÛ¦“ˆ ‡`[\Ó„TX\êž1£#v“eª„¾i\ó\ô\"\Ûkt¯\'\ô\r»\Ù\ÜÁ•3D•\äe©ˆÖ žZ•\Ñ†\0\èÈ©\áªI~¨”î‰¹±»Q:\ì\÷r\\&\ö‡\àr7\Õ\ÅÊ°Š§ú˜\ò±_\ö\r\Ü\î\Ñ1\è\ïØ„²~!\é~Nž‡û8þ\Ä\ä4Â¯—±v^GˆsQÏ¨%ºm­\Â3+ žS\ð¸-œ¿b\ÄxxbFä¼…yÁ|˜¾Ø”_„D­\Ëì †f\ó\Éq×™\Ìg‰‰\É0\ò;\ØrØ›¥\ìez=C˜\Í.Nù”p\Épª\'Ä³\äKX\Þ_B\è‡-±V±\âJ›yÑŒ\ï\è\Í;Pc\Ñ<\Ç\Ïa¨U\ï‚\î“\Z)*\æœ7“W$x}Œe\çÈšG\ÓO\ØyR\Ê@R´Mpr\é®_&\õC\r\Ä\í\Ü^ »q\"K²,³…ù/d\ò-4\\ú%6\ÓR\ðZ4˜Ô²e#\áh§ü\Z\'*j\ö!\Ïd\ÙycoCCV\í%s\è?Zp\á”\óÀÒ†½‰§_²`M=Q,~J\È\\©—žˆf•·\ó\Ø\ô\Ö`“¨\óœÿ\0\ÞYœY‚¢Ý­\Ó’ˆDIxƒÒžZ\ä\ÆV\ç-\ðg$”Ï–I”œ\ðC×ž\ËÁ\Æ+g°›£y¬YW	Ü…{û¦ø\Îs¢p^\Ó$7sº`\ñ‰\ð]„•:±r~qq—_‚˜{&o\Ë\Êu	pL;¡’yÎŠ\ò\Z&\à\íX\îÑ¬\ñ\ÈÅDAŠyŒ\Þ\núµ±;\Ê7\åN$Z­3±<\Ò[\ò>Ò¶û\n\ïkË¿Ðžwy!ÿ\0¥0ªzc\Í+ÿ\0Ó´j/\÷.I`FI“mpDl\Ú[\ã”5_\'©r5­\çq\ôd\Ûa\'¥JcÀ\÷w‚[6j\ã\áw\às>\Ø\à6ÿ\0¤\Ú=Zl¯=„\Ñ¿B.O<²V²\Í)¹q½Ë·þSRÁ\ö\nW¿X\ÑlÌª›09?n†«?b\Ò\Ö\Ä\êoÿ\0F©9Kx7l±*Lÿ\0&„TŸa‹<hûû9\Ûgf¦\ÅxW`ì·‡¤*s.Ûˆ\îC\ë|$\Û\Ù‡\'U˜“oY¹G5\r¦\ë?\Ù)I{L\çd„Œn‹,~	}£mT§e±5›Á\'É©QºÚ‘j­Ç¤$J›\çC•\n•\ð^-_t°\ïý\æ08W`™\Å\ÈJ\ôF\ÜQm\â$X\Â]m\re7}§y*%±^”ø°hL»‰ù\r,\èt‘«+\ö˜‰LLŠíŒ•z3¼‘\Æv ©\ÍýC±§e-<<^\ã$\ñ\è‚X4¼\n‹\î\Âž‹¸\ÍÂ’jƒ`—a2\naa\Ó3›Ó²\Z³$\r’g²i¡R\Óc^L¤ˆ\êÁ£\È2\Õ6ªmOÁH¶ª¾\Î\ï\ìI&\×û*\Ö\ÂÀ\ÒF”\óÀƒ\ólG“ÿ\0*+#L»’i9œIp\É\ÈÛ«\ìpµ\ò,“ú\É\Ç\ËF2\Ñ*ªJ\òF¬.\ò-´µ­\ZÀ\â\r¢£v\çŸ%!”¿\Ùj\á\ÎÐ¸›+Tk€z‚†]	9±1·•û0\ö\ñGSñŠ˜«\ØH\ò\ó\ÂšZJ&³\ÛJ\ÖZ†œ8Ievg81\ÜÌ»\Ñ\rmü\"\Îw¾Dk\ò0\ã/\Å\ë†ßËª“»ÐŸ#\Z#dm0ù\Ä\Õ\æ’\ä\ò2	Swh\ê/\\ª?#B&\î	mYg*(up\Ü!\ØQF\Õ\ð3Cü/\ì7\Ý-x¢\Ù\æ¡\Ëg`JÀ\õš„ü! c\ö;\ç)¦\ñD\Ò\ñC\Ùma\Ë\ãÌƒhk\ÞL\×\ìUµ\ê`\Z\Ð\ñ–\ËFr¢\àƒ+Ž\Ë\\\Z\äz\ÚG”Ž¶°;…\ä:Jø\ì\Åþb\ò88O\ØÄ›K¶9¦d»œë­}\É.Ÿc“›üux6ÁjÑ…v[-£!¨RF\é».\Þ¥A\ìÃ¤\î`™–š\Ç#Cp»1C\Z²G¯–+6µ2\ã\àsxnÃ²É\ò#g–b\è\ïž\ç‰O½³qi¡¥\ß\ö)Ü¼\nAnP²¹)É½16Ev‚2\ã9úÖ¦­³\Ì\Ûy§\n\n„d‰[¶…\rú\"•\ö[#\Ó,T8À\ö¤[\ÇD›G˜^g<$13e«ÉŠ×Œ\ÖÆœ\Â’6ý‡\ÛØ‰&»\ÃÐ•¬\Ó\Z\õxÕ¬XHI5—(q»Iw>LL\ç,uCZÝ¸ÁM#w€‡\ÉA%*žs\ô%\Ûp-4Ž\àù%¹™\ä\Ò\×=Š0š{Ü´o>HŠ\Ô\ÜC~\r(\Ò\Þ²›*Ÿ±¸iq§³r\ô‘	eR5\ì“IFš‹Á-\n\ó\äÀW.y®\ä@\ÏcÀ16\'\ÎF\ò15i¶  \ÛXà«…HønKqr?\Ó\àxþ…½\Öÿ\0Fª\Ú%±½\á#ý‰^y,Üˆ¯qdj0¯£»©¥Àû.\êM\í7ù.\ã\Äw\ð›\"\Ïf’™‹Ê»Á•\Ó[\ZÇ£{Á\Ê\ßø)L\Zd¶¹\Ï\èÙ±\\7Œ\"¸¿\Ã6–Zû7K#\ß7\òK2š\ä©L\ru(Ke¢aù3¥¿†\È\ÜW“$XX)‡!\ð¥þD\å†\ó´*^²4¨›\ãl¥•\ñ¸\ZlµªJ’\Í\Z\rùV\àPL•\ë¹UA¦==+y3¾à­°\ä–Ä>C\\²WcfšTSÍ¶n\r«\ïCˆVQž™j\æý‰ÒŽ\Í\Ê\är¬µuSÁ´»˜\Ã\íªb\Ó\éw¡$Þ‚meŒWG\ìW\r;e\Â}»…‡n–M[$¿UZ\é\ö&°gÀÒ¨\êjDŒƒIK¸N\'!\öjm\ã‘Å¤jþn²c\Ìv‚\ãoÈ‡\Ð!#l×‘j\âÁ9.R¸\õJ:WŽ\òi,C_D#\ñÁ.20VœSpIT›\Zø·\ÏgþL\â\á™i\äV\ÖC$\àd[‰½\ô9—lrm¬#\÷É…\\§¢¶\ÓVb\ò+E\ä\Ù\Ö4Ö˜ÄµÈ™\ÄRe‹9[\ô\"{MË‚\n¨»\"\ö1”$±\à[p´\È\rZD\ç\ïP…Š«=\Äy¸O\ì\ÖE[K‰U%nLH\óŽ{\â&0\í?šX!¾RMÁ(n\ËFÀ\ñQÁ\Ý\ÍSdnªT\ò\és\ÒC’B!\çh¿%\è¬\ä\ÌID\ÔM½™—Ð¥F—/Àªµrüœ£‘\0´]\'‡q\Òw\Þ\r¹ƒf˜ƒh› \Û6·°Ž†¶šdI\æ>7\ra²bŽ‹W½w0$“\ðv\ÙÃº—X\ìØ‰¿b\òf\ô³\Âcqv=‹}š._\ìh–p\"\öo\Ê!\îE¹‘\×O¯$\Ú>JÒ¬lBX²6‘\ñý\î\ð†Ý¥Ž\ëv\ì+©±¦\Þ\Zb\ä\Âz´v\r¡®…0Àš@\É¬Y	x&¢‰#ZZ¯\ÑtF\ß\"Ž£ªþ›\"\æV\à~\ê\"J¿\Èu\ëþ„)gþjYÃ´aª7\È\ÞÀ\ãƒ\ëIC\î\Ð\ë\ÂWo\"y\Ú8\ß-B6]\Ú\Ze|‘\Þ\Ô\Ï\ÉQ\Ê\ÞagÙ›Núÿ\0³4\Í\Í\Î\Âe30²M:H\Õ\ë$+Îµ7\àmª´øc)\ÂüX‡mg ™TUÝ¡1Ÿ±²P6“[;>\á«\rQw<‡–+Át8\Óg\ö!¹N\ÅÁˆ˜\Û/I;xŒa\É\ö\ð$“#\ÜTv­\É\Â>‰gƒ\Z\Ï\à\ì¿EaN“h\äx¾G`¬Ž\\¢½\ïÉ¸nª«›\ä¢<\ñ£\äQlW\à›ª–$7‡ª5×•Pž	¬¡.GžHh½¸˜“\ÚF\íj¶bK&L\áI\ßù\ñ™z\äm;h97»Ðƒ\ÎºOF\Í\Ûlce£\â[&û\ö9%)\ßbvt\Ø\ß\ô46ŸH[+\÷,\ÛBWn^G*³BJÿ\0C´I\ò\ì‹À•ú!Ñœ“ûÿ\0\Ñ\×\Í[1\ì\Ñ\Ú\\\í0šS\ö7Kœ>F­¬l\ç#=\ö‹u©\íÆ´]o{\Z\Ö3Yú\èø+#ºÂŒ+ü™º<¿aCnd\ï¸q¥RŠzÓƒ¿\×S:¾\ÎG\n·\Ê\"Ò¿Á‰‘u2b{ƒû?\'#ÎŒ+k\Ä-1Ð¸PC5iF\å\ôts\îvu…ý‰ “w+\ÈÒ­\Óük%\ÂDÚycM\á\Ý\\\Ï?\÷\"pNq\äI¶­v9\Û}-C{@\Ù&šv\Ñ\r\âó½™­§«\Ä5v†Æ©c´ªÄž[Ð—”9ÛB\"?\0û\Ðo…§†\Ær·\Ø&4špD¬IÔ»”‡#V\Ä3\ö?\"ŠXU¢•\0—\Ñ\èøh­»!\äP“&\ê\íH;´\ë\îj	sX\Æu±§&\Ö\Ör‰¹1Û»À\ì£ú€\îH\Ïa\æp\Ûý\n^1ÁUˆ»\Óyr:3\Û\Ú\å\ðfd«\r\\\Î,¡\"[š¬\òØ•I;•d¼‰F\Æø§Ss”I4¼2û!:\ò«oý\ÍÓ¹Z{MNÜ‰\ï¿ý	½—\ð4|­A`\ÚvŒ·K/°\Ù\ä\'Lm˜4go±¶\Ãm¼ª2y|lžºhÐ¨\ó\Â!§²7m1^\ôBÙ½‡D§\í\ì\î6µ‡\Ã\ÜWã«Ži+^\ÅÂ’f¿£eMLy«ž}\ßþŠT¯\Ü-Ô±S\Ùj}\ßato\ë\è\ÂM\Z®\ß\ó\Öm\×~a¯ct¬8-8\Ã\Û*§/ƒW\Ê\rj<z/k>Xj[¾\n$\ì.†\Ð\Ùž\å\"F´\Ð\éDW\ÈÝ•<\Ô\Ú\äD\Å\Ì\äi‘\Ïf&¶\"\Ò\Ø\ÖW\ãb\Ý_`l¸8šýC\Ì9\Ü~\0˜\ð\É$± ”³^\É\\–}\å~£p\é¡5\'&›Kƒ‡Šÿ\0Á•°-\Ó0\è®\Ä}\Âf+iŒ…iT\ðÌ¤K\ßƒIX6\î\öjfux(Ë‚@š+\\r%Š\ö\ò\Ç/O»*B¬‡\ìIƒ\ä\Ã\ÂÑs‘©,Ü”7ˆ’k\Ñ-p9¡T‹†=7\äY‰\Ì\äQ¬2\Ú3\ËT‰œ£\á\ß\"»\Û\ÜEÑ±£H¸!g\Ù\ZC\É\ä\ì“\Ã_±QmiÂ§4\ÚV{lS|1Ê¼Ÿ=\÷j»Ÿei’G|r6	\Ú$Ê«	øLÿ\0’K;š\ÃD\\\ÍgÓ°°Ô˜__èƒŒ!\å	f¼\àiy=´\\Š\Ìi¢±1û\áy(\ì¯Ÿ\È\õ\ä\ì6iG\Ø\ÍþQù€K^BL&~EJ†ûsž.M\ãÁ\Ú_€¼\òä¥´s\äJ\Ädµ¯‰£»2\î\ð%šo(Q8-®¬{D•\Ö\Ø\ÄûY8¤tw\ÍŒ¹\ådD\é\Üþ…“I6¹¡F—…¸iy3™6“´xk­˜j‹†i£¾\nw«#ÅµÄ¤-`°\ÔEûN\Øw–\ÅZ¬\ò®d\Ñ\Îr=yHKÆ‹	¨/Ì†¸·VA\ãÁg\"³®d\È\ëbyw\Ü[R(Ÿ\Z\\2ÿ\0\èFÈ‡/d·§¦°\Å,\ÙT‹9Ã¢šN\ñ\ö]“\ète¥\ï\Èâ²­\õÿ\0A¾Q¯\õ3Xº™\äm\'\ìHV•,\ö¬˜\Ø{›˜\ð»©%|‰ŠÞ¢:\Ò^\\Ò¥“r\×b^„\Ü\è\Ïý\r\Ë\ô$Ø’cDU†~?\Â6¿\Äœ­QRµ]_‚]\õ]¨t–v$´\Ú<\rg<“W‘/\×\ö\'ú;\rø\Ü\ð@\Å\Õv;•\Î]ý‰¶;¿y™%\Í5\Ú8<\Zú’\'ú.‰\á\ÚT\"W\'ÁNH„P\ê$Œ±\Z\ÓB:\ÃÀ†¡\Ô\Ôf ¾I“Z\Ò\÷g9z\Za“m\ï°Û¬\Ú}\ô`q¦¥IG\"\ò`8º,—N¼’\ðß¶\ÓÁ¥\àFJû\"34–\è¶Y\ì„(N@²\â\ãfrk1\ÆZLK´\×\ô‘xW—\à¦Í&\órp\äªy¶Y5\à‰n#œ\å~\Ûa\ÃØ¹\\B\\„­µ\Ý\ì2\'!€i´|28¸JŠS³y%a¡¨Â›\ôÄžI\\\Ò\î!”Û—ù\Îù~Dº´“LRwXk_\Ð\ÍK-5ŽÔ»Ò¢H\ÙT\Í\çÈ®Ù¹\î*†\ÍV\éL\Ýøž;	^ø2FÆ’\r\è\óh>‰\n¾ˆ‘\ÕYrø‡7¶\àüß\Õ-\ÙN9ÿ\0g%®(´\àˆ™\öB\Ù\÷\\—H†S=29«—\Úý±Ž\Ø\Õ¶\Ër¦\å–\Þ>£;\åYEM“o[Üµ\Ó:\×ùr‘YØ•‹\0E\Ør\"\ÆM®þ9¨\å¥\Z8œx{¿ød)@Ëµ²#z(‘†f^&\Ùý‹J®3+/J^?\ï\ì£\älÐº\Õ\äÈˆ–\Ö1\ÈN~?_¢S{_\Ñ>G\ó#2ª°’ý˜NEŸ%\Úc#‹$e…‘P\Ø\ÍbŸ¸\æq\ÃÝ³R\åI|aµÁ¹\Þh„e\ä6‰ \Û\í±,COC,kŽ\n\î®!á—!û	X˜#\ÄY\ôl\âÀ\Ón9-¯hg6\òn\Ûa&l<¶%ˆŠŸ\Ë\Ùjn88\r\×\Ê\ìg\Z\ÝÊ¸\×9\älÛº6o—PD\nq3 ™)g~„¼­\ð´¶`\óXK‘Œ\ë\ZjÀ=˜\Ñ3\ZTMÿ\0\à\à]½v*b\ÊCA´L¹1J[\ðÿ\0\æZ2\áþH\Ð:üÁ\Öøi\èv8·oj}üd¬\ÍQ.ý„w’\ð‡™d0c¬£9Š3xe ¯s~1©p(H\à~\Ò_\ìhe%f¼\ïû!\ÅÁ?\è4\ò,{1\Ö\Ã\å&:Z…‘‰¿4±‹M;Bm´L-:¡¤l\'‡pÛ‡JD\ò#\ô¶ûT>Y&kÀ”†q\í\n\ÔN)\÷\ægdÿ\0¾\ÑÀ\'\á\ðAT\ñk\ãc+—\èsgé˜g\çŸ\Õ\ZC\ÍY¯\Ð\ì[\ïÿ\0#<2e.Yvwÿ\0K*\Ç.DY¦±qJ©Yp†¾;F\óª<…Á}gG\ÄBY?“\à%^ø‘+°Ò‰*{YA\Ø\Ë-ùÁM/0\Ñz:\Ó\ì\"J\â„XX>FÍ³J³‚RJiM#j]Œ[\"3T{\É¦`\Æ\÷f\ád[6¸®f‹o¤c%Qpe›‡”°xOc\Ó\\±m\\¶}8U\ö–\Ñy\Â\æ×”†¥›Kûb\Ü\Ë\Ù	\\2¢ ¸~Jœ\ÇfuË¡\è~ZxÈy«9™\ÂD«Žß³¹K\Ä\ß\ä[¤\×o’H\ô?È¡\á”\ãhD¼\ÒS\ßý”Á6fSYo#;im?\Â6>_\óC\Ñp\É~¹>*»‰\Ë\ècú±E\È_£\õÃ¸\ÍÁEyMyRÿ\0L\ñI\ñ\Çù&,¤]rJ\ÙHW\ð6\î)\Ûuº\Ì\Ö\ÃB\éÿ\01ú\Ã\ìÆ’˜Ÿ\é2u\ÖM\n¯8¿FQ)\ÒX?!\ÂÍ¼–\àê¼¯Ú‰Ž\Òk&+7iCY\Ú?_øl<±\à\ß\î\Ïÿ\Ú\0\0\0\0\0\0+.\Ì\ÚP/z\ÊYi¹\Î=\Ç\n²Jz8\"ÀdG,´†5A‡\n\Ë,<Y£‘i\ç7—¨}ÿ\0®t\ÂZm£\Ør\×*±\n\\\ñ³\è\è7š\ã(bÀ8SY\"Lþ\Þ\Z©\Û\ñ¶\ÞGi?¿Ê‘£,\ák\Å]_¤À-¦M\Ä\Ø\éÄŠ^§\ÊZ\å\Å\Þ\Ú~8\ÎK+šjM„Ô|~š`½\ïM\òQ\É\ÒM´ª,\Û\è|›ý²\Ú\è½þ\Êãž‹;šUsŽS±M³TZYŸ6\Êm ž\n(:\áK\Ëli\ÂH&š\îd¦›#	t™c\Å?$X$’>\Û×›*\ò:\ñ–þ\Ñƒ\Þz\×î£®}\å\ôœm•]\Õ\÷‘\Öjb¯n\÷ï›®«-\ðÍ\Ñož1\ã«\ì„\Ëo\ÞRE|”Q¥HC›¢Š$²‚± ¿\ÏL¼s·~\ÊNü\ê\É\Ãt	\Ý}e\×u„T’¯Nº^Z\åOy\÷‡}\ókŽ ¼„\Óý\éQ4}\Ä,’û7\ó0‚iCH±\ÛÎŸ]Np\Æþ©ÿ\0t\Ä€o“\ÄpJ3Nw\ãž\Ó\Óm¦> ±,\÷=e\\£&[Ïž†&n,\Ú€&Ám-?\ö™- p@€\Éj\ã=p¦ê¡„\0\ïŽa\0\ä\Z\÷\ï\÷\÷\Ï\Ú\Û N0‘×Œ0\Ã8b\n2T9\×q¬Â¢›À\ÇRE^±E\Õ=\ñ\Ç ¬!\Ò\Â^TW]7\í\÷\ÖL_¥Â¸©ûfQZ\è­²þ\÷\×\ÏyŸwDŽ\n\íû­\Ï\Í\Ç\çO8\ðŠ²O\ò)+ž\Ì* ]0”\Û|’û[¤ˆhªH½´/u\ò\ê‚¿ŸA„\Z\Å~ø‚:ïª»z¢\î-†Š\ë5\ê±É£\Ê\ò„½ù\ÄP©¿¤ý¸\Îø\Øgk\ë¨EE\ñ½p\è‹\\@\é\é­˜¦=-\"&Ÿqzƒ\ñeƒ\×a”þ}b„~Á\ðÃ—\ån(\ÅP\×\Üø\ó\çši\ÏÜ¡m6\Ð2\ÐA\ÔÂ¡\Ú\0—rž¯<\Ä$\í4oº()\Ï\ð«\Õ15r\ÃE‘\ãl\ØzTZJ­\Ìa\Å\á¼\ã3ˆ)\Ók\Z®\æv,³[¸\Æ\Ø\ô\ï¨+\r6I\ç™1\Øp#\Ú<£Œˆ©\Ð(\ãF½\ïø\ç/ši\öµ\íN¸¾¹óµ”Œ~\ã&\Ñ\ñµg\ZCiYn¾¬°\Û;k¢l\âE¦ˆˆ\Üµ¡ùwø.G==Ÿ‘\Õ	8¸\ç¦\Ûx\÷HrªÙ©Š>]¯Ë‹u&K[Ámnt\r‰p¤]‘dD‚\Ù\"‚o¦Žû¯ª‚&YÂ¼6Yœ¬ ¶G¤j¦£@´l7J@ ¢Š\"ºi¬Ž;c\Ç–\ãa\â	Àr\ì\äŠQ\åV0…<–[u\ó\0\ÙdŠeži­³\Þm\Ìlþ\ç…\Él\0³—]Œü“\ôˆJETS“a\Öz —\ó\á6<ù\Ð\òž(§·Ÿ\'\ë\ðR\ç\"}&A2\Ãÿ\0\ÆW\Ü2\é%C\ð_\Ûv¹½NW\÷¡‰\ï\ë\n\Îx4}m¿\÷þy£\Ý\ó\íÕ¹K_%­\r©%Nz:\Ä\êJ\ô—\ï°\ÒvCx–üpÎ–}˜‡\í—\ÔqC¢\Èµ·|/c·B&>D,\"±:;gŽ\êp\Ê<û—oRO`]P\Ç\Õ\Â\àÿ\0½Ÿ\Öø)§\Õg^\Â*z‚Q\Ã\Ñjg}ùcU;˜€£ù—š/•»\Ò\è¨\ï·{\ð®\ó\îNoeV¦„T]Î°UœOo^ª\á1›„\ÚÖ¿`wLc\ÌNwSÎ¯\ÞF\Ô}øy\ëMRit1°·\éZ¢2‰%\Ò\ç	a•Ž¼\\\ïb¾U\ájA4L;ž\Ø>i}\áxú,æ’ª\Ò\è“;q7\ï —¼\Ìlm,/‡™»`C\ÞMÅSÇ‹¨Œ4/1ž]\Êg\è6\ØÃ·hG½\é+\ë²\\0–\Ë$+\ï (\Ô.¿š\óW\Þl\î\ö¬]\n€x—·d¬E\Ñ\á3izB„°\Ð;·#j\æ!Ž[5±\Ñ\É\ä~ˆ4.d™®¥a‘¿…\Zr¬ˆKŽ\Â,\â\nB»c€f¼m±f\ïŒ(‘qý`\õ-\ÖiwU{¦¤­j¾yª\Ò\àÚ›Fiù\Î$€ƒ\ë«0@›¯Y¦ýßŽŠù<\ô’ReŸQm’ø+±v=Š—\è\Æ)X.WÀü\è5R\ñ \÷d]®H\'³ë©¢ºv§Jä½žža½+=g\÷œ\ã;\Û**Àû\\©U™\"Y\íº)pŽ\Û-†-ucœî±Ÿ¯\âƒU\òNS©”•ŒÂ„š¡\ìŸ8\é\àš+\ã‚:m»	\È}\ÚS€(±4\ã·\Þb\ÖS\å3‹\Ü\ÉJ®Ü­\"»¬†¹¬š\ô \Â8RqÛ¯eý:x¸×¤7w†\Ã{®X 7,¢Â«ž\Ûb¶\ëiþ\ç\Û\ÚW¤\ç3mV0½u\ÇP\nuq\ã‘\n>	šPvÀgP±r\Çù¢—»\0gžA˜^‘‰\öø\Êiu¶\É)\ÍÐ·\0ùBd\ïI*Ûnq\Ð\â\ö\nX\ß NÖª\ç	ûÆ«Œ‚\ë²|Ÿ\ê\÷&	rQB\0°M¸˜\êh0)\Ì:þN\ën\ê\äþC5\Üü™\ë\Ó52EJ[7\èV¶´:kF0\nPI`‰ž-+›`NÀø2\Ã\àc3ò¼«¨¬pµu¤Õ¥®K\Ð‚\òjdw\ã2y\ôD×ƒ<\\¦¿6C‘ÿ\0!\ìGR‡T!¥û¶2bƒndŽ}[~„­\à\ØùC4\Èr#cN$\æo„— ¶F\Z\á‹\ñ’\ö[\ÚO|\à…\ÉýÂ±›`“\ç@d¼\ÉH\ê¢\Ë†\ç¥Ä²M\ÆG\0–ªFÊ‘4kI\Ò\äa¡‡MT´—¦­8&€‰\Üv—š¾\Ä\àpª~h¾û\ÔÛ¡\Ó\È$}aAS&Ã¸ª8<V²j¤\õx\àLZ—3o·\á†1I½œ?\ÅK\Ôv¨Bf%w\á\ñ\ó@Œ†ue»f4cÕ¢Ë–-\Ð\èGtÁs~`\óº\äg	Gžn¨N¹\ß\Ët\à\Óÿ\0…0\ÜTW®H‰\Ç@\ö0Ÿ}\Ðz?Ã„7¿†ƒ‹È u\àú!ø8#ÿ\Ä\0\"\0\0\0\0\0\0\0\0\0!1 A0@PQaq`ÿ\Ú\0?üû\ë\ì¿\È_¤¼\Éu}5\ò¡}Uø\nOÁ¿~u}…\ó_øeÿ\0T¾U\ò\ßÄ¼_€˜›>Œü\ì\')JR—.R”¥\ÊR”¥)D\òü3\'\ðž+é­‚D&41,˜\×\ßX…\ç<^_¾;\ç13Ð™Ø—\Û\Ã\ô\r„ùL˜–2Œ&Q\áv‹/(HB”¹F¿<É‰	k_¢L¬\äL\î$DaÁ	2	cc\n¼lo\í&b_bE\ÖpQ\r–‰Œ\\1[)Š{CI5\ö1\'²Cp¥.$R‰—*.\'\ñ\ìj}…\ñ\"ÂœøA8\\\\o\ìL$B›ž3!2k\ë\\CB	\ô†\Ç-„\óYD!\ì(\ÈA\"2Š(Ÿ¢„\ì­av6‘\Å\ó/È±‘\"\"^5\rp\Ãfr!15®<Ÿ\Õl©cs²Î±\ÉŽ2		xQ¼Wù3e)+!5L¥\Ô\Ù\ç>N†Ç“#!2b^K^·\âü_\È\Ç&pvtR¼˜±²\ä!À\Ù~µ\Æ\×Hnü+ÄˆB	Œo\æ/^\r—.\Â¥)q1ø%«üK\ÍxI›þ—\Ö\\‚BGE\Ç\à„O|3\Ïü\"KÁj\Z\Ä\òS\È1\ä\×\ñ¥À\ñ”™JO(P\ÓX±b(\Ä-y~-¨¢\'\ì„)\ÙˆLº™cŒx\Þ=£Bk\'\ì™	\ðy6”A1¡<c.\'\ðß‹	Ï‡Gú_£B\ào\àS“Œº²f9\è¢\ò_bŒ¨¹<o‚\ð~\ã¿E9\ÈBy¤>5Ÿ^\ä\ÈBƒD\'‚Î¼1ø?¥ˆ%\äˆA\rx\'\ä\ßÛš—¼™|Î„„‰”lZ¶l\ÄO\à¹\ìƒ\Æ\Ë\óP˜¡0Š0O¢Lo\'‹eË”\÷“\ñ|1²·‰‚b\ÄBQ¡o.-\ìyH%\ì\\‰C\Ù\ï;%\Z\Ú(J4B\ã9:9bTq\r’\ã„T\'¤R”&¯\Ù\ß9j9\ìÿ\0	ˆLN\ôF‹\à\Ë\n2z ÿ\0…)Àa3¶6—E\Ãe0‚¥˜¥E¢\'øu	6&…\Ø\Ùø\öH6[¶³œ§X\Ú\õŠ\Æùdâ‹±Áºz&2øA,HrQ2„ß£–O\Ñ\Ö]‚)D \Û\ôX¡a}‹‘ŒX\Ê=¥ \Å\Ùý\ôyH$>6‚\éa\Ë\ÄBú]k¥\â/˜œ(\ÙýÄ‡”ƒS†wœ”8\ð€ÔœŒXÿ\0c%gCè¿¬·(N\õ\ë:è´ƒ:8ÿ\0yþp\"sYSmtHQ~²\â=‘\ðu‰”\àn¢\çE\Å\Â(“\Ø\ÙÀ‘\ë\'¼C~„¬ƒ,\ÅÊŒŒ¡\ò%ga\÷”\åŸ\Âú%\ï¸=\n\"“)F4\ô—Zžp|œ<‘—‘7\Ø\Û!\ÒAµŒ\ìk>O\ØGcO9Oƒ²w²·ˆ\á—:t\é6\Î\ÏbU“ž\è•GIPù\n\Ç:CÅ¬~\éû¹ \ÏU\öz\ã=‹hžpSŒ|ø\÷\Öv>+¤:3\ö¢\\Rq\á\ì\ìþ\r\Õý?¢~†ý„×±:Æ§\ö#\Þ.±²\é¡ç£°…„z\ÇCŠ/]3 øK\ô.Å¢‘\è\ö\ÎV\ã\Ä%\Üÿ\Ä\0#\0\0\0\0\0\0\0\0!1A@Q 0aqP`pÿ\Ú\0?ÿ\0\ÖOü ÿ\0®gýy³\ö¿\ðú_øŒ³\ã\ïù9\ð·\ò\Ûm¶ß…¾6\ßÝŸ¯m·\ö\í¿†\Ûo\è\Ûmý`2\Ï&Yg†Ye–Ya\á–xg´¸´´Ž|m¶þüÏ‚ø[m¶\ß2ø\Ûmý‡\Âx\ò\Ïç¿£,‹r[<\ç\è\ì}\Û#\Û\'\Õ\ôø\î\nO\í\Ú[o…\ó‘È™g\ä;\ìLúi2\ìX\ì 9„u+\Û:·\ê^\Ñp|\"\ßÀn\ì\Û%\ïg³:\Ý\Ã\"\ò¾(<z\ñ$¹1%«¸|=ü·/c}B\î]‚À¶eŒxO9¦(¶Høýû}eØ²\Û\á¾	rÝ´%_\'R\ì9nÝ¬2w,|}¶\Ì\ß!j~’\ó\ãŸr½\\»\ð?	¾\ñ\á\ò1\ð9(9·\âW©V cÈ²\Ë\'\È\å\ËŽC%}²3‚[«qHL\ðù\"m\ð1ra\Ç\Ç\ç-\à‡q\â&­[·\õ/$Z¿\ÔLv”‰d\í±\Ì+\'~@^\ãa –,X™³û>¯\ñ#?I+­»6\ÊK\ã\ä\å»i$9“\êT»›e±\é¶\õi\âý¥\éu°ûŒ–Áds\á?ŠÞ­FŸ¤¾\åz|OIii¸Iqo\Õ\Ér€€\ð;ø\ïÁ0œ²¡¶­°›m\ÂÀe\Ë>\ï\òf-±\Í<\æü;ƒ\ó?Rl\æl›Õ¡\Ý\Ü9\êX\ñm:Á%x.\ñ/\ÔA\÷\àHD8ü7\õo\è$\Ì»ˆB_qz²G« ˜ø_KS¯pY!‘g\ñ¹\ðÀ\õ&K\á¶S¯][í€–[f4\Èø\0y1s©\Ö\r»ye\ÆF½A9œø\é.øl\ØÕ™Õ‡;l¢/“aý[ùqX-\÷8ø\rœ:µa\îÜY°Y\à\æB~1u\ð5>;“À\Ã\àýÁ‘\ÇdY¼X;¹q\"\÷Lwdá°±\Þ-ï°Œ6¤.\å®\àºI>ý\é-mz,}À\Û¹\år\ê=›O\Ë-±Ì’Tl\æ\÷“\ÉGBÃˆ\"I<\à±:™§©\ßp}G\Ôi²G./³:\Ù\ãn>:u\ß$Þ˜/w4A>¥½Y°}\Þ\à\ÈVg*\ã\Õ\ÛÍ¾‰sÀ‹\'¨>¼\Zu¹\Ç\Æ²nXÃ–Ó¹oÿ\0lKN¬^ü+’vý¼Y9\Ô1B\Èo\äs\0»X_Å»g9\àxR›K\àHGQ\ñ²SÔ¯¹M¥±\ân\ôµ`\Ø¨\ñJ\ÚD|]-}±ž¥mû„{³\ë\Ä_^-9\ð7»2\È…\Ê<\Ðd¡øºs\êZl_md\ò)?{\à¹˜sž\0ø\Ä2\ê&ÿ\0l…q\á&A±|M´“\í´\ÏnA®pl\×\Ä\É\ç©\Ù,\Þîµ‘\ÇÇ¨ ‚\êG¶K\Ü\ËûA\êD¾‰\ëLj\ÛÅ¶s\ÇvA™1Á¡f\Üú¸I\'ƒ¸9\â\é\â?4²}ÀuÏ„\á·.ƒ›p\ó9\Ñl2^-X´\ðÙž0ƒ/\â?±²Þ¤\æ8\ê^|#\Æyg– ^c—[Þ²;l\÷~\ï«zrÅ»\ð_©6S\Ü\ÇS\öYvqc¶x2\\•¶\ó&N§0\Ù\Ä\Ø\ç‹I}›>¤e°\ó\á¡k\ê=›\ìK’\'\íœ3\öÉ¶sË«D[\ß\å›\â¹Å¼s`\\\æø;\áŽ~¥=\Ê\ñ\0á±¼\Üû°\\£g\Üÿ\0N6/0}‘\â8™\å†úÎ¯1\ÊþF\É\Ý\×W+’\Ý,\É\Ø\çÝ‰¤\ïQ\ØÅ¨\ë\Ü\æÁ¼–¶O\Ô·™˜Y0m™Í³ÉŸV¶\Ô\öm¸\á>‰p#¬c\âS‹TzO\ò \È\ÖUµaq\ê^xŽ9\ã}\ÂF{„RÛ¬ƒ©\å©acx—y³lú’\ßfø2\Ì\î\ÞvÝ½Á±ƒd\õ’N.“\"\È2@a>–q–cYú[Œ\ï˜e`û¸%—ŒŽ%\õc\î0e\âÄÁj–[\Æ\ßR\Ë\Ür‚sc¸Ž\\Ü™\Zq„ƒ‚\Þrcc\ê\à\î?¶i\Å\ÄÉ™‡lZNc‰d\Ç71½\Ø{\\eŸR,Ì’\è—Ü½Nø_¨Åœs{<tlv,v¸\õk:a	n2¾\ï\êÃ»’?²Q\Ôg¹\ç}Ä«\â¸,a\';<:BJu!f9–s­Û‹{žc\'”5¬¦\ó\Ô\á\É\ÄF£s,ao].œ\÷wÄ‰\Ü\ñÝ®\à”\Ü-.X\åÀ\ävsg\Õ\×q{\âË‘<^\ä%Ç©A\ãÁ¤\ó†f\àÙ¤6lp²ÿ\0,[“’V\Ü \ÖI\ÔÌ¡\ÛP\ãc<\Ú<°†\âW\\\Ú\å¦\æ\Ü!Ô‡•—^,\ç‰-\Æ\Æ\É(3¾%\÷\r \Îì¸·`\Ô\'¡\'#W\\\Â5Ü™\ZÀ$\ðr\Ü\ô“\î\ã¯\0±\êv\×B¸\Ðm€G,¸.\äBq™ž<\Ã:°^l·ay[\ÈH‡I¥ .\rž‹‡KƒKƒ[´7¹Ž8„w>žS\Ì3«\Þ9.\ä¹\É\ëÀo+».vaku’\ñ%\÷\å\Ú\öž“\ÞW\ÕÀ\Í]eÁ\Ï\ì\öµ·X½\Í\æ·ÿ\Ä\0\'\0\0\0\0\0\0!1AQaq‘¡±Á\Ñ\ð\á\ñ ÿ\Ú\0\0?²fFmA­K2r\Ë\ÌY\è\æ.|\Æ9\ÉP3\æ8š˜\÷—s\ó\ó¯\âLD«Œž!oY\Ä\ÇR\Óü\Â\ð\Ê\æLÿ\0\ä‰|\õ\Ë\ä\Ô2\çrø—š¶\Z´¼yƒŒq.¢\ã\åËª\ÝL\Ê<ÌŠ\Î#8—‚·üq8\Û\öƒd[eû%\Òe\ð\ó¼\ÂüG\ëF\r\äÄ¸’­\Ö#UR–\Ås¸¼J½Mu¦\Ä<}Ë§¸ªC\ñ4”º\æ-F2Á\ó,\ÔXç‰¬›…ULL\\ƒq/\ÒuÁ6ù›2\Çj\î]•q\Ó\Ô:šfqŒÂ„»\õ‹\ß2¯uÔª.[¸¼sQ]\Ë\ne\çp³¸hhŽ;˜úF\Þ1ü\ÌS3o0j5€\â>\ãÃ©K\ÌT6\Ë*‚¦§R\Ì2\Ú[\÷7\É\âqx\Äw™_³|M±5P\Ë\ÌZúCWŠœ*{\ÍmƒN`üu\ÇÌ»aY\Ìu‡\âbƒq,\æO‰¦r\ð²±U4&ûŒ-üKmü\Ã\Ô\ñ7¨&±< {\Î\"\Ý\Å\îX¥q.^\'3#\Æ8Ž£*#šŒ¢¥S»\æi§Ì ®aŽb«Œ\â\ÅL»l\ôŠ²\èy€¹\á\Êg0³¼A\óolº”l—§·™¶\ï©C1eù‹Á4˜´IY\Ç3\ÚPþ\'\ÕJ¾.5~³pÝ±.3P\æ\õ8+©t\rÁ\Î)eüÂœ\âgC\r¥€\\³¦q\ë\ì\÷úÍ™=a·˜u?‹¬\Å;‹Xf\0¼’†\ö&y†0\Ë\æQ+ƒ\Ìx‚\ÄiÄ¡£0vA¦_5\r³¬\óüb³1\Æ!\Ü+DÎ Fi\Çd\ãÌ´\óž]\ñ4\Þ%j\æžu\Æeä¸¶¹ve†W\r\ïG\ð\ä,\Ï\Ì-Ì§yš2DU}\Ì-fN}¥‘\âd7<c\'˜™Ž\ñ˜”ûüÌ\\@Jz—†uPk˜\î9æ¸”\ÜO˜¿RÁƒ\ñ5~%\âþ\à\0Ô½úC\Õgq»\"–\Ó/\É/3†zjqlÃ«ŠÖ³2Ü²Ø¯dÛ¨­B¥L‚±\æ\\»n-T8—~\Ð[Ü¿x8Š³\Æ\â*¡:]\îE{…weÜ¼C&\à	1yô‡Š‹ø¬‡ª¸&7.°Å©û‹Ì°Ä·76\îTeú\Ç6¬0jØ¼–\Õ^a}|E²¸\î[¹¦Û‰UÍ®pÀ¹w_™c\Ìÿ\0\Õ\Âû\Ü{.o\â&¿P™\Æ`b4…\âw{‰ˆl²¥TN\âM\ñr\ê\ó\ñyf{ŽO^!Š—c\Ð5.\Ì|\Êj{Ä‰Ä¼TPg1_x\à%\Ñ/§3-O^gkžYw\Ì/5(s0˜¸U\Æ\ÑB˜¹Kža\å.Ë…\ï/$[lwD.\ÅÏ*¨«”q¹‘r•>#°\ËÎ¥\Ù\rÂ­Y\èGv`‹´\ê\r9\ÜZnxM(«Šû&¥\ç\Ö^s¶Yþe8(al\Úù—I˜4+\ÅuBAf1ü4\ÅbdŽL²\Ä\È4V3)NOxSŽeÓ›¦h:\'L`‰\ë\Z\àL\ÝF\ÅUq/\Ô\ã’EXEº•Á*Q\Ò\å\÷¸\ë\îe}‘a›\ñ\Zf:\ë<\Ä\ÖeVˆuK\î,\\\Ól\Ñ\Ô\ò–¸µ™O1¾±#\r~¦!¹a™dir\î¯qogq\ÏI§v\æY\r\"\ÛmM<\Ç\ÅÁK`Š\ñ\âüL™\\Š]Åš+­Í¼KqùŠ«‚]\ð§\ð+x\Ï>“n*`°\õ\Þæ“ž\È`\Ä5¹N\á–^\å\ôAj?^ ;Šw\0\ã\Ïs%FngùK\îˆMF’>›˜F¿ˆ½9Ô¿H©f˜Ò¯B\×\ñ\í1\ç‰Áns\Ìc…|\Ã\Ü9”9ƒœ\ñ,Iº¯ˆÁm€9¿Xn¸žŒ®¦ˆ\×<Dd\Ãw˜‹™\Ër\ß2\à”G\áiˆ_œNx–¹Ô¿\îÄ¼Þ¥\Åy\êY\Ãž’‚P0\ò\Ür«£†\áa–\Þùšƒwx”u+µ¤\ó2¸\æ£\ã\ó\ë\ê\æj¨¿3g¯0À\Üß˜U5¹fuD\áp\óPi¾Yk¨\ñ2Û‹\Ã£p©\ÉÌ¾ƒWú‰\á<3“\õn\'ˆŠ»\ÜV\çQy@q\ëÁ\É6®\à\êx`KM\Ù<³‰’`\ö\Ë\öRýc‚¢\Ó.\Î.4\rC\Þ\Å)nb‰[\Ç\ð˜\Ç\âUšŒbcs\Ëø%CYž!ˆ üA\æ,_¨­B\óKw¡BZ\óS+\ÜW\Ò6¼Á¡«yÎ¥\ã#T]\î\r\ê3¸3F¥\á‚\ç¸/q7q»k]\ÅP\ö–s‰eš\ê=¡S¹at\Ëm)\æ\îT7ª‰\Ô\Íb--A\×\ê7‰y\ñ4•¢.\õ11\Ï(Ñ¶`‚\Çˆaþ\ã|b•\ï1\ïZe\ËV\îRV3À°\ó\õ+\Ì:h—œEª¬²\Ð\Çzf“fj\á£,N+^`\ÝJ²\âf\âx\Ïr±Y6\Ï2\á—:•~±„\Æew:”\â\õˆux¸\óÛƒ¢qq™„Á)Ì¦û%0¾ã¸¯G¼V£\n\ç\ó¶\á–\÷/R¥5l\r\ÎH\Ë)—vWM¯Žn_\\E\ñqJ•Š*\Þb½ÿ\0\ì)\Ç/_¥zFÿ\0\Ü\ÆkúžœEiq7‘Á/LÌ»8\"\ã3,‹\ßQœ ªj<qp¡¼\ñOrâ‹¨v\ìY\Ç1eú”‹f §7\r\Ã^*\r°\É3P\Ò\Ç\ÒSÎ¥k\ñ+\Þ_¹UBª&\Â,“\Í\ÊÏ–Y\æ;˜3\Ü\ÑqnR¯\âq\Ï\ñf\ã\ÚyA ¡\Ê ,/¬B\ê™WXjhJ¹¢\ê[\Î\"¼\Ê#Á‚\æ>7û\÷†X\ê*Ö£sŸh\å\ÄvÖ¥f»!—\Æ>&Z®xƒD]Eaz \ñ+cøK(. «‚[E‹xŽuùˆ¦+\æh¸®¼ÎÜ¼b^\×pw\æ\"³D\É\ñ\æ4z\Ë\ö>5©œn]\Õj3\n\ô”hƒç¨Ž\å\õX8©Y\îo\çY\ro¡C‹­B«\×1”\çA‚kùþ\á’\Û\n\Èy\â4b\Ï‹©o \ÄDì·\ßP\nN\"Tvž\ò\âwž`X,=H`\òY‡gy\ñ0\Ô|K»\êm¯h(sF-\ô‹o;»\çP^s\òk0ú©Y\èŒF\â\×H\êa[©Mo\Ä2.ºþ‰\æ ”D«¨2Ì¬Tq\ã†û)~œJx\Ïi¿ˆl\Ì:†\õ™Sqqp”¿PûªŠEïˆ\ñkˆe\Ä1\è¢ 0\Ö*Q]T51^°\É\ËP3¼Kc®jº†^a\Ù\ÝN3:Œp	™\ëü$ä²°sR©›¬\Ë\â cV`\Ï\ðh&]\æzÅŒ\Ç…Œ“\\³wK\ï`k\Ú)º\Ä\Ð~ ¦3Ê¹«R½/ˆ\å\â\'r\\¤4\æh\\¬tÁP5\Üû•ŸhkD\Ï\îlýEG\æYr\ðR\Å\ÜÖ‹ `²d7¸&(‰~‘²\ÝAæ¡†\á—\Ö#“y`\Ò.“/:Î¡‡s“ž \æ\ã\Îr\Ç%²³y¾¢sQ@\Ä*ª‹$z¶f•4”\ÂdÏ‰¶	\Ä.q~\ñ\Ü\Þ Þµ/>awW\Ì®.4\ÑÆ¢½\Í\Ì\åÖš\ÄX=#\õ\Z\ãQs\É.¾&\Ï\êkH<süj\ó·¨0j¢\ä–z\Ã\ÎGMª\ði¿\á|Î…Å±„\\áªŠgˆr_7å«¼\Ä\öÙ·Ÿ\àaþ\ã\Í\Z”ø™\óˆ+]g1\Ë.N\"]NÁxM gz”>\"ü\Ë\Æb»&)\îRu¹\Æ\ãª\ó\Z•ž\êi\Ür&\n\ß\ñm`µ‹œ¥X“¶Z˜\ÌL»¨jú‰}b\\\æ\È-\ÜÈ¢¹|f-8Ü²\'0\Ön&w9C0`\ç0Ð—Eq\ñ<\Å\ë=x—±pœË½A]\rLŽe·¼BÂ¥\äW\òs\â{Á¦¥[žPb.¯?\Îý:†%q7~`\â®m˜7ˆnz›j*\ñ\r;‚\Ý=qm%œ{C\Ï1\ç\ÄgD\à\ñ-\Ì\Ù\Ô^nd³\ÍEÙ•l\ã\õQ,¬n= \ò\î	u3]\ã_Àÿ\02F„@w^‘3m\Ê\Å\ó\ÔG\Ú\Ô¸I\à~f3P­½%\nx5¦:*,fNq‹\Ô\n¸¨Ý±úK\Ã|\Ë\Î!\Íc\ÒX˜—‹+\é\êX—†3\Ô\ÃSJ‹\Ç0^\"\æ`\îe­±¶ —2ú\Ü,3Y7\nyƒƒ©j\\¿©CR\ò\Ã\Ân<£LúsQ\ô\óK\åEE\ÃF\Ûe½C†¬—ž\â\ÅK¬þa£\"ŽS\Ã\â]\Ë\ÕFø\ô‰W=\õ2À×¬4\ì\\EIP/\Òr\Ã\æ[a\ó™w—\óù‰\Ç\'˜a\æd\Ô6\Æ!‰\ÅB’°\Ãsƒ\'\÷6\ä|\Ä\î:%J\Î~ g!]\Ê\Ë|Î”\Ã\å+7/Ü›U\Â;ˆº–¢\Ê\ÃP^¦\ö@ÿ\0\É\ä\Ä\ÌT>°Î žX·/¸U\Ë\ï\æ-´EL\ãuø‹y¶zAº›†\ågpœ“&\ôcùgx—Y©b\Å\Æ&•\ÜV½ \Ù\÷Ä¿˜†\âùƒOP¤\ÆIHcqU{ÀnY\Øb¤\Ì~Ø¹\ÄT·)O0\Ãl/diw\Ì_vekˆ–ªÆæ˜ƒŒ0£/i\æ_2”\ÍË²\Ü\æË†\Ï?fi:©Y`]4@\ò \ÅX5\Üw‡w(u¢_W(§+$«w¹ŒeœL\naÂ“¦H™ÁÔµfjúþqs9½DÆµ1r\ó–\÷\ât—o0[%§qu™q}nQß´Q·\ó0ŒªÄº³ø¼0c‡s\Ìu`\Ô\Ëzˆ.\òJsûŠš/\õ-èŠŸu.­œ€@Ü¯YEq\'™N \àø†j\ñŽ%«Q y\öŠ½Dž\ñÒ¥ªˆÉ–16q‰‚sm\ÜU\à\ñ0¶?\Ü`…^&•S)\Í`˜fk!\æzj0|\ÅTªYTx\â-=J%\ñø–\Ì-\â!\0TØ¢S§™T@&¾ý`5P¡\ÚKP\ÔVï¨¹ƒ‚¢\ã\Ú~9Š1@¨7ýAü\Ã\éüK\î_™xj¾`\÷/Á¬\Ônü\Ë\ï¸ú%\ÐÃ¸´Ä¼zC\æeP¥^`Ž¥†^<D/±~%’†#\é\æ±™À\÷)\Ë(¼\ê™ù˜!¼5Qú•–±*¢\âÙšªX\â\rzÀu‚\ÜJcº€šc„\ê˜–j\êQp¶›e½Ô¬\éˆL\Ôr\æ<L”\Í]üÊ­µ¨†ýbU\â\ÈE;˜\ê\Äß˜˜\Ö#ª\î%w¾eSù…^Lw8‡\õÿ\0Q\Þ*\â)v\Ç\Ò(K\Æw8©µq.\ñ2…Íš\ñ/uVÿ\0j±j\rWþfJe\Ý\Ü\Ý2x¦\r\Ë\ÇU­9Š|\Ç9c¸uü.´Ì´\ÕD¨Zªs&™‹w¬\õ9\'¬´q©x\Ë\ê i˜Ar¨\á¼Â½\áÒ‘§{•ž|C^eœCq\ä]Á§ª\Çp¦’YKº©¬\Ç;ˆ_¨€ÀE\Æ7º—0)¾\÷c–9‹þc3\àX\ä&ýk\æ \ô–\Ð\Ü\Ë\Ì\Ãû•\É\í,Z¹e\ë’<q8\õ*]ø”­.`-\ÜE·W‰{eüÁ­n •\æ^±ˆ\Ø\Ö!¹už:—’ù\ê_)3¶\\¼j-Vg*b«Š†_P\Ù\ÜzŽ¡ø‚\Ë|Å¸Ô¼Á\ìƒUW3‰u]K\Öq\nVq\Ð\ðœˆa7\Þ|Ç®oø\ßR\ïP«<C+\Ôb\ó\Äj³\ÜsÄ¥n^;9\âzn(\ÄÃŠš8Ž…Kyb82LÌ“Ï´u\â,·©sØ±¼\ä\Ô*…Œ]±«\Ò7q¹PýNN\æG—±®f\ZQzŽ\Îe\á¿KŒ¿û\ó\à\ö\çR\Ê\Æ\å\Z¿˜\Ñy\Ï\ÄmX\Ä7Ža\Ãr\ë\É,\ãf–E\ê\072¸¶ZL±\Ì[wX·¹±øˆøšÚª8I\ö\"•u\â\Õ\Ë\æ\È\él¸¾eü°hež²×»žQwŸh=\Ñ¸ºÌ¼pAO¢\Û<Â…\ñ½Y\íƒÔ©\ê]\Ô1W.«PF5ˆ´\Ë·™u¾®X–M\æ\áA˜…11\ßÃŠf\ì}#e5{\ÇØ–‰4u1«Ž;\öþ³=ÌœL7¸U½\Ä\óýÁ¸ˆ‹“\ÌG,Gs\0ß¡\Ö\"´\ánsr\ÕXp`\é¸8P\Z­\Ë\î	Î¥\å\Ìj\î^\÷R	¶¥\â-6Ç›¸²\à!\Êd—Ì¥gS~eHz\Êw®\å)\Ç1\ö1y¸:\Ô2«—\í\â\Zne‰³/<Ey\ÔE¼\ËSBiqQNm—Yu,«\â4orî©—®\æN\î\ñ(9\æS‰w¸>e[\Î\ãc\Ê\ë¨ A^\ê\â\ÍÁ\Æw\Ô[ÁIƒÌ§mF\î\âH½-§´V Ù\\¿-Çž±3b­Q\Ú3\\Áþ!\ö—3m°b\è\Û8$\nù\æo]B\\a•»\ê«x…\ï0pPN\áƒWW/’x…š\â\öO\Ã\Ì\Â\ò\Ëq°þc¤\á‹7ˆ8»\Ô\Û+ŽÙ—ƒ0i\ÊB\ðT^\÷	\ÒrŽ{–u\ß2Ú«—ˆiˆ³\\K½\î`Å³ ­ø\âadX¥\î\áu¹jûb«<\î\à\à‡™Ÿ2\Û?p\Ãm\Ã\nƒsc¯2\àT\Î	’\Ï\Ûr\ïø‡Ÿ–:\Ö\â\àk0;×˜\ð”\îf·\Æýåº—™±¾¡cQU\ÜiU«s#\×Q‰¶\ÌJ0\ÑJ\ÊGye\çc?§ƒ\ëQ\ó\ÔF¡—‰oE\Ã\Âp\ñ\ó\íw\é\ï1y\Ô\õ×´\Ñ\ß\ð\rÀ\ñS«.²\ËW™ƒd\ä\\r®\"¸P…¹†Ž\"³L¹”7\ÑU\ë\Õ\Ä{\Ê`›”\Ý\Í:<Kk˜\ö…0$\×u\r¼Íˆ\'¬Éž\Âs9£r\ó¹Q\ÌW\ë+\ã™\æ;‡F b\áž`o\î_¿™»¬Bÿ\0P\Ã\õ3}[S&Ê†&n”Œ\Ñ]\Ê\Ê%\Þ!•Uº¹ŽsQ\Í\ÌÊ¡‡2˜u©½\Å\ÅW¯¾\õ(»—ˆ—[yšf¾’\î\Ó+\ôr\Í\Ümb\êK½F¦ =¦\Ýú\ÇK\Ô*ûÂ¡W™F¯q\ë\nx;‹e\ó0øœé„›\Ü\õ\Ü1¢¡­\îeˆŽ£§\Ö5\æs˜›\Å\ÄS_2“\Z”\Ë6\ñ6\à¼\Ç&±9¸µ»ŽX—g’ú†¼Â¯S=ng¾¢`Nn%j\\A©…T\ë\ÌK [À­0\Ó\ñ\õ(Y<Ky‡=FŒ¼\â\à‚-.Ø¦y‹Z\Ü2Ï´=‘³yN&Mß´\ÇN#¯B¼¬)3\ÄÏ¤|0(a‡\ÞPoˆbh\îtü„´ŠªÜ¢\óü\î6\Í\Ë–ZV\ó²9\çþ\Ë\öœ7\ë; u‰Ÿ>\óš\ó0´\ã0\òYJ©†]ÇŒ\Ç~\ó;\ïs\É4\Þ*/1\é/L\çk\áø„ª¿PÕ¼Ozn{`jS5“\'|NU^“B\æ5R\ÕX©M\Ã!¿˜§,\Ú?‚\å\Ûw˜\ô\ÃRù7Äº1¸µ\î<n&už™€e²\â[§Ä±˜¡\Ì\Èx•^ù»ŽKX¨Ç¬¼Ä©\Ô\\q6ƒD)¾ah¨e\Ü:0^1pË›‚Ã\î)\Ô,À\æ\æ+p\ä¨Ü˜\Ìÿ\0¸Bš¸\Æq\Í\Ã|Ã³/…f!–¦n[\Ä*R\ñ»™E\÷ª\ñ\ÄjN·¸\Z»f\ðtSˆ\ç\í©X\æo\ç™k\è\ñ£œ\ï\\\Í39<\Ë!S?h&ˆ\á½O=\Ëú\ÌKÔ³lv¶ „\ê\ê^\rÅƒž \Þ\ñ\nJ^\åo›…\ñÔ§8ƒP`¸…®Æ¡\Ý½³\Ö<K¿Iª¢P1ü%;‰\Þ\Ù\ÃýPk\Ìz\Öln¥B]5¸:”0¡Ša†XdU\Ê\á¡s\\C\Ï.\á\ã\â8Õ’\Ý$E\çQ|À\ç™Ò³1\ô™˜†tLJ\áÏ¬Üœij¦·\çÇˆd\ç‰gŸž I¦\áuŒ\õÃ¤/P\ë~¿²U\ÄVø…\Üm\éPz\Ì_\'ˆ±ÿ\0l5l\Ð\ê\"˜\èL\õ(7‰Ž\Ø\æ¦+1\â,\ÌÇœ\Ê\àýÂ„[¯\àwœRxfP\Æ<\Å\ï\âLæˆ´y\î\r¹ü\Ãi|Á9\æiúž\Ï\á\Ê^3/\Ï\ðÿ\0¬¼\îb\âš\â-± \ô”5QN\"\Ë?\ñ2¸—SO\rª\Z\Ó)\ï2\'8\Þ\'“\÷Š\ÌZ\ÎzŠu0\ô@Z‹\Ü}¾\óŸ$v†yü\êo\n6¾±3x\ÍP‰­n/Ô¼xšË˜¼a/\ó68‚¼ne\Ìn\ã\n\r\Ç,k\Ì\Z72\Ý\á\â//\É1]GœÄ©\â~f¤ByK\nœ\Õ\0\Ñ­¡\às[›\î\ê{}a–\á‰)FA…f|\ÊÇ—´Ã–w\n°\Ï\Ì\Ì\ÙL\÷\Ë1¤\å‡\ÂxÃ¬<\âc\ÆüÀ¦\Ék¶müƒ˜ü¢\æ.b–xŽù†c³½\Ã\Ò3Zrï¸”\ç\Ï\ñ\Ä\ö–¸kø–j\î;\æ|b\öFÆ¾#\Zgp’\ì¯$›S©wÄ§\ÖZº†sNni\æ\rsE\Ï\æP\ÅúNŠ\è¼ÎœAËž7p\\® ª\Þ\áþ¨k\Ö»Ÿ\Ôok%k¶l^ex\Â³\Ì*\ô\Åtˆo‰x`£p\à\\+¹\Är\Ìqüv\Ü\Ó\÷Aw\áÕ…\ß@»˜ûB\ä\óa&9œ.g\Û1\Ä\æo/á²¡P\ÕJ\â¦\ÉA\Ö\æ\ó¸¹\Ë.˜\õ\rxš1o–¼\ð\Ë&“\')üO	mEŠp\ê^Xª-pÀz2\óc\îÙýžsI³ž!˜O´·%³yž7< 	\òC¼\â]\òT\ZfG‹Í®<Ô¼9+¶o7TÁ¸~ D\ZE”9ì‰ª¹´\Ù\Z·X—|\Ë \æ[.4\Î%\ê[–>`n•\ëø—\Ü1šw3s¹—Pl¨¦*^«\Ä\\23\Ð\ÏÒ“0Ï¸v©_\çÕ†y†\é;­Gs\â\"\r\\¥\îa\Ì\é\ÄÁ\ê0˜\à\Ì3(&\ï_Á§1\òœ8‡\Ãû\Îe\ÂL8žYë†³\á/‰¤\n‚\ØnV	§˜g¸z&ž˜P\æo\Þ\ç0+Ï¤¥Â›\×eÁ¸5¤\Ì\Ù\êbtÍ³ü6\ÊG2Ÿ\à\åüÞ¹\ê•\îV\'¶¡“{ƒ„žr¸˜b\æfi“‘be.?”\í7„yFw”\Þx\Ì7¡\ë™s2€·1\Ó>\órR\ï¨Ë¶¢{\â\ßs¬\×qS)\Ç9gb\è\Ö\çÄ³†\ç\n\Ì1\Ã²Z\à\Ø|\"¡Sø“¾d¿k¸g\Þgª¤Ù·0¾½<C\Ù	½3½\Ì9¢m6›\Â5\ð–‹É¤\Öw…#\Ö5cœ<ÿ\0‡,\à\ãørþE›\î2ûþxšÀ3\×Q\Æu%±™Z„0AÑ/1\ò™\Ç8ù\â9oøxF>“\ñ…·3€/p¼0\Þ&:…3\Ä-9\n\æ+p`\î\n™dŠú\Ïdµ\ð\\c³üm²%’lO\âq!g.¡›™‡~b\ð\Ã(ž\\\Ìy\â<O«ø¸\Í1-rþ\ðŸN_\ÆÚ”\çùH\ìC\ÊhÌ¼\ò\Â\Þ\ÓH\Éi\Û|L¢Š\Ô\ÌþO\àe0þo=qþ/T\Æ8\Ëw\ZEOT…/\ð\Ûq´coá“¹\æo¸c\ì$¯3.\âX\Ä`-\îg	\Ö{€¾ oup*ªX\âaûŒs%!þ`s\×rÀÁ\çp\áO¹w\no¥h\ôÄ§\n@j\á\Å\ÎÈ•j\Ë˜…\öE\êq/É˜±k\Ö8NU\æs92Ýƒ[™©y‹._\ð$P_ÈžY‡œ\ËL`´s/?\Â\ñ.\\^‰—2±)¹›‚±Yl¹™y¨­F\å£y—˜\Ü\Ìj.\å…\ÖgAˆ†\Én7\å–\Ëa \ê\Ê\æ\Ä\Ña\á9€\äH¥Y\èLLF\\\\\raˆ½	y	CÁeÒ¸\Ã ¸\ê=ƒ\ÅC¯I‘°^ sE\ÉÈ§56‰ŽS\Ó2w(\ñ8‘\Ô]µÄµi—½FN1R\×©mT\n\Å?‡hmüû\Í3<H¡\ÔWýB\Ä1\â08”\Ö	M\Ä\Ä9AB=}K\õ-\Ô-X‹\ÝGEË’ýKu/zŒ+ˆ$º‹E\ê0	\ìC»,\ä‹\änaG‰m¬©j¹–­b8\ê¥Pü\Ç\ÉJGµ=\Ðl\07U1^Q¡?)­¤B¢*Áš\ÅE¦\ï\æ\Î1ˆ©\ô˜bb.‡,[J#/\ÆB€³Y\Ñ\Î\"A\ãùœ)¥\â*®\õZ¨\ì¬LK7Ä©º‡O2³˜B»\ÔKq0.R\â^\":‰\êR\à	\è…\rL½\å\ðb8¼\â\ÙW/\Ô|&\Ój‚Ÿ	\àA\\‘gw¨\ç¨&\Z\Ü0º‡B\çd\Ö\æPÉ‰J\Õ@-­\Êø”& („¥x”=#GJ©Hˆ‚@Ž\ÉN“™‰\Z\Ò\å–cˆLKJ4ø\ÄbqÜ·µ\"\Ô\ãQ\ÎS¦Šø„hSS\ð¨v\\\÷2\ÉÌ£´·$x‡®\Î#r\Ä2g0”xFXÄ¹wpZ/0Ò¶\Ì\Ôf]\0\ÍK/w.\ï%D¼\ß…;\îV:ƒ$¯#•N#UZ‰\Þ\"-¤©w1À11wX‘	bb;\Õ\Çsù†“``ˆ[ŠUÊ® W¸\Z\ÍDl\'5@\\´s&É’9 %.°»¿HC8Q\n¤\æ|\ßÆŽ\êù„\Ý\ÕÃ¼j\"9™™\îw„ne/\ÊuEÌ¦Tø\Ú ¼\ÆÀ\õ3\Ì\0«\É)$m\r¯\è\0©\Ä!™D‡F£\÷WR¡\n\Ñ++\ÊSYs\"\í\\Xn\\9feµ\ÍD1Kž&^UW\n“\Ú\\G}ÌŒ\Ü%\Ð@\÷ˆ‰0Š>’\õ#D\Ðe²ú¾[\æ«\'¨-K™‘–\ÜÀZ\Ì¸…·\ÄqX\Æ\ï2Ø²+8†ûÅ¸¶K)ŒKH\óŠ¸u\ëø<zÃ»\0\×\Z‚6\Ù.‘2\"\ß1yþ{\ÅÅ²‚\îYnX—¿$S\Åw5SŒ\ÆX\Ëpa\Ì@¾Ù`\éR\Õ\n.XQ@^`\rÅG©U4FSs=D„º\Öß¬9Fž\Í\Ì5Ü¯$Bªt\ËT\É2*\r•I½‡†\rF`\æ\Ë\ÌcÂ¯Š˜\è£Q¾\"PÙˆ„T5Q¢Ö¢Wo\áV[›D@\Úb\ÐfX\Z1š¢Ujb!r\ð¬<\Ü%µ1e!\n+ˆ>%-˜UF#WP³0K\ë{\\\çSq0\ÇH-›E\Ü__1Ø—\ê^\å\êcˆŒ©P\ë¢.³xŽ\rKakˆˆSF£•˜\ô‚ U]CB\"4fÓ˜ f Ä›#{ˆzŽ_,½2H:Æ¦°\\q/1LŒAY`¾4C\Ú:Œv=ckÜ¡\ß‘Û¨³•=C™©fTP‚\èr\ÎB\ñl10´À\ïp0\ÝË¶\ïP¿\öb„@k2¦® )\Äb\ÜP[\ëR\ÆÙ¶?Ç…\öÀ{€\Ô	Y…\ß\ïø\Û[škøEÀ{À* Î‰³\Ô0™¦¥ù©œ,\Ç\ÂP\âqšŠ7<%¨S\0EÀ™D”31¬°£\Û\Ôk6‰l˜\0ac\r3(\î\n¼2\ã,ng‚XÉž\ãÒ¨ ¨\ó\æT\Ç1XDsQ\Õh›°ù…6Â¥,\ØxA8q\ÜRû¦\ÖÑ†\Êy?Q·o†k1\óe\ÕG£U0.0`¹Á\Ê@¹`\Ô\çøn1•su\â>\"Ì¸\Ú ®{•ZŽB\ó¸A¶ J!%µ–¡7¤)\Ä2”@\ê \Ä\Ù\Ä\\\0Õ¿yP\Ý\Î3Ö°|À#›´ûCŠ¥C\ð0¾\å\Ã\Ð\É\ï/(l”\'\ç˜&Ø«B\ê„\nÀOXˆ@\á-–ZO\ãq‰w)\ÔEL\ê^\"\Æ^J—¸\æf¡q,ˆç§¤`!”¬k\ÄHº”\ÍW¬ÀU\Ô5\ó/@\Ë\ñ7#Ô®-\õÔƒ\Zˆ4˜:‹\r\æ\æK-,XNY	B\ØtL\Å_ˆŒ¹\Ô5„u(¹\Ûø7ž\ô?‚\Ï\ðr+Á]@¬\Â(\Â|\ÔDm\êƒ\æ0´\ÎÀÁ\Ö¥¥n\0;W|n\à3\í	¿•H·\ÃB-\ê¸C´\Óý™ŽWi¿’|ÄµRÌ€\ò®Š\0Û¯˜¥ÁCëŸ˜€\ÈWt0cÁa\ñÎš?…]\0¹l¿fÉ½4‡p¤\ÊsW)0\Í1*6@\'jÄ³¤LÀÁX›À5r\î/¹lZ—ÿ\0\'¹þQÁhÜ³2¥Ì¥j\î;ZÞ µ¹Q1FúD(¢8ˆ1b\í\\A\n!’¾X\íAˆ–\Ô[7,™””j³‹††-ygK\ÌE\ÊkŠž±“$y\ê\Z\ÓA ¼D50þ\Ê`\æt\Ü$“†ÿ\0€…‰=&þŽþ\Ëû!\ã>i\ïþ‚$Ù¸!~Ü½+\æ,¥lQ\ò\â(nuš\ö\"U\Ã~¥–\Ï&@¾\ï\Ä;nˆ•ÑŒ£FYù\Õc«£o\Äo”\Ü\n¾@û`\Êo®jrC\È\ë,¾[/-ž\å\ÜE\Ë\æ\Ï\á®³OW1^—\é¸f¸A¿;\ÔYv\Þ\÷ä…‡\ö®ß˜M0\Ã?\ÊƒûC\ð2\ó¸½E™Gøf\à\Ô\Z%˜ƒ‰½\â%™iq»ƒv@f¤\r\æ‚mKl3\r\ì+\Ã-X£†0pe»‚¹!\Ñ\nh\0`±•\Z\ñ\Î$\0\Î\à¸¹·2—Že–þ¦˜i©n¥¨“‘þ\î \áØ–\\\é*Š\å(?0{[Àº<\ç~¥Ž\ô1eZ\í_Á@\Ã,\ng\ïY:S\í*Qp\ö\ö…0chJ\è|Ž\ê\Ül~”|¤<\r»º½ÿ\0Qk\\\ÃÀgkˆµ\Ó\Õÿ\0›\òÁ³ùt53\ÈQ\ß1¥[}h3\î\Í\á8º\Û\é)\ÕE\É\ð•,\0ý‚²ýC\é\Òû\óš¼gß¿™dOu«*SÉ‘š\ãQ*o\nºýº®2\É\ÑT\êª)ZÝ–\\¯£¸\n\æ}e†5ü«œ\Ä\åË—†%¿Áa„\Ã<K¹e1+[•)ž\ãVû‹æ¬[\ê#’92{F\ÓEu)Ë¾\åR\Ë%˜b€K[»þ<À5y@b~XšÌ¼kˆ\Û\Úy˜„Cy%f*®R\ØJ>Yx=\0ý\Ì}Á>\Ì>ü\ËP/Uùn|K\Ø>~UË˜>!‘\÷9\Å\× Ÿ¨Ü½[8\Õ	h´n\Ô}}vŸ ^µ”\÷š	Î¨\ã\Í\ï\ê\ro`PN&\\\ÙOx‰­œ_²\â\Ç\È\Ô}\ÌJ6]\\`\æ`v¹\Ã^[ýAQ¥OÔ£G]xÌ¬Jy.¢Aµ©~\ðià¬š¢­­¿P=œú­ª0|C\Ð:€þf\n\Ò`bP£¨\ñEºz\æ)\Ø[˜[–n\\¾Iµ—fK¨»¹r\ØA„¹Ü¼Å©\öŒ\\EÌº\Ä±-§>\ß\ÃÀbB‘)\ÜZ1.ª\ãvv]b\0_Ðƒ\0l”0«%5\æi\÷‚X\Û­pT¢\"\n\ã™e]‘\ÌAY\Ü\Ü\à#o$¹\ÏÁ+Íœ~_ª‰v•·\ó\ÔÄ{\ß\Ä\ö‚¯B\î \ÄD­\ào\ï?ˆWhøøÁ*\Ý.0R}\î$\à&¯F²Ð¸®½­Q1\Ú/š_usW½-\0	Yl~\æ\n¸Q¿kû\ÔG:W\ê®¬\ë³~\ðÑ´qEø?qÆŽS\ê~)\Ø¶/\Ý\í¢¢°\õ41\Îm™‡O\09\Þ_¹p7®J?Þ’¶¢x\Ýª`\n:J\÷Žn[xo\Õeaâ¨”\Ü8\×\Ë\0]¹W½CJ[ª\Ôo\\\ök\Þ9X™\ó|	\ÞA+R\Ø\çD5ü\r\Ã¾ \Ü3_Â—ˆ¤s8Ÿpj.3˜8ƒ\÷0\Ï†!¼\ê\\¹\Ñj²k¹‚š\ÜÐ‘	!JŠj	R”\ÕYJ¹G}\î\ÝúÁD-`\Ú\ß\ÄM`r\\L£\Ó\Äùf	\Ö­\ãk\ì@P\Ó\Ï/þøŽm‘I`;\Í0°\Ò0z¯ü…uÏ…®ÙƒD\È\ò€23¬E\Ö\Å\àO\î)¦\ô\Û\êeQK|n®h%º•0\ÑqÜˆ—~\Ü|Äšx\×	Ÿ(\í‚\"[¿\ÌZ\Â`\î¥0\ß*·©\ßT·§\Ç\÷,1…\ÑZ\í\Îw\à¤»@~R\ê&\ä¬˜v\Û\\B|\Ä.¬ýE\Ýz¾\åJ™ÿ\0¬­z\n&4¥ªŸ-\ã\æQ{6‹²\ÇX\ìËœ%ÿ\0E\'\În/m`.Q¤\×r¶\é¨T•‹$)3\ÔE•0eXis†f\ÂØ—u\rÿ\0\å\î/\ðj	}J4C:…M\ä¼mjn,\çø\0²@\\\æ²\åË¨³˜·¸½\Í%ZG\Ê]\ó/-V¸;‡¹G\ÛQ2É§¾¥šÝ‰_Q\Ä5>?k•	XAÍ¿M\0\ï\Ò#ž]¦W3-“À=\å\ïJA{\à_\Ñ\Ôqu\ðŸ3e\ÎGªÀ\n¯¹;¨|®Ph[Ý•pº\Ð7°?w*@µq*cC›R9_c¸n•tZ±øƒ@\ç€?¿H\ßa¨\óQ\n:³2\ö0s{E\ö^eÅ¦Ì¡W\ï*‘\áÞ«Õt\"e…\îaC_‚Z\Û\Ë_\Ü/#i\àcx\õ\é,Ezf)\\†\ñ\åkqr¡°p\çWˆ±\ÉÊ£>t~\åD\áP:\Þ<A\"`V4\å;ó¨º£UÁ\ò\ÐÓ³\â=\íe)Dì‡\Ü:Ì½\Ã,k¸\ó°=e¦Yc˜¢ƒG¤8K&\óÁ0…¹‹n#«Šœ&\Ë:—‘\ÅÁ};þ&01w™pq2EbŒYEÇ…\Â\Ñq˜\õ‹|Å–šžvbÚª¬k\ê‡3x&3\Î~†¦Û«X\ñ…h\ZÚ¾“%ú\Â\"\ìC½\Ê	e\\Ê¨j€>5¦U\æYˆ7­\Æ\æ\Æ8\ÄÆ \Æ\Õ\Z¶b*^~C\òJ3+’¦Nm\×þ\ÌL\Æle\ô^`ú\Ö2·Ø„ŒÀè€´[\Å\ã\â\ØY@M`qD\Z\ôX\r3:¸e·\Ç\êZ\Ò\ëh}¶\Å\ék\ÄÎ¥z©¬\ï}YŒ!\ß&[aN‹\ÔL[x²Ÿ5¢D.¾Y½‡@a\í¨R\Ì\ÞÍ”žj5\ÙVž\r\Ê[¢øg\Ð \Îü9]a‹¦,1¸K{\'–Z\æÔµ•Vø\ã\â9F\à‚H\Ø\Ëy¸\ÕN\ØÁ.ba¸&®\×\ðIqfØƒsj%«\âZ¥œ¹*·\"\à\ËphÄº\ÌW¤\æu\â\õ‹\Ï\ð\"ù—nT\Ôm3cø\Â\Ì\áÌ½\õ,\áŽ\r\\º`mEq\ÌQs\Ìÿ\0T\n\ÉÕ—\à\î#\ÚÜ·Öˆ£AÖ¦A0\ÆZ\Ä`©\æÍ¥Ù®32aEh™\n\ÇMT?pª®ÿ\0\òd\0Œ¸–p¦KV\0l‡›üwBr•.\ÐVøþ€À=e\Ì\È4þ“F ®\Z–\Üo 	V\'	WQ¨¬\ê¦]Áªd<\ÄÁ••\öW›ýÀ}û\È6—¢¿D-€´>5ë¨”%\ó“\Èf)À\nXÖ‹—t¼‰Ÿo\î!Â\÷-s§·1r³\Ù*¦y\î\ÝBˆ\Å7ý\ñiLZ§¶eS‘o«˜$<^Á\Ý•h²˜L	“J¹´R\ÖF \æT\æB¥\Z˜M%ü\Ë{›AƒR\Èøb>B`GzÇ˜¹â¡Ÿ\Ä2¹{\ó\Ì\Ò\n§ú#\ç\ñü>\á¡¬\Ëd…!Ž\ó›&ŽcS1Í¨\Ùn^!.M\Zù„9S)\Z¯r%vG¬=\âÐ¦ø¸Ü®u(Éª9”»ÿ\0\Ô\r«fJº/™m\0\öX¼\Ñ\Ä\ÊÁ“…j%\Â\î\Ä•T\Ý?\ö\ãCy¥<ÄŽ¬\Ûý\Â\æØº²‡¬4\ÇJŠ¿\êx24q\ê\ñ+5Ô Beƒ E{¦’\×\æ=£²\õ«¾X­²sþ/\ñ5ŒºWÛ—\Þ,ª\õ,°Æ‹~¥%\ä\õ­Â¥Æ¥Pj¯D\Ño@\ÄÀUƒkXV\à\ñ\æ±,[‡[|E\ÅR£\é\÷…ŒUE§n¥/•.v†\Åa\Z¥aHf-\Ðo%ë¸°¸E\Ð\õ\ä€TË¿2°\õ.TTÒ¿\×\õ+Sˆ\Ó(3I)^!PqK\ïqþ/;šWy–\Ów\â-\Æ\×Ô°Ìº\Þg\Ê,Ëªƒœ\Æœ\Ã\Ë1¼jÎ•\ñ6\ÆŠq{\Ì>1¾£•D‘Æª¬W<ýÄ…0\ì\Ô\äh\èn6PPB¼—\Ó, @GS*\Ö\ï–rUt¯\"Ž\÷\\\Ëf—u\r¢“\ÍY\ó@\öS,º\r1\ÂU\Z²›– y¶\ë>7†ƒ\÷¯\õ\ËúK\ËU\åý@\ÕX0b½‚\â\Æ_o›”…X\ñ*€qÀº\ó«“	\\CºÙ–ŸxH Q\ËwÇ˜ˆ‹E\ÅûBØŽš\Ì[©\ÇQ\î\É\É\Î\ê‰g“‹TY\ÊVs*\Ê\0qœB¼Õ‡l—‰|\ä=3Av—¨Œ©^\Õ¶ƒ\ËQ¾7X—Qj\ä£ƒw¶X\àZ…\r©¡‰Ñš–`Ì­€  {‡CÀ³¼E5,\å‡_À½\Ã!=\àÏ´¼b	™©u\æm*ù—Œ\ÏHµ‰\Æaç™‘\æ\r\Ë?ƒOI´\Ý.{ \çq„y˜oøº\Ä\ÝG‡\ðH7^}ˆO	Áj\ö\çu˜#(\ô\Æ,\é\òKm‡\ÊÍ 9\á¸oiPK•<dW«Ì®\ÇšeS%—wR\ÑLv	pm\î\â\éQa·\ê:«i]­Møž«,\öGí–ª¡\ÃB£l)\Ãþ\ö‡I½€c\Ú\0\n¥\Ç(\n\ã3³\Ý\å\÷eµ¦X\Üa=kÿ\0#\ëx\õ˜ú­-´k›\îw[\Ñ\Ô\È[_2\Ó$£·pX«\Æp\\°P\ã,½P½5-\'¼(lùKˆ\\º-Š—9T½ŒÞ¯1+\Þ\îË«\ÜPÀ—¬J\Æ\ôó¹¨‡°¿\ÌT¶˜H¶`9²b\ê6¡lXD¸‰¼ÂŒ@ !Œ\Â\ÓL\Ë\ñ/©r\ö\ïUPq™§™¸e˜“’‰\é4\Ä]ÆŽ\ZŠ+{‹8Š¥¾*6|ÁF/‰ÀƒÔ¶\ñü6¼\ê0¼\Å\ÜÀ¶-\Ê\Ç\ÇÓ¹²>\â<‚\ó2³–?\ð‹DP\õ²d\"­z\Ë\ì\×þÁz¡\Ý\ó\÷@\ñ‹sPø..±\Z.\Ä\É\÷\êg,›\Ï\óuª@\Í{û„\ìýÆ£Q@qXv\é\Ç\îs®\ç“\ód\ô•\ó\nG\Ìm.\ëÁq\á§\Êe¦Ý±R%7\Í\Üh+¡\æRa½\ÕKUú3k¡»…0!\ð–q‹úb6Q\ÈQ-³—US\"ƒ\r)wa‘°€\n\Ö\ÌW’Ö e 9\n\î0\è½Ä \'¬ƒA(®\Ö_‹>Xš=8\õefCn†\"Ù‡gý‚OÈ\é˜.xµ·‚9	¤\Ù+ˆPŠ\Þ%·C\Âh0\Ôhs™˜a˜¬\÷\"ãŠŽL1.jdA\ä˜Z¨TÀccžaÀ–¸€\ò°ÉŠt\Ä\Æ\Î\ñ/\×\Þ_œF\Ý\ËCl¬/\r±­²y¼‡‰\öQ\Íz\Ç!b™æ¢ˆD[P\ÇÎ¦h\è%\\2”ºAª\0Ø‡\â	XQ8B—€%Œu¡Q\Ç%‹«Úƒ\æ^\Ûh	\ãü1ªú¬±(\Ú\ò^j&l\É\É\Ï\÷Y^q\ZªQ{\ñ\ZEMƒlC¾KbS#i•R\Ë7\Ë\ÌJ\ß-ec«ˆ8U\ê\×S»\É}«\÷\É [¶*%†Ç˜\ðk\é\Ç\Ô\ØwŸ\ÔLL^\ð€”†ø*B›³I\rN\×\÷26\'t1‰\î\â%\0^4ŸrúwÄªÕ´\Æ\îV\ÊA˜€)–EÁ07\ë-°¬ž#d\\\é¡p²Ò£Cúˆ\Z\r\Û?ù-“%»\â†®Y	\Öû‚s(\ê(Ne\Ó<A\î^`\ÂØ”\î\ôƒÿ\0°e\ß¼Ë—\Ç.49Ü¼b\"\÷Qb†I\Ìl\çQ’¾c\ÜMŽ\õü‰kî§¶/¤\Ã\ÖyM\Z†c\í%[*¯P¢\Îy?\ö$\í¼f½	h²\åO\ÛRo¬\Ý\ôDŠ\ê1\Ön:d\öX¾\n!:~O\É,Á/tþ\å¤\r\Û\Ü0¦*ª‚C\ê2‘m{€ë½Lºµ\ËM\Î(ûK\ÑTWo\î,,[%¨\÷jx|À¢«ªüN$/\ÍAK±wuU\Ñ\ö”mTPi*\ã\âf²Þ²å¸¦\ê\Î8&<Kiþ~#J\00Àž\íA¾\ÕhlXúŸ’\Z\ê\ÒoÄµ\æ\Ýz¸\ä°u-v(&\ÎR‹G‘„@\n|AZ¤c•£Ñ?\ÌK-\ô™R‘•ýGm\Ü3Ð™%\â\Z$\Ç(\ê B\"9³m\Ü-\ã\Ö\Ü2\õ†s\Ìz—w™o\Ô6e\ã\Ä.¸—/\ÊjWsPq\Ô\Ë\ÞÙ–ù‹œM;ü\Ìo9c”4¹\ØÁœ\Ãg©Z*?o\àe†\È\Ò.|Á\á\æ=tzh¾˜— ú{L5\î\óüµ€\Ý\nƒÜ—²W«4¨\è?r\õ49\Ü\Ì€›\Êt¼J+v\õÄ¢±\ôD‹z\ôf]Å—¢ª/¡\ßg¬¢ºžT	X+–†s\èø~c\Ñz­Õ’þ -\æºÌ”—R\Ð\Û\\’¢d«\ÑùJ\ËcŠn\ë\ò\Ý|K.\Èx\rŸÔ²ÕŽY}J‚\Ýh\Ù\èw)À\ñµ\ê\"¢Û·D\Ç!\ï\æ0JÁº§f\Åm\ë\Ï\âd@:…`¡‚ NB\ï\îR*\ÑR€,zfR6\r¾eXž £t}J,_™Bg=q0T¯-\ÇUd\è\Æ=¥&+}\ÍKf>a\n„ea_V µ\õ˜ny\Â\Ä\ìb]i|CúM 7\ó\\¿0e\Î1/$a\ËTwWw\Z?\ÜGq\é\ñ>\È\ãºœ—˜¢\÷˜­\ô ŠwsJ¯\à5\Î\å\ã…\Æv\Ë\æ\êW”<[?;²ž\Ü\æ\Z\noA/Q\è\ÍU-5\àˆ\Ç¸T8S‰H\ç\è5¡^O\îXØ‰°O\êÆ]>c&\Ú\á }&:–\æ\ë§²°^°\îRÁ‚\à•jÿ\0K\ô\ñ\ÔetI\Ý(©À<…Áz½GVS\Å/G0Sb¬‡ý”rF…6\Æs\ó.N4±~‹w£T¾\Ð\ëCt\ã\ß\íDEjzú\Û)v‚Ý‡\'üÄ¾\Õ3Ë‹å—­®–\ßW3\È ¼\×1µR`pcR‚«\é¨\Ì--U\Ä\ö7(\Â7–\ÖQ«Š±\Ì\n€{\Ç\àï™‡Y\ð•R—Wž\àQ(x3\ÝÌ»m\ð¬K#Z‹[±\ÈW±\èCI(^¥g&a\Ü>ü\Ä\r\Ù·˜V\Ë\Õ™a¿XŠŒ\Ì\ÜÁ+xþ0zeûÿ\0‚ff}¡iH\×\Ö7c\Â\ó2(\ê)\ðŸœk6G=ûÀ«5á©9ƒF•þ¸d\ó)\à”¯´LxM\ñ.½\âÿ\0Q\Ö\ê%7j%Cº·™DI\Ø`\Õé›‡O\r«‚Te\ëû–A2,ý¸= [`¶³:4-\îVG0\Ób\ó¼ü–ª\ÞH\Ý\ñ@u\Ü\ÅI›\ïº\éOB\âÁ\Ê[\ç\rTH\ÓE\õ1–¼Áâªœs2\Ö\Õnƒ¯Y¢ž\Þ>\ãy’Z;\Ï9Ç¼!h8s1\ë^\ÃG‚\ÕR­\ê\î0›˜\n\â\ØD—P»Koh~|L¤·XY«j¥Ö•TU:\ÏOO™€$“$¹\ÍjQH7Cù(‘\Ê\Û\Ø%x™Q\ô\Ë_—-z@ \ZlÀ“&€\ôa}\ëe†\ò\õ¸92@­¶¢™\ìLW—OM++Ã‰B•—\r.)’Õ„cŽ\ÃU\0‡š©­«w\ÌA\È\öþ¥¨\ñ\0mÀŽ¥e\ñ»‰m±¯|\Ì\Ò\ßX\Ú\Å\Ü@Ÿ\í\òqw,\ç\áü\Â0\ÕCJ‚E‹øüBn`w\æef\Þ`\ë5¨\õŽ\÷1w/‹—X®X¶˜\ðq\Â\ÈjbVWÛ¸oL\ó\Í\êb/b¾¨Ál¢\Ã^Ž/Ìª¢pÞ·0—	ª\n>\á3\Î€\Ípr …º\îdQ6žÏ\Þn\\[vª\ï&£\ë‘W\Ñ\â~a¹\è>£¶ÁÀ¿lt—pÉ¨	ªŠ›\ñ_™r…&B\Ü\ãˆL\r\ÖsTî»•[vÞ°¤\Ï\Ä\ô\Æ\Æo‘Ç·\÷*ª/aï‹Œƒaš}+S+why]Wüš\Æ\í**Õ©yX[\Øûk\á‹\0\n\î‰nEŸ“ûŽ™\Åw,4(×‰Q_.4c:>§\Zg¾!‘]?¨„Hù\Åÿ\0\É[›o€Ü½\ä£Ä¢š\Ý@7~¥\Ì\àF–¼z@Â´¥½T\nHu`ý~¢\à\Z.–}o¨¶\Ï5^e­[\ÌPZ\Æ%†\ôbZÕ¿˜ªYq*—ˆX\î&\öj¸Š‡þF\Ði\Ò\ít.hFû\Ü/ITy{½M8Ÿ\ð‰Rµ-Ž·(y\Ä\î{Kbmq-‡¹p\Ë.\") Æ¹u©[•%Äµ™á¹®­\Þu*Î™k±ù‚eÞ¢&a7\ÅQvµ–½¥\Ã\0\ZGû–U\r•\r…z~‰ƒ3ykŸˆ‡C±.þ\å`Õ\â\ß\Öe8.\×\Û\Åu¬—O>‘‹\õmf²\Ðj\ñ~HP*\ðUûu³;Š\n\éT—ýAb\ól{\Ç‘7Fz\ÚÃ•WH_\Ý\Ç9%Ö¥ÀA\Är—ƒFvS*ª~%†Ÿ>X=¨\ÌµQ}Í‹\Þ\ÈVƒmg~\Õ(-ŒüK\Â\0yX\ë‡cq,J€DPf\öa\\¶z!€¹\ãLZ\Ðc ¡K·l\òŠ\ó‹>Y\éQ¨{fR)\×Y\æ2\ô\Ïlu\ãÒµE8j\à1CVˆút¤€!GH¦Bx\ÜMi¾\Éf/)\ñ	pj\Æw2¢\ÙKQ¤\ñ\Ì\Ãq^¢6\Ãu6’’æ«˜34²m\â&–XKTV«\îw7Ay©\÷1y‰9f\ã‹x;˜=%\àù‚\óR\ãyƒ\Ã\ZT³P£6\ÇS\0\"W¤·T‰@…\Ò\Ñ\á¯\Ì\Ð3CtJƒU‰\ÜP,ŸŸ\Ô0\ÚQ\\®ÿ\0Š•v\Ú~£…zÓ¢þ\ò€P\ÊZ¼\â\ï\â+vN|¿¸š³r­=.0­\í>\Þ#l¬(+Õ­ATW\nn8SN‹ÿ\0‘,{C>\ò\ÕTq\Ñ\é2Nø\r¬&VYAw]\Ü+Ô />§Ñ¢)o=ahC…ú—$A\ÉW}\Ë\"\ÎC“~“$xÀ~Ð­\Ímq¬\Òj¼\Íþ\ò\à\ö\ñ¶¡þ\\,‹\í¥¿ƒ	A\ê:\ñ˜\Ü\ÇÐŠ*[ZMú2\Îq\Ëm„p)%™.\ïo\õ0TC\"GO‚-–4m¸Š™{\Å‹©R\Û\Ò1Z\Ö\Ø¹0D8¸‚a¨\Ü\Þ71Pf²i\Ì>bÜ½¡‡gˆ\ñˆ1)DFx›\ÜÓˆ\é\Üw\âRÓ©ºS¼Gf\à\Ãg8\âZ™\Ü\"j[¬\ÇK6n4o>eÿ\0G\Ì¹œV\á\ÓP‚\ëpc•jq\ÄM°+p« >²‡\Õ\êh\Ñ\\Q®\ås`•_“2_$\Û\÷.\ãº\ËPwp\0\ÒViG¾X\Ê\ê\îZU¦\ZX\ñ(˜¥$.ÀVÿ\0\íÄƒTquQ\ó\Í\ê\Å4º\r±d+u½¿¸¥¨\÷¨¬®i€%U¹L@)Û‚^j)É¨\Ö-¬\Ç å²¿?ˆúE¿¸v\ì\Ý\ÞP²d\ä~°;r†&\ðx_\ÔJm\õþ\å\Ý\ê\ÙcWF»bF\r\ñ.€\'û\îM@\n%û8ANL•*„\Z9¢\âe\í`¹Uº@4´\Ò†Xªm\ZÇ’Z\0\ßq\ËÓžH0\ê\rP•p›Ë¸Žÿ\03À<’|q0€»\îh\êSQR\Õj%\ò¾‘}\æ%>“&s\0·\Ó>H)\Ç\Ì\\°G¼YÇˆ0Â´s<·Q+\ë\Ä[1.s–\á.µ\ó}F3\\X1¶mZ3›\Ü\Ã7\æ\ã¼t©d`\Öa–\'Áü(Šþ[\õ€¨_/~™–FZ•Hr¾¦\ØE\r\Ðjª—/DX\ÊBüQ ·£\æ*¯dz\ò$V=\ÙK\Ê\ó\ÏþÇ•A\ñˆ‚\r¼š\ï,\0\ãW•\í†]f¢\ÒÁ\ðg\Ò.\ÑY·\Ñ\ì|\Ø\ÜPù\r4}‡;”@\Æt+\êµ–(1-\ÚcYÏ¤¸R\ëƒ+Œ–\óo\òX.€å˜\î+\Õþ·(*¶\ð\é\ëÔ¡@\ë(\ÊR²\ö\Ål	e\Ä\rY\éy\õ‚!¼¦”2ýYf\Çqw`7\é\Ü/_Ž\Â\ë\çÄ¹°\ôˆ0`:M<K\ëo¬nR‰…`0²|5Žzq(”\Ë\Æ\åe€\ó*\ÌÞ’\ÎÙ•U\ê\ç)—,\Å\Ã\Ä\"ª3Ö§*\Ì\Û<wq|Ú—˜\à.-8\Üùb.\È\÷,\Å#2\ó\Ã\æ|\Ôp\Â\Îc\í\Ôt˜CˆT•7\Ä	Ö2Å«ª–)vl‚Ð–\Î¤([\Ê\Ç\r¨\èµû\Ã\"m2~¸˜\ô)\ÄA\Z?©F’6¹>Zpj<Æ‰\Æ.;S_\ç1\Ú\ö8\ô•\ñ5{–P\å\"–u\Æw«\Å\à\ÂPÐ²Â€I¢€¿XF’ú–@\Ç9\å%Tp`3\æ<\èo‰F\Å\è\ÜkGþb—´\Ý;”t§\n±\Z09L¯r\ëT\ç/†b\è­›Cg3,Z”5¸_Õœi‚\"+ü1+»¶\éƒb¨\ñýF…_N¾fG}\ó¸Lý¶?F`Gœ\Z% Ý‘±\ÐQN;ˆ‰ƒa”\Ä\Ö,X#x…ª\Ë\ÔDÞ–Z\Ðk^±0I›i\æX¿\Î=jT7ˆk5\ë±·eorÁùŒ\Âbn\àdþ,–\ê$c¦0\ÎaOxÙ¸\×lK—Ü¨\Ü\×sŽ]»ˆ\âi\Ãq.\à…ƒY7Ù‚\ï|@L\ó+en[\Ñ2#\Å]Ot\0U–­[\Ö\"\r.KªüAh=­ý@Ê´x\å\ï)€\î\Òþ\'¨¤Á´Ul[Áû”!Yj{\Í(&Ò¿,.‘|e±Q\ÒZÊ”HV\Z™pš\Ãþ\Ë\Zk»>ˆ9k~PCl\r&\ðÀW|Ey/\óÉ¥jú\Ä|\Ø\Êø6\Ä+Ê€¸œ\\UV°\ã\ê€i,\åª}y\áÊ«\÷>%)Qa}\êCÎ¶ÿ\0Pfªpß¿q3SSz?r\Ð\ï[¿\Ô†\ÜŠˆ¶·©\ÜL#Õˆ«sGš\Ä\Ï(\0}pˆ\Ù/LA\ê)\å\ñ\åŽ\Ô8‰†‚½ˆ\éE´y\ñ¾£\Ô \0N\ê2b(Æ£­\÷\ÕùŠ§	\\E\Ì7TKŠzŒ\ó\0-·8®¡r‡³<\ä\ÖJ\Æ\æ¥Y*\Ã\î”ƒ¯¨\Ï\â5¹•_1±»Š¹¬JB\"5\Ïp°¯h’\Â7…‰\Ä\ÊJ¹C\å\ñ\Æû*]\"\Ã0\ð\Ì7£ŒT\à”f\ÖcyÜ½Å³3n®\r\ÇX\"\î\ÊÁ£&\ØÍ¦/\Í†±Sjk[j\Ç\ö‰\næ½´{\Å,\Ðd7^’Ú†…×ˆ‹\ÓwB\èUP\0\0{k\õ ¯R*¥¨À×®b‚\äû&)h‚jhUUC \ôš…j¼	\ï\nŠ¼dŠp\Â\î\ë\÷,AUx &Aè°”h]`|V%€Sw·ª\Ä\è_\"%¢¾…\ã¯\ö 4É²4ù‹eeýB™·K¿\Ä€\Ýÿ\0\äBüy½@\n+ª.¼\æ8=Ž\Æ^A\ç/P»PA·ý–c’¢.3\è\×\ÜZP‹\Ï\î\"Ý+Q6*\ëW\Ù|1v\Õ\ðS™Pk¹kcß¤A\\µsQ¨×¤B“\'ˆ+P˜\å¶\ÌU\ðˆEŠ\"\Çu\ÌÀ#sAÈ¸_n\ó\ÅV\âºoJÑŽŸˆ\ëlÉˆŸ\ÔU\ò2\á†\\Ó˜\n\Ä\ä\Æ\ì;¥\Ñ\ÄV\"R-;¸€ƒ2\Ü0T•±Ü½i\ÙNY›\â¥q\Ä%\ç™\\jS\Æ{”\Å\ÆX¸\'³\Û\rž%Å‘m®‚ß˜€Dx\Ø!b\Ì\n\ÙRŸ\É26\ç^übº\í\È\÷|\ÌEE/\àŒmM%|€¡‹Hÿ\0T8€»wUZ¥|½ã¬‚\Ú;¨)9vw…¡\Î¯R.7—\âh#\Çû1¥%¾±_“>e\éJ“Z\nª\r\Ë8Y\ë\î%V\0b,•\Ã\Ä=ª;,Š\Ý\'~H»\r¦\ê\0q\ëqŠÞ¯\ÅÀfW-\ðœ ˜/—\Ò=\r³\ãú\É<‡\÷NŽ\ÇV\ã\Õ-T+@ \n«>7)<QN/\ÌB\ÚW^I(LŸ¸Š\ÊQ-jd¡¸5Œù•\è|G\Äx…ƒš\æ\\V*d\Î&XQ©8¸›\Î\Ú  	€JhŒn\r‡˜\ÚtJ\Ë\Û(3\ã\Ãy £\nˆ8\æs¸…„†N&›‰‹¬\Çb¸‹\â7m±Û’Q\Ô2\n±r±\Ð\îUqYŽœj6\ëDR\ä•\Î\àº\Z\ñ*y™\å€Ì¬Ksx,tn\Ø\Ðn¥Ï˜2—K\Õ}\ã\ã\èt7_rÀwµ¯vÏ´¨i€\Ðy`•\Ò\öþX‘gYm¾\ë2›:¦•,\äžX`Rc%±\êÿ\0 ™gC¯Y°±cBc¥¬Â°€\ð\Ù)P\ð®fGÐŠ(E\è\Ê\åB\Z\Ù=\â\ÙiuzD+±;A”c°WÜ©M7£\ã\Ç\î_¡\Ø|\Z\Õ\Æ\õ87Tu\è\åþ\å¸¹­‰H\Ñ\å\'\Ô\Ìe\Ê?.\áp\é\Êø?¹p-´ú\Ï\Ü„\çû\Í\àmª›iC2«¡3ƒ\õ,\Ì|º‰¬\ã7±»¸\ËTaUk^\Ò\ÔÃ‹J¸°\ÅGü%A¥\àIì‘ 53©M\î-:b$­\Ü\Ãm(ou\Û»‰G|Ô·uÂ…\rF9!\àRÜ¦A\Î%FqT\î\à(X/#.¨‰V\Ì-\ç3ýs1˜¸^%QŠM	Q¼LØ™\Ô\Êú‰Tn\ÔBn£±Vb\ëLE®!`\ÅB\Ç)qJ’–>œC@eƒ\Ö¡\ó2H)[^\Ñ\÷j¼°{sRŠ\Å\0©\ÌU\æøA\\ozŽ:¥\æ\ñ\Ä\rùD\rZ«\ñ1‹p³H\ït]\Ê\öm\n¯x5µzÿ\0Œ}\èœ˜…·	‘mø”¬¿\Zªÿ\0xP8R/U\×\æk­·†¾ˆ\ò•N<¸¶\î\Ùjhœ†¼\Ê$\\\"\Ã\ãûŒ¡‡¢½+\ó(\ÉF+¢W©€\Ø\n\õu+\0\Z¬¶þ¥C`s\Zƒ$Ž>£ÊYn\Õ\ð‘_wU,E\æ·q&…-\ó@Sq¦Wøþ¡ƒk6H½¥\âPo-JƒYu{”\Än\ÙjtUÄ‚\Îe…Ñ†\ðbZ\îùˆ³’T\îZ>#\'Iw¬¸f‚6#‰@<\Ë\Æ~eq*‚ìŠŽý \r	¢pˆq+‰¾ã£ˆ6\ðÆŽ\â³i\ë\ê>Ùžq©\ç¢fRC\'\Ú%¬\Ë5Š&²\êû–j¹”w‚(V%XÊ¨\Û/In	`•¸9\Ì(&pEY»V—~w6î·ˆeGu`b†nA[a\r\ÂPZe‘\Ür4>·ˆ\"¬qm}ûB¶gÈ¾©¸\ÌÊ®\ÍzG]\áJ0\ì@`¡¿¸\ËM\ÞiU^Ò—lŽ¥¨,¸Òªh²•\Û\Ì=\ê	S\ÆÖ®7t†³Uø`œ\íWR¹\ìŒw\Ô$”.²cšQÁ\Ã\Ê\ñU”\ìß¼GaÄ³,°p¦N£f‹\ß«\\·˜\ØÀ\ö¯¸\í¥ie-e\í\ç\Þ°^²·\ë@\õ“pÁZ<YS:¾`‹š\ÞcMqHS7‰°,ßˆ\ë‘* \ç^\'šˆ…\ä”:É¢\õ.Í™j´Á/oÜ¢†\à––; &ù\Ô,\öGŠ\æ$9™\ðJ,Ui*£ˆ\õbß¤¤\Í\î\Z-ûœ\è‰\ÞX3²ú—\í\Z\Ò\Ê.\õ\ÄV\\°a‚L‹oqs‹”	ˆŸ3\ÒE´Š\ÅK­\â\ôk—f`\r@\Ûg¬º†#®2_Ä®4¼.¢\ÝO€o\Ó\Ä\0m[¼\ãÿ\0`Õ¢¶h¨h;`7j9\Öa~¹\å\0¬\ÖÚ…=\ã`W‚¬K!ú†!.ƒ®„/Ö/›\ì=¡Á¤Å±dmºo\á‹/\æn\Ãn8Ê™\Ç)•B=B\0¬=\å\Ðû\Ñ\ôJ\â½Q/\îVÝ¿²Œ\0g¹i&Cß™—@”ÿ\0\ä\ô¨\Ê\õ\æP»\êÑ‚pÙ¯\îZ\Ñ\×\'\êc\Zr\ÅÕ­\êýE‡mŒ½!=°&Â°\Ä‰¬T\"‚ÿ\0)R\è+D3\Ìn	M\Ô\r˜PJˆ]c\09%ncÐ¤\Ö`$0†\â7;s2\ö Œ\í@0¸\n\Æ\åh­\ÊfFsˆ/Ì¥`\âoSV£D‘b¥\ÞL:±«†©>bkŠ\n\Ñ)Y€9J±™–GQ\Ì-’”†\à%€&–%\÷+Œ²\ïP\rB\ãOûp+OA¯\ó-U\ZxÌ¨™Gƒ1¾\ÊM½»KIj¹þ Ö„2$¬)³J\Ó\ZJ\Ã	M\ØXµEy–¨\ÛYŠ”[L,).µ¿h£F4ªe2|R\å	±5.\Úo„T¡\Z¶ß¹`d5Õ©•ÿ\0¾%vÁy\ç\Ö\ê€T>H\Z¸\r©ú]Æ¬rz¾e¥Vx\ÇçŸ¨&Ü­R\Ï\Ã\0.œ>?1 l\òªú\"”\Í\âv¨XÀ\ïƒE\åoÔ¤Z7©g0V¥\Zq{—E¬K\Ígˆ˜)Qc³9a7W¨”\õ«\Û)—®\ô\Æ\âú¸‚Ž»•JnaÎ¿5\Ü)~gjV·\é3\ÅµŒ=“®Jˆu\×0ž©VÌ£v\â0\ÜtV&\\2\í\ÜW`‘¬w\æˆ\æ°«Ky‡X˜w2J\ò‰pø‰¶¾”s\æÝ©G{^qéœ­Ü¢\Ù\é¸J\ô­ýƒ\ÍY—¶}¦bX\Ý#	µ«\ê±.\Øk=ø€.‡’¾fM=pBÉ§y×¦?r\ØQx\ô–\è«Â·P‹^\âŒ®\ì7\Ï\Z×‰›‚\é@SçŸ‰·£  þp\r—\ß0oZ¸>‡qº\ÓfOm\ÄjfÇ¾y€u7\ÐWþ|G ¾•m\Åm…L©\æ :*\ò-¢\à\Å>f’Ù¢QCa–’>Ê…s˜AË‡\ñ2\åV\ã@ý¸I\ÆF‹;)•§{B\ìF\ã¦eŒ!0U\Ì\â\÷\\D|\Å\ÛR\î\rÐ¦·M\Â\ÑW˜‘jy††q°x}ÐŠ.)\Ä.\æWT\ÌÙ¬73Y\×qÛš—YEµE\'¸”Gr¥†£¨Á{e€J ¢R\î*X¦\òsª·8S \Ä<@7\áfþ \å\Ä3<\ËPS¸ˆ\Êc³\å×¥\Íªºª%\ô\Öbú¹xP\ì\ë\æ895{>0Ä¨‹tŸ¤5º\Å_þA @Z¼&@€j\Ën\" e\ñ5x$ \Å/¬Àe¥·1š\ÅÜ·Á\â¬\Îø>Ÿ\æ4&\è\Ä\'À±o\÷\Ì\ÃØ”^®¾\"\ZDVf•\ßø!fT*o\Þ<*1ˆ\\ˆ\ð\ÂW¯\ìˆ\Z-i\ô\î-Dµ\ÂUqoy\ó\Z‚ªi\Éør\ÓÔ‹ ²¬>¿\ä°1\çÝ.(o\ñ³R±UXÎ»\öÔ²\å—È€ªµp9ƒ¬\ì€Ì›”M\ÐJK\ó\ÄX\r†$\æeJb\î®*˜€\ö.%\0~%Š`\Ñ•\Ñ\Ô@¦!|h¦^\"G#dfT\àn=Aw	\Ù*Á¨\ö‹,Éˆš¼\Ì\ìZ5<\Ñ\\\æU½\ó\é\Ü;2g™d1*3&²\õDº\íB—F%¶T\Ç&{…Á\ñSBF£\Í\Ç©G“Þ¡_\"¼\Å\Æ\à¾egx)‘½\Ì@~A€I<\\üK›«\Öf¸€\0e\ò!´\æfšeA?ÀûT*D\ò­W˜˜`V2_\Ä(«on=olAjµ½_¡\0L9ÌºX\Ñl‚\ÝÝ¨?½/\à”)p\ôyw¼e¬F¸ 6¿þ`Áj\Ô\ç\î\'.Sp\ã?0\ÑF¢\Ú)\÷_\îb\á^\Ðú\ó\÷\ä‹\ÞÄ¦B”Ï´h¯‚8>\rUgÌ±]Jú«ƒ-IÚ®¿qA§mwXK\ØÊ˜#e7f\Ç\Ôh\ÊW\ÇÁ@6”\îá´¬¼\åKJ\è?¨\ê,P¼¥&\éþ»[\ò\ã\Ä\ßM\ìŽ\r.\÷\Z+^³³\Ì\Ó|’\æq\ê °ø™\"¾c³3\\\Ëj>\å\Ü\Û\ás#.†Y–\Õ,\ô›$<:Š)ŒA´Õƒ¨5Œ½_´·h”u\rx˜\à¨auÚˆ]\Üj\ê]V®(\ÜvÀ3\ã˜u‰‚ø—bS\Åb\0´\ÍÌ®!€\ÔJ\â`‹9{Ž˜ø\æc6j]2ù—„|\Ér\ó:€hP\ÅWþ\Ë\ðf–\Ï\ÔCÔºŒQ\É`\÷jU]\ñ~°3\Ò\Ä\Ä,…§Ý¹\éV\ê¾‘[-\Î>¿0a^\ò\×ÿ\0%»ø\Â\ô1\óqq(ù\êƒ9[v\ô\ï\Ö!Ý‚tP\æ#ev{‡\ò\ÊzŒ‹¯g–\n–šqƒu\ëµ-«wŒf2‚Œ=£\à´(­{Kø `\Ë~D¸UÜ™\öš_8\ãPÀ§\Ò\Å\\®\Ê/’d7-Ð—jÓµ¶X¥Št¯h7-\ß\ïÿ\0 «y\÷IT¼\Z\ç¤\rÀmük\ÚD]¶+\Ò\åfŠqª\ã¹W\rœƒŸ0;*\Ý\×D\0¤\ò\ÞÒ©nß‰P\È+‹†A¶\ë\r@W\é\Ä(nï‘€¸s¸—–üF3%\rz\Âbn`\"­‹Œ×¢\\{\ë\÷\0\ñ1‘qJ\Ì\êdDe¥™°m!\æy‹[\ó(Ì¶™‹’–QMš‹m…07\öµ©nW3¸…E\Ã\n!³y”zŒ9•>œFs1#\ß\Ú/‰‚\îdËµ \Í\îf”gk¹\é\rC]\îM FO¯W^\Õ\Ë¿`Y\ñ\àû\ñfooÀo\Þ	NMRˆ®>„´8žOCqu\Þ\Ø~þa\\5Z06\ë/\ÔY|ˆi\Ó|W0ª-\è‡\ì>\÷3\èp^©…”È§\öW©j»IW\Ò*,\Ð\Å\0|@t\í\ì0[¦\ï:ŒŒ‹%Wœo\÷+YÞ´¿sû‚-A\Õ\ÔKF5V²’‚ \â\ñ\õþ\Ü‚\Æ/™CM\Ø\'¬L„ \å\Ç\ÖXTÁŠ}\\b\Æ*Õ‚ù¨1š\ï˜Y}\õ›\ñS3•h\Çá´²âš£YŠEz¥zŒ‡•_\ÔM„\ì\ËÎ°AR\Ûc¯ù,\ÐU\ÍD®\Ü7Y_\Ô ±‡X\"š{Cs’¶e-—¼þ¥YÌ³…	ˆ”ˆ\np‚j®j :Ö£\r½\Ç 6Kª4f<&µ(™a<\â<®»”QS\r„A£Ne\ÝÔµ\ígsE†;€Å[\\OF¥-9ƒs\÷<\ÊJ<WqP\ÕÁ\Ö\÷6DO\Ä}Ä—_ù,·üÁŠ\÷\öŽ\ÍF5\ó+U˜Ä»*eƒU*>%CBû+\â5„p\Û^„|ƒ\Ð\á\õ\Ì9\Èfü\Ã8\\SP¹™‡±­\ò\ÎŠÑ‹ø”	~\ì(¨\ñVš\Ý×ˆv\ÓtLüÿ\0Èª§O§¾fl:\×L²e\Z1x\ï“\àˆA:Qµ\õ\ã\î±L¿\ë‚\Ê\ìÅ¾°¯I\ê]w‹¨f­j®—Ï¤aZ\Û\È/ûN\Þ\÷…±\n¥\ÛD5\ÆS\Ç\æ\n\õ¬î¸;\Ém0ý\ÍB®NO€ýÁ,\èºÆ½a°¼²\ÊJ\Êtº \â\ï\êP\á£\'§ýŒ X\Ð+^\÷ˆ–\ß\ôüZ\n\ä\Óq\n\ðej\æRN«ø,\öf—\n€§Œ‹}%Š­’\÷c\Ò\nG#U\Ë\\\ËBK\Zxq“\\\Æh\è8VT¬\ò¬\'\ÇýŠ\×ý#a½N\Ï2ø€U\Âÿ\0O\ÕÛšL\È7þ\Ì=€~Ix\Ò\á\0!ljX(Z\ñ0¦o\Äu™ƒ®c)±¸xŒ	hÀ¹zD\Z\\Á2»¢d\Ä\ÑuŽ¦\Ú\Ë €²Áx€’Ë–¬†\ã¨úß¬º\Î\î2æ£›­ÿ\0Ü¢\Ñp²0\ä\ÝÀj¥n|Cu\r\Ï²\Ë\àÅ±rù\ÕD\Â\Ï\Ëh/¯\Z²†Ð =ˆ§¶›ƒCqU\í˜S\Ã8\rl¾e†ƒ/ž¥O•”2\Þ:¿H‹¤¦ÿ\0“l\ë0§\ÇRVX/(Á,[]*\ñ™Ç†\Æ~\çˆsÁv(z¼¾‘J\Årn`Ô·’ŸW©J³ø”—ÁsÊ•8?\ß?¨Û¨W,\ZÁkÕ¸î€«1\öÁŠ›7\Å^¦eªb†ûˆ@+\'¬q-$‹J—B¼WsUH\éuˆq\×OxÑ .¯1 47«‡“®Þ¬9\ÈX_|\Ê\Ð+2\ìvŸ¦ ‚\n\Ä\rb\Ó9¸\Þ`Â²\ÅÓ‰mW`^sþ\Ä£n›\ï\Ö2@wšKÆ›ýÁ N\ÇOˆ8®So=07j2 \ñùš3©\\`\ß~²Ž·\ónïˆ”ø€\nª†‹Q\nb­31\êxƒ˜Yu)PjP`Ä²\Ô0Ãˆ\Z¬K\Æ14z&\Øekƒz˜£uP\ÙX„f¯¨\õŽv\Æ\õE»š\÷p\Ë.\à1x‹~C\r\ñ¹vW0Õ·pN\ã\ã^c©oqaL\Ò\ô\ß\Ë \Ë\ËúŒ.\Ë\Í2\Ã\ìuK\é\nU\\r«?Pk,-A›½œq\0\Ô0\ÛÒ†\õ\äŒ*\ô½.V\å(8p\Þy†`\êiø\ß\ÌkVÞŸXVV˜m e\ðUù…\à^.¯®¢mŒ\n\Ê\âø•tATz\êüG![\Ç\ã\ÇÏ¬E\n°\Ó\Æê¥“}‹.½\á]d\Øü3	/³\íÇ´Mm•Á\Ì\"‘[\nK\óz\ç¸±KhŸ}C±€ Ug\æ\ÑF\ØpV1þ\ê;U‚¼F„lv~} ¯‘œU8\Îþ\".\çz\õ\ë,Q! 2Í‚\ã\ÚF”—\ñ«dœƒ}Aª9o\ß-\ÄmÀ‚mý\÷\Å9µŠ\÷\0¥\ñ\Öýe\r½%\ðë¿¸4\0Pžú\î%\Z\ÙM¸\\\Ý|K¢3,bšH.ý†Rxe!N¹Œ°\Ú{Cˆ\Ò\ó\ääŽ‡DAŽb‹¨\n§‚9Ù…gc£q<@g\Ùª¥\Û\Ä\ZCZ€\Þe+ƒ\æXZ4.\ñ,\ßQ—X‚f£®D\â\ê7UQVzˆ¶}Kb\ç©\é-\çs,\ñ\n9q,\ëlZ¨U\ÑR½cŒ\ñÔ·“1\ÖjR>‰\ç\æZ´ª¯\Î\å	MV\Õ\Ú\è‰µ\Úù/,4\"\Ø\Å~Vë«&FV\ñW{(\àÌ°\å7~YŸ\0t\É\0Ž\Ãj¯0±^J$0,P¨\ÖŒÿ\0ž³vG\'\Ðþ¡¬¸\ì¿\Ôjm4€\Ë\Ñ\æW/\"®G6ø\ñ2® ¢¼Ÿ˜–\0ªÝºú\æXÀZ\Ç\åŠyš*\ï—Z\Ä,\Ö\ÃJ\÷\åJk \ç\àtV\ë¨G\ö;}n â¢–\âTQƒµß‚\Éc‹\Ñ\îSƒÀ_ü!‚p\Û\ç\î\n†6\Ø\\jX\ð¬LÈ¶b´\"\õ\Þ\nÌ¹¸->j-È¦>ã€¡d¡¿\êjN}N\ñ›m	‹ÿ\0°l\è.=¿\ß2¬”S?=Tº\ryû\ê\n“FFO\ñ+*\ÑmX|5¡–\Ò\Ë\È?\ìX4ªIv!S#\Ä©²\ñ\Æ ™\Ã(¾¦f9B‰m\'0b\Û2`_0q\äN\ïyx¸˜\äŽ&S‚8….XB»”¨/bÃŽ (y Á¾b+\Ë1Š‹¸> ¶\Êt—§\ÄrÌ»IO\÷E/\â/\ß\õŒ®\ãQ·µ\æ\r’ü¥ }\Ëbêªƒ\Ý`\Ââ±¨\ö\ê1azÿ\0}\ài#jQ\Ü^F\èÏ§–>µ\Ø\â‚\ç4ÃŽ½ OG*\õ4b\Ò\Þ,®œ¯Î¿p¼z\Õ^„ª²\ëH|\Â\Ñ\ãvC¨Ì°µ \Ñ\ô0ü\Ê\ÄN˜+\è\Üc\\^×®z‚\n¡ÂŸü@y!J\Þ9{ÀÈ¸µª=\Ì\Ë/fM{^9‚¶˜¡\Æ&\Å\n*\òK•¯M\æ\\ù€_5p½c·Œw ‘,l\Ç\ë\Ö+\Þ\Ùù•q§¡\Ù*”\Ìà»¨\çŠr.#*p|Ê½\Å\Ýyj$ˆp>×¾&Pf…Ü·C\Ù\Å|\ÃMî¶±\Ü\Â-T¬\Ë\Æù\â$¢€[«\õ‚²\Ç\Ó¦¹°‡¦}b0S\Ëm0\Ê@\Æ<\Â\0¤)¯\Ì	E>e	MÀ¹w´jHº\Ø\0\Ø_´¬L¹\Ìn\Ø\ô–n·¬Ç®e¡ —›«`	®!\Îc¼\Â7}iŒ0\È^\å˜\Z˜\ñ˜\È_™\ÍY\Þ xJx˜q(q.ˆü§ž%ú\ÇS Æ¥¸—˜¯Q}\à<\å†u=¥O2\Ùû\Z ^  xÔ¢”£\ê9•œˆ/\Ö\\Œ7EW eV±|UA\Ø\ÂSL¹\\4<\ç\îS–\ò\çzG¼b¤*\é\ß:pD\r\ÔUb»íˆ«7ŸV_\ÌÄ°Í®¨ŒŽ\"Ñƒ\áÊ†›Tø¯\ÄH8”R«\Ðq\æ\nmÛŒ\Ö?\Ø.°lh\õ\Û/ˆT>\0@¤g}µª¢Íº{—\Ê2	±¾¡^\ÍU‡/Ÿ²˜\Ç\Ô\r+twp@Y¤\í/_^“re5Q)†»ÿ\0fXŒÎ®PX\Z¢¥’Š­u2U\Önb›ù\Éq¤ 7\é,.\Ã\Z~¥¥	@1‹ÿ\0s¢\Ò\r‰,K	\ãQG\æþ!¼p\ÙV—½B8\Æ\Èú\n¥\äG2\Äi8\Üv\í\Ä\'u\nmœþ¢ì‡¨\ÝxŠ\Åe73FüÀ³i?P\Ý\ç¦\Õ\Öy–\Î!`u;EI\Ý\ÔP§qµ\n˜(\ÔÁ¨\'\æ8b(3xžQ\Æ\Ô0sV\Ãqq\ñ@¸x\Ë\ë/p(m¢\×\æGK\õp(V\ê\ô)\ë\æW(5ÕŸû\0l—\ÃÖ¥—8n\ÛK\ó›ŠlH\á\õý±«\n–[r°-€-c˜’»TR4\÷N\ËH\ìi\Ã\êZ‚l\Ó\×u\Ë)fªe|_\Ü\r\Ð K\ÏDh\Õ,+\Ü\ÔmV}mX\"A¦¡\í\Ü}º\éÿ\0bK=À~nt‹T{—©¼Ž \ÅÕ°™+\Ç_QD\õSp\r‚\ÞÆ˜\n>›¼[Ÿ©f@RÝ¤Av9?¹KxL\ÐÄ¬²\Ý\ÝÁ¼\æ\"\Õ\ñ‚+- úº\ænšAhŠxu¦[š\Î<\Å{\ð˜0W;|¤4R±gj=\Ô,\÷\æaPž\ÈB\0¸u¿¸1¡˜ÀfeÜ¬\Ý\î%F%Ko¸‹ü!‡~\ÐVF!„x•fe¯¨x•H\n‚\Ü\ÍT\Ó?2\Ê_ü†AÀb,\Ë*\\g\Òy@‡Lªƒ\Ã.¦«*ý Á)Wp1Y\óÚ\Ó†T	aK\Ê\Ðbœ„\ß\Å\Æ§Z8\îS\ÓyzDTÙ]û©Gc3œù&\×EhÒ¹¾e.¢U\n¼ja¢4¼¾nˆ‚‹½T\ì\Ìa@t³Mx]úÌ°;&ÿ\0–´„\Êª\õ”\Ø\Ðš\ï\Ö\àPV9\Äo\Î.i\Õ-^¯\õ:Ù¹\Ê2Rƒ\Õ\Â›)z¸¼ùVb\í|D•\\›\Í3‚ƒ\õýJj”\Ýs¹‚…\Ö\ð\â!\È\ï\ÂÂ‰Vÿ\0\Õ\Î\Z®\êÚ»¿x-h\ç1\É\åMÁK\ÚUŸ2‚³¦™`§}ÿ\0\Ô\ËB·\Ì0W©¹W\0Y¢\àX«©J¬\'\rþ`i•X±\ô€\"iø–sË˜„\0ƒ l\ÑI\Ä\n‚ w¸¹5Ì¨[¸\í\ñ\ó\n\å*\Ö!“r½¢qpDO\ÔE9‹ °CP\à\Æ\Îb‚\à˜s63±‚¹‡?\æS$HQ,bq\\\0)\ÔÑ‚¿©¤\í+<D‰œfcm\ÄøÀ•›¡ATtb\É+\Ý\ï\Ã\Ì#Me_‚j–¾œ‘\n¾–·»rµ©A\ÅJ9\÷”«†gº®¹œ;«=øˆ\r­w^eU”#“NA¨<\" ¬?9ÏŠ•\î_\Ì86°¼y\óÜ¡NE‰\Äµ¦@\ê\ôJT!Ä­{\êY\Î-\Û\ë^‘PŸ[yt|ÀJ\î‹mþ\æ#2¬  \ê[W\Æ%yU\Ð/=L€¡œA°‹a\ð\ÖXC`\á0±•ù\í*­&ø\Ç\õ\÷J”f–þýŠ\í\ìT´«¡\Íû›\0\ÞeZ\ê9\Ç@†¼Y¨”£\åPCAVÂ†Sj \Z<­À\0X\áM~\"ŠÈ¿2‰€]Ÿ\ê˜IX\Ê`T\ßþJ@O\Ô=\ç0\\­}À\0·\â2¢U¡g‰t\ÃŠˆµ4\Æf	\Ø\ÄUt@\Äqˆ\õ˜\ëg!J—¦\Æ\Èø—\â`\×\Ü\ê9\ä\ñ©\ã†v^c‘Q\ÂU1?\ò\'‰¥\÷9@-X?2¥`‰+\Z\ÌÎˆ\rs¥W7\0aX›ž¨€`d²Ï¨&cƒW@\â[\Z\Å\Ñ\ê\ÇL‹PýDd‡‘‡£2!£\Ìm\Éoˆè¬®=!º»]8A`\ÕÁ\à`‡\Ë‚«T\Ú{¾b€th2|\à„©+…¶/«¿ùU\rf*\ß\Ìh‹€\Ð|>#Z\Ò\Ê\õ~ý\ÈÐ \Éjù\áŸH¦KjP}	vL™}º\ÌÒ¾E\r~aPL±k_}²ºE¦‹h•]ù\Õ\ç,£“\ÄGa\Ú\Ý{\ó0\ÂLG49\r‹\Ý3\ñ\0£b\Íý0% u \÷½\Ê\Ç.\Õ~\à:_-Ð¼\á\à¨Q\Z\Î„ \Z²\ôyî¥»–Ÿ\Ú\Ö\Óx\õ€U„a¢\êV%\Û\Ø\ÊWf/G‰‚\í¦Ë\0\n\àÈ‡(»j\ç\ë\ñJ\ÐvNý¥ùyžs\Ö^€\á*œje’[g\æ$%pŽ#«\æ\Z..vª–\Ë&eŒbQ¶PÊ€* ]\÷U(•dr²½\æøˆÞ¥ZT¬\îVeiÀ\ÇQ‰‰j\é›z\Æ™e@­\âQË€!n~\ÔWÜ¹À9@{D7%dWDB\Ê@kß¹‘R– ¦\n^\ÝQ¿ºˆ\ê:º“\Õ\Ôdwm}]BÅ€±7gh\Ç\â\ç\å%Š	z\Õ\í_¸”\êU\á\èrµ•_\Ïý…v\Ë\Æÿ\0pºs×›\ó¯Ä°©L¶\ï\ÔQ)…¢!+PG  ¦6\ä¥\ì\r—\ë\nJ,C\'\"¿®\"|—\è¥}^=\"Ô´†\ï\ÍÈ¬%\Ó	ëµ”ø\ëV_T\îUE­–•\ñŸl\Ôod9\õ”z*\àb*¡	y\Ë\ë)\\”˜»Z‰x\0×›1‡\Ú;¥\àA€\àÿ\0\ä\ß\Ê1ø\ñ\ïf£\'\è›\Üm]´Ú·½N:¸ƒ;¿0>Nµ‰Xµr¼F‡Æ°{\âl¢™\÷©–Q•›}\ã^Eþ%TP´®+˜)¯H\ÇHD8¬\Ë1.«\Ì»‡PN\çqzL™~\õ\è3#–a\Ð\ÃS\ó\r½A\çpaBW\Ä\à%^µ?­¹Eùœ<Ã´<\"f˜\î‡13ˆ\ÕT¬DU\Ây2§* \â!@Q\ã\ó¨ƒ	mYY,¸fS\õ$ƒ:\É\ã\ÌBÁÑ\ì\àB\ïji~o\õ4B\Í\Ö{b\à\Í‡+Z\ÍC¥MÀn¸Á_B2žKÆ\ê\ÖZ\ïI€¢«r\Ìmhº[\ñ* `%\\\ñ*\â¨\Ç\å\íþ¸’;\Ð\è\îb e{o\Ò(k ¦<œúEL\Ø\Ê\Ófu–\ßX…{\\©ûÿ\0\ÙS\Î+~X.ˆ8»l;\Û\Ø\ÄD®,fqË„=YŽHr•||Â¼°*ß‚‰\Ý\Îe¾\×¥f¯\âP\ÉfW\Úg\ì6\'D\áKŸÜ¤$„y_OÌ¼±\0­3ºü1„¥INÁ\ë\ÖÅ‘m\Î@^’\ë\õúˆU+ap\Ü¡S\'\äû‰>¥¿s$\Åt<\êVUø\òÁ\n{O¯ˆ–]cJJF£\Øû–%¼}ù/\n^\ë\÷\Zm±\Û\é0ù?0Rø\ân·\n7˜\Ùtb]J\Ì\óü\Z\Z‰\ÔÔ«\"V&`s\ÜL\âüS©\Ìg0–q=¦O\áÔ«Ö¥D\Î\åQQÃ©¹I7\rk\Ö.13\ñ\Çp3„U¶¿n\"\É\Ùúx(\ÔÍ´\ê)°!»\Æ}þe…9q\Ó>°du`,|f	DE±\ðý\ËS¢\Ëjú]n&))\î\ëU™Cš\ÎÇ•8#Wb\à“A0)\÷¿\Ü|l§ú\åh¹|kˆu˜>\èŽQ\Ò\ð\Ôc‡xP\ßmJ¡±) q­~`„*p@®(c‚\ÜF\ÚW©U\Å\0qe\ØýT¥\íc\Ì\Z¬e«\Î^\à’“³} Q\õ­{\ÌB- ®\Ü\ÌJ¨¨Ýž©,*jŽ=¥(Km\r£ú†Y¸Z¯\×2\ô´.\n?\\Ë€‹¥1y½u.©J\Ñ\"û|\Ä*Â»\óý\ËX\ïVb¼\Ëy¨±“\Ã\ãÌ¬/=M’\ÌÑ—’\í\ÉUÿ\0»†c\Äw\ç\Þa\rE”^%°[y\ÞÒƒh©O©\Äf±¡~°Š\Ä\'ox€c\âT\nnU\r\ôf@\Ì14\Zƒˆ–@\\¶\ÉAoD¥J°¹W\é\Ö%_Q>!e¿YG08œ*n>\ÊÄ®¡\÷\r\âf<\Ü&\âDŒ8©W+	üYE\ÌGq\Ë¡¾•\Æj\ðsJzµ~%g˜jÁ\÷Á	˜‚²\Z\è1\ïX8,O\Ô  8y{›\Â•U\í\n\Ò\Ë\í\óúA`œvG7’#\ô¦\\Œ]ˆù\Û\nÜ­ˆz·vù\Çsž}m9\Äup\ó˜A\ë¬\Ç\0»\Ùc;\Öx˜eƒ’\êøŠ\"YO¥ˆ6\Û.°\÷Â‰\r‡\Ö\Ú …°Rd>ùŠ\Ðd=Ñ†[€iˆ\ÚH¬\'\Ø\ë\Å@‰\à\'yë™ŠU5¤yz	šQ¡\\B‚`½¾\âY´š¡ú\ÌvWLa\èú\Ê€E8úŠ\0³ Ó¸\ÞJ¯\\>;\ñ\n}£úC1\\€ú38ŽJ\Ã\ÏX8a§§‹\â\n´\ö|T0\Þ-•z\ó0\æ¯Ç¬†&o\×\êp0\Öw\âù@›eÂ‡\"\Ý\ÆM>\Ë1\É>\Ìk\õŽ®E@û@Ô®?\î¦:bÄ­uV¥)¨™‰™W1ž\á—\çøuƒ\ÅzB> [Œb\'¯\ñ\Æg2¨ƒ¾\ã;•5+2¿Š\ñ\Ó*µ)\\“\Æ`<wQ\Í\0P/\\E ´meÿ\0°µ¶,P¯¶#Zk*¾¶[tzÄª\ád \ô\Ê\Â\Ðý^¾¬bS¡Vú\ò\ÅfG™K]**î¼°\È\n\áe^£J$1\ó6VŠ”%…)K^J—´4m\n\×8#c€\Í\ã‚\õpVJ¢€ïš…1;ÏŸÌ¸]«uW\íY|\Ü\ÔL\õÍ—\\Á®\ì©c\"r xwù…Á	›¢<\\/¸/$U¥+Œy\î-™\ÍWS\nsÀÀ\ÊUY¬<J\Î:y…\Âtc\íª\Ù\Í]ÿ\0\äÀŒX]\ß\÷®\é\Þy•Ø¸\ZÂ \ÊÙƒ¾\ì\ñ2u³}µ\â9j…\á\Ø\çs\".\Å\çýu™\òÏ­T+\0S\rb\÷¹\÷,„×Š…A\\j.\Ú`	~I¥\âe\Õ6\àUÀ\×p3ƒ\â\ruþ\Ê\ÍNa—‰¸™\ñ2\æ} M\ñ\'¼®„\æ;Ä¬Ê¨¹%JÔªÔ©Y™2£R¥rzÀûJ›Ž4~7\ï\ê<µ²\Ã\ØK<^	b‰4TzKb\é½\Ô,\ò\÷,\Ý\ÉÀ\ô«\'ŸH¤¥²³½}\Â\Z(\'\÷TË Ç¤Ð¢\öZþ!BšrúÀ³AYV\r9Aj\ÇhÝ¥@™\ë\íÍ¡£š•ZM\ÒS\Ö)B\ä\ÙýJ\×N˜-\Ð0\ð\rU,CÌºÄ«4Aç™š$,¤=s˜\÷\Í)`¡\ñ\é®\Ò\å\ÝM…Ytû™…”a‡bnl†\é0¾H\âÊ²-°TjŒ{@H-Át\ÌÅg>cS\n¿D6q—·˜R›¶\ä\äøƒ²\Ùhb\Þ\ó¯û\ÆFW¸\è£c‹\Ü]\ÞH\á\Å\Ñ\÷•Bab@F\ñUw0%b\r`·¹BQ1˜˜Ç¤§ˆ¸\Ô1X›„w6Nc\ë&qüD\ÍÀ¢T\È\ãr³˜‰P%D\Ô\ò”\Ô\ÐÄ©P\ÊWÿ\0@ÁÔ¶\'†‡–i\Äi˜ZŠª9«¯¸-‚·b|¿©t^¹\Ä/NM7¡¬,j‚Z½(UJD\óv½\â*2\ÎVë›”KC]]]|J+nªd\õ™P&Ax9º\n€\Å£&¿ØŠb!Žw\Î+>\Ñ\ë(,\Å_\öAHd3T¿Ü¦\ðug>ú!|WvBHºt¿ŸHÊ±Ã’x\æ`]\Zµ\nù”¡5J\ÕÁ^G²\Ä\"\Î\ÅK^\Äy·\Å\ØRz\Ís–\ñY¼‡1\ì\î(‹#6\ÆüW ·\ïÔ–\ð\È1»þ¥KSŒ¨ëˆ‹@\ï\Ôv}R\ÄT™AW¿\îbÁ j’f\ÆrøŠ\0-•üøb,·\Ë)`¢hÄ£ar\âPÁ˜b\ð9\Ü3™˜úJqúD`UJ\Ü\Ó\Ì\Úm©]B=\na\ÔN_\àŸÂ¥\\\ÊO\ð\ÒRQ))(™\\»\r.2w[V\ßwPE(_œ\Ô[\n«œ7Z#Â¯‡ »\ÒV%‚b¬³\ïÇ±(¢]–•f¤aƒ—\\\Ø–\ìžØ€\0\è\Æ.h\ðk¡-¿X%³u‚\Ý\ï°P™\ö8 \"†hC/©c)¦\Ús\ì\ç\æ\"\ÖÏ“•@\áÁƒ_Û˜Pqnú²¢\r¢¿¨0:\ç½w(¨QP£o›ƒj:n\ó)€0$H$-d+Ñ\0S|\âÿ\0Pz’À´Wˆ|=úE@ºû_ï¸¢uŽSk4\Ó\Ô08ir\Ã^\Zü\Ã\Ä\íO{Ô¹6\Û!\Ã.‘i\È\òy‰Àq¿´\n8(9\ÆÀd¹\ô†,¯r Œn™“\Ñ-€2\×Rž%D¹l¢i	}\æuü…?\Ã*V wü6¨\ËøT?‚\Ói_\Ã\nþ¡\ò*¯ã˜¥5p,\ì­\ó\Ôq5uF\î°ú|ZSþ˜ ¨6F°w\ï$J8¿wR\ô¡mƒß˜SYS\"/\ÞW•ŽE¼wQ…\ö\Ñ}\"(.\ç˜\Õ\ê\nid2Y}\õ/-ž&P\å.\ñ\êÿ\0\Éi\Ã_YI–0ƒ¿\0U]c\êü\Â‘NA\ólpA`\n]ø\õ¬Á\0l?ýjQ*š+nh3\ÕY\ÞX³¨—aš\Z«jµ½GVú\Ö\ç\Òÿ\0¨\Ë\ZÒ…À\÷m>\êj\íUG\ÞbHi¶@ÿ\0\Ìs¦v\ÐU†ý “šˆ8\Ö\"R\öý\Â~ ²~M-š\Æ\æj,-ÀwŸH\ØR^j¯SUš­µ§95z\õ††¶S_´¬±d3›\ãþJL›P^vsA\Ä\ä5KMo\rr@¨\03G\æ+!\\_ûQL\ÃF€\ã\÷,\rT‘¬\ñ\n\í{–5\È\\F\î/Jƒ“?Â§\Z˜\Z\â\áYWSÁ+\Ä¹X0ü\Â\áV%cR¥T?\Ç1‚.™Šˆ \0\Ùg\â`j·\Ï\í„P#-\×\æþ\"(²R\Ì/\ód\0\ê.¸¯\ÜW˜U7²\Ç\Üc¥+»ø>—6\î¢\ÕR\Ò=\Ðe¬\ÙE\ï\ÅG‡\"€\Ûþb\ß\æ\Ö\ï\Òr°¨/§šŠ0\Åzš \Ê.b\æ6v=>\ò¿«+\ã[po@œZ_\ñ	4‹/>3\0„\ð.\ïŒT\Ò`ƒEÖ¦«y`¬5»\ã\â(…x\Ñ~¾± ˜2R}Ä‰Di\0}ya»Ž\ÓÂ‚\õµƒ£X\Æ\Þ&b±\Ë\"\ä\Î=Ê‰Yf\Ïb£F\0\Ó^<\Ë5Žq¼\Öq¢ 5fÀ\Ð\ä¼\Ìµ—‡\ï\â*\Ó\á\Ö\ów\Ç\Ã,$°8\Êÿ\0¼\ÇÁD±‘wŸx;4T\ô\ZueEf ´¾\ßÔµ9\æ[\õ_\ÜxpV³;“¬¡;\çˆ\ß\Ë\å¼\Õc\Ò$!\Õ\óZ=`Ð®¥›r•Ç™|»\Ê\ÍS\Í	PY‚¾5\æ\n\0\\\ì­\ôŽ\á¤Ü«1i€$X›•ú\Ìd\Þ\å¦C\áü<%†\Z‰œ\ÂW\Ì\Ôy„ |Á\âh¨\ÂT fUJ•¥JˆY\Ë5\âkA\éb•¨dl¼n¸€Ë‡«‚qB°½+lJ\Ñf\ÊŸ\×\ÙU0ü¬ùø‡S\÷¾\nw~°z•»Z\ÍLh-\ö?1Ý Zÿ\0¯i¡)T³[\õ\ß\Ì|)U\Øxÿ\0f0#·;†€•C\\Ä¶³no¢V·V\Ôkg\ç\ói§ùr\ÅB£¸)E«ù¹À\Î\ær\ë\ãÿ\0\'H\Ñ\ì\ßQAp\ä¨h ±Jù†*,^\í«­|Áp\ÖP\Ë\ì…\Û\Ý-\ô\í\õbt\Ût5Û©C_µÁq\0\ÕDx\ÝúKtÚ‡ùh¸&\ÜI¢y\ó\0\â\È¡»¨\òi\ê¾\\[Ax(\×W\\\çˆ\á)e!XÎ¯\Ök©{L5P\Ä\Érr\ãEÁ\'	Atª\â\0„Z\ÜS#Ú²¦„\ÆMy\õƒ˜&¥’½Gþb\ÒÎ•Z«G\æv»!–«¶ã°Š\å¨\÷\å˜|\ôM\îú\Ýy\Å\Ê\Z‹-o;\õJA%•2|g\Îf‹26a]a¾&a{°©ß«¼fSr ¨\÷_\åJÀF\Ò[n-qr¥\Û{šŠ•\Ëo>‘A†(\Þ0Ï´_\ô\â\ó{}>!<˜C<]Lb“¬8\r\Ê( \\+vu\Ï1\Ô\×G\Ïr»‚\0=Z#\ó&–|œÎª\Åp¼u8y‡cø™\nBl%\\\áÿ\0Àß¨@w@˜J•MG²/±ª×˜\à\Ãi±	\ns\Ó\áŽf‹Ï¤4\ÎaR¯.s.\n—bþ˜\íRŽ\Ìg¶Ø\à¸‰pœ\n\Û8}bÃ¸\nNn\\\æP¾?\ÜL0\ã\×P\åB”5,±­S¸fz@¬\0¼o\ño´_þÂºÖ‹¯\óp\ô+¢¬\Ú0ƒb§q€\Ò#w\ÉÏ¤»1kC’\\y\0\ï\Ìn)nD4k?˜;˜r‡T5¬\õ\ó\çˆZÑ¸p\á!bWÿ\0c`W#Ý–¡‚\ë§|D^ÁV\ëüƒ(\Z?k\Äe\å`5½Y\÷\0m™BŸJ¡\çx‰m\Èg\æ €Š`µy\ÇxŒù\Z\Øz\çˆ\ÜA\ê\Õh\ÔF¼[n‹\æ“,fB»0\çTm\ó\è!¬Š\çÁ\ê\0ŠDlPx-ú—D`pùœ?\ìQ4¬iC9|\\	Ó©\èÕž…C&Î©\ÞoûŠ€\åc \ã\æ\"Z´\àm·ž\ñ¾\Ý\ÌOGü™\÷y€\Úüx\òÀ\ó>­?\î5uRS*¦\â0\Ñ^<Oü•- ¤o/wz\îÃœFYýª$VŒÿ\0½¡<£X6ùe\éd¶øcÿ\0P¤\Ë\íŠb\Ö\÷_\Ê9\îƒlVSVì©„\îø-¬—6\õ®‹\÷ŠR¾\Z\Êa•\Å5y¶¯ØŒ+j½\×8 \ÔyøƒPW…8\Îb`$H\Úk‡V96zœM¦N\á\Ô¨R €•ˆ¡*.\0>X€±.\Æ$¯-\Ü]wVD«q>4úJ°\ê¯\Â\×^°9Šh\êÿ\0?R—/`\0\ö«\ë\õ8p¡*D\ÌX´\âÊºg\Äi\"\Ê9Ö®1s‹½\Õ5[3¥\r‰G¿û™hd4ü’\âlb°¸ 1\ö¦4\ËB	¨P¦¿ZP\ÝY\\u\ÆE\Ñ]\Ö\÷z\ãq\Ãer‘³\õ\Â\às\r‡\ÅJÁ»\É\Ä.¦´™ÿ\0xŠ$c®_ù¸¬£\Ï\õYƒÁ8æ¢Š\ÉhPPr½\ÄK#lb\ï\æ\ã\ÑD5\çÞ½ \Ê \Ö\Þ%\ãU\Ì\ë\Ò\Ög[xˆ\ÈšZ\ê\à\ßº5ù–Ä½t\â\ë\ójp2\ÎW\é\Ì@´@À\Æi’ùT¥©/Ež\à\î@\ð—^Ñ‹XW9ü .¡´@zE\Ù1S\Æw]ÿ\0È¦6•–\Z±Z¯©h›Æ‡‹\ÕKX#GXªÞ¥{uì»»ƒl%a\Øú\÷\â^¯Â€Á­À°­Šü’ \Ív\Ü\ó.\é°\'´*<W\Ì\ð%ÚŸÝ¹\Ãw\ÐKÁ{m\Ö\ìßŠ¸³c}k˜LÄ­q¬s\éÛ®€œ\ì\ä\õ\r\Éc[ãˆ¡\Ó+E>=\ÜF‚›¿%x½À\Ú\Z·±kt=e¬Q\Úùú„.Qvw,B{\Êl˜\0%Ç©ÿ\0²\Òa¡€\ã\ÓL\Åû1\Õ2¨J\ÃkV\Þw\n(Q\nµ\ë\Ç|\ÌU¨D\í<EC@°QR±\Æ\ó/T\æýž}\àU#%\'©þ ‘\è–\Ñ\ÑYr\Ì\â\È\Òj\Îik£P\Ä\ì\×£ÕL\Ølþ¡Ã˜ƒP\'Î¡¬@\Ä\â3\0´«©y`X_n¦2˜’\Ö<\ñÿ\0bWo[Hœø:!Wÿ\0%W\×\0£?ù\n’P°½ÙJú”f†«\Ûir`.Š?\óqÊ±\Ñ[\ÇR\Ôxy\Î<K,¤ »qµ¯H\ò\õ\í\ëúb\ð\ÊØ».ª¸¢h•µ\õ\ôýJY\Ë\ÉE\Õü|\Ë\Í$P¹EÖ½eºSb€»¾\ï\ÅF†\é\ÉtŒ¨<¶\Ë&þ%…f\á-rk\Ç\î’E†ù\ÇûH¨º\0º·Ü²2gV‡qŒà³¬\ã\ñ\0Ž@\Zÿ\0œ\ÄI‚³êº\ð\Ò\Ù[§Û˜P\ÈSž£r­\rhG¿I—\Ï.\ìÆ«“;”{\Ì(\Û\å7®\Ùrª\Ù\óe@›\ì-tÖµ\ÜZÁ¤G&_\ÌA\ZžwW\ê\\¦P¥•\ìM\Æv^©¿2˜V¾ˆP]\n\ð\ó® ‡©–tW\æ!\"‹%×–h(x\Ê\âX\Ã:\Ç\â`/s\êts¸H\ÑZ\Ø>B‚8œ=¨\ã˜\ÙrÒµ\õpE’º\ß\à}#*žb\Í\Ë\àtµ£«wu©V\ØkRœ\Å\ØW\'\Ó-\ÙNù\ñ­DMC‹Š\ç\Ï\n\íþ±p\Ô7°±øû\ñ\n»·?/x¨g&[~\å0\ñN+y£\ñµ’·¯|D.ZïšC*œ«n\Ý/j^0\ÉY£«\ÇþÃµ¼-qg^±°D\Ö\È\ë›\æ\ôE\0°–•Wº 9\ØAˆ\õWwg<\õ¥„•9U\Ñ\éè…‡;«§\ó-$\Ý3}\Ü-GD6]c‡®!T\Ú\0 u\Ü\r;ƒ(¡\áÁy\Ìr/%\Z\ÍúE:+H°\õ\ó/\Ç\"\ô¿hª«8~_¸\'%ýJý@fOXâ¼\Ä&iD¤ÏˆÀ+’\Î.\Zd,H1ªË—A¼<Á\ï\Õw¥\ä™G\n¯-¦ø\ÔLe\ès¯HÁÝ€[\á\×R\Ñq³v¸å¸¦’¤\Ñ\È>n0\àV¢\Z¤hŠ‰³}/¿\Â#3K·\É\Ühs°ÿ\0¹Ž©PidÎŒ\Ç\0¥¿&\ØÝš2\Ð\â¯\Ö\r…*•‡\Æ<W½\ÆhM\r\"§ü¢\\\Ð*\r\ï‚73‘›\äk‰Cg!¦¼»ˆPLš†dÍ°\nÆ¯ƒ\Ò]W\Èl¿ù*\Ö=V;5	+rƒx:üÀ7¬‚§-\÷¨\õ\Äi\Ç-\÷\0º›-e_¹{Þ©G\Õ}\ógngƒ\ì6\ô{ÁR­™\ÝyƒÈ«\ZS¯iœ3\íºÿ\0n–Kv\ï\Û\ñ¸\Õ\É\ì3\â 2(Ú³2¢„\È,s_\ïÁCÇ´`Z\"\Û\òq©A½³›=\âbƒM]Qqq\÷ \Ø\ß\â\Ê\ðŒ\ö¾B³+T¿1(‹¨R\õ\æ\àù°\ô(sý\Ä_PøUpc\Ô.\Ù^\Î0·#\à\×9`\ÔZ*›])Ç» …Vü\è\î_1#u´¨Ð•\Ú¼m®\ãžµ=%„KU\Z\å\ê#¾p\ÛÞ¹ƒ†RÓƒR\Ì\âVg©o/˜R¡\Õ\0y^\Ùg0\Å/¨#m\à»f\É\Ë\éß‡¿2\í\ÄÁT\Ç\ÏZŠ\Êº\ãl¡\÷9}J4V\ñ{s7AL¹U.º\ö › k[»\ó\à–‡ -®}•-§#\õ\0\Ë_¬°89W0mT\ZT[±fUƒ+ù\ñ+h ”V5n{%\ë\à\ÕÆ–\àsˆ¾\ÍÛ³`wÏ´0×²\í\ðƒ\î\âg)SK\ô\æ\"²¬”0w‰Gn­#i‹\ÕÀ¥’9þ·.\r,†ú˜‚œ\â\ÊÁ0ü~#G8KN±\ÜH³J[\ÎÓœ\õ\Õ\Ëø TU‚‘ª*~&o\Ð#³\ÙýJw>\\\Ù\Ô»;”º™˜d~\â7³fhYP2[—Ž~e©\ÇkÒŸXH\ä6N/\Æ\â\Ôp\æWÇ¶\àCJ6*¯^Û•QL•¥n-Á\Å+?lL/–^~|f)A°\ä9—=AC•;\ñ\æ\n\0Àq^Ò Ž\Æ¬¼¼Ã€O7F+Ñ›\Økj•É†UÔ¶¢\Ìÿ\0±.;5\0°§9»\õ\Æ%\"+\r–S\Ò;u¸³¯˜A\r±¾¥³k„ªûŠÀ†&K*\Î\ÐYcAø\÷ˆg*°\óGý‹ \n6tb½x\ôŒ¡i4¡Õž¯\Ô:\Æ\\_Aˆ\÷J`üÿ\0\Èz¶-\×°…s\ßYýE¼™/–ý\átÀ.¼ƒÚŠH@\ÚJÿ\0\È\òVVe[k=\nÿ\0s30X^³\Ç\â\n\ÑKD-4žrk\×Qrµ\ð|@´z\ÔÆ£%uX8§\ê][€e2d}˜$XiU}ûK$B+\ßU\çR\õ&Œ\è\à:¾`p\ÈP\Ã\Î!\íwHgN¡\òß´­„>€L:‡Lå“£\Äg8:ª¾:\Ô.\èHûÃ®\"J†–\Ç\Z\âR”Åž\î:˜6€¨–^¿\ðql{p\ó\ãL•G4œGû/,¶R[\ÑE\æ\Þe\Þ-ƒŸD<r\Ö\ã0…C)\Ðë»”»Lœº”@W,]ª\õŽ\õtuAq\åûE€\Ök˜md\'P\ãû…¸#«À¼ÅF­bÅ©Á,…¹™ªº¼\ï™j\Úk“\êj¬XU¥\ñO2ú™J\"\î¯¹‹ª}\0\ñœ¿˜\"4\Æ5E\Ã\é¬\öù‚\Õi·¯\Ô\Ø9\ÓV9Ì¤ý©\Z_NÀü0ºV2¢¯G[ž²d°\ìÇ´-\n\âd¯ºsb\ó\Ë0\Ð-\ñúûŽ/DlS­U\â/v\ß:Œ¬cfuV@ \ã\ÜË‡B\æV­°\r5\×Ì²Z”\Û\æ\à6\éVXs¼qlª\Ú\Ðã²—\Ó1½UlU\÷Fº«\ò\ÄZ]£ww®ø0{<»\n\Ð\ã*\ê¿Û†@-Ci¥}Kø\Û\Æ}£ŽvÀ(¡¯\Ãi+K….\Ï\Ô,\Éwb«H³Á„f¾\ÌÁ€¾\ô–|J#[¡–rJV½\ç6ÿ\0¼G0x^•þaË£,v.]\ÔÅ´\å™\ë\Ì­ae^W!Ÿ0\å)\ßuªw¨ \íFME¡kx¼×Ž7™¯O«­\Z6D¿h9f~B9›°é°žD…0žb¤W…p?ø”\0¥*Žz†Q6Šµø‚È½rk-k¸¢\áTUP\ÞÐˆ\Ä\ÎÀÁe~b\Ò\Ú«º\Í\×x\ÜE[WþEú4F\Í><@B]h\Öý!\Ì\Åk\Ýc\÷À k/¸K± ÿ\0® \Â\Ër6¿ˆ@6k\Ô\0gÆ¿\öŸ9F\óª\ðbl\Ø24b4\êÖ’ \î\'.\èp~b•þfŸ:ž‡p%Ï­§\ÖTYf\ÂEL­Š¬4zE\Ò\Ùb:Œ\ra\r\ðL\Å&\à^¼K‘²\n·\ÃQ\ô`=˜\à†\×/£F\Z\õ•«¶c\ÌÈ’-@\Ï’¢P±-zB„ªŠ&{“2ù°ì²œƒ/\ÄQ*dr\ó]yŠD‡‡Œ\ó]ÁU~k|\Æ\ìN\Í\n\à¬@VP \òr¬]J‹Bû/¬\ZgÀ\à\Ü \n9&\ß\ò\ZuV\Ì>Ä¾\è\ä	nQ¯h\Ñ2Q\"º\êerr·r\â\ÃV\ìüúÁ\ÃHZ‡=Y \ÜAËŒQù”µ\á\Ôz\Ä!¢œTpvq˜”\Ö\Õ¹ýù!˜m\ÉuÆ«p\çcÇ½\Ê*”¢\èqþø‡n\Ü\Ú\Èx«Œ8Ywy—\ö ª±‹xÿ\0¤OtsL\ËEƒÿ\0~ã•žt›—S\ô\Z½øCKVoŸ¨\0‘4½UµYR\Å\0«¬w\ò[UQ…z\ñ˜V( £akn)Â®kv+\ïQw¤-p]ŒMP6›×¾1.…¦\è\ì_\ãÌ¡\Â\áTÓ…<\ÅqA\Äa]A\êlùÜ¦\ð\ÌÀÞ¿¸‡ v~þe±\ÐEIl~\à!RŒMˆ×¸+žspÖ«n!@.€\r!\æ\'Š¥L\Ø>½\à8KU^ûg…[C¾nþaÖ¨£·:ß¬pj\ÞJ\ö\ß­Yú»\ô–kT\Û\Ë_€»B\Ú\ë\ó)¨-š\å\õŒp&e\ï$\Ï\ÓM\'O›\Éú\"Ú¯4ûD±,#°\Ö5-\á›\ê$e†0/\ÍG¨	K­g1´À&\ãV\ãuÔ¥%¥l½W¬\ÊG‰h¿\õ\æ\ëÃ¼x\ê[‚ž?û¨V]%wþ!\Ïdª>o\ÌH.\ÕX\rn\È\ÉG-PùŠ\Ú%h\é\à\óPÊ±¯/3\ØJ\0¿8™Y.]_†4\\\0ª\÷•hœª\öTÃ«A\êf\nwwx\äÁ\Í_JŠ)¼V*/¬¤	|-ß¿\ê(ÁN/¥½Rƒ\ï‹b9!“\ä\Û8!¬‹\Ã?˜\ÙÅ E\÷;©\Ü\Ò\Ð\æ\ó¯\Ä\Ø\ÑW4\ÍnÐ¶¥,P^/G\ÜpÚˆ7¾•\åa	FmS\ÖW1­ÀZž¥\n\ÊjQ\ö3ù–f›3þ\Ü\'\Ò!ëº©U\ÙÍ·\È~`[{§U~\ÄK \Ìc§²>µ›\ã—ƒJ\ô³”\õ\\)\ê\È\Û\â¿s)›‰‡üŒª¹©A||FÕ«M@y/\ê+E.Š8ß«85¡\Ò<¼E¡@\ï\öKUsKª\åüÊœ…T»>\î5deÇŽ\ê\á(3b¦\×oŽ¼°\ÑC\Ó^c\è\ÃÖ—dˆR\õ\åi\ñ’’\ÕL›ŒS6ú\'¿\æY¸®¹ºz\Ü\0\ÕVÁ\Ðû8¨•	\î²?ˆ@\Ó˜r?,UsŸmCŽwÒ\Ï\ê¦›}mtlF+L:o-Vxü0;š¯\ÞWùý\Ë	U+\á\â$6!µ·üegc²x¬K-‹Tºº\Ü\Ä>Á\Í\æ”\ñ-©†^·\ñ\03ß·°\æSU\0—:v\Ôh…00;Kü{Kp\Ý=G(Šv\÷ÿ\0\n—¥±›\ÓgÉ‰Œ”¬\í¿\÷˜KY]ŒK.\0r\Õø\ÕûËý›µªXŠ»Qc–½˜\ÝË­g\Ì;\ö‹«Šj,ssXÿ\0u*š3û\ÜÀ^ ˆš\áë¸¢\×uUZaE\Ú`¸Z6–\î\õž¨‚«\0\ï„­µ[Ô¥Nq{q¶\\\ÎEi¿\÷\õ•§G\÷7‘YÅŸ™DXl;ûŽ5Lr¼cª‚U\0rtzFE@\Ò\Û+ŸN¡`´Py\Ô)Sj,b¹©KPz…uljªa—\Ìv@¾J¿‹¦N\\wR\ë\Ú\Þ/?lº\Ò ý\ó\ç\á\Èø” <.°\á=·ø8‰¥kš]{Ì·“t›\Ì\Îk 1~Ne¡U¯¹ƒ€JqÄ¡} ‹Ç€7*±\åP\ÈR<T¯V0uƒˆÑL>ÿ\00+VK\ðF\ò6(<f%M\Æ\Æ\÷\Ý\÷)d.EŠªÉˆXN5\ËÉ°–_d\"žþ{†z\à*¼x\Ì\Z\à)Ž«½KL»wŒU»¬«\î¥™7\ÆS.»œŠ\æH§ú;Vª\Ýr\æ\'\"\é \Ø\æÞ\Êì¨¼Œt¦Ð––\Ýø‹\0¦ JÕŒ\n\ìÝ¬u\Ö\è”a“F\"XÒ¨¶ˆ‰Tv´.¾#C“\n\Ö3\ñ\Ô\Ô\Ðu_Rˆ‘±·Ÿ\ö¢<\Ø¶“U†^™\Z\0\ëŒø”à±¾‡{\ÅR\Ô­k©…m\Êá§ˆª%#9ÁûÜ¤†]¼S\Ç[›\ímfù9*\nœ@`§QIE55°±¨¼”©»S>†\"›«\ËU\ã\×>c©¥\È\ë\ÞrdxV¬\÷—\Ð#³x^k\â\r \ëd»\nF\Þâª‘§L\äO¹@\ß.(<nV\Ð\\Š&J)F‚\ñ6¡lƒ\Ò>SzsT\ò\Ã;y\Õÿ\0\Ø~¼\ñ\Â\Îw}\öJ:Q¡\×\æ%\ÜÒŸK—\ï\ÚtˆÀq\ß2\Æ\ÛÊœ\×qÁ\ÇVy_þ\Å\0y\n\Ôm!\í)°(¿o\ÄH\n,\ß^Ÿ™®7JuW\ÌE€evœ\ã\Ãp\Êi\ÞÀˆ\äè¬¦\Úü\â3ch\äO\ñP[*\Õ\ò7 \óßˆ\îz\àŸ\êa>´-F°²ý/Û˜\í\å3£;q\Åc\×u\â\ê!\0S`gQB6\Ý\Þ©V(¶y\ö™¢X±yH\ê\n¶\ÉO©R\áR+.o—\Ò_]„±Ëž#K;\ZF\ß:˜F- u¨¯Ao\î\rg@6\Þ\Û\è\0¥%\Õ\Ò]6­½¢ ˆjCÁ*¶‡\"\ç\êW-º5²\ñ–jª‡¬\ZÀ\Ùa Xª\Â\"‰yY\õV­‡\â 6`ú\Ãe\ÎV\ö5\ò,gÄµ€¤£šÇ˜”Q.­`‚ù£1g@\Ët<S*T°\Ðf	€«^\\Ä©[[M\Â\Åj)Ö“˜£Š\ZV1\Ñ\ÇNE³“^½ø…-£\Ù+—\Ú\rz8§2\na\æS\Û· LÀ\ó ˆ\Õ\é¡\ë\Öe½\×\ÜnV0§ÁÙ¨ ˆ\ì\ð\\T\n¡gV¾-³\Ò%¡³cp\Ì0,\Ð\ÞOŸ¨–¨½v\'?q\é|m‚\óÿ\0\"©t¶Û³\Î5ƒX<T·\à¡,Ž{w\n\ö¼5\0­ù7Xšâ¡Ÿ»Ž\Å\à–+Tz\\D*\ÖAÏ§¬ªe–¬.\é\ã^\ó@™wß´D\Ð\Ø\Å\êŠ;†\Ã[¸Œ\Ö>M×µ@\â\n”(\Ûx\ó¬Â•\ZM\îýnP†û³a\Ô\0‡OYs\æ-c\ÌJÛˆ\\]<ù”#¸C¬\òC¤#6Zÿ\0º‚JB\ë\×ÖˆƒP‘«P+GÔ \ì®]y@”Q•\Ý\Ë>Hs\Ún¹`\â¡T¤O²o’¬oƒŸ¨B²“n)o\æ3ÀX)·¹\É%\ô+UÎ®)Z\ØO\'PÕŠ\â•_P«¤U\'ù–U˜\àQ\Ó\â jg\Ìý<Lv3\ÑNüfX2cm\Z\ß\ê(\02¦®%¶k–\Ûú¨ŠZ\ã\Ð@\ò(ICœ¼Á\"\ÔQhºý1\ßü+\É\\´\Þ\Z`\Õ\Òx\ßÔ¬\ão‡:\ól™ kWqƒ\ñ8\åœ<Áw™hˆ‹X\ñ¯™qb\Ü\0¼[¸UQ\î{¬54!¼]\æú;‡\ÅfU\í).TJúW5\æc\îq”\ñ€\âk\Ù\ð¨	†Es¨a\â¸lB\ðà¡¡¯X¨-\Ì-o˜\nm«‡¹–\â¢ü+®e\í:”ù¸Z2SE\ï˜T´´„^A\r…3Œù€£Sg³Œ”H\nD\"±r\ëX\n+À\Øb®£±»\ó(.\õL	o—G,D¥b&D\È\Ö\ëú\óÛ„\õŽž»\Z^1!#1•\âª\n j\Ýu¹’\Î9W5\Ä*š%QB¾*¹²â˜Œc\ÍZ3\äm}¡\Î\ÙÀû¨\Ë\Z†AqZ\çqp*\ÍQüy–Z==V½œ\Âº\×`\ç\Ò5@—¤\ï\"¡z\n¨pÜ©°4\Ø8\ÂÊ¹Âš³\ÈüÄ©6Y/;û‰Q-e\ã³=\ÆHÀ†©rš©°(\ñ˜x7F\ÓO›\Ï\Ä\0•F\Ö\à\í³]\Ìfj=$HaJå¢•]W:ˆƒ-f‹¿\Ìro\ÍKw\é\ó+¥–ÖŽ\ò(!¼\Ù\ñ*À)\æÞ\Ùhth+\ÈþüC*·A\ö”\áR°\è\æ;]¬¡ÿ\0—bØ‚¦|kvˆixÞ¿¹‚Í‚\ÂW=Ž¦§Q\à>hŽ“G\n~!\ìh\ó\ÌX,VÁEùzüÌ­©Ÿ!\ò\Ñ:cM\î—[‹””p™}8¨B\0Q6—N‰a‘u•r\î\ó\éÊªX\ê\Õ\öÿ\0°\'\rƒ9¢\òËˆ;4\îm–\ÈF\îý\â\ÇSm\å\õÁ–\Ô`\Ç\âªY1j\Íÿ\0q\ØIy?r\ÏpX\n7\ß\ÌNrþ\ñj\ç+ú\Ï\â\à[.\à¢˜_\Þß€¼\ãúüÅ°ã®Ž§$Å„Ç–!B©}	\Ç\Üf¡C‘\å\â^\0Ñ®Ø¿‡\ê<É  ýLŠP\Ä»\Úû\âYˆ\0t.Þ†4Á(¡\"\Ê\åm\òGN\Ìn€\Ô)S°\æZ¯ù7\Ò vúQpÊŒ\Äs\è9™\ëcE\÷†@\î†\Ð}\åýD\à™\õ‚M7\î0\rn§\ë\Þd‘\\²¯Pþ¡\Æ \âŒ/¸ˆ†Á3\ö6rþ\"\âT––ù€t…td<yŽ^v\ö\ó„R97£¨\Ô5Ä•h\ÑffYÁŸ˜ti\éEuÀYx\ÖyCrªYŽÅ½*!m+?>X¦\ðZh_û¹[Hc/´xŽù\Ü\ÌK\Ô\Ö\éû•þTµQŠç˜ Ye±šh/\ÌRºl™T|D·n\ê½7¨x®À\r\æ6Ì’\Ñ\nf/”šv¦¼È‚,™6\\‡f\"\ó\nØºo¡\í\"°\ZÉ˜\ØÙ»\Ôh«\ãR\Åer_‹¸À±{Å™ú	~‚\Ì(‡Ip\î8|¹C\Î7kµš\Å3›V‰\Ãg>ÿ\0R¹V\Ë\r/\õ*›Š‡žÿ\0phƒ0\Ù\ÇU\r™\0l<ÿ\0\ßHkn\n®¢¥­r®j\ÅBƒfWÓˆ\"N–.RjŠ\å-[\\š\ñ\é([ÁUŽ©j 4\Úú\0SAq\Æ\â<ª\ÎˆŠ+¢\å%\ÅRŠsXNÉ]b€o©}\0©o8”G›‡¿ImnŽ\\D\r¶\ÐejŒW\â`.ZX þ¥ƒdX@B\ò;G¸PS²\ìqˆ\ô\Öyßˆû«-›ªæ¡£¸ £\Æo\Ï1{…\Ëv\í‰Iú‹/qm :—É\ËxŒ½J\ÎÙ‰TYx>SpHÊ«¬\ñ\íQcPvXÜ°\ÊÀ®¸ŽX\0füŒ®PK›%}K\0Æƒ\ÎR©rYmýFÚ”\Âþ·\0rG‚iÇ)\äcDfŸ¨\ØÆª\Ê?i›¦\Ü\Ò9\ñ\ÄP\ëT5\ÜZ9JS\ÖQ\Û	\\rhJ5Ÿˆ–\Ã®¸%D\Ö`ªRª¡´¤¾û‹”ZÀ_4w)\Â\Ò1ÀŽ\ëc<\Ú\î\ç‰i\Õ9XP€\Óm<w\ÜH,]\×UŸ2À3@Ù¦\"\r\Ö8ùû„2eŠ\n\è€»O¯hVs^\n\Ä~«M;\Û\Ôu¿•Ö¯H€®B·ÁoLt®H‹\ßz5œã©•D[h\ê^(…«¿:ü@0‹¡¾(üyˆcx2,¦\Èvì˜»D\á\öúP l.\ò|\\\äÀ¨\ô—\ï¯ˆ\Ìq@ý\â¬\Ðaef`Q¼\Ýùï¹ªaEµÁý\Äx§°\Ý{Ë±\î\ÚË­ÿ\0³€Ešrûs;#±MfyMgÔ‰\à\à{~\êþ\áúv†µ\æZ³\È2³\ænƒ5N½81T	\ç|¹\í+\æ	‰U\íÍŸ†Ä¼„ 9\Î<Lp†\Ìzw™j«ƒ–«qÀ½—þ.0\õ|7\õˆ,³®ý\â	—­³\Ô|žÚ²<s/†‚—ù•:ir\á\â\ï\ê5VS‡ÑU\ñ´cù\n\íºl\\Á½•qf\ë7Æ´·…ß‹S\à~L\Ü\ð¡{\â	Š…¸QÍŠrŽ<fV£¡±zn»\Ü\È—‰u(¼™D«úª‚¥Ýžù\òk\Ó0‚‹7Ÿ\ífXÏ}L˜)pÜ²n\Å\Õ\ÞRrT6f\ñ\ËZ8ZZ\Ï\ê!EH\é¯Áu\ìF¶D\'\ë\ã\ó(3CH9\Ï\ÊüK\ÑKwŠ\æ¾&\ß-#z\Æ\ñ(J§U\ÇQ\à\n¹\õ•u†@\Þþb;’ß—µBz„¾q¯’\å7EU.\î\ö\Üd¸\Ö\×ã·ž&<\Ä²½ÿ\0p¢…r\ÙýÅ¾”³\ã\âU²ùÁZ_~#J\ë®\å\î¼Le©\"\çQkU‘ñ•€—7\Û\õ„\È\ÈY‘\éN\ÒG¤Jn¤¬H(­\ò	\0\Ãc¶³\0šÀ¼x\õ‰	Ñ–úº\ÜS(7±@Ø—\á\Ó|@—KOý–Z@XÅ•¯©™R…jÏ‰v“’µŒ\×QÊ¬\Ä\Ð,°}X¨¼\Ûî‚­¼ª¸ù+y\êª4YVZ\Ú\ç\ô\ËU‰\ìƒ^‘Š¼˜iE½\ô#\Å<~ú\ñ/w€.œW]\êo¹.Š\rw\É%€X?<q1\Ò\Z}\âC´m\ÖuIû™D\öZž\Ç2‰\r\nT\ä¿-Á\ï¬\\\òüG6×¬7\è„{%\äm8¸Á).‘>ŒÊŸdPZF\Ú\ö>bÁ\ì\÷—¹\èU\Ç \÷ †É¡£\Ë\Ô sg^qL d¾µS]\n\0\Åú\ÏL\"¹\â31À\Íøœ\"¥JBùÒ…31mHP/1\Ø\n”\ÌÔ¶ÿ\0r—iJ»9:·\Þ\"€X\Ö\êfÀ‚ü ¼E]j²¿ýŒ[ê‚F\æŒ/¢q\õ,¼\'/~Ð¸\à8\r\ï2œ$Pa\ï¨y\'>\ó‚\ÊF\\\åú‹\0\Ñ\Ú\õ,1\Î\ã¹\\\Ò\î\ÃU\ZÏ¤šœ5\Æ8ˆ£\\´\Öùù3ˆ\×\ÝCyºøÈ±@Ko?ù«@.\Õÿ\0³µ\ÉxÞŸ5¾a2\ç[æ¸€.ƒq\è+Y\ï:>¥\èUÿ\0^\ðB›M¦ý39·»\÷>e\Ô\äÑ›¶l\àùIa8\Zb\÷™‚\ä\Z-=h•\ìNo\Ñ0\ÈeF\Þ`¡$Wa^rEm¢\ÏC\ò²¹@5\ØûW\Ì\Z‚šow˜51U\Åk\î \" Ë¤ÏŒ\ë\Ä@µ\ì\ê,\Údj¯)Šƒ~\×)@-Ù·7\é\Ð\Ä\r?9˜ Tú`\Ú\Ò?]F\á]ªP!²˜YB\÷\"²€«\Ä\×~\ó$S›h?\ö7|!T½r9 Ÿù‘¶³>\Ð\ÇIW\ö\ÌM92ƒ\ë2ºR\Í\Ñy‰ˆ %z0\rYBcþ\ß\Ô>\Ëh¹E\á€\ÐH½¡åŒˆ·-«\Î=&!_ ··\àÔ²Quœ¯‘£û—P\ïFpÍ»\ê\çaK¬\â¢\Å:V\Ï%\áq\ñ\ÉV\ë=r¿~f,e\Z\Íù\Ü-¦\02X<}\â,¸¥…ù?ù\Ñ\n`¹¥¶8C\â0\Û` [¯F\à€c\Ô/Ÿj©H,‰”Ee-l\ß\Ô)u£§\n€›\ê\ÃþÅ—„\È\â \Ûx¯¨Ic|\\PÁ»o›\Õ\0”&˜(ÿ\0yˆ \Ú\è4ûq\÷*°˜PX~¦\0®£p\íù—G\ö3\ì\Þ\Ïx\Î\Ñp°.v\ÒRßˆT˜ƒJ\ÏÁ\0(Aµ<{À\ÒY\Ø0Vn»…#6¸o­ýKf1¤\à·žåœ±±n\êR”fª\'4W€PX²¨ÁM˜-‰\ë,µ‘\ç\Ú+0\ò\ß/ú¡b6B\ñ\Ç9”P\"j\àM@5(Z\Zh]g¯¨¹\ÅB\Õ\ïÅ–\Ã!\Ù\n¨-—ŸÑ¯0U)P\ç—\Û\÷)\ã±P5ŸFR I\âP¸Z-f\ßhQÓ¸{¸\åƒOt+\Ê\é\ï\Ä\Ë#»OL$lY˜N\Í\n6ú\Â\nŠ¡È£_p‹h£\ó\ÌRT`;¾\êý=eÖ§\"+@\ös\é,v\Zto%{\Å¡uP]ø—_.Uw^[¸(-1½·ÿ\0%½·v¥+ˆu²(œ>\ÜJ\ö\â¯s‹q\ãþA¯\n“kžvFA²DV¡ì²¨ê‘ŽÁ 8xÀrÌ£(\Ö\ß\ÊÅ’À‹\Ã\Øn\n’\ßúŽŠ†²n	$°®\ð°\ÛÑ ›\ô›F(M¯FwÓ˜\ß\\J“\r‚ø%\Ï2V±t\Õ\ê1¦\ìø\ÔIŒ\È\ÇûS*ª^E«\õ…(tw\ï\ó1Nn\Ê{yf‹\Þ\Û~\"Fv€\ëù¸\ÊEA³O\õ\õ/\\\ÙLX*ß¯˜ˆƒ@\Î\ó\âŸµX[\ÖbEg)}?©½l\0my.,;\íM\Õh\Ã\ëFƒ;6wR¡=\È\â\Ó\î4\Ût×³ \ZUZN6s(Ö„t½\ã\Þ+H\Ùþ\Ô)P;­_ûP&\ÙG-Ÿ©[ˆ)=1G!4(¸\Û4\âº\õüJ\0\Ü\è+ŸgiÁKº\á 0\Û!8\à­\äo\ÓC³S~=3\nmW¼\ë\á%¥\ÕUŒ–\Ç\Í&\ò„µ+J¨\è\ôS/\î> B\Û\ÅJ­c\÷.}CƒÖ® y.¥VýHp°]Ü¤\õ’l]qSµ¼~ŸˆD\Ü\n7Ì©,\ÝÀ_ù*\nM\n1£D\Z	¾\ñ\í\Ôp&>³­ž\"\Ì7µc>#el9my>¥¿œ\à\Úúx—+5N{\äÿ\0w1Hh¨ET/Á\Æ;œ\Æ\ñŒ\ÊVk=\Å\0»¼Ÿˆ\ñ¨\"RÖ *?9A-¯k¸\0Ñ¶t\ç\ÄnE(1k`¯F\Í\ÆC}\ÔL´+G;\ñWu3[k¼O‰“š\õˆC\ÅÛ›rÜƒ\ÔB%.’›üÄµ´¥¸+ˆ\Âvn\×¹’@\r†½?Ú˜BÔ¡w\Æ\ÍCsf\ÑG\Ó,Á,Ž²\ß\âZjxdz\àù¨\ô\0·WeüJ g V·§\ç?\ñ\n\Ú\Ùv\ï\î:\ê«T»-üzA(µ”\Ð\ô\ï\æ\0š€†«¯¨bD¡ \Ô1´!\Ìþª0Ê½\å{1ÂSL¯V\æ,\à¼/y™x:Â¨¬co’\Í\n·y¬u.E4\Ë\é\Ô\Ø—o­Î¥Q‡0ÁYfFýf\ÙKÓ˜IÀ\Þ(¸\Ê\ñ\ÄS•(•\ê\ó\ï\Üu@\n´\×U\ZÎ¶a\õþ\àKB*\Ñ\\\âcl²Œþ¬eÈ¯ø–j	›\Z)D\ärFŒ\0S[†œ–|x‚\"¬¥š\ÄMjS\Äug\\\Ç\ÈQ\æ›\È\ñ\÷ƒ«œ?¯Y‚QT8q§‡_˜k®(t™\ÙkÀý•‚\ó|\ñ¹V\ÂÀÑ´2·ì™H”Åš¼ù\â\r(Qœµ_¿2–h\ã\Ò\Z©\ç\\nP\ÝJ\Âq\Ï\Õ\Ì\É\ÜY£jR\ñR­©llLW’^z•X¾M¿wƒ\èû×¼\ç/\nº\ó\Ù¢™¯¸\ÅM\Øq|9Žœ%\Ø\ä0\ÊÁ°\Þ\ê\÷\ÜªÝ†ƒ°\î\àj†Ÿ>…Ä’9…±®\Ú-^«\ËÙ”-Ÿ«¢ \àÿ\0¼Æ¸wVi\ï\÷–K\Õ\n\È+5ù—!K\ñ]Êµ)1—^\ñ\Íf(6±\ã\÷,†TjŠÍ’\ï ‡‹\ã\ï\ê\0–	Gb%bŠ½{\êY€´wt³ú”\ðJx\×0,\Ãt1)h\ãb;\èÄ·„?Jl®\ß\Ûæ˜¬–\âmZ—›c½z\Êú„n\Ú~el\å\Û\ò\Ä\Ø\÷©j¦°kü\Ã`¨f\ò\á^a€§;1G®\È\Û\ÊÚ½Á\õ±‘Š\ÑG\Z>\ã\r]\Ø2­_\Ô/³@2\ë2³šXÅ¦­Q£’_EN¶ý¡u7¬yqbo0™+¡T\Øs\ðJ…\Çc*—\Í\Ù3 \n\÷®sK‡h\óŸ¦^|(wF}\ÌE #h¹·\Å{B˜\ÛV¡Žý\ö@½\Î\è¥ü°\ç²El\ß?\Ó%U\í¯·\â¸oB¯\ÜdhN#\"Y\áUùƒBBŸ¢*]®\ó\ö\êY¶Œ×¬\Ã2”­º\Ì\Üí…§·´F\é–V\è\ÍMqº\nÊƒ]^\ò¸K@´\r]JJ\å\Õt‹p\ÃMZ\å‹HU4vx\ÌÀ^%bùœF\òli:¸e\0À­=ú\ÇYEÀˆ•¥‚\ïúšøP\èÿ\0\ßK\Û\r\ñ\Ä\ÚT*\Öx\ÏûQ\Ð/’pQ\÷ÿ\0`(8µ~¡qPm^¸\ö\Îm\'•\å…3S9\òü\Ä]F±[„\É&\íi¼Q\Ö\"º¸»4o1\Ú.ƒ•\ô„J¶k\Ûs\n‹~Ò¬S	eu´v!ž;Ž\ð\÷6ú\êú€®¯\ó\Ä\òa¤qˆ[šK‚ù[·¸±pq˜ž\n0‹l\Ü\Â	2Gs\Ç\r\Ûug§\÷j¤o€ªU¸>³))†TªÀ[,\ê^\ë*\Ãvx\ô›\æ\Þ;jl)nS\äø‡”° ´þ\ñ®lBXZ¯ùŒý\ê³k_PF%¸\Ï\ÜPVQ‡\Þ\Ò×’0\0‘Kv\å3\õ\ó\ì»eº­²\ÌÁXhº/\æ!U\\\é\é\ÌZ\Ø\nUqŠJz\\f\Ò\rzkÝ‚H#Ur\×\Íb¿W\ï\Ìjg—X%~¥\å\òv\à\å}\Ø*i9É\ô6À>¸Ž³\Ð)\ÌapÂ¾~\á¢zU\ê£b\ð[\ð\×\Ô	]Ö¸V¹\öýFV\Ê5UÁ¹|„<‹Jž+\èm\"C“\Üÿ\0n!•qK\Ñ:8_O6}D\Òh`‚\ñ\à…±¹iE\Çüy€Ñ´\Æ\Æ\é\ñ’NXX0Ï¾\åš\n9¢J\ç\Ö\íÀ\r»rûJ5ü\Î+Ù‚Y])gÖ-µ\Ü1žW¼°`\ñ¦@\\{\Ó\Ò\Ñ\Ô]š=1(ªw„\öüJC­€rù»ˆX4+©Ç²üC+®ø.O´a@e=,ü \î5v\ê}Ë‚C#b!t§[m\Ñ}f\rŠB\Íkˆ°jûW\õ2(N6\Çû1i\ÏT2=?\Z‡\\¨H=¦ 4\ñ~%„KŽj\rÕ°s‡\Ú,\Ì*t¹\ã¼C.Ž%]blK\Ú\ÝWKdFL¢»ú•\ð°1YÎ \å`/V\ës\â}\\)Ž*B¥´h½\ôJ]\ÈK»\ö—$\èÞ»\ê\æ\â•L\ôg\ô„[@‚Æ«ˆ\êý•K\å\ÑL@\n.r1\õ¦Òšg/ß–TU«H#!–Qã¯™v2\0gOJ5\ZhdŽ5À`ƒ@ —G#x\Ä\Z—\È\å®73(Û€o†\í¦^_˜{\Í>S>\ð+`U\æ Mª®¢¢\nKÙ›I]’Œ·Ú‚a\â°qWŸ¨ø¬£T,A‡œ®nctTrûTV›l\r+B‹g¤\Ð$¾D.€«’³3Q\ÅX5^¯Qj²¯V¿\Z@—Sƒ¨—zQ›ÆŸ« \Ýÿ\0¼J\Ð\Z\ç¾#P$¨\\;;\0´Z£ù„«	Cüw6#X¿ý€\Ì\nœV€=ª‡À9ÇA`\ÝŸia\Ö\Ü\Üÿ\0\ÉA\0 J\Ê\Ø\ëvf\Û\çKMxip|0»LLubQ\Î\è)±z\Â\ã9‚\õt>\ì-k\0iÏ­Í¤p:iÏ¦˜\Üf\î\Ùibxý\ÄV\Â,t\Í|\Â\nJ(iÒ¾,\á\ôºzi&\"¤\äBX{Ü¹·P¢\Û\Ð#6VXœ%eÓŠ\÷I9›¦[\ê²ú¾¥¸hd\Å\Ð/\Ãù„\ôªU\î\Õ%£ia¼”\öfT¡¬¹\ãz\ñ(ej›4\ëý\ÜVZ\Ç\Ò\Ê˜ \ã1+7ë˜øš-]\íþ\Ø\"@¥7\Æÿ\0R\óxÔ¥û¾@f¤#J\nü\\A\÷¸«i3£Wjf«¾€…©}uÁú†Š¨œ\ß?0¥AŽk¸EÊœúÚ¸«\\,\ä\èk\ÒC=r¸©M.\ò\ëR‹ ‡Ï¬/k 0/:W\ã\æ•`B¨\ó\ÜÎ²8P\ç.o\ê`‘¢²§Ç¼_|[ª¶‚¹‚mE¦\×J]¿Ô»\î!r®+\ÌPÑ¡‡J\ç\Îþ\á6u\r€¯\ÌmÈ…–M\\ !BZkb\0#h\\œy€·†JÏ¤º6AJ\ëþDL†\ì³:>\åi\Ê\Çl¢»[F\ÇÜ \08¯\Ì¸,4\ñøß™NdmužrKQV\\†	\âœkï¨„\ôu¤½yŽ\ÂQL\Æý\"f5\0\ïˆS¶¾\ï‹\â®ø¾~3³\Û\Ù\Ì(¦¸$\Ä|Ý·¯X‰M\ê\Ï\ÕÀI]wŠ†1ø”[ø{{À=¬\ò3-”w[‹84´\Õ\"\Ð\Ö]\ãšÁ\Û@\Ê\ñŽ36ˆ¨K\õÿ\0nT¡û‹[\Õû\è\óTjÅ»W/¶Ha±6¯\rk¹RJ\0\\\×Ô»˜ZnºXk…¹N„\Ù.†V»º{J¶×ŠYŒ\õŒÔº\Z )¡\ä½fþ£¡‰¥kO¬\É\n\Í)§G†]jÖÇ½\æR¡O\Æb¤+\Ì\Â[%*•r¾?¡/µ\ñ¶Ym+Z‹n8+f°o«\"„€-M9<\ä\Ì\è\ê\nŠ\ä˜aI ;\Òz\Ý>\ò\ðb¶ˆ\\2ì©†[\èD‘g°ø*\Ç\Ú_@¤4×²‡Ï˜Ôªw–?$Á\r½\Æ\ðý<\Ã‰\Ðj³\â\àp!ET\r¸\"¬™Pcm_\ËYjF7Ã²\ê¶E³µ),U‚Q³\Î`)\Ñ\Ç\æ\ãÆ¢£n(»„\ê\ÓLr£\òŸ00Š\ÝA\ê®\ã\ÉsUµ\ßÙŸ¸pŠ¨Y–;¤ø‚%›º3\ìÿ\0±\Õ\Ð@T9¿£\Þ<\õJ¢\í¢Ÿ;•Œh2€¯†\'`\É\ç\Ú\åu#]70\á˜4X\÷þ\êm{vÚ¬\r]9\Z(\â]\Ê\ÜU7.€IiŠ\æ(ƒúþ\å¤\æ){©hÀ\Z3úŠ’Ù†kŒ\ËF¨Ý¾N“ˆP€CFŠ4¾ku-ƒ†7\É\0Œ—yŒ\Z0\Ï5˜\\¨n\Ã\ï\ñsYº\Ó\Ö\à‹¨\óþ\êPÔ¡»³\é\Î.=BM\ÂA@²{û€\Ä4\r9`]­%5]?¸\ã„8\Â\n£\Ú-8œ\õOÁ\Ä\ÔZ°¶\Ñ„©fP·?6iUŠ\õ‚n\Å.9À¯7¨Ž†\Ôÿ\0‘\ÌÒŒ\Øq\Ô25—ß}\ÎG•“;\â#¦\Î\ì\êÈ¸š\Ç\ãû9v\ñþø—\×n€*%‰P¾SQZ¢¾\Øz\r¼\Ø\ÙÀ\æ¿¹‡B\÷FI@=6f™\Ë\í\÷\ðœbA¡\ß\ô\Ä\Õn»¶>&A»F¯ú#wP‰\çk\Ð\ÇÜ¬µ“ \÷\õ7}]%)^‹]\0X\r}vL]°]\Ç<|ýÁ{‰W94\õD-„0ºWRü¬	\ÊNe\áa\àZ‚\ÓcW\émE¨k(j\Õup‚\'\ÆÆM¶\ó¬À¡•TÊ¨,O8H“@Y\\”8úŠo\ÕS\×kÁdfœ¯½ÂˆB°,o\Å|\Â\ÎhE\ì¶+;˜¢.¬\õ»o\ØOù,t‚\åx@_®¼G\ñ¡/\ë\â1Œ\È\ãŸKgºj\Å’±\ïœø–£P«¼}™‘L\×\\PRW´\ëP‡²z\ç\ê\r€46¶_Ê©\ìBNp­ß€=Yƒ#V›K±\ö€±\Äa†Ÿ@\Êè©¢]\×†ˆ\Ö)Œ§	\r{¯d—pT,j\êÿ\0\Þ%Ek×¯vƒª\Õ?Ÿ©œ–J¹2\ô\ÌË‡ÊªF\ËpÒ‘\Ú\ì^\Â\ÞË¨› ¹{\×\Ó\0\Åh*\Ø<–ÿ\0ª()Ñ“\öF€l+’\nŒd^þÅ€¹)¥º¿™;š\Ò\ã\'\î3 wœ´\êExCv`IºfQ0¾\"PŠ#¨ˆ °\×[\ô™{gBç˜“4’”\ò~·5®\Ø\àz1×˜ŒM\åW\ÊT¨Š+…—}Y4*oý\ó‹Tˆ\ã\æ\0º²\ðzE\ê\rŠ}FEP@ƒ¬\ãýq‚•\Â\õ¦\Ø\rH|€6ùcg*–8|ûKˆ²²ºkƒ\ñ˜™Yx\ås\ß\ZsR{R²\\ÁFR\×\ß\î] Zºe\ó7[B\×9¢-F$Úªµ7§7\Ö\êX4J*\ès·	-¥¶\ñ\ë\ñªu|\"@\ð¨-\'\ÝüÀ\êd3Bÿ\0\àÊ°¬¿\ò2V¾j\n\àJo\Är]e\ÅBaK{D&«t\Ô\n`ƒW2†ª.\Î0üCRYh”}e„¬B›\Îu(\ÆÂ®\Ð3\ã\Æ\åB‰°WŠ\Ì{y…øP–´\Âx*\ë1\ëª/\Õ>¹¹y™AÚ™~nU\òƒ\"\ÅH\Ýs\066¦\Ê\Å\ô,Sb¹lµV°e‚ùT\ÃM\ì\ö…\ÑgDÝ±\n›»GŸŒ )[E6)…\Ó\æ\Z|eN\ë_P\ó•\0]6¹\ã,|F€Y¬_›Vøˆ¹\á\Ì\0+^¦ ‚\Æn°ê±„k\ÚW@G\ä\ñ\íRy…wi^kú!\ÂPÍ‡Š{\ÅË‘T.\×À]ibg6[\ë2“z\\\åVz\âZ¹Q¼lý\Ä\ê†kÎ‚XmSTüa–\ðtEY\Ï\Æ&[­\Ñ^3¼[w›—NÂ¡´³W®¾%\ê3¨hÀ\çÒ¾\æO\ÈS\ÃWf’%¢8\í¢\×w0(\"RkŸ\Ä5>_6F‡¢ù€XU¬c\Ú6\Z.\é*Ž\ó\öL…jf\ßø¾\å\Õ@6$z²ý\àW¹ù¥\ä%š°ˆ¾ˆ :PV™¾|±r¸\ì2ª\ä\ô}#\Ývi\è>\íqpš¨›y\çr\Ùp\ÐrÁ®0V;¥\ÎC¡\×t¼Â‹”»‘n¾X¨vS\ó\í\î\Ól¼E&!².\å‰6+. ª	m• \ÛvùŽ’\è\Õ\óûŽ\r]˜\óˆc\Â\Þ\îd¶+ªû\ï\Ä\Ñ)9þ£«D\Øâ­…™+·ý\ÔÄ³t V¥\Úa±¥‰ýK,\Ñ\Í\ÚÜ¶š¸+ƒ\"Ù‰…°\êY=)1œþ¡@*§5¡Ï¼¢‡&\òf]™*ª±†f+•˜Q’—Œ\ÔU@`\rÌ£\÷*-¡¿¸ hU—=b[%[\Ö\×Ye¼¤\Ò\å\Þ\ë(³MÊ³\äYmV®T\ã\ó\Ô>.\ä£W™0‚º²\ã\nlW¼Cü&\à\ð\âi‹ž\Ä?pž_¬Ÿ\Éq\Â2\nAQ@\\QET¦4\Ímý}\Ç\Ñ\Z[ý‰[«ø²`µ›\Ûh9\ÂQ~3\ó[–\Û:`R¿\'\Ô\"f\nV­ú(\ê=)¨~þ \Ü\à<e9¾n½=eNR\í¨BZ:Eùž¥™™-r°µK3·º\ô†À-žC‰tª¿c€\ñƒ0\r\Øý%[\Ð0»Œ7¿\ÔjÉf‚ø\÷¹bŠšÿ\0§¨•(UP(\Æec/Y3\ï\Ér\Ý«\â¶5\ÛP–^\ñJ¿¶µÁ]\çdE-I1x¿’\ã¼\0P\õ\â]\æ\Í<K\0Ú…‹/§¼l Gvi\âŽøl’\Ï‘a¡!ÞŸ¹z•K|¿0y;\ê\Ò\ç\ê0\õn™(O\ÔB\î\è}¡»¦;\È\"{q\é8\Î\Õlo\è_\Ôh€¸ay?\ö5l/Œ%\'\à\Þ/\õ8H5Cn~¾\ã¢7‚yy\È|‡Qû\å{ƒ\õ\0Â›P£\'6M»Yl\Ï5¯F”¦\0¤w\Æ^s-”\á~lÿ\Ù','image/jpeg','AVAILABLE');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `program_types`
--

LOCK TABLES `program_types` WRITE;
/*!40000 ALTER TABLE `program_types` DISABLE KEYS */;
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
  `program_code` varchar(50) NOT NULL,
  `program_name` varchar(200) NOT NULL,
  `program_type_id` bigint NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `num_days` int NOT NULL DEFAULT '1',
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `programs`
--

LOCK TABLES `programs` WRITE;
/*!40000 ALTER TABLE `programs` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_roles`
--

LOCK TABLES `user_roles` WRITE;
/*!40000 ALTER TABLE `user_roles` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
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

-- Dump completed on 2026-10-02  0:32:50
