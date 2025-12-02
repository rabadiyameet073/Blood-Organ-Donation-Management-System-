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
-- Table structure for table `donors`
--

DROP TABLE IF EXISTS `donors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `donors` (
  `donor_id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `age` int NOT NULL,
  `gender` enum('Male','Female','Other') NOT NULL,
  `blood_group` enum('A+','A-','B+','B-','AB+','AB-','O+','O-') NOT NULL,
  `contact_info` varchar(150) DEFAULT NULL,
  `address` text,
  `medical_history` text,
  `registration_date` date DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`donor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donors`
--

LOCK TABLES `donors` WRITE;
/*!40000 ALTER TABLE `donors` DISABLE KEYS */;
INSERT INTO `donors` VALUES (1,'Vinu Mavji Gevariya',35,'Male','O+','123-456-7890','123 Main St, City, Country','No known conditions','2024-01-01',1),(2,'Ravi Keshav Patel',29,'Male','A-','987-654-3210','456 Oak Ave, City, Country','Hypertension','2024-02-15',1),(3,'Anita Harji Bhatt',45,'Female','AB+','555-123-4567','789 Pine Rd, City, Country','Diabetes','2024-03-10',1),(4,'Leela Chandrakant Shah',60,'Female','B-','321-654-9870','101 Maple Dr, City, Country','Healthy, no conditions','2024-04-20',1),(5,'Mohanlal Parmanand Joshi',50,'Male','O-','555-987-6543','202 Birch Ln, City, Country','Chronic Kidney Disease','2024-05-01',1),(6,'Sita Ram Bhatt',70,'Female','A+','123-987-6543','304 Ashok Nagar, City, Country','Heart Disease','2024-06-15',1),(7,'Bhupendra Arvind Mehta',32,'Male','B+','987-123-4567','567 Gandhi Street, City, Country','No known conditions','2024-07-10',1),(8,'Pooja Ashok Vyas',25,'Female','AB-','654-321-9870','234 Sunflower Lane, City, Country','Asthma','2024-08-05',1),(9,'Kishore Harshad Desai',55,'Male','O-','432-765-1234','890 River Road, City, Country','High Blood Pressure','2024-09-12',1),(10,'Anjali Jashodhan Mehta',40,'Female','A-','567-890-1234','678 Seaside Boulevard, City, Country','Diabetes','2024-10-25',1),(11,'Rajesh Kumar Patel',62,'Male','B+','678-123-4560','345 Mango Street, City, Country','Heart Disease','2024-11-01',1),(12,'Lalita Shankar Sharma',28,'Female','O+','543-210-9876','456 Forest Road, City, Country','Healthy, no conditions','2024-11-10',1),(13,'Vinod Chimanlal Trivedi',47,'Male','AB-','789-654-1230','234 Riverbank Avenue, City, Country','Kidney Stones','2024-11-15',1),(14,'Geeta Premchand Gupta',54,'Female','O-','321-987-6540','678 Park Street, City, Country','Chronic Lung Disease','2024-12-05',1),(15,'Jitendra Mahesh Patel',39,'Male','A+','654-321-0987','123 Orchard Lane, City, Country','No known conditions','2024-12-10',1),(16,'Kamala Anand Joshi',45,'Female','B+','543-654-3210','876 Cherry Hill, City, Country','Hypertension','2024-12-15',1),(17,'Ramesh Premji Mehta',48,'Male','O-','987-432-5670','234 Blossom Road, City, Country','Liver Disease','2024-12-20',1),(18,'Nina Krishnan Shah',33,'Female','AB+','654-987-3210','890 Hilltop Drive, City, Country','No known conditions','2024-12-25',1),(19,'Arjun Devendra Patel',59,'Male','B-','432-123-0987','678 Jasmine Street, City, Country','Heart Condition','2025-01-10',1),(20,'Rita Manish Yadav',26,'Female','A-','987-654-3210','345 Village Square, City, Country','Asthma','2025-01-15',1);
/*!40000 ALTER TABLE `donors` ENABLE KEYS */;
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
