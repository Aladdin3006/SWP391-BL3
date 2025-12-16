-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: swp
-- ------------------------------------------------------
-- Server version	8.0.44

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
-- Table structure for table `actual_transfer_ticket`
--

DROP TABLE IF EXISTS `actual_transfer_ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `actual_transfer_ticket` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ticketCode` varchar(50) NOT NULL,
  `requestTransferId` int DEFAULT NULL,
  `transferDate` date DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `confirmedBy` int DEFAULT NULL,
  `note` text,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ticketCode` (`ticketCode`),
  KEY `fk_actual_request_transfer` (`requestTransferId`),
  KEY `fk_actual_confirmed_by` (`confirmedBy`),
  CONSTRAINT `fk_actual_confirmed_by` FOREIGN KEY (`confirmedBy`) REFERENCES `user` (`userId`),
  CONSTRAINT `fk_actual_request_transfer` FOREIGN KEY (`requestTransferId`) REFERENCES `request_transfer_ticket` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actual_transfer_ticket`
--

LOCK TABLES `actual_transfer_ticket` WRITE;
/*!40000 ALTER TABLE `actual_transfer_ticket` DISABLE KEYS */;
INSERT INTO `actual_transfer_ticket` VALUES (1,'ACT-2025-001',1,'2025-12-01','Completed',9,'Inventory restock completed successfully','2025-12-01 02:00:00'),(2,'ACT-2025-002',2,'2025-12-02','Completed',10,'Holiday sale transfer delivered','2025-12-02 03:30:00'),(3,'ACT-2025-003',3,'2025-12-03','Completed',9,'New shipment processed','2025-12-03 04:15:00'),(4,'ACT-2025-004',4,'2025-12-04','Completed',10,'Bulk order shipped to customer','2025-12-03 21:30:00'),(5,'ACT-2025-005',5,'2025-12-05','Completed',9,'Black Friday restock processed','2025-12-05 01:45:00'),(6,'ACT-2025-006',6,'2025-12-06','Completed',10,'Defective returns processed','2025-12-05 21:40:00'),(7,'ACT-2025-007',7,'2025-12-07','Completed',9,'Emergency event stock delivered','2025-12-06 22:45:00'),(8,'ACT-2025-008',8,'2025-12-08','Completed',10,'Inter-department transfer executed','2025-12-08 04:20:00'),(9,'ACT-2025-009',9,'2025-12-09','Completed',9,'New gaming gear arriving','2025-12-08 23:55:00'),(10,'ACT-2025-010',10,'2025-12-10','Completed',10,'Year-end adjustment completed','2025-12-10 00:15:00'),(11,'ACT-2025-011',11,'2025-12-11','Completed',9,'Popular items restocked','2025-12-11 01:10:00'),(12,'ACT-2025-012',12,'2025-12-12','Completed',10,'New store setup in progress','2025-12-12 01:20:00'),(13,'ACT-2025-013',13,'2025-12-13','Completed',9,'Supplier exchange processed','2025-12-13 02:40:00'),(14,'ACT-2025-014',14,'2025-12-14','Completed',10,'Corporate order fulfilled','2025-12-13 20:25:00'),(15,'ACT-2025-015',15,'2025-12-15','Completed',9,'Backorder fulfillment completed','2025-12-15 03:55:00'),(16,'ACT-2025-016',16,'2025-12-16','In Progress',10,'Clearance sale reduction','2025-12-15 22:35:00'),(17,'ACT-2025-017',17,'2025-12-17','In Progress',9,'Seasonal products prepared','2025-12-17 00:50:00'),(18,'ACT-2025-018',18,'2025-12-18','In Progress',10,'Warranty replacements delivered','2025-12-17 23:20:00'),(19,'ACT-2025-019',19,'2025-12-19','Pending',9,'New year prep awaiting stock','2025-12-19 00:50:00'),(20,'ACT-2025-020',20,'2025-12-20','Pending',10,'Promotional materials distributed','2025-12-20 02:05:00');
/*!40000 ALTER TABLE `actual_transfer_ticket` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `categoryId` int NOT NULL AUTO_INCREMENT,
  `categoryName` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` bit(1) DEFAULT b'1',
  PRIMARY KEY (`categoryId`),
  UNIQUE KEY `categoryName` (`categoryName`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'Laptops','All kinds of laptop devices',_binary ''),(2,'Monitors','Computer and gaming monitors',_binary ''),(3,'Peripherals','Keyboard, mouse, and other accessories',_binary ''),(4,'Printers','All types of printers and scanners',_binary ''),(5,'Networking','Routers, switches, and network devices',_binary ''),(6,'Components','Hardware components like RAM, SSD, CPU',_binary ''),(7,'Others','Default category for old products',_binary '');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department` (
  `id` int NOT NULL AUTO_INCREMENT,
  `departmentName` varchar(255) NOT NULL,
  `storekeeperId` int NOT NULL,
  `status` varchar(50) DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `storekeeperId` (`storekeeperId`),
  CONSTRAINT `department_ibfk_1` FOREIGN KEY (`storekeeperId`) REFERENCES `user` (`userId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department`
--

LOCK TABLES `department` WRITE;
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
INSERT INTO `department` VALUES (1,'daaa',9,'active','2025-12-11 14:15:05'),(2,'dadawdawd',10,'active','2025-12-12 03:20:30');
/*!40000 ALTER TABLE `department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permission`
--

DROP TABLE IF EXISTS `permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permission` (
  `permissionId` int NOT NULL AUTO_INCREMENT,
  `permissionName` varchar(100) NOT NULL,
  `url` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`permissionId`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission`
--

LOCK TABLES `permission` WRITE;
/*!40000 ALTER TABLE `permission` DISABLE KEYS */;
INSERT INTO `permission` VALUES (1,'homepage','/home','Access homepage','2025-12-03 17:10:25'),(2,'login','/login','Access login page','2025-12-03 17:10:25'),(3,'logout','/logout','Access logout','2025-12-03 17:10:25'),(4,'forgot-password','/forgot-password','Access forgot password page','2025-12-03 17:10:25'),(5,'view-profile','/profile','View own profile page','2025-12-03 17:10:25'),(6,'edit-profile','/profile/edit','Edit own profile page','2025-12-03 17:10:25'),(7,'reset-password','/reset-password','Change password page','2025-12-03 17:10:25'),(8,'register','/register','Register new account page','2025-12-03 17:10:25'),(9,'view-users-list','/user-list','View users list page','2025-12-03 17:10:25'),(10,'view-user-details','/user/detail','View user details page','2025-12-03 17:10:25'),(11,'add-user','/user/adduser','Add new user page','2025-12-03 17:10:25'),(12,'edit-user','/users/edit','Edit user information page','2025-12-03 17:10:25'),(13,'activate-user','/users/activate','Activate/deactivate user page','2025-12-03 17:10:25'),(14,'view-roles-list','/view-role-list','View roles list page','2025-12-03 17:10:25'),(15,'view-role-details','/roles/detail','View role details page','2025-12-03 17:10:25'),(16,'edit-role','/roles/edit','Edit role information page','2025-12-03 17:10:25'),(17,'role-permission','/role-permission','Activate/deactivate role page','2025-12-03 17:10:25'),(18,'permission','/permission','permission','2025-12-07 17:26:03'),(19,'department','/department-list','department list','2025-12-11 04:01:35'),(20,'add department','/department-add','add department','2025-12-11 04:02:41'),(21,'update department','/department-update','update department','2025-12-11 04:03:08'),(22,'department-detail','/department-detail','department-detail','2025-12-11 14:29:23'),(23,'/user/update','/user/update','/user/update','2025-12-11 14:51:01'),(24,'view-actual-transfer','/actual-transfer','View actual transfer list','2025-12-12 02:42:54'),(25,'view-actual-transfer-detail','/actual-transfer/detail','View actual transfer details','2025-12-12 02:42:54'),(26,'add-actual-transfer','/actual-transfer/add','Create new actual transfer','2025-12-12 02:42:54'),(27,'edit-actual-transfer','/actual-transfer/edit','Edit actual transfer','2025-12-12 02:42:54'),(28,'/supplier-add','/supplier-add','/supplier-add','2025-12-12 03:36:08'),(29,'/supplier-detail','/supplier-detail','/supplier-detail','2025-12-12 03:36:18'),(30,'/supplier-list','/supplier-list','/supplier-list','2025-12-12 03:37:24'),(31,'/supplier-update','/supplier-update','/supplier-update','2025-12-12 03:37:33'),(32,'/request-transfer','/request-transfer','/request-transfer','2025-12-13 11:59:56'),(33,'/request-transfer/detail','/request-transfer/detail','/request-transfer/detail','2025-12-13 12:00:44'),(34,'/request-transfer/add','/request-transfer/add','/request-transfer/add','2025-12-13 12:00:59'),(35,'/request-transfer/edit','/request-transfer/edit','/request-transfer/edit','2025-12-13 12:01:10'),(36,'/add-product','/add-product','/add-product','2025-12-14 05:13:43'),(37,'/view-product-list','/view-product-list','/view-product-list','2025-12-14 05:14:08'),(38,'/view-product-detail','/view-product-detail','/view-product-detail','2025-12-14 05:14:18'),(39,'/edit-product','/edit-product','/edit-product','2025-12-14 05:14:35'),(40,'/view-inventory','/view-inventory','/view-inventory','2025-12-14 10:12:34'),(41,'/product-change-detail','/product-change-detail','/product-change-detail','2025-12-14 10:12:50'),(42,'import-warehouse-report','/import-warehouse-report','View import warehouse report by date','2025-12-16 12:00:00'),(43,'export-warehouse-report','/export-warehouse-report','View export warehouse report by date','2025-12-16 12:00:00');
/*!40000 ALTER TABLE `permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` int NOT NULL AUTO_INCREMENT,
  `productCode` varchar(50) NOT NULL,
  `name` varchar(255) NOT NULL,
  `brand` varchar(100) DEFAULT NULL,
  `company` varchar(100) DEFAULT NULL,
  `unit` int NOT NULL DEFAULT '1',
  `supplierId` int DEFAULT NULL,
  `status` varchar(20) DEFAULT 'active',
  `url` varchar(255) DEFAULT NULL,
  `categoryId` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `productCode` (`productCode`),
  KEY `fk_product_category` (`categoryId`),
  CONSTRAINT `fk_product_category` FOREIGN KEY (`categoryId`) REFERENCES `category` (`categoryId`),
  CONSTRAINT `chk_product_code` CHECK (regexp_like(`productCode`,_utf8mb4'^[A-Z0-9-]+$'))
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,'LAP-Dell-001','Laptop Dell Inspiron 15','Dell','Dell Inc.',112,1,'inactive','https://res.cloudinary.com/dacgihdpq/image/upload/v1765699903/zt0sbmi0zzds94vw0dg1.webp',1),(2,'MON-SAM-27','Monitor Samsung 27\" Curved','Samsung','Samsung Electronics',116,2,'active','https://www.newegg.com/insider/wp-content/uploads/2022/01/Blue-Accessories.jpg',7),(3,'MOU-LOG-MX','Mouse Logitech MX Master 3','Logitech','Logitech Intl.',221,3,'active','https://www.newegg.com/insider/wp-content/uploads/2022/01/Blue-Accessories.jpg',5),(4,'KEY-MS-ERG','Keyboard Microsoft Ergonomic','Microsoft','Microsoft Corp.',62,4,'active','https://www.newegg.com/insider/wp-content/uploads/2022/01/Blue-Accessories.jpg',6),(5,'PRI-HP-LJPro','Printer HP LaserJet Pro M404','HP','Hewlett-Packard',18,5,'active','https://www.newegg.com/insider/wp-content/uploads/2022/01/Blue-Accessories.jpg',4),(6,'RAM-COR-16G','RAM Corsair 16GB DDR4 3200','Corsair','Corsair Inc.',175,6,'active','https://www.newegg.com/insider/wp-content/uploads/2022/01/Blue-Accessories.jpg',1),(7,'SSD-SAM-1TB','SSD Samsung 970 EVO 1TB','Samsung','Samsung Electronics',106,7,'active','https://www.newegg.com/insider/wp-content/uploads/2022/01/Blue-Accessories.jpg',2),(8,'CAB-ANK-2M','Anker USB-C Cable 2m','Anker','Anker Innovations',310,8,'active','https://www.newegg.com/insider/wp-content/uploads/2022/01/Blue-Accessories.jpg',3),(9,'BAT-LOG-G502','Logitech G502 Battery','Logitech','Logitech Intl.',202,9,'active','https://www.newegg.com/insider/wp-content/uploads/2022/01/Blue-Accessories.jpg',7),(10,'WEB-LOG-C920','Webcam Logitech C920 HD Pro','Logitech','Logitech Intl.',110,10,'active','https://www.newegg.com/insider/wp-content/uploads/2022/01/Blue-Accessories.jpg',5),(11,'BAT','dat thanh','Logitech','1 thanh vien',102,1,'active','',7);
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_change`
--

DROP TABLE IF EXISTS `product_change`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_change` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `change_type` varchar(50) NOT NULL,
  `change_date` date NOT NULL,
  `before_change` int NOT NULL,
  `after_change` int NOT NULL,
  `change_amount` int NOT NULL,
  `ticket_id` varchar(255) DEFAULT NULL,
  `note` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_product_date` (`product_id`,`change_date`),
  CONSTRAINT `product_change_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_change`
--

LOCK TABLES `product_change` WRITE;
/*!40000 ALTER TABLE `product_change` DISABLE KEYS */;
INSERT INTO `product_change` VALUES (1,1,'MANUAL','2025-11-30',0,50,50,NULL,'Initial stock setup','2025-11-29 17:00:00',3),(2,1,'TRANSFER_TICKET','2025-12-01',50,70,20,'ACT-2025-001','Import - Monthly restock','2025-12-01 02:00:00',9),(3,1,'TRANSFER_TICKET','2025-12-05',70,90,20,'ACT-2025-005','Black Friday restock','2025-12-05 01:45:00',9),(4,1,'TRANSFER_TICKET','2025-12-10',90,95,5,'ACT-2025-010','Year-end adjustment','2025-12-10 00:15:00',10),(5,1,'TRANSFER_TICKET','2025-12-15',102,112,10,'ACT-2025-015','Backorder fulfillment','2025-12-15 03:55:00',9),(6,1,'MANUAL','2025-12-14',105,102,-3,NULL,'Damaged items removed','2025-12-13 20:30:00',3),(7,2,'MANUAL','2025-11-30',0,100,100,NULL,'Initial stock setup','2025-11-29 17:00:00',3),(8,2,'TRANSFER_TICKET','2025-12-02',100,110,10,'ACT-2025-002','Holiday sale stock','2025-12-02 03:30:00',10),(9,2,'TRANSFER_TICKET','2025-12-04',110,102,-8,'ACT-2025-004','Bulk order shipped','2025-12-03 21:30:00',10),(10,2,'TRANSFER_TICKET','2025-12-07',102,110,8,'ACT-2025-007','Emergency event stock','2025-12-06 22:45:00',9),(11,2,'TRANSFER_TICKET','2025-12-12',110,104,-6,'ACT-2025-012','Transfer to new store','2025-12-12 01:20:00',10),(12,2,'TRANSFER_TICKET','2025-12-15',104,116,12,'ACT-2025-017','Seasonal preparation','2025-12-17 00:50:00',9),(13,3,'MANUAL','2025-11-30',0,180,180,NULL,'Initial stock setup','2025-11-29 17:00:00',3),(14,3,'TRANSFER_TICKET','2025-12-02',180,195,15,'ACT-2025-002','Holiday sale stock','2025-12-02 03:30:00',10),(15,3,'TRANSFER_TICKET','2025-12-04',195,183,-12,'ACT-2025-004','Customer order shipped','2025-12-03 21:30:00',10),(16,3,'TRANSFER_TICKET','2025-12-07',183,195,12,'ACT-2025-007','Event preparation','2025-12-06 22:45:00',9),(17,3,'TRANSFER_TICKET','2025-12-12',195,203,8,'ACT-2025-012','New store setup','2025-12-12 01:20:00',10),(18,3,'TRANSFER_TICKET','2025-12-15',203,221,18,'ACT-2025-017','Seasonal stock','2025-12-17 00:50:00',9),(19,4,'MANUAL','2025-11-30',0,45,45,NULL,'Initial stock setup','2025-11-29 17:00:00',3),(20,4,'TRANSFER_TICKET','2025-12-01',45,80,35,'ACT-2025-001','Monthly restock','2025-12-01 02:00:00',9),(21,4,'TRANSFER_TICKET','2025-12-06',80,70,-10,'ACT-2025-006','Defective returns','2025-12-05 21:40:00',10),(22,4,'MANUAL','2025-12-11',70,82,12,NULL,'Inventory correction','2025-12-10 19:15:00',4),(23,4,'TRANSFER_TICKET','2025-12-15',82,62,-20,'ACT-2025-016','Clearance sale','2025-12-15 22:35:00',10),(24,5,'MANUAL','2025-11-30',0,14,14,NULL,'Initial stock setup','2025-11-29 17:00:00',3),(25,5,'TRANSFER_TICKET','2025-12-01',14,30,16,'ACT-2025-001','Inventory restock','2025-12-01 02:00:00',9),(26,5,'TRANSFER_TICKET','2025-12-06',30,25,-5,'ACT-2025-006','Defective returns','2025-12-05 21:40:00',10),(27,5,'MANUAL','2025-12-11',25,33,8,NULL,'Additional stock found','2025-12-10 21:45:00',4),(28,5,'TRANSFER_TICKET','2025-12-15',33,18,-15,'ACT-2025-016','Clearance sale','2025-12-15 22:35:00',10),(29,6,'MANUAL','2025-11-30',0,125,125,NULL,'Initial stock setup','2025-11-29 17:00:00',3),(30,6,'TRANSFER_TICKET','2025-12-03',125,150,25,'ACT-2025-003','New shipment','2025-12-03 04:15:00',9),(31,6,'TRANSFER_TICKET','2025-12-09',150,168,18,'ACT-2025-009','Project allocation','2025-12-08 23:55:00',9),(32,6,'TRANSFER_TICKET','2025-12-13',168,183,15,'ACT-2025-013','Supplier exchange','2025-12-13 02:40:00',9),(33,6,'TRANSFER_TICKET','2025-12-15',183,175,-8,'ACT-2025-018','Warranty replacements','2025-12-17 23:20:00',10),(34,6,'MANUAL','2025-12-14',175,178,3,NULL,'Found additional stock','2025-12-14 01:20:00',3),(35,7,'MANUAL','2025-11-30',0,70,70,NULL,'Initial stock setup','2025-11-29 17:00:00',3),(36,7,'TRANSFER_TICKET','2025-12-03',70,90,20,'ACT-2025-003','Restock after sale','2025-12-03 04:15:00',9),(37,7,'TRANSFER_TICKET','2025-12-09',90,100,10,'ACT-2025-009','Project requirements','2025-12-08 23:55:00',9),(38,7,'TRANSFER_TICKET','2025-12-13',100,110,10,'ACT-2025-013','Exchange program','2025-12-13 02:40:00',9),(39,7,'TRANSFER_TICKET','2025-12-15',110,104,-6,'ACT-2025-018','Warranty claims','2025-12-17 23:20:00',10),(40,7,'MANUAL','2025-12-15',104,106,2,NULL,'Inventory correction','2025-12-18 20:45:00',5),(41,8,'MANUAL','2025-11-30',0,270,270,NULL,'Initial stock setup','2025-11-29 17:00:00',3),(42,8,'TRANSFER_TICKET','2025-12-08',270,300,30,'ACT-2025-008','Inter-department transfer','2025-12-08 04:20:00',10),(43,8,'TRANSFER_TICKET','2025-12-14',300,325,25,'ACT-2025-014','Corporate order','2025-12-13 20:25:00',10),(44,8,'MANUAL','2025-12-09',300,295,-5,NULL,'Quality check - damaged','2025-12-08 21:15:00',9),(45,8,'TRANSFER_TICKET','2025-12-15',295,310,15,'ACT-2025-019','New year preparation','2025-12-19 00:50:00',9),(46,9,'MANUAL','2025-11-30',0,155,155,NULL,'Initial stock setup','2025-11-29 17:00:00',3),(47,9,'TRANSFER_TICKET','2025-12-08',155,180,25,'ACT-2025-008','Department transfer','2025-12-08 04:20:00',10),(48,9,'TRANSFER_TICKET','2025-12-14',180,200,20,'ACT-2025-014','Corporate client delivery','2025-12-13 20:25:00',10),(49,9,'MANUAL','2025-12-10',180,178,-2,NULL,'Test samples used','2025-12-10 02:30:00',4),(50,9,'MANUAL','2025-12-15',200,202,2,NULL,'Found misplaced stock','2025-12-15 00:20:00',5),(51,10,'MANUAL','2025-11-30',0,85,85,NULL,'Initial stock setup','2025-11-29 17:00:00',3),(52,10,'TRANSFER_TICKET','2025-12-05',85,100,15,'ACT-2025-005','Year-end adjustment','2025-12-05 01:45:00',9),(53,10,'TRANSFER_TICKET','2025-12-15',100,108,8,'ACT-2025-015','Backorder fulfillment','2025-12-15 03:55:00',9),(54,10,'MANUAL','2025-12-15',108,110,2,NULL,'Promotional stock','2025-12-19 19:30:00',3),(55,10,'MANUAL','2025-12-05',85,83,-2,NULL,'Demo unit used','2025-12-04 21:45:00',4),(56,11,'MANUAL','2025-11-30',0,90,90,NULL,'Initial stock setup','2025-11-29 17:00:00',3),(57,11,'MANUAL','2025-12-01',90,100,10,NULL,'Initial stock setup','2025-11-30 18:00:00',3),(58,11,'MANUAL','2025-12-10',100,95,-5,NULL,'Internal use','2025-12-09 20:30:00',4),(59,11,'MANUAL','2025-12-15',95,102,7,NULL,'Restock','2025-12-15 01:20:00',5);
/*!40000 ALTER TABLE `product_change` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_transfer_item`
--

DROP TABLE IF EXISTS `product_transfer_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_transfer_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ticket_id` int NOT NULL,
  `ticket_type` enum('request','actual') NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_transfer_item_product` (`product_id`),
  CONSTRAINT `fk_transfer_item_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_transfer_item`
--

LOCK TABLES `product_transfer_item` WRITE;
/*!40000 ALTER TABLE `product_transfer_item` DISABLE KEYS */;
INSERT INTO `product_transfer_item` VALUES (1,1,'request',1,20,'2025-11-30 19:00:00'),(2,1,'request',4,35,'2025-11-30 19:00:00'),(3,1,'request',5,16,'2025-11-30 19:00:00'),(4,2,'request',2,10,'2025-12-01 20:15:00'),(5,2,'request',3,15,'2025-12-01 20:15:00'),(6,3,'request',6,25,'2025-12-02 21:30:00'),(7,3,'request',7,20,'2025-12-02 21:30:00'),(8,4,'request',2,8,'2025-12-04 00:45:00'),(9,4,'request',3,12,'2025-12-04 00:45:00'),(10,5,'request',1,20,'2025-12-04 18:20:00'),(11,5,'request',10,15,'2025-12-04 18:20:00'),(12,6,'request',4,10,'2025-12-05 23:10:00'),(13,6,'request',5,5,'2025-12-05 23:10:00'),(14,7,'request',2,8,'2025-12-06 20:30:00'),(15,7,'request',3,12,'2025-12-06 20:30:00'),(16,8,'request',8,30,'2025-12-08 02:45:00'),(17,8,'request',9,25,'2025-12-08 02:45:00'),(18,9,'request',6,18,'2025-12-08 19:15:00'),(19,9,'request',7,10,'2025-12-08 19:15:00'),(20,10,'request',1,5,'2025-12-09 21:20:00'),(21,10,'request',10,10,'2025-12-09 21:20:00'),(22,11,'request',4,12,'2025-12-11 00:35:00'),(23,11,'request',5,8,'2025-12-11 00:35:00'),(24,12,'request',2,6,'2025-12-11 20:50:00'),(25,12,'request',3,8,'2025-12-11 20:50:00'),(26,13,'request',6,15,'2025-12-13 01:25:00'),(27,13,'request',7,10,'2025-12-13 01:25:00'),(28,14,'request',8,25,'2025-12-13 19:40:00'),(29,14,'request',9,20,'2025-12-13 19:40:00'),(30,15,'request',10,8,'2025-12-14 23:55:00'),(31,15,'request',1,10,'2025-12-14 23:55:00'),(32,16,'request',4,20,'2025-12-16 02:10:00'),(33,16,'request',5,15,'2025-12-16 02:10:00'),(34,17,'request',2,12,'2025-12-16 18:25:00'),(35,17,'request',3,18,'2025-12-16 18:25:00'),(36,18,'request',6,8,'2025-12-17 22:30:00'),(37,18,'request',7,6,'2025-12-17 22:30:00'),(38,19,'request',8,15,'2025-12-19 00:45:00'),(39,19,'request',9,12,'2025-12-19 00:45:00'),(40,20,'request',10,10,'2025-12-19 20:00:00'),(41,1,'actual',1,20,'2025-12-01 02:00:00'),(42,1,'actual',4,35,'2025-12-01 02:00:00'),(43,1,'actual',5,16,'2025-12-01 02:00:00'),(44,2,'actual',2,10,'2025-12-02 03:30:00'),(45,2,'actual',3,15,'2025-12-02 03:30:00'),(46,3,'actual',6,25,'2025-12-03 04:15:00'),(47,3,'actual',7,20,'2025-12-03 04:15:00'),(48,4,'actual',2,8,'2025-12-03 21:30:00'),(49,4,'actual',3,12,'2025-12-03 21:30:00'),(50,5,'actual',1,20,'2025-12-05 01:45:00'),(51,5,'actual',10,15,'2025-12-05 01:45:00'),(52,6,'actual',4,10,'2025-12-05 21:40:00'),(53,6,'actual',5,5,'2025-12-05 21:40:00'),(54,7,'actual',2,8,'2025-12-06 22:45:00'),(55,7,'actual',3,12,'2025-12-06 22:45:00'),(56,8,'actual',8,30,'2025-12-08 04:20:00'),(57,8,'actual',9,25,'2025-12-08 04:20:00'),(58,9,'actual',6,18,'2025-12-08 23:55:00'),(59,9,'actual',7,10,'2025-12-08 23:55:00'),(60,10,'actual',1,5,'2025-12-10 00:15:00');
/*!40000 ALTER TABLE `product_transfer_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `request_transfer_ticket`
--

DROP TABLE IF EXISTS `request_transfer_ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `request_transfer_ticket` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ticketCode` varchar(50) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `requestDate` date DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `createdBy` int DEFAULT NULL,
  `note` text,
  `employeeId` int DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ticketCode` (`ticketCode`),
  KEY `fk_request_created_by` (`createdBy`),
  KEY `fk_request_employee` (`employeeId`),
  CONSTRAINT `fk_request_created_by` FOREIGN KEY (`createdBy`) REFERENCES `user` (`userId`),
  CONSTRAINT `fk_request_employee` FOREIGN KEY (`employeeId`) REFERENCES `user` (`userId`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `request_transfer_ticket`
--

LOCK TABLES `request_transfer_ticket` WRITE;
/*!40000 ALTER TABLE `request_transfer_ticket` DISABLE KEYS */;
INSERT INTO `request_transfer_ticket` VALUES (1,'REQ-2025-001','Import','2025-12-01','Completed',3,'Monthly inventory restock from main warehouse',6,'2025-11-30 19:00:00'),(2,'REQ-2025-002','Export','2025-12-02','Completed',4,'Transfer to branch store for holiday sale',7,'2025-12-01 20:15:00'),(3,'REQ-2025-003','Import','2025-12-03','Completed',5,'New product shipment from supplier TechParts',8,'2025-12-02 21:30:00'),(4,'REQ-2025-004','Export','2025-12-04','Completed',3,'Customer bulk order fulfillment',6,'2025-12-04 00:45:00'),(5,'REQ-2025-005','Import','2025-12-05','Completed',4,'Restock after Black Friday sale',7,'2025-12-04 18:20:00'),(6,'REQ-2025-006','Export','2025-12-06','Completed',5,'Return defective items to supplier',8,'2025-12-05 23:10:00'),(7,'REQ-2025-007','Import','2025-12-07','Completed',3,'Emergency stock for upcoming event',6,'2025-12-06 20:30:00'),(8,'REQ-2025-008','Export','2025-12-08','Completed',4,'Inter-department transfer for project',7,'2025-12-08 02:45:00'),(9,'REQ-2025-009','Import','2025-12-09','Completed',5,'New product line from Gaming Gear Co.',8,'2025-12-08 19:15:00'),(10,'REQ-2025-010','Export','2025-12-10','Completed',3,'Year-end inventory adjustment',6,'2025-12-09 21:20:00'),(11,'REQ-2025-011','Import','2025-12-11','Completed',4,'Restock popular items',7,'2025-12-11 00:35:00'),(12,'REQ-2025-012','Export','2025-12-12','Completed',5,'Transfer to new store location',8,'2025-12-11 20:50:00'),(13,'REQ-2025-013','Import','2025-12-13','Completed',3,'Supplier exchange program',6,'2025-12-13 01:25:00'),(14,'REQ-2025-014','Export','2025-12-14','Completed',4,'Corporate client order',7,'2025-12-13 19:40:00'),(15,'REQ-2025-015','Import','2025-12-15','Completed',5,'Backorder fulfillment',8,'2025-12-14 23:55:00'),(16,'REQ-2025-016','Export','2025-12-16','Pending',3,'Clearance sale stock',6,'2025-12-16 02:10:00'),(17,'REQ-2025-017','Import','2025-12-17','Approved',4,'Seasonal product preparation',7,'2025-12-16 18:25:00'),(18,'REQ-2025-018','Export','2025-12-18','Approved',5,'Warranty replacement items',8,'2025-12-17 22:30:00'),(19,'REQ-2025-019','Import','2025-12-19','Pending',3,'New year inventory preparation',6,'2025-12-19 00:45:00'),(20,'REQ-2025-020','Export','2025-12-20','Approved',4,'Promotional event materials',7,'2025-12-19 20:00:00');
/*!40000 ALTER TABLE `request_transfer_ticket` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `roleId` int NOT NULL AUTO_INCREMENT,
  `roleName` varchar(50) NOT NULL,
  `roleDescription` varchar(255) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`roleId`),
  UNIQUE KEY `roleName` (`roleName`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (1,'admin','Administrator with full system access','active','2025-12-03 17:10:25','2025-12-03 17:10:25'),(2,'manager','Manager with management privileges','active','2025-12-03 17:10:25','2025-12-03 17:10:25'),(3,'employee','Regular employee with basic access','active','2025-12-03 17:10:25','2025-12-03 17:10:25'),(4,'storekeeper','Store keeper with inventory access','active','2025-12-03 17:10:25','2025-12-03 17:10:25'),(5,'ship','shippp','inactive','2025-12-07 18:16:12','2025-12-07 18:17:10');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_permission`
--

DROP TABLE IF EXISTS `role_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_permission` (
  `roleId` int NOT NULL,
  `permissionId` int NOT NULL,
  `grantedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`roleId`,`permissionId`),
  KEY `permissionId` (`permissionId`),
  CONSTRAINT `role_permission_ibfk_1` FOREIGN KEY (`roleId`) REFERENCES `role` (`roleId`) ON DELETE CASCADE,
  CONSTRAINT `role_permission_ibfk_2` FOREIGN KEY (`permissionId`) REFERENCES `permission` (`permissionId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_permission`
--

LOCK TABLES `role_permission` WRITE;
/*!40000 ALTER TABLE `role_permission` DISABLE KEYS */;
INSERT INTO `role_permission` VALUES (1,1,'2025-12-08 04:28:18'),(1,2,'2025-12-03 17:10:25'),(1,3,'2025-12-03 17:10:25'),(1,4,'2025-12-03 17:10:25'),(1,5,'2025-12-07 17:38:03'),(1,6,'2025-12-03 17:10:25'),(1,7,'2025-12-03 17:10:25'),(1,8,'2025-12-03 17:10:25'),(1,9,'2025-12-03 17:10:25'),(1,10,'2025-12-03 17:10:25'),(1,11,'2025-12-03 17:10:25'),(1,12,'2025-12-03 17:10:25'),(1,13,'2025-12-03 17:10:25'),(1,14,'2025-12-03 17:10:25'),(1,15,'2025-12-03 17:10:25'),(1,16,'2025-12-03 17:10:25'),(1,17,'2025-12-03 17:10:25'),(1,18,'2025-12-03 17:10:25'),(1,23,'2025-12-11 14:51:08'),(2,1,'2025-12-03 17:10:25'),(2,2,'2025-12-03 17:10:25'),(2,3,'2025-12-03 17:10:25'),(2,4,'2025-12-03 17:10:25'),(2,5,'2025-12-07 17:36:43'),(2,6,'2025-12-03 17:10:25'),(2,7,'2025-12-03 17:10:25'),(2,9,'2025-12-03 17:10:25'),(2,10,'2025-12-03 17:10:25'),(2,11,'2025-12-03 17:10:25'),(2,12,'2025-12-03 17:10:25'),(2,19,'2025-12-11 04:03:40'),(2,20,'2025-12-11 04:03:37'),(2,21,'2025-12-11 04:03:34'),(2,22,'2025-12-11 14:29:34'),(2,28,'2025-12-12 03:50:17'),(2,29,'2025-12-12 03:50:13'),(2,30,'2025-12-12 03:50:11'),(2,31,'2025-12-12 03:50:07'),(2,36,'2025-12-14 05:14:52'),(2,37,'2025-12-14 05:14:55'),(2,38,'2025-12-14 05:14:58'),(2,39,'2025-12-14 05:15:00'),(2,40,'2025-12-14 10:13:04'),(2,41,'2025-12-14 10:13:07'),(3,1,'2025-12-03 17:10:25'),(3,2,'2025-12-03 17:10:25'),(3,3,'2025-12-03 17:10:25'),(3,4,'2025-12-03 17:10:25'),(3,5,'2025-12-03 17:10:25'),(3,6,'2025-12-03 17:10:25'),(3,7,'2025-12-03 17:10:25'),(3,24,'2025-12-12 02:43:36'),(3,25,'2025-12-12 02:43:44'),(3,26,'2025-12-12 02:43:42'),(3,27,'2025-12-12 02:43:40'),(3,32,'2025-12-13 12:01:33'),(3,33,'2025-12-13 12:01:38'),(3,34,'2025-12-16 12:00:00'),(3,35,'2025-12-16 12:00:00'),(3,37,'2025-12-14 05:15:14'),(3,38,'2025-12-14 05:15:17'),(4,1,'2025-12-03 17:10:25'),(4,2,'2025-12-03 17:10:25'),(4,3,'2025-12-03 17:10:25'),(4,4,'2025-12-03 17:10:25'),(4,5,'2025-12-03 17:10:25'),(4,6,'2025-12-03 17:10:25'),(4,7,'2025-12-03 17:10:25'),(4,24,'2025-12-12 02:45:31'),(4,25,'2025-12-12 02:45:34'),(4,32,'2025-12-13 12:01:53'),(4,33,'2025-12-13 12:01:50'),(4,34,'2025-12-13 12:01:48'),(4,35,'2025-12-13 12:01:45'),(4,37,'2025-12-14 05:15:25'),(4,38,'2025-12-14 05:15:23'),(4,42,'2025-12-16 12:00:00'),(4,43,'2025-12-16 12:00:00');
/*!40000 ALTER TABLE `role_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `supplier`
--

DROP TABLE IF EXISTS `supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supplier` (
  `id` int NOT NULL AUTO_INCREMENT,
  `supplierCode` varchar(50) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `contactPerson` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` varchar(500) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'active',
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `supplierCode` (`supplierCode`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier`
--

LOCK TABLES `supplier` WRITE;
/*!40000 ALTER TABLE `supplier` DISABLE KEYS */;
INSERT INTO `supplier` VALUES (1,'SUP001','TechParts Inc.ccccc','John Smith','0901111111','john@techparts.com','123 Tech Street, City','active','2025-12-09 14:04:49'),(2,'SUP002','PC Components Ltd.','Sarah Johnson','0902222222','sarah@pccomponents.com','456 Component Ave, City','active','2025-12-09 14:04:49'),(3,'SUP003','Hardware World','Mike Brown','0903333333','mike@hardwareworld.com','789 Hardware Blvd, City','active','2025-12-09 14:04:49'),(4,'SUP004','Electro Supplies','Lisa Davis','0904444444','lisa@electrosupplies.com','321 Electro Road, City','active','2025-12-09 14:04:49'),(5,'SUP005','Gaming Gear Co.','Tom Wilson','0905555555','tom@gaminggear.com','654 Gaming Street, City','active','2025-12-09 14:04:49'),(6,'SUP006','Monitor Masters','Emma Clark','0906666666','emma@monitormasters.com','987 Monitor Way, City','active','2025-12-09 14:04:49'),(7,'SUP007','Keyboard Kings','James Lee','0907777777','james@keyboardkings.com','159 Keyboard Lane, City','active','2025-12-09 14:04:49'),(8,'SUP008','Mouse Mania','Olivia White','0908888888','olivia@mousemania.com','753 Mouse Road, City','active','2025-12-09 14:04:49'),(9,'SUP009','Cable Creators','Robert Harris','0909999999','robert@cablecreators.com','852 Cable Blvd, City','active','2025-12-09 14:04:49'),(10,'SUP010','Storage Solutions','Patricia Martin','0900000000','patricia@storagesolutions.com','951 Storage Ave, City','active','2025-12-09 14:04:49');
/*!40000 ALTER TABLE `supplier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `userId` int NOT NULL AUTO_INCREMENT,
  `accountName` varchar(50) NOT NULL,
  `displayName` varchar(100) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(100) DEFAULT NULL,
  `roleId` int DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `departmentId` int DEFAULT NULL,
  `verificationCode` varchar(255) DEFAULT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`userId`),
  UNIQUE KEY `accountName` (`accountName`),
  KEY `roleId` (`roleId`),
  CONSTRAINT `user_ibfk_1` FOREIGN KEY (`roleId`) REFERENCES `role` (`roleId`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'admin','System Administratorrrttttqeqwew','0192023a7bbd73250516f069df18b500','tuanhdhe173314@fpt.edu.vn','0912345678',1,'active',NULL,'5b07e1ae-c2ed-4158-9d98-8395a4da3f8e',NULL,'2025-12-03 17:10:25','2025-12-11 16:08:19'),(2,'superadmin','Super Admin','0192023a7bbd73250516f069df18b500','superadmin@company.com','0923456789',1,'active',NULL,NULL,'token_superadmin_002','2025-12-03 17:10:25','2025-12-13 12:03:35'),(3,'manager1','John Manager','0192023a7bbd73250516f069df18b500','john.manager@company.com','0934567890',2,'active',NULL,NULL,'token_manager1_003','2025-12-03 17:10:25','2025-12-13 12:03:35'),(4,'manager2','Jane Manager','0192023a7bbd73250516f069df18b500','jane.manager@company.com','0945678901',2,'active',NULL,NULL,'token_manager2_004','2025-12-03 17:10:25','2025-12-13 12:03:35'),(5,'employee1','Bob Employee','0192023a7bbd73250516f069df18b500','bob.employee@company.com','0956789012',3,'inactive',NULL,NULL,'token_emp1_005','2025-12-03 17:10:25','2025-12-13 12:03:35'),(6,'employee2','Alice Employee','0192023a7bbd73250516f069df18b500','alice.employee@company.com','0967890123',3,'active',1,NULL,'token_emp2_006','2025-12-03 17:10:25','2025-12-13 12:03:35'),(7,'employee3','Charlie Employee','0192023a7bbd73250516f069df18b500','charlie.employee@company.com','0978901234',3,'active',0,NULL,'token_emp3_007','2025-12-03 17:10:25','2025-12-13 12:03:35'),(8,'employee4','Diana Employee','0192023a7bbd73250516f069df18b500','diana.employee@company.com','0989012345',3,'inactive',NULL,NULL,'token_emp4_008','2025-12-03 17:10:25','2025-12-13 12:03:35'),(9,'storekeeper1','Sam Storekeeper','0192023a7bbd73250516f069df18b500','sam.store@company.com','0990123456',4,'active',1,NULL,'token_store1_009','2025-12-03 17:10:25','2025-12-13 12:03:35'),(10,'storekeeper2','Linda Storekeeper','0192023a7bbd73250516f069df18b500','linda.store@company.com','0901234567',4,'active',2,NULL,'token_store2_010','2025-12-03 17:10:25','2025-12-13 12:03:35'),(11,'admin2','asdasdasd','0192023a7bbd73250516f069df18b500','hoangdinhtuanaladin@gmail.com','0862199478',3,'active',2,'fad3bef7-d862-4e29-a15a-aa3c2dc1c765','08e91dd9-5f7e-4025-afdd-9e460019a7f6','2025-12-04 04:54:41','2025-12-13 12:03:35'),(14,'storekeeper3','Alex Storekeeper','0192023a7bbd73250516f069df18b500','alex.store@company.com','0912345670',4,'active',1,NULL,NULL,'2025-12-14 10:43:16','2025-12-14 10:43:16'),(15,'storekeeper4','Maria Storekeeper','0192023a7bbd73250516f069df18b500','maria.store@company.com','0912345671',4,'active',2,NULL,NULL,'2025-12-14 10:43:16','2025-12-14 10:43:16'),(16,'storekeeper5','David Storekeeper','0192023a7bbd73250516f069df18b500','david.store@company.com','0912345672',4,'active',1,NULL,NULL,'2025-12-14 10:43:16','2025-12-14 10:43:16'),(17,'employee5','Emma Employee','0192023a7bbd73250516f069df18b500','emma.employee@company.com','0912345673',3,'active',1,NULL,NULL,'2025-12-14 10:43:16','2025-12-14 10:43:16'),(18,'employee6','Michael Employee','0192023a7bbd73250516f069df18b500','michael.employee@company.com','0912345674',3,'active',2,NULL,NULL,'2025-12-14 10:43:16','2025-12-14 10:43:16'),(19,'employee7','Sophia Employee','0192023a7bbd73250516f069df18b500','sophia.employee@company.com','0912345675',3,'active',1,NULL,NULL,'2025-12-14 10:43:16','2025-12-14 10:43:16'),(20,'employee8','Daniel Employee','0192023a7bbd73250516f069df18b500','daniel.employee@company.com','0912345676',3,'active',2,NULL,NULL,'2025-12-14 10:43:16','2025-12-14 10:43:16'),(21,'employee9','Olivia Employee','0192023a7bbd73250516f069df18b500','olivia.employee@company.com','0912345677',3,'active',1,NULL,NULL,'2025-12-14 10:43:16','2025-12-14 10:43:16'),(22,'employee10','James Employee','0192023a7bbd73250516f069df18b500','james.employee@company.com','0912345678',3,'active',2,NULL,NULL,'2025-12-14 10:43:16','2025-12-14 10:43:16'),(23,'employee11','Sarah Employee','0192023a7bbd73250516f069df18b500','sarah.employee@company.com','0912345679',3,'active',1,NULL,NULL,'2025-12-14 10:43:16','2025-12-14 10:43:16');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-14 19:43:36
