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
-- Table structure for table `donation_campaigns`
--

DROP TABLE IF EXISTS `donation_campaigns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `donation_campaigns` (
  `campaign_id` bigint NOT NULL AUTO_INCREMENT,
  `campaign_name` varchar(150) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `organizer` varchar(100) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`campaign_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donation_campaigns`
--

LOCK TABLES `donation_campaigns` WRITE;
/*!40000 ALTER TABLE `donation_campaigns` DISABLE KEYS */;
INSERT INTO `donation_campaigns` VALUES (1,'Blood Donation Drive 2024','2024-01-15','2024-01-20','Red Cross','A week-long blood donation drive aimed at increasing reserves of all blood groups.'),(2,'Organ Donation Awareness','2024-02-01','2024-02-28','Health First','A month-long campaign to raise awareness about the importance of organ donation.'),(3,'Emergency Relief Blood Drive','2024-03-05','2024-03-07','City Hospital','A special blood donation campaign to support victims of recent natural disasters.'),(4,'Save a Life Marathon','2024-04-10','2024-04-15','Sunrise Clinic','Encouraging organ and blood donations through a charity marathon event.'),(5,'Youth Donation Week','2024-05-01','2024-05-07','Student Health Association','A week targeting students and young adults to participate in blood and organ donation.'),(6,'Corporate Blood Drive','2024-06-15','2024-06-18','TechCorp','An initiative encouraging corporate employees to donate blood.'),(7,'Rural Outreach Campaign','2024-07-10','2024-07-20','Wellness Foundation','A campaign to bring blood and organ donation awareness to rural areas.'),(8,'Heroes in Health','2024-08-05','2024-08-10','Community Health Group','Honoring past donors and encouraging new participants to contribute to blood banks.'),(9,'LifeSaver Blood Week','2024-09-01','2024-09-07','LifeSaver Initiative','A national blood donation week organized across all major cities.'),(10,'Hope for Hearts','2024-10-01','2024-10-15','Cardiac Care Society','A specialized campaign to promote heart-related organ donations.');
/*!40000 ALTER TABLE `donation_campaigns` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-28 19:57:29
