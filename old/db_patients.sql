-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: db
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `patients`
--

DROP TABLE IF EXISTS `patients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patients` (
  `patient_id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `age` int NOT NULL,
  `gender` enum('M','F','O') NOT NULL,
  `blood_group` enum('A+','A-','B+','B-','AB+','AB-','O+','O-') NOT NULL,
  `contact_info` varchar(150) DEFAULT NULL,
  `address` text,
  `medical_history` text,
  `registration_date` date DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `doctor_id` bigint DEFAULT NULL,
  PRIMARY KEY (`patient_id`),
  KEY `d_id_idx` (`doctor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patients`
--

LOCK TABLES `patients` WRITE;
/*!40000 ALTER TABLE `patients` DISABLE KEYS */;
INSERT INTO `patients` VALUES (1,'Aarav Patel',28,'M','O+','123-456-7890','123 Gandhi Road, City, Country','No known conditions','2023-05-15',1,1),(2,'Priya Sharma',34,'F','A-','987-654-3210','456 Nehru Street, City, Country','Hypertension','2023-06-22',1,2),(3,'Rohan Desai',45,'M','B+','555-123-4567','789 Patel Nagar, City, Country','Diabetes','2023-07-10',1,3),(4,'Anita Rathi',52,'F','AB-','321-654-9870','101 Mahatma Road, City, Country','Heart Disease','2023-08-01',1,4),(5,'Vikas Verma',40,'M','O-','555-987-6543','202 Bapu Lane, City, Country','Chronic Kidney Disease','2023-09-05',1,5),(6,'Meera Joshi',26,'F','B+','666-543-2109','303 Gandhi Park, City, Country','No known conditions','2023-10-12',1,1),(7,'Amit Kapoor',38,'M','A+','111-222-3333','404 Patel Avenue, City, Country','Allergies','2023-11-18',1,2),(8,'Sunita Mehta',47,'F','O+','222-333-4444','505 Nehru Colony, City, Country','Arthritis','2023-12-05',1,3),(9,'Ravi Yadav',50,'M','B-','333-444-5555','606 Mahatma Road, City, Country','Heart Attack','2024-01-09',1,4),(10,'Nisha Singh',31,'F','AB+','444-555-6666','707 Gandhi Lane, City, Country','High Cholesterol','2024-02-01',1,5),(11,'Rajesh Kumar',60,'M','O-','555-666-7777','808 City Center, City, Country','CVD','2024-03-10',1,1),(12,'Seema Gupta',43,'F','A-','666-777-8888','909 Main Road, City, Country','Back Pain','2024-04-15',1,2),(13,'Karan Sharma',29,'M','B+','777-888-9999','1010 Ram Street, City, Country','No known conditions','2024-05-05',1,3),(14,'Anju Verma',41,'F','O+','888-999-0000','1111 Keshav Lane, City, Country','Diabetes','2024-06-12',1,4),(15,'Deepak Patel',35,'M','A+','999-000-1111','1212 Rajput Street, City, Country','Liver Disease','2024-07-22',1,5),(16,'Pooja Yadav',27,'F','AB-','111-222-3333','1313 Mall Road, City, Country','Allergies','2024-08-18',1,1),(17,'Vijay Rathi',54,'M','O+','222-333-4444','1414 Lake Side, City, Country','CVD','2024-09-25',1,2),(18,'Rekha Kumari',33,'F','B-','333-444-5555','1515 Station Road, City, Country','High BP','2024-10-11',1,3),(19,'Harsh Patel',25,'M','A-','444-555-6666','1616 Old Town, City, Country','No known conditions','2024-11-08',1,4),(20,'Simran Verma',37,'F','O-','555-666-7777','1717 New Market, City, Country','Kidney Disease','2024-12-03',1,5);
/*!40000 ALTER TABLE `patients` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-28 19:57:30
