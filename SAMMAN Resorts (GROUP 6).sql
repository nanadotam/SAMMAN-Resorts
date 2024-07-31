DROP DATABASE IF EXISTS SammanResorts;
CREATE DATABASE SammanResorts;
USE SammanResorts;

-- Table creation

CREATE TABLE Branches (
    Branch_ID VARCHAR(20) PRIMARY KEY,
    Branch_Name VARCHAR(50) NOT NULL,
    `Location` VARCHAR(50) NOT NULL,
    Operation_Status BOOLEAN NOT NULL DEFAULT TRUE,
    Number_of_Rooms INT NOT NULL,
    Branch_Head VARCHAR(20) NOT NULL
);

CREATE TABLE Customer (
    Customer_ID VARCHAR(20) PRIMARY KEY,
    Sex CHAR(1) CHECK (Sex IN ('M', 'F')) NOT NULL,
    DOB DATE NOT NULL,
    Customer_Type VARCHAR(10) CHECK (Customer_Type IN ('Guest', 'Visitor')) NOT NULL,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Email VARCHAR(50) NOT NULL UNIQUE,
    Phone_Number VARCHAR(15) NOT NULL
);

CREATE TABLE Department (
    Department_ID VARCHAR(20) PRIMARY KEY,
    Department_Name VARCHAR(20) NOT NULL,
    Department_Head VARCHAR(20),
    UNIQUE (Department_Name, Department_Head)
);

CREATE TABLE Employee (
    Employee_ID VARCHAR(20) PRIMARY KEY,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Sex CHAR(1) CHECK (Sex IN ('M', 'F')),
    DOB DATE NOT NULL,
    Date_of_Employment DATE NOT NULL,
    Branch_ID VARCHAR(20) NOT NULL,
    Department_ID VARCHAR(20) NOT NULL,
    Position VARCHAR(50) NOT NULL,
    Home_Address VARCHAR(50) NOT NULL,
    Email VARCHAR(50) NOT NULL UNIQUE,
    Phone_Number VARCHAR(15) NOT NULL
);

CREATE TABLE Room (
    Room_ID VARCHAR(20) PRIMARY KEY,
    Room_Name VARCHAR(20) NOT NULL,
    Room_Type VARCHAR(20) CHECK (Room_Type IN ('Single', 'Double', 'Suite', 'Presidential')) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Room_Status BOOLEAN NOT NULL DEFAULT TRUE,
    Branch_ID VARCHAR(20) NOT NULL,
    UNIQUE (Room_Name, Branch_ID)
);

CREATE TABLE Facilities (
    Facility_ID VARCHAR(20) PRIMARY KEY,
    Facility_Name VARCHAR(20) NOT NULL,
    Branch_ID VARCHAR(20) NOT NULL,
    Facility_Head VARCHAR(20) NOT NULL,
    UNIQUE (Facility_Name, Branch_ID)
);

CREATE TABLE Service (
    Service_ID VARCHAR(20) PRIMARY KEY,
    Service_Name VARCHAR(50) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Facility_ID VARCHAR(20) NOT NULL
);

CREATE TABLE Room_Booking (
    Room_Booking_ID VARCHAR(20) PRIMARY KEY,
    Customer_ID VARCHAR(20) NOT NULL,
    Room_ID VARCHAR(20) NOT NULL,
    Check_In_Date DATETIME NOT NULL,
    Check_Out_Date DATETIME NOT NULL,
    Requests VARCHAR(255),
    -- UNIQUE (Customer_ID, Room_ID)
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Room_ID) REFERENCES Room(Room_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Service_Booking (
    Service_Booking_ID VARCHAR(20) PRIMARY KEY,
    Service_ID VARCHAR(20) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Customer_ID VARCHAR(20) NOT NULL,
    Employee_ID VARCHAR(20) NOT NULL,
    Check_In_Time DATETIME NOT NULL,
    Check_Out_Time DATETIME NOT NULL,
    Branch_ID VARCHAR(20) NOT NULL,
    Requests VARCHAR(255),
    FOREIGN KEY (Service_ID) REFERENCES Service(Service_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Branch_ID) REFERENCES Branches(Branch_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Room_Billing (
    RBilling_ID VARCHAR(20) PRIMARY KEY,
    Customer_ID VARCHAR(20) NOT NULL,
    Room_Booking_ID VARCHAR(20) NOT NULL,
    Payment_Status VARCHAR(20) NOT NULL CHECK (Payment_Status IN ('Paid', 'Pending')),
    Payment_Date DATE NOT NULL,
    Payment_Method VARCHAR(20) NOT NULL,
    FOREIGN KEY (Room_Booking_ID) REFERENCES Room_Booking(Room_Booking_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Service_Billing (
    SBilling_ID VARCHAR(20) PRIMARY KEY,
    Customer_ID VARCHAR(20) NOT NULL,
    Service_Booking_ID VARCHAR(20) NOT NULL,
    Amount Price(10,2) NOT NULL,
    Payment_Status VARCHAR(20) NOT NULL CHECK (Payment_Status IN ('Paid', 'Pending')),
    Payment_Date DATE NOT NULL,
    Payment_Method VARCHAR(20) NOT NULL,
    FOREIGN KEY (Service_Booking_ID) REFERENCES Service_Booking(Service_Booking_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Indexing for Performance
CREATE INDEX idx_room_booking ON Room_Booking(Customer_ID, Room_ID);
CREATE INDEX idx_service_booking ON Service_Booking(Customer_ID, Service_ID);
CREATE INDEX idx_room_billing ON Room_Billing(Customer_ID, Room_Booking_ID);
CREATE INDEX idx_customer_email ON Customer (Email);
CREATE INDEX idx_room_price ON Room (Price);
CREATE INDEX idx_service_price ON Service (Price);

-- Table population

INSERT INTO Branches VALUES 
('B001', 'Samaan Na-na Executive', 'Accra', TRUE 5, 'E001'),
('B002', 'Samaan Frimps Suites', 'Koforidua',TRUE, 5, 'E002'),
('B003', 'Samaan Amar Resorts & Spa Two', 'Kwahu',TRUE, 5, 'E003'),
('B004', 'Samaan Kiki Express Hotel Two', 'Kwahu',TRUE, 5, 'E004'),
('B005', 'Samaan Sin Ocean Views', 'Cape Coast',FALSE, 5, 'E005'),
('B006', 'Samaan Hilltop', 'Kumasi',FALSE, 5, 'E006'),
-- ('B007', 'Samaan Forest Lodge', 'Takoradi', 30, 'E007'),
-- ('B008', 'Samaan Riverside', 'Tamale', 35, 'E008'),
-- ('B009', 'Samaan Desert Retreat', 'Wa', 25, 'E009'),
-- ('B010', 'Samaan May''s Mountain Resort', 'Ho', 50, 'E010');

INSERT INTO Employee VALUES
('E001', 'Kwame', 'Mensah', 'M', '1980-05-15', '2020-03-01', 'B001', 'D001', 'Manager', 'Accra, Ghana', 'kwame.mensah@samaanresorts.com', '233201234567'),
('E002', 'Ama', 'Osei', 'F', '1990-11-20', '2021-06-15', 'B002', 'D002', 'Receptionist', 'Koforidua, Ghana', 'ama.osei@samaanresorts.com', '233201234568'),
('E003', 'Kojo', 'Asante', 'M', '1985-07-10', '2019-09-10', 'B003', 'D003', 'Chef', 'Kwahu, Ghana', 'kojo.asante@samaanresorts.com', '233201234569'),
('E004', 'Yaa', 'Boateng', 'F', '1987-01-22', '2018-02-05', 'B004', 'D004', 'Housekeeping', 'Kwahu, Ghana', 'yaa.boateng@samaanresorts.com', '233201234570'),
('E005', 'Kofi', 'Adjei', 'M', '1992-04-08', '2022-01-10', 'B001', 'D001', 'Security', 'Accra, Ghana', 'kofi.adjei@samaanresorts.com', '233201234571'),
('E006', 'Thabo', 'Mbeki', 'M', '1985-08-25', '2018-06-30', 'B003', 'D003', 'Chef', 'Johannesburg, South Africa', 'thabo.mbeki@samaanresorts.com', '278201234577'),
('E007', 'Fatou', 'Diop', 'F', '1991-03-14', '2020-02-15', 'B002', 'D002', 'Receptionist', 'Dakar, Senegal', 'fatou.diop@samaanresorts.com', '221201234578'),
('E008', 'Mohamed', 'Ali', 'M', '1982-11-12', '2017-01-25', 'B001', 'D001', 'Security', 'Cairo, Egypt', 'mohamed.ali@samaanresorts.com', '20201234579'),
('E009', 'Njeri', 'Kamau', 'F', '1987-05-20', '2019-08-14', 'B004', 'D004', 'Housekeeping', 'Nairobi, Kenya', 'njeri.kamau@samaanresorts.com', '254201234580'),
('E010', 'Abdul', 'Rahman', 'M', '1990-02-09', '2021-03-10', 'B003', 'D003', 'Driver', 'Lagos, Nigeria', 'abdul.rahman@samaanresorts.com', '234201234581'),
('E011', 'Linda', 'Yeboah', 'F', '1989-09-01', '2021-04-12', 'B005', 'D006', 'Gardener', 'Cape Coast, Ghana', 'linda.yeboah@samaanresorts.com', '233201234572'),
('E012', 'Nana', 'Kwame', 'M', '1978-12-11', '2019-12-01', 'B006', 'D007', 'Accountant', 'Kumasi, Ghana', 'nana.kwame@samaanresorts.com', '233201234573'),
('E013', 'Aisha', 'Mohammed', 'F', '1993-02-17', '2020-05-18', 'B002', 'D008', 'Maintenance', 'Takoradi, Ghana', 'aisha.mohammed@samaanresorts.com', '233201234574'),
('E014', 'Peter', 'Johnson', 'M', '1984-03-03', '2018-07-14', 'B004', 'D009', 'Driver', 'Tamale, Ghana', 'peter.johnson@samaanresorts.com', '233201234575'),
('E015', 'Sarah', 'Brown', 'F', '1991-05-05', '2021-10-10', 'B006', 'D010', 'Administrator', 'Wa, Ghana', 'sarah.brown@samaanresorts.com', '233201234576');

INSERT INTO Customer VALUES
('C001', 'M', '1975-03-21', 'Guest', 'John', 'Doe', 'john.doe@gmail.com', '11234567890'), 
('C002', 'F', '1982-07-15', 'Visitor', 'Jane', 'Smith', 'jane.smith@yahoo.com', '442012345678'),
('C003', 'M', '1990-09-30', 'Guest', 'Robert', 'Johnson', 'robert.johnson@outlook.com', '61234567890'), 
('C004', 'F', '1985-12-22', 'Visitor', 'Mary', 'Williams', 'mary.williams@gmail.com', '49123456789'),
('C005', 'M', '1979-05-07', 'Guest', 'Michael', 'Brown', 'michael.brown@yahoo.com', '11234567891'), 
('C006', 'F', '1995-08-14', 'Visitor', 'Linda', 'Davis', 'linda.davis@outlook.com', '442012345680'),
('C007', 'M', '1988-02-19', 'Guest', 'James', 'Wilson', 'james.wilson@gmail.com', '61234567891'), 
('C008', 'F', '1992-11-27', 'Visitor', 'Patricia', 'Martinez', 'patricia.martinez@yahoo.com', '34123456789'), 
('C009', 'M', '1983-06-16', 'Guest', 'Charles', 'Anderson', 'charles.anderson@outlook.com', '27123456789'), 
('C010', 'F', '1976-10-03', 'Visitor', 'Barbara', 'Taylor', 'barbara.taylor@gmail.com', '33123456789'),
('C011', 'M', '1980-01-20', 'Guest', 'Chris', 'Evans', 'chris.evans@hotmail.com', '81234567892'), 
('C012', 'F', '1987-04-25', 'Visitor', 'Olivia', 'Martin', 'olivia.martin@gmail.com', '442012345681'),
('C013', 'M', '1992-11-10', 'Guest', 'David', 'Garcia', 'david.garcia@yahoo.com', '51234567892'), 
('C014', 'F', '1984-06-30', 'Visitor', 'Sophia', 'Thomas', 'sophia.thomas@outlook.com', '21234567890'),
('C015', 'M', '1977-09-19', 'Guest', 'Daniel', 'Jackson', 'daniel.jackson@gmail.com', '21234567891');

INSERT INTO Department VALUES
('D001', 'Management', 'E001'),
('D002', 'Reception', 'E002'),
('D003', 'Culinary', 'E003'),
('D004', 'Housekeeping', 'E004'),
('D005', 'Security', 'E005'),
('D006', 'Gardening', 'E011'),
('D001', 'Accounting', 'E012'),
('D002', 'Maintenance', 'E013'),
('D003', 'Transport', 'E014'),
('D004', 'Administration', 'E015');

INSERT INTO Room VALUES
('R001', 'Deluxe Room', 'Single', '100', TRUE, 'B001'),
('R002', 'Superior Room', 'Double', '150', FALSE, 'B001'),
('R003', 'Executive Suite', 'Suite', '300', TRUE, 'B002'),
('R004', 'Standard Room', 'Single', '80', TRUE, 'B002'),
('R005', 'Family Suite', 'Suite', '200', FALSE, 'B003'),
('R006', 'King Suite', 'Suite', '350', TRUE, 'B003'),
('R007', 'King Suite', 'Suite', '350', FALSE, 'B004'),
('R008', 'Luxury Suite', 'Suite', '180', FALSE, 'B004'),
('R009', 'Luxury Suite', 'Suite', '180', FALSE, 'B002'),
('R010', 'Junior Suite', 'Suite', '130', TRUE, 'B002'),
('R011', 'Penthouse', 'Suite', '400', TRUE, 'B001'),
('R012', 'Penthouse', 'Suite', '400', FALSE, 'B002'),
('R013', 'Penthouse', 'Suite', '400', TRUE, 'B003'),
('R014', 'Standard Room', 'Single', '80', FALSE, 'B003'),
('R015', 'Standard Room', 'Single', '80', FALSE, 'B001'),
('R016', 'Standard Room', 'Single', '80', FALSE, 'B002'),
('R017', 'Standard Room', 'Single', '80', FALSE, 'B002'),
('R018', 'Economy Room', 'Single', '60', TRUE, 'B004'),
('R019', 'Economy Room', 'Single', '60', TRUE, 'B003'),
('R020', 'Economy Room', 'Single', '60', TRUE, 'B004');

INSERT INTO Room_Booking VALUES
('RB001', 'C001', 'R001', '2024-07-01 14:00:00', '2024-07-05 12:00:00', 'Extra pillows'),
('RB002', 'C002', 'R011', '2024-07-02 15:00:00', '2024-07-06 11:00:00', 'Late check-out'),
('RB003', 'C003', 'R003', '2024-07-03 13:00:00', '2024-07-07 10:00:00', 'Airport transfer'),
('RB004', 'C004', 'R004', '2024-07-04 16:00:00', '2024-07-08 12:00:00', 'Breakfast in room'),
('RB005', 'C005', 'R013', '2024-07-05 14:00:00', '2024-07-09 11:00:00', 'Spa appointment'),
('RB006', 'C001', 'R006', '2024-08-06 16:00:00', '2024-08-10 12:00:00', 'Extra towels'),
('RB007', 'C007', 'R018', '2024-07-07 14:00:00', '2024-07-11 11:00:00', 'Late check-out'),
('RB008', 'C001', 'R019', '2024-09-08 15:00:00', '2024-09-12 10:00:00', 'Airport transfer'),
('RB009', 'C009', 'R020', '2024-07-09 13:00:00', '2024-07-13 12:00:00', 'Breakfast in room'),
('RB010', 'C004', 'R010', '2024-08-10 14:00:00', '2024-08-14 11:00:00', 'Spa appointment');

INSERT INTO Facilities VALUES
('F001', 'Swimming Pool', 'B001', 'E001'),
('F002', 'Gym', 'B002', 'E002'),
('F003', 'Spa', 'B003', 'E003'),
('F004', 'Restaurant', 'B004', 'E004'),
('F005', 'Conference Room', 'B001', 'E005'),
('F006', 'Tennis Court', 'B002', 'E011'),
('F007', 'Golf Course', 'B003', 'E012'),
('F008', 'Kids Play Area', 'B004', 'E013'),
('F009', 'Business Center', 'B005', 'E014'),
('F010', 'Library', 'B006', 'E015');

INSERT INTO Service VALUES
('S001', 'Massage', '50', 'F003'),
('S002', 'Personal Training', '30', 'F002'),
('S003', 'Room Service', '20', 'F004'),
('S004', 'Laundry', '15', 'F005'),
('S005', 'Catering', '40', 'F004'),
('S006', 'Tennis Lesson', '25', 'F006'),
('S007', 'Golf Training', '60', 'F007'),
('S008', 'Childcare', '15', 'F008'),
('S009', 'Business Services', '100', 'F009'),
('S010', 'Book Rental', '5', 'F010');

INSERT INTO Service_Booking VALUES
('SB001', 'S001', '50', 'C001', 'E001', '2024-07-02 10:00:00', '2024-07-02 11:00:00', 'B001', 'None'),
('SB002', 'S002', '30', 'C002', 'E002', '2024-07-03 09:00:00', '2024-07-03 10:00:00', 'B002', 'Personal trainer needed'),
('SB003', 'S003', '20', 'C003', 'E003', '2024-07-04 12:00:00', '2024-07-04 13:00:00', 'B003', 'Vegetarian meal'),
('SB004', 'S004', '15', 'C004', 'E004', '2024-07-05 08:00:00', '2024-07-05 09:00:00', 'B004', 'Express service'),
('SB005', 'S005', '40', 'C005', 'E005', '2024-07-06 14:00:00', '2024-07-06 15:00:00', 'B003', 'Special diet'),
('SB006', 'S006', '25', 'C006', 'E006', '2024-07-07 10:00:00', '2024-07-07 11:00:00', 'B002', 'None'),
('SB007', 'S007', '60', 'C007', 'E007', '2024-07-08 09:00:00', '2024-07-08 10:00:00', 'B003', 'Golf equipment'),
('SB008', 'S008', '15', 'C008', 'E008', '2024-07-09 12:00:00', '2024-07-09 13:00:00', 'B004', 'Special care'),
('SB009', 'S009', '100', 'C009', 'E009', '2024-07-10 08:00:00', '2024-07-10 09:00:00', 'B005', 'Meeting setup'),
('SB010', 'S010', '5', 'C010', 'E010', '2024-07-11 14:00:00', '2024-07-11 15:00:00', 'B006', 'Book suggestion');

INSERT INTO Room_Billing VALUES
('RBILL001', 'RB001', 'Paid', '2024-07-05', 'Credit Card'),
('RBILL002', 'RB002', 'Pending', '2024-07-06', 'Cash'),
('RBILL003', 'RB003', 'Paid', '2024-07-07', 'Credit Card'),
('RBILL004', 'RB004', 'Pending', '2024-07-08', 'Debit Card'),
('RBILL005', 'RB005', 'Paid', '2024-07-09', 'Credit Card'),
('RBILL006', 'RB006', 'Paid', '2024-07-10', 'Credit Card'),
('RBILL007', 'RB007', 'Pending', '2024-07-11', 'Cash'),
('RBILL008', 'RB008', 'Paid', '2024-07-12', 'Credit Card'),
('RBILL009', 'RB009', 'Pending', '2024-07-13', 'Debit Card'),
('RBILL010', 'RB010', 'Paid', '2024-07-14', 'Credit Card');

INSERT INTO Service_Billing VALUES
('SBILL001', 'SB001', '50', 'Paid', '2024-07-02', 'Credit Card'),
('SBILL002', 'SB002', '30', 'Pending', '2024-07-03', 'Cash'),
('SBILL003', 'SB003', '20', 'Paid', '2024-07-04', 'Credit Card'),
('SBILL004', 'SB004', '15', 'Pending', '2024-07-05', 'Debit Card'),
('SBILL005', 'SB005', '40', 'Paid', '2024-07-06', 'Credit Card'),
('SBILL006', 'SB006', '25', 'Paid', '2024-07-07', 'Credit Card'),
('SBILL007', 'SB007', '60', 'Pending', '2024-07-08', 'Cash'),
('SBILL008', 'SB008', '15', 'Paid', '2024-07-09', 'Credit Card'),
('SBILL009', 'SB009', '100', 'Pending', '2024-07-10', 'Debit Card'),
('SBILL010', 'SB010', '5', 'Paid', '2024-07-11', 'Credit Card');

-- Adding foreign key constraints to prevent referencing errors

ALTER TABLE Employee
ADD FOREIGN KEY (Branch_ID) REFERENCES Branches(Branch_ID) ON UPDATE CASCADE,
ADD FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID) ON UPDATE CASCADE;

ALTER TABLE Department
ADD FOREIGN KEY (Department_Head) REFERENCES Employee(Employee_ID) ON UPDATE CASCADE;

ALTER TABLE Room
ADD FOREIGN KEY (Branch_ID) REFERENCES Branches(Branch_ID) ON UPDATE CASCADE;

ALTER TABLE Facilities
ADD FOREIGN KEY (Branch_ID) REFERENCES Branches(Branch_ID) ON UPDATE CASCADE,
ADD FOREIGN KEY (Facility_Head) REFERENCES Employee(Employee_ID) ON UPDATE CASCADE;

ALTER TABLE Service
ADD FOREIGN KEY (Facility_ID) REFERENCES Facilities(Facility_ID) ON UPDATE CASCADE;

ALTER TABLE Room_Booking
ADD FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID) ON UPDATE CASCADE,
ADD FOREIGN KEY (Room_ID) REFERENCES Room(Room_ID) ON UPDATE CASCADE;

ALTER TABLE Service_Booking
ADD FOREIGN KEY (Service_ID) REFERENCES Service(Service_ID) ON UPDATE CASCADE,
ADD FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID) ON UPDATE CASCADE,
ADD FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID) ON UPDATE CASCADE,
ADD FOREIGN KEY (Branch_ID) REFERENCES Branches(Branch_ID) ON UPDATE CASCADE;

ALTER TABLE Room_Billing
ADD FOREIGN KEY (Room_Booking_ID) REFERENCES Room_Booking(Room_Booking_ID) ON UPDATE CASCADE;

ALTER TABLE Service_Billing
ADD FOREIGN KEY (Service_Booking_ID) REFERENCES Service_Booking(Service_Booking_ID) ON UPDATE CASCADE;

-- Get all that are unbooked
SELECT Room_ID, Room_Name, Room_Type, Price AS Unbooked_Rooms
FROM Room
WHERE Room_Status=FALSE

--Get all rooms that are booked
SELECT Room.Room_ID, Room.Room_Name, 
Room.Room_Type, Room_Booking.Room_Booking_ID, 
Room_Booking.Customer_ID, 
Room_Booking.Check_In_Date, 
Room_Booking.Check_Out_Date AS Booked_Rooms
FROM Room
LEFT JOIN Room_Booking
ON Room.Room_ID = Room_Booking.Room_ID
WHERE Room.Room_Status=TRUE
UNION
SELECT Booked_Rooms
FROM Room_Booking
RIGHT JOIN Room
ON Room.Room_ID = Room_Booking.Room_ID;

'''
-- Get all customers and their billing details 
-- (including customers who have not made any room bookings)
SELECT Customer.Customer_ID, 
	Customer.First_Name, 
	Customer.Last_Name,
	Customer.Phone_Number,
	Room_Billing.RBilling_ID, 
	Room_Billing.Room_Booking_ID, 
  Room_Billing.Payment_Status,
  Room_Billing.Payment_Date AS Billing_Information
FROM Customer
LEFT JOIN Room_Billing
ON Customer.Customer_ID = Room_Billing.Customer_ID
UNION
SELECT Billing_Information
FROM Room_Billing
RIGHT JOIN Customer
ON Customer.Customer_ID = Room_Billing.Customer_ID;
'''

-- Calculating paid services
select sum(Amount) as "Revenues for Services Paid"
from Service_Billing
where Payment_Status="Paid"; 

select sum(Room.Price) as "Revenues for Rooms Paid"
from Room
inner join Room_Booking on Room.Room_ID=Room_Booking.Room_ID
inner join Room_Billing on Room_Booking.Room_Booking_ID=Room_Billing.Room_Booking_ID
where Room_Billing.Payment_Status="Paid"; 


-- Select all columns from Room_Booking table
-- Join with Customer table on customer_id to get customer details
-- Order the results by the customer's last name
SELECT Room_Booking.*
FROM Room_Booking
JOIN Customer ON Room_Booking.customer_id = Customer.Customer_ID
ORDER BY Customer.Last_Name;

-- Select all columns from Service_Booking table
-- Join with Customer table on customer_id to get customer details
-- Order the results by the customer's last name
SELECT Service_Booking.*
FROM Service_Booking
JOIN Customer ON Service_Booking.customer_id = Customer.Customer_ID
ORDER BY Customer.Last_Name;


-- Select all columns from Room_Billing table
-- Join with Customer table on customer_id to get customer details
-- Order the results by the customer's last name
SELECT Room_Billing.*
FROM Room_Billing
JOIN Customer ON Room_Billing.customer_id = Customer.Customer_ID
ORDER BY Customer.Last_Name;

-- Select all columns from Service_Billing table
-- Join with Customer table on customer_id to get customer details
-- Order the results by the customer's last name
SELECT Service_Billing.*
FROM Service_Billing
JOIN Customer ON Service_Billing.customer_id = Customer.Customer_ID
ORDER BY Customer.Last_Name;


-- Select Employee details along with their associated Branch and Department names
SELECT e.Employee_ID, e.First_Name, e.Last_Name, b.Branch_Name, d.Department_Name
FROM Employee e
LEFT JOIN Branches b ON e.Employee_ID = b.Branch_Head  -- Join with Branches table on Employee_ID
LEFT JOIN Department d ON e.Employee_ID = d.Department_Head  -- Join with Department table on Employee_ID
WHERE b.Branch_Name IS NOT NULL OR d.Department_Name IS NOT NULL  -- Filter to include only heads of either a branch or a department
ORDER BY e.Employee_ID;  -- Order by Employee_ID

-- Select Customer details along with their room booking information
SELECT c.Customer_ID, c.First_Name, c.Last_Name, r.Room_Name, rb.Check_In_Date, rb.Check_Out_Date
FROM Room_Booking rb
INNER JOIN Customer c ON rb.Customer_ID = c.Customer_ID  -- Join with Customer table on Customer_ID
INNER JOIN Room r ON rb.Room_ID = r.Room_ID  -- Join with Room table on Room_ID
WHERE c.Customer_ID IN ('C001', 'C002', 'C003')  -- Filter for specific customer IDs
ORDER BY rb.Check_In_Date;  -- Order by Check_In_Date

--Groups the total expenditure a customer makes  on room bookings and orders by amount spent
SELECT Room_Booking.Customer_ID, Customer.First_Name, 
    Customer.Last_Name, SUM(Room.Price) as Total_Room_Expenditure_Per_Customer
FROM Room_Booking
JOIN Room ON Room_Booking.Room_ID = Room.Room_ID
GROUP BY Room_Booking.Customer_ID
ORDER BY Total_Room_Expenditure_Per_Customer DESC;

-- Select Service Booking details along with customer and service information
SELECT sb.Service_Booking_ID, c.Customer_ID, c.First_Name, c.Last_Name, s.Service_Name, sb.Check_In_Time, sb.Check_Out_Time
FROM Service_Booking sb
INNER JOIN Customer c ON sb.Customer_ID = c.Customer_ID  -- Join with Customer table on Customer_ID
INNER JOIN Service s ON sb.Service_ID = s.Service_ID  -- Join with Service table on Service_ID
WHERE sb.Check_Out_Time IS NOT NULL  -- Filter to include only bookings with a non-null Check_Out_Time
ORDER BY sb.Service_Booking_ID;  -- Order by Service_Booking_ID

--Groups the total expenditure a customer makes on service bookings and orders by amount spent
SELECT Service_Booking.Customer_ID, Customer.First_Name, Customer.Last_Name, SUM(Service_Booking.Price) as Total_Service_Expenditure_Per_Customer
FROM Service_Booking
GROUP BY Service_Booking.Customer_ID
ORDER BY Total_Service_Expenditure_Per_Customer DESC;

-- This query calculates the total revenue generated from all room bookings using the Room_Billing table:
SELECT SUM(CASE 
            WHEN Payment_Status = 'Paid' THEN 1 
            ELSE 0 END) AS Total_Revenue
FROM Room_Billing;

-- This query counts the total number of room bookings:
SELECT COUNT(*) AS Total_Bookings
FROM Room_Booking;

-- This query counts the total number of bookings for each room type:
SELECT Room.Room_Type, COUNT(Room_Booking.Room_Booking_ID) AS Number_of_Bookings
FROM Room
JOIN Room_Booking ON Room.Room_ID = Room_Booking.Room_ID
GROUP BY Room.Room_Type;

-- This query calculates the total revenue generated for each branch:
SELECT Room.Branch_ID,
    SUM(CASE 
            WHEN Room_Billing.Payment_Status = 'Paid' THEN 1 
            ELSE 0 
        END) AS Total_Revenue
FROM Room
JOIN Room_Booking ON Room.Room_ID = Room_Booking.Room_ID
JOIN Room_Billing ON Room_Booking.Room_Booking_ID = Room_Billing.Room_Booking_ID
GROUP BY Room.Branch_ID;

-- This query calculates the total revenue generated for each room type:
SELECT Room.Room_Type, SUM(CASE 
            WHEN Room_Billing.Payment_Status = 'Paid' THEN 1 
            ELSE 0 END) AS Total_Revenue
FROM Room
JOIN Room_Booking ON Room.Room_ID = Room_Booking.Room_ID
JOIN Room_Billing ON Room_Booking.Room_Booking_ID = Room_Billing.Room_Booking_ID
GROUP BY Room.Room_Type;
    
-- Find employees and their respective departments
SELECT e.Employee_ID, e.First_Name, e.Last_Name, e.Position, d.Department_Name, d.Department_Head
FROM Employee e
INNER JOIN Department d ON e.Department_ID = d.Department_ID;  -- Join Employee table with Department table on Department_ID

-- Find employees and their respective departments and the branch each employee belongs to
SELECT e.Employee_ID, e.First_Name, e.Last_Name, e.Position, d.Department_Name, d.Department_Head, b.Branch_Name, b.Location
FROM Employee e
INNER JOIN Department d ON e.Department_ID = d.Department_ID  -- Join Employee table with Department table on Department_ID
INNER JOIN Branches b ON e.Branch_ID = b.Branch_ID;  -- Join Employee table with Branches table on Branch_ID

-- Find which employees have interacted with which customers through service bookings
SELECT e.Employee_ID, e.First_Name, e.Last_Name, c.Customer_ID, 
    c.First_Name AS Customer_First_Name, c.Last_Name AS Customer_Last_Name, 
    sb.Service_ID, sb.Check_In_Time, sb.Check_Out_Time
FROM Employee e
INNER JOIN Service_Booking sb ON e.Employee_ID = sb.Employee_ID  -- Join Employee table with Service_Booking table on Employee_ID
INNER JOIN Customer c ON sb.Customer_ID = c.Customer_ID;  -- Join Service_Booking table with Customer table on Customer_ID
