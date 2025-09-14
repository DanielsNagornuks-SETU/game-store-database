CREATE SCHEMA `gameStore` ;
USE `gameStore`;

CREATE TABLE Games (
	gameId INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    releaseDate DATE NOT NULL,
    genre VARCHAR(30) NOT NULL,
    developerName VARCHAR(50) NOT NULL,
    publisherName VARCHAR(50) NOT NULL
);

CREATE TABLE Platforms (
	platformId INT PRIMARY KEY AUTO_INCREMENT,
    manufacturerName VARCHAR(40) NOT NULL,
    platformName VARCHAR(40) NOT NULL
);

CREATE TABLE Game_disks (
	gameDiskId INT PRIMARY KEY AUTO_INCREMENT,
    price DECIMAL(5,2) NOT NULL,
    platformId INT NOT NULL,
    gameId INT NOT NULL,
    FOREIGN KEY (platformId) REFERENCES Platforms (platformId),
    FOREIGN KEY (gameId) REFERENCES Games (gameId)
);

CREATE TABLE Sale_orders (
	saleOrderId INT PRIMARY KEY AUTO_INCREMENT,
    date DATE NOT NULL,
    emailAddress VARCHAR(60)
);

CREATE TABLE Sale_order_items (
	quantity INT NOT NULL,
    saleOrderId INT NOT NULL,
    gameDiskId INT NOT NULL,
    PRIMARY KEY (saleOrderId, gameDiskId),
    FOREIGN KEY (saleOrderId) REFERENCES Sale_orders (saleOrderId),
    FOREIGN KEY (gameDiskId) REFERENCES Game_disks (gameDiskId)
);

CREATE TABLE Stores (
	storeId INT PRIMARY KEY AUTO_INCREMENT,
    address VARCHAR(200) NOT NULL,
    phoneNumber INT(20) NOT NULL,
    emailAddress VARCHAR(60) NOT NULL
);

CREATE TABLE Disk_stocks (
	stockId INT PRIMARY KEY AUTO_INCREMENT,
    stockAmount INT NOT NULL,
    gameDiskId INT NOT NULL,
    storeId INT NOT NULL,
    FOREIGN KEY (storeId) REFERENCES Stores (storeId),
    FOREIGN KEY (gameDiskId) REFERENCES Game_disks (gameDiskId)
);

CREATE TABLE Employees (
	employeeId INT PRIMARY KEY AUTO_INCREMENT,
    payrollId INT UNIQUE,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    phoneNumber INT(20) NOT NULL,
    emailAddress VARCHAR(60) NOT NULL,
    homeAddress VARCHAR(200),
    storeId INT NOT NULL,
    managerId INT,
    FOREIGN KEY (storeId) REFERENCES Stores (storeId),
    FOREIGN KEY (managerId) REFERENCES Employees (employeeId)
);

CREATE TABLE Distributors (
	distributorId INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    emailAddress VARCHAR(60) NOT NULL,
    address VARCHAR(200)
);

INSERT INTO Games (title, releaseDate, genre, developerName, publisherName) VALUES
('Fallout 1', '1997-10-10', 'Role-playing', 'Interplay Productions', 'Interplay Productions'),
('Fallout: New Vegas', '2010-10-19', 'Role-playing', 'Obsidian Entertainment', 'Bethesda Softworks'),
("Assassin's Creed 2", '2009-11-17', 'Action-adventure', 'Ubisoft Montreal', 'Ubisoft'),
('Gothic II', '2002-11-29', 'Role-playing', 'Piranha Bytes', 'JoWooD Productions'),
('The Witcher 3: Wild Hunt', '2015-05-19', 'Role-playing', 'CD Projekt Red', 'CD Projekt');

INSERT INTO Platforms (manufacturerName, platformName) VALUES
("Sony", "Playstation 5"),
("Microsoft", "Xbox Series X|S"),
("","PC"),
("Nintendo", "Switch");

INSERT INTO Stores (address, phoneNumber, emailAddress) VALUES
("Dungarvan", "123456", "dungarvanstore@dansgamestore.ie"),
("Waterford", "564322", "waterfordstore@dansgamestore.ie"),
("Dublin", "345678", "dublinstore@dansgamestore.ie");

INSERT INTO Employees (firstName, lastName, phoneNumber, emailAddress, storeId, managerId) VALUES
("Daniels", "Nagornuks", "1243522", "dan@gmail.com", 3, null),
("John", "Smith", "643256", "john@gmail.com", 3, 1),
("John", "Smith Jr.", "25635", "johnjr@gmail.com", 2, null);

INSERT INTO Distributors (name, emailAddress) VALUES
("Warner Bros", "support@warner.com"),
("Bandai Namco", "support@bandai.com"),
("Bethesda Softworks", "support@bethesda.com"),
("Ubisoft", "support@ubisoft.com");

INSERT INTO Sale_orders (date, emailAddress) VALUES
("2024-10-1", null),
("2024-10-2", null),
("2024-10-3", "alice@gmail.com");

INSERT INTO Game_disks (price, platformId, gameId) VALUES
(59.99, 1, 5),
(59.99, 2, 5),
(9.99, 3, 3);

INSERT INTO Disk_stocks (stockAmount, gameDiskId, storeId) VALUES
(50, 1, 1),
(50, 2, 1),
(5, 3, 3);

INSERT INTO Sale_order_items (quantity, saleOrderId, gameDiskId) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 3, 3);

# shows list of employees and where they work
SELECT 
	CONCAT(e.firstName, " ", e.lastName) "Employee Name", 
    e.emailAddress "Employee Email",
    e.phoneNumber "Employee Phone Number",
    s.address "Store Address",
    s.emailAddress "Store Email Address",
    s.phoneNumber "Store Phone Number"
FROM Employees e 
INNER JOIN Stores s USING (storeId) 
ORDER BY e.firstName;

# shows total amount of disks sold for all games (learned that you can stack joins from a post: https://stackoverflow.com/questions/6032691/sql-select-from-three-tables)
SELECT
    g.title "Game Name",
    p.platformName "Platform",
	SUM(s.quantity) "Amount Sold"
FROM Game_disks gd 
INNER JOIN Sale_order_items s USING (gameDiskId) 
INNER JOIN Games g USING (gameId)
INNER JOIN Platforms p USING (platformId)
GROUP BY gd.gameDiskId
ORDER BY g.title;