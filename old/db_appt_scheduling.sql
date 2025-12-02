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
-- Table structure for table `appt_scheduling`
--

DROP TABLE IF EXISTS `appt_scheduling`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appt_scheduling` (
  `appt_id` bigint NOT NULL,
  `patient_id` bigint DEFAULT NULL,
  `doctor_id` bigint DEFAULT NULL,
  `appt_date` date DEFAULT NULL,
  `appt_time` time DEFAULT NULL,
  `status` enum('Pending','Confirmed','Cancelled','Completed') DEFAULT NULL,
  PRIMARY KEY (`appt_id`),
  KEY `patient_id_idx` (`patient_id`),
  KEY `doctor_id_idx` (`doctor_id`),
  CONSTRAINT `doctor_id` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`) ON DELETE CASCADE,
  CONSTRAINT `patient_id` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appt_scheduling`
--

LOCK TABLES `appt_scheduling` WRITE;
/*!40000 ALTER TABLE `appt_scheduling` DISABLE KEYS */;
INSERT INTO `appt_scheduling` VALUES (1,1,21,'2024-11-30','10:00:00','Confirmed'),(2,2,21,'2024-12-14','09:45:00','Completed'),(3,3,22,'2024-12-01','11:15:00','Pending'),(4,4,22,'2024-12-18','14:00:00','Cancelled'),(5,5,23,'2024-12-03','08:30:00','Completed'),(6,6,23,'2024-12-20','15:00:00','Pending'),(7,7,24,'2024-12-02','14:30:00','Cancelled'),(8,8,24,'2024-12-21','16:15:00','Confirmed'),(9,9,25,'2024-12-05','17:00:00','Pending'),(10,10,25,'2024-12-23','13:45:00','Completed'),(11,11,21,'2024-12-06','13:00:00','Confirmed'),(12,12,21,'2024-12-22','10:15:00','Cancelled'),(13,13,22,'2024-12-08','11:45:00','Completed'),(14,14,22,'2024-12-24','12:30:00','Pending'),(15,15,23,'2024-12-09','09:15:00','Cancelled'),(16,16,23,'2024-12-25','08:45:00','Confirmed'),(17,17,24,'2024-12-10','16:30:00','Pending'),(18,18,24,'2024-12-26','15:30:00','Completed'),(19,19,25,'2024-12-12','10:30:00','Confirmed'),(20,20,25,'2024-12-28','11:15:00','Cancelled');
/*!40000 ALTER TABLE `appt_scheduling` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-28 19:57:32
