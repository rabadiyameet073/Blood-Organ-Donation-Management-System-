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
-- Table structure for table `transplant_requests`
--

DROP TABLE IF EXISTS `transplant_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transplant_requests` (
  `request_id` bigint NOT NULL AUTO_INCREMENT,
  `patient_id` bigint NOT NULL,
  `doctor_id` bigint NOT NULL,
  `organ_type` varchar(50) NOT NULL,
  `request_date` date NOT NULL,
  `status` enum('Pending','Matched','Completed','Cancelled') DEFAULT 'Pending',
  PRIMARY KEY (`request_id`),
  KEY `doctor_id` (`doctor_id`),
  KEY `pat_id_idx` (`patient_id`),
  CONSTRAINT `pat_id` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=121 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transplant_requests`
--

LOCK TABLES `transplant_requests` WRITE;
/*!40000 ALTER TABLE `transplant_requests` DISABLE KEYS */;
INSERT INTO `transplant_requests` VALUES (101,1,1,'Kidney','2024-05-15','Pending'),(102,2,2,'Liver','2024-06-22','Completed'),(103,3,3,'Heart','2024-07-10','Cancelled'),(104,4,4,'Lung','2024-08-01','Pending'),(105,5,5,'Pancreas','2024-09-05','Completed'),(106,6,6,'Kidney','2024-10-12','Cancelled'),(107,7,7,'Liver','2024-11-18','Pending'),(108,8,8,'Heart','2024-12-05','Completed'),(109,9,9,'Lung','2024-01-09','Pending'),(110,10,10,'Pancreas','2024-02-01','Cancelled'),(111,11,11,'Kidney','2024-03-10','Completed'),(112,12,12,'Liver','2024-04-15','Pending'),(113,13,13,'Heart','2024-05-05','Cancelled'),(114,14,14,'Lung','2024-06-12','Completed'),(115,15,15,'Pancreas','2024-07-22','Pending'),(116,16,16,'Kidney','2024-08-18','Cancelled'),(117,17,17,'Liver','2024-09-25','Completed'),(118,18,18,'Heart','2024-10-11','Pending'),(119,19,19,'Lung','2024-11-08','Cancelled'),(120,20,20,'Pancreas','2024-12-03','Completed');
/*!40000 ALTER TABLE `transplant_requests` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-28 19:57:31
