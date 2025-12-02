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
-- Table structure for table `matching_algorithm_logs`
--

DROP TABLE IF EXISTS `matching_algorithm_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `matching_algorithm_logs` (
  `log_id` bigint NOT NULL AUTO_INCREMENT,
  `request_id` bigint NOT NULL,
  `log_timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  `algorithm_details` text,
  PRIMARY KEY (`log_id`),
  KEY `request_id_idx` (`request_id`),
  CONSTRAINT `request_id` FOREIGN KEY (`request_id`) REFERENCES `transplant_requests` (`request_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `matching_algorithm_logs`
--

LOCK TABLES `matching_algorithm_logs` WRITE;
/*!40000 ALTER TABLE `matching_algorithm_logs` DISABLE KEYS */;
INSERT INTO `matching_algorithm_logs` VALUES (1,101,'2024-11-27 14:30:00','Initial matching attempt for donor and patient using age and blood group criteria.'),(2,102,'2024-11-27 14:45:00','Refined algorithm to include medical history matching for better accuracy.'),(3,103,'2024-11-27 15:00:00','Testing new scoring mechanism to improve match percentage calculation.'),(4,104,'2024-11-27 15:15:00','Algorithm executed successfully with a 95% match score between donor and patient.'),(5,105,'2024-11-27 15:30:00','Logged a failed match attempt due to incompatible blood group.'),(6,106,'2024-11-27 15:45:00','Matching process adjusted to account for organ availability.'),(7,107,'2024-11-27 16:00:00','Algorithm updated to include additional conditions for age range matching.'),(8,108,'2024-11-27 16:15:00','First-stage matching completed with optimal scoring algorithm.'),(9,109,'2024-11-27 16:30:00','Log for reviewing patient-donor compatibility with organ type specified.'),(10,110,'2024-11-27 16:45:00','Algorithm run for cross-checking multiple donor options for a single patient.'),(11,111,'2024-11-27 17:00:00','Performance analysis of matching algorithm completed for the month.'),(12,112,'2024-11-27 17:15:00','Algorithm debugged for more precise age matching logic.'),(13,113,'2024-11-27 17:30:00','Log entry to record a case of successful multi-condition matching.'),(14,114,'2024-11-27 17:45:00','Updated the algorithm to filter donors based on updated medical records.'),(15,115,'2024-11-27 18:00:00','Logged new integration with external data source for improved match results.'),(16,116,'2024-11-27 18:15:00','Reviewed algorithm results for error handling and correction.'),(17,117,'2024-11-27 18:30:00','New algorithm iteration tested for real-time matching efficiency.'),(18,118,'2024-11-27 18:45:00','Adjustments made for better handling of unavailable organ data.'),(19,119,'2024-11-27 19:00:00','Results of a matching attempt where the patient had multiple options for donation.'),(20,120,'2024-11-27 19:15:00','Logged insights from retrospective analysis of matching patterns.');
/*!40000 ALTER TABLE `matching_algorithm_logs` ENABLE KEYS */;
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
