USE Pickup_Laundry;

CREATE TABLE Role
(
	roleId INT(2) AUTO_INCREMENT PRIMARY KEY,
	roleName CHAR(8) NOT NULL
);

INSERT INTO Role(roleName) VALUES
("Admin"),
("Customer"),
("Staff");


CREATE TABLE User
(
	mobileNo CHAR(10) PRIMARY KEY,
	userName VARCHAR(20) NOT NULL,
	password VARCHAR(10) NOT NULL,
	email VARCHAR(60) NOT NULL,
	city VARCHAR(28),
	address VARCHAR(255),
	registrationDate DATETIME,
	roleId INT(2),
	status INT(1) DEFAULT 1,
	FOREIGN KEY (roleId) REFERENCES Role(roleId)
);


CREATE TABLE Cloth
(
	clothCode INT AUTO_INCREMENT PRIMARY KEY,
	clothName VARCHAR(50) NOT NULL,
	description TEXT
);

INSERT INTO Cloth(clothName, description) VALUES
("Dress","This is a dress."),
("Skirt","This is a skirt."),
("Bedsheets","This are the bedsheets."),
("Curtains","This are the curtains."),
("Jacket","This is a jacket.");


CREATE TABLE Service
(
	serviceCode INT AUTO_INCREMENT PRIMARY KEY,
	serviceName VARCHAR(50) NOT NULL,
	description TEXT,
	serviceImg VARCHAR(255)
);

INSERT INTO Service(serviceName, description, serviceImg) VALUES
("Dry Clean","This service will dry clean your clothes.","DryClean.jpeg"),
("Washing","This service will wash your clothes.","Washing.jpeg"),
("Ironing","This service will iron your clothes.","Ironing.jpeg"),
("Starching","This service will starch your clothes.","Starching.jpeg");


CREATE TABLE RateMaster
(
	clothCode INT,
	serviceCode INT,
	price DOUBLE NOT NULL,
	processingDays INT(2),
	PRIMARY KEY(clothCode, serviceCode),
	FOREIGN KEY (clothCode) REFERENCES Cloth(clothCode),
	FOREIGN KEY (serviceCode) REFERENCES Service(serviceCode)
);

-- Rate for Dry Clean for each cloth
INSERT INTO RateMaster (clothCode, serviceCode, price, processingDays) VALUES
(1, 1, 100.50, 3),
(2, 1, 152.00, 4),
(3, 1, 102.00, 2),
(4, 1, 148.00, 5),
(5, 1, 140.50, 4);

-- Rate for Washing for each cloth
INSERT INTO RateMaster (clothCode, serviceCode, price, processingDays) VALUES
(1, 2, 91.00, 2),
(2, 2, 83.50, 3),
(3, 2, 105.00, 2),
(4, 2, 111.00, 4),
(5, 2, 90.00, 3);

-- Rate for Ironing for each cloth
INSERT INTO RateMaster (clothCode, serviceCode, price, processingDays) VALUES
(1, 3, 120.00, 1),
(2, 3, 140.00, 2),
(3, 3, 134.50, 1),
(4, 3, 122.00, 2),
(5, 3, 129.50, 2);

-- Rate for Starching for each cloth
INSERT INTO RateMaster (clothCode, serviceCode, price, processingDays) VALUES
(1, 4, 78.00, 2),
(2, 4, 86.50, 3),
(3, 4, 65.00, 2),
(4, 4, 93.50, 4),
(5, 4, 89.00, 3);



CREATE TABLE OrderMaster
(
	orderNo INT AUTO_INCREMENT PRIMARY KEY,
	mobileNo CHAR(10),
	orderAmount DOUBLE NOT NULL,
	orderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	orderpickupTime VARCHAR(15) NOT NULL,
	expectedDeliveryDate DATE,
	isAmountPaid BOOLEAN NOT NULL,
	FOREIGN KEY (mobileNo) REFERENCES User(mobileNo)
);

CREATE TABLE OrderDetail
(
	id INT AUTO_INCREMENT PRIMARY KEY,
	orderNo INT,
	clothCode INT,
	serviceCode INT,
	quantity INT NOT NULL,
	amount DOUBLE NOT NULL,
	FOREIGN KEY (orderNo) REFERENCES OrderMaster(orderNo),
	FOREIGN KEY (clothCode) REFERENCES Cloth(clothCode),
	FOREIGN KEY (serviceCode) REFERENCES Service(serviceCode)
);

CREATE TABLE OrderStaff
(
	osid INT AUTO_INCREMENT PRIMARY KEY,
	mobileNo CHAR(10),
	orderNo INT,
	status ENUM('pending', 'pickup', 'delivered') NOT NULL DEFAULT 'pending',
	FOREIGN KEY (mobileNo) REFERENCES User(mobileNo),
	FOREIGN KEY (orderNo) REFERENCES OrderMaster(orderNo)
);


DELIMITER //

CREATE PROCEDURE GetClothDetailsByClothId(IN clothId INT)
    SELECT * FROM Cloth WHERE clothCode = clothId;
//

DELIMITER ;