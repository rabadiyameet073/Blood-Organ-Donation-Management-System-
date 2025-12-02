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
-- Table structure for table `donation_details`
--

DROP TABLE IF EXISTS `donation_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `donation_details` (
  `donation_id` bigint NOT NULL AUTO_INCREMENT,
  `donor_id` bigint NOT NULL,
  `organ_id` bigint DEFAULT NULL,
  `donation_date` date NOT NULL,
  `donation_type` enum('Blood','Organ') NOT NULL,
  `is_successful` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`donation_id`),
  KEY `donor_id_idx` (`donor_id`),
  KEY `organ_id_idx` (`organ_id`),
  CONSTRAINT `fk_donor_id` FOREIGN KEY (`donor_id`) REFERENCES `donors` (`donor_id`) ON DELETE CASCADE,
  CONSTRAINT `organ_id` FOREIGN KEY (`organ_id`) REFERENCES `organ_inventory` (`organ_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donation_details`
--

LOCK TABLES `donation_details` WRITE;
/*!40000 ALTER TABLE `donation_details` DISABLE KEYS */;
INSERT INTO `donation_details` VALUES (1,1,1,'2024-06-15','Organ',1),(2,2,2,'2024-07-01','Blood',1),(3,3,3,'2024-08-10','Organ',0),(4,4,4,'2024-09-05','Blood',1),(5,5,5,'2024-10-20','Organ',1),(6,6,6,'2024-11-10','Blood',0),(7,7,7,'2024-12-01','Organ',1),(8,8,8,'2024-12-10','Blood',1),(9,9,9,'2024-12-15','Organ',1),(10,10,10,'2024-12-20','Blood',0),(11,11,11,'2024-11-25','Organ',1),(12,12,12,'2024-12-05','Blood',1),(13,13,13,'2024-12-18','Organ',0),(14,14,14,'2024-11-30','Blood',1),(15,15,15,'2024-12-12','Organ',1),(16,16,16,'2024-12-22','Blood',1),(17,17,17,'2024-12-25','Organ',1),(18,18,18,'2024-11-28','Blood',0),(19,19,19,'2024-12-10','Organ',1),(20,20,20,'2024-12-23','Blood',1);
/*!40000 ALTER TABLE `donation_details` ENABLE KEYS */;
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
