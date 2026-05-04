/*
SQLyog Community v13.3.0 (64 bit)
MySQL - 9.6.0 : Database - expense_tracker
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`expense_tracker` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `expense_tracker`;

/*Table structure for table `budget` */

DROP TABLE IF EXISTS `budget`;

CREATE TABLE `budget` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `month` varchar(20) DEFAULT NULL,
  `limit_amount` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `budget` */

insert  into `budget`(`id`,`user_id`,`category`,`month`,`limit_amount`) values 
(1,1,'Bills','3',4000),
(2,1,'Food','3',40000),
(3,3,'Clothes','3',4000),
(4,1,'Clothes','3',6000),
(5,1,'Bills','4',6000),
(6,1,'Clothes','4',10000),
(7,1,'Food','4',10000),
(8,1,'Medical','4',5000),
(9,1,'Shopping','4',5000);

/*Table structure for table `expense_split` */

DROP TABLE IF EXISTS `expense_split`;

CREATE TABLE `expense_split` (
  `id` int NOT NULL AUTO_INCREMENT,
  `expense_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `expense_id` (`expense_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `expense_split_ibfk_1` FOREIGN KEY (`expense_id`) REFERENCES `expenses` (`id`),
  CONSTRAINT `expense_split_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `expense_split` */

insert  into `expense_split`(`id`,`expense_id`,`user_id`) values 
(1,37,1),
(2,37,2),
(3,38,1),
(4,38,2),
(5,38,3),
(6,38,5),
(7,38,4),
(8,42,1),
(9,42,2),
(10,42,3),
(11,42,4),
(12,44,1),
(13,44,5),
(14,46,1),
(15,46,2),
(16,46,3);

/*Table structure for table `expenses` */

DROP TABLE IF EXISTS `expenses`;

CREATE TABLE `expenses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `group_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `expenses_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `expenses` */

insert  into `expenses`(`id`,`user_id`,`category`,`amount`,`date`,`group_id`) values 
(1,1,'Clothes',2050,'2026-03-23 14:30:37',NULL),
(2,1,'Clothes',3000,'2026-03-23 14:30:49',NULL),
(3,1,'Food',400,'2026-03-23 14:41:29',NULL),
(4,1,'Food',200,'2026-03-23 22:54:50',NULL),
(7,1,'Bills',101,'2026-03-23 23:40:46',NULL),
(9,3,'Clothes',2000,'2026-03-27 00:44:02',NULL),
(10,3,'Clothes',3000,'2026-03-27 00:44:37',NULL),
(17,1,'Food',5,'2026-03-29 19:57:04',NULL),
(25,1,NULL,800,'2026-04-10 00:57:42',3),
(26,1,NULL,700,'2026-04-10 00:58:02',3),
(27,1,'Food',800,'2026-04-10 01:04:59',3),
(28,2,'Food',700,'2026-04-10 01:06:30',1),
(29,2,'Groceries',100,'2026-04-10 01:06:38',1),
(30,1,'Food',400,'2026-04-10 01:07:27',1),
(31,3,'Food',200,'2026-04-10 01:08:41',1),
(34,1,'Food',22,'2026-04-15 15:34:42',NULL),
(35,1,'Food',11,'2026-04-15 15:36:06',1),
(36,1,'Shopping',2000,'2026-04-17 16:31:17',NULL),
(37,1,'Shopping',2000,'2026-04-17 16:36:06',1),
(38,1,'Clothes',300,'2026-04-17 16:41:32',1),
(39,1,'Entertainment',800,'2026-04-17 17:10:32',NULL),
(40,1,'Shopping',1000,'2026-04-17 17:10:49',NULL),
(41,1,'Fuel',300,'2026-04-17 17:13:33',NULL),
(42,1,'food',2000,'2026-04-26 16:49:34',1),
(43,1,'Medical',200,'2026-04-26 16:54:52',NULL),
(44,1,'Medical',300,'2026-04-26 16:59:05',1),
(46,1,'Food',850,'2026-04-27 12:12:19',1);

/*Table structure for table `group_members` */

DROP TABLE IF EXISTS `group_members`;

CREATE TABLE `group_members` (
  `id` int NOT NULL AUTO_INCREMENT,
  `group_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `group_members` */

insert  into `group_members`(`id`,`group_id`,`user_id`) values 
(1,1,1),
(2,1,2),
(3,2,2),
(4,3,3),
(5,3,1),
(6,4,1),
(7,1,3),
(8,1,5),
(9,1,4),
(10,5,1),
(11,6,1),
(13,7,1),
(14,8,1);

/*Table structure for table `user_groups` */

DROP TABLE IF EXISTS `user_groups`;

CREATE TABLE `user_groups` (
  `id` int NOT NULL AUTO_INCREMENT,
  `group_name` varchar(100) DEFAULT NULL,
  `created_by` int DEFAULT NULL,
  `invite_code` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `user_groups` */

insert  into `user_groups`(`id`,`group_name`,`created_by`,`invite_code`) values 
(1,'manali',1,'948222'),
(5,'kokan',1,'bdaf22'),
(7,'xyz',1,'1ff66b'),
(8,'trip',1,'d9a37d');

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `users` */

insert  into `users`(`id`,`name`,`email`,`password`) values 
(1,'vaishnavi','abc@gmail.com','123456'),
(2,'Anjali','xyz@gmail.com','123456'),
(3,'Om','pqr@gmail.com','123456'),
(4,'Komal','q@gmail.com','123456'),
(5,'Ved','mno@gmail.com','123456');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
