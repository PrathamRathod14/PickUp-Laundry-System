-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 04, 2024 at 01:59 PM
-- Server version: 10.4.25-MariaDB
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pickup_laundry`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetClothDetailsByClothId` (IN `clothId` INT)   SELECT * FROM Cloth WHERE clothCode = clothId$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `cloth`
--

CREATE TABLE `cloth` (
  `clothCode` int(11) NOT NULL,
  `clothName` varchar(50) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `cloth`
--

INSERT INTO `cloth` (`clothCode`, `clothName`, `description`) VALUES
(1, 'Dress', 'This is a dress.'),
(2, 'Skirt', 'This is a skirt.'),
(3, 'Bedsheets', 'This are the bedsheets.'),
(4, 'Curtains', 'This are the curtains.'),
(5, 'Jacket', 'This is a jacket.');

-- --------------------------------------------------------

--
-- Table structure for table `orderdetail`
--

CREATE TABLE `orderdetail` (
  `id` int(11) NOT NULL,
  `orderNo` int(11) DEFAULT NULL,
  `clothCode` int(11) DEFAULT NULL,
  `serviceCode` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `amount` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `orderdetail`
--

INSERT INTO `orderdetail` (`id`, `orderNo`, `clothCode`, `serviceCode`, `quantity`, `amount`) VALUES
(1, 1, 1, 1, 2, 100.5),
(2, 2, 1, 1, 2, 100.5),
(3, 2, 1, 2, 2, 91),
(4, 2, 1, 3, 2, 120),
(5, 2, 1, 4, 2, 78),
(6, 3, 1, 1, 5, 100.5),
(7, 3, 1, 3, 5, 120);

-- --------------------------------------------------------

--
-- Table structure for table `ordermaster`
--

CREATE TABLE `ordermaster` (
  `orderNo` int(11) NOT NULL,
  `mobileNo` char(10) DEFAULT NULL,
  `orderAmount` double NOT NULL,
  `orderDate` timestamp NOT NULL DEFAULT current_timestamp(),
  `orderpickupTime` varchar(15) NOT NULL,
  `expectedDeliveryDate` date DEFAULT NULL,
  `isAmountPaid` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `ordermaster`
--

INSERT INTO `ordermaster` (`orderNo`, `mobileNo`, `orderAmount`, `orderDate`, `orderpickupTime`, `expectedDeliveryDate`, `isAmountPaid`) VALUES
(1, '9157510123', 402, '2023-12-05 12:22:53', 'Morning', '2023-12-06', 0),
(2, '9157510123', 1558, '2023-12-05 12:23:28', 'Morning', '2023-12-06', 0),
(3, '9157510121', 5512.5, '2024-03-04 12:12:53', 'Morning', '2024-03-05', 0);

-- --------------------------------------------------------

--
-- Table structure for table `orderstaff`
--

CREATE TABLE `orderstaff` (
  `osid` int(11) NOT NULL,
  `mobileNo` char(10) DEFAULT NULL,
  `orderNo` int(11) DEFAULT NULL,
  `status` enum('pending','pickup','delivered') NOT NULL DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `ratemaster`
--

CREATE TABLE `ratemaster` (
  `clothCode` int(11) NOT NULL,
  `serviceCode` int(11) NOT NULL,
  `price` double NOT NULL,
  `processingDays` int(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `ratemaster`
--

INSERT INTO `ratemaster` (`clothCode`, `serviceCode`, `price`, `processingDays`) VALUES
(1, 1, 100.5, 3),
(1, 2, 91, 2),
(1, 3, 120, 1),
(1, 4, 78, 2),
(2, 1, 152, 4),
(2, 2, 83.5, 3),
(2, 3, 140, 2),
(2, 4, 86.5, 3),
(3, 1, 102, 2),
(3, 2, 105, 2),
(3, 3, 134.5, 1),
(3, 4, 65, 2),
(4, 1, 148, 5),
(4, 2, 111, 4),
(4, 3, 122, 2),
(4, 4, 93.5, 4),
(5, 1, 140.5, 4),
(5, 2, 90, 3),
(5, 3, 129.5, 2),
(5, 4, 89, 3);

-- --------------------------------------------------------

--
-- Table structure for table `role`
--

CREATE TABLE `role` (
  `roleId` int(2) NOT NULL,
  `roleName` char(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `role`
--

INSERT INTO `role` (`roleId`, `roleName`) VALUES
(1, 'Admin'),
(2, 'Customer'),
(3, 'Staff');

-- --------------------------------------------------------

--
-- Table structure for table `service`
--

CREATE TABLE `service` (
  `serviceCode` int(11) NOT NULL,
  `serviceName` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `serviceImg` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `service`
--

INSERT INTO `service` (`serviceCode`, `serviceName`, `description`, `serviceImg`) VALUES
(1, 'Dry Clean', 'This service will dry clean your clothes.', 'DryClean.jpeg'),
(2, 'Washing', 'This service will wash your clothes.', 'Washing.jpeg'),
(3, 'Ironing', 'This service will iron your clothes.', 'Ironing.jpeg'),
(4, 'Starching', 'This service will starch your clothes.', 'Starching.jpeg');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `mobileNo` char(10) NOT NULL,
  `userName` varchar(20) NOT NULL,
  `password` varchar(10) NOT NULL,
  `email` varchar(60) NOT NULL,
  `city` varchar(28) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `registrationDate` datetime DEFAULT NULL,
  `roleId` int(2) DEFAULT NULL,
  `status` int(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`mobileNo`, `userName`, `password`, `email`, `city`, `address`, `registrationDate`, `roleId`, `status`) VALUES
('9157510121', 'darshannnn', 'DARSHAN1_', 'darshan123@gmail.com', 'Surat', 'Landmark', '2024-03-04 17:41:26', 2, 1),
('9157510123', 'darshan', 'DARSHAN_', 'harsh4499@gmail.com', 'Surat', 'Tulsi Park Society', '2023-12-05 17:42:40', 2, 1),
('9751435145', 'hiten', 'HITEN123_', 'hiten@gmail.com', 'Navsari', '101, 102 Bilimora', '2023-12-05 18:07:59', 1, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cloth`
--
ALTER TABLE `cloth`
  ADD PRIMARY KEY (`clothCode`);

--
-- Indexes for table `orderdetail`
--
ALTER TABLE `orderdetail`
  ADD PRIMARY KEY (`id`),
  ADD KEY `orderNo` (`orderNo`),
  ADD KEY `clothCode` (`clothCode`),
  ADD KEY `serviceCode` (`serviceCode`);

--
-- Indexes for table `ordermaster`
--
ALTER TABLE `ordermaster`
  ADD PRIMARY KEY (`orderNo`),
  ADD KEY `mobileNo` (`mobileNo`);

--
-- Indexes for table `orderstaff`
--
ALTER TABLE `orderstaff`
  ADD PRIMARY KEY (`osid`),
  ADD KEY `mobileNo` (`mobileNo`),
  ADD KEY `orderNo` (`orderNo`);

--
-- Indexes for table `ratemaster`
--
ALTER TABLE `ratemaster`
  ADD PRIMARY KEY (`clothCode`,`serviceCode`),
  ADD KEY `serviceCode` (`serviceCode`);

--
-- Indexes for table `role`
--
ALTER TABLE `role`
  ADD PRIMARY KEY (`roleId`);

--
-- Indexes for table `service`
--
ALTER TABLE `service`
  ADD PRIMARY KEY (`serviceCode`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`mobileNo`),
  ADD KEY `roleId` (`roleId`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cloth`
--
ALTER TABLE `cloth`
  MODIFY `clothCode` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `orderdetail`
--
ALTER TABLE `orderdetail`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `ordermaster`
--
ALTER TABLE `ordermaster`
  MODIFY `orderNo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `orderstaff`
--
ALTER TABLE `orderstaff`
  MODIFY `osid` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `role`
--
ALTER TABLE `role`
  MODIFY `roleId` int(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `service`
--
ALTER TABLE `service`
  MODIFY `serviceCode` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `orderdetail`
--
ALTER TABLE `orderdetail`
  ADD CONSTRAINT `orderdetail_ibfk_1` FOREIGN KEY (`orderNo`) REFERENCES `ordermaster` (`orderNo`),
  ADD CONSTRAINT `orderdetail_ibfk_2` FOREIGN KEY (`clothCode`) REFERENCES `cloth` (`clothCode`),
  ADD CONSTRAINT `orderdetail_ibfk_3` FOREIGN KEY (`serviceCode`) REFERENCES `service` (`serviceCode`);

--
-- Constraints for table `ordermaster`
--
ALTER TABLE `ordermaster`
  ADD CONSTRAINT `ordermaster_ibfk_1` FOREIGN KEY (`mobileNo`) REFERENCES `user` (`mobileNo`);

--
-- Constraints for table `orderstaff`
--
ALTER TABLE `orderstaff`
  ADD CONSTRAINT `orderstaff_ibfk_1` FOREIGN KEY (`mobileNo`) REFERENCES `user` (`mobileNo`),
  ADD CONSTRAINT `orderstaff_ibfk_2` FOREIGN KEY (`orderNo`) REFERENCES `ordermaster` (`orderNo`);

--
-- Constraints for table `ratemaster`
--
ALTER TABLE `ratemaster`
  ADD CONSTRAINT `ratemaster_ibfk_1` FOREIGN KEY (`clothCode`) REFERENCES `cloth` (`clothCode`),
  ADD CONSTRAINT `ratemaster_ibfk_2` FOREIGN KEY (`serviceCode`) REFERENCES `service` (`serviceCode`);

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user_ibfk_1` FOREIGN KEY (`roleId`) REFERENCES `role` (`roleId`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
