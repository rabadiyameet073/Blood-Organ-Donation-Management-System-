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
-- Table structure for table `organ_inventory`
--

DROP TABLE IF EXISTS `organ_inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `organ_inventory` (
  `organ_id` bigint NOT NULL AUTO_INCREMENT,
  `organ_type` varchar(50) NOT NULL,
  `availability_status` enum('Available','Reserved','Transplanted') NOT NULL,
  `patient_id` bigint DEFAULT NULL,
  `donor_id` bigint DEFAULT NULL,
  PRIMARY KEY (`organ_id`),
  KEY `fk_organ_donor_idx` (`organ_id`),
  KEY `fk_organ_patient_idx` (`donor_id`),
  CONSTRAINT `fk_organ_donor` FOREIGN KEY (`organ_id`) REFERENCES `donors` (`donor_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_organ_patient` FOREIGN KEY (`donor_id`) REFERENCES `donors` (`donor_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `organ_inventory`
--

LOCK TABLES `organ_inventory` WRITE;
/*!40000 ALTER TABLE `organ_inventory` DISABLE KEYS */;
INSERT INTO `organ_inventory` VALUES (1,'Kidney','Available',101,1),(2,'Liver','Reserved',102,2),(3,'Heart','Transplanted',103,3),(4,'Lung','Available',104,4),(5,'Pancreas','Available',105,5),(6,'Kidney','Reserved',106,6),(7,'Liver','Available',107,7),(8,'Heart','Transplanted',108,8),(9,'Lung','Available',109,9),(10,'Pancreas','Reserved',110,10),(11,'Kidney','Transplanted',111,11),(12,'Liver','Available',112,12),(13,'Heart','Available',113,13),(14,'Lung','Reserved',114,14),(15,'Pancreas','Transplanted',115,15),(16,'Kidney','Available',116,16),(17,'Liver','Transplanted',117,17),(18,'Heart','Reserved',118,18),(19,'Lung','Available',119,19),(20,'Pancreas','Transplanted',120,20);
/*!40000 ALTER TABLE `organ_inventory` ENABLE KEYS */;
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
