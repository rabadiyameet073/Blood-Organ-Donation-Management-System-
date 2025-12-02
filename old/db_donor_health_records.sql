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
-- Table structure for table `donor_health_records`
--

DROP TABLE IF EXISTS `donor_health_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `donor_health_records` (
  `record_id` bigint NOT NULL AUTO_INCREMENT,
  `donor_id` bigint NOT NULL,
  `health_condition` varchar(255) NOT NULL,
  `record_date` date NOT NULL,
  PRIMARY KEY (`record_id`),
  KEY `donor_id_idx` (`donor_id`),
  CONSTRAINT `fkdonor_id` FOREIGN KEY (`donor_id`) REFERENCES `donors` (`donor_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donor_health_records`
--

LOCK TABLES `donor_health_records` WRITE;
/*!40000 ALTER TABLE `donor_health_records` DISABLE KEYS */;
INSERT INTO `donor_health_records` VALUES (1,1,'Hypertension','2024-01-15'),(2,2,'Diabetes Type 2','2024-03-10'),(3,3,'Healthy, no conditions','2024-05-20'),(4,4,'Asthma','2024-07-05'),(5,5,'Chronic Kidney Disease','2024-08-25'),(6,1,'High Cholesterol','2024-09-12'),(7,2,'Healthy, no conditions','2024-10-05'),(8,3,'Migraines','2024-11-02'),(9,4,'Allergy to Penicillin','2024-12-01'),(10,5,'Heart Disease','2024-12-10'),(11,1,'Back Pain','2024-11-15'),(12,2,'Healthy, no conditions','2024-11-25'),(13,3,'Hypertension','2024-10-20'),(14,4,'Anxiety','2024-09-30'),(15,5,'Diabetes Type 1','2024-08-05'),(16,1,'Healthy, no conditions','2024-12-20'),(17,2,'Chronic Fatigue Syndrome','2024-12-15'),(18,3,'Asthma','2024-12-22'),(19,4,'High Blood Pressure','2024-12-10'),(20,5,'Obesity','2024-12-18');
/*!40000 ALTER TABLE `donor_health_records` ENABLE KEYS */;
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
