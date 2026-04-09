create database event_management;
use event_management;

CREATE TABLE Events (
event_id INT PRIMARY KEY AUTO_INCREMENT,
event_name VARCHAR(100),
event_date DATE,
venue_id INT,
organizer_id INT,
ticket_price DECIMAL(10,2),
total_seats INT,
available_seats INT,
FOREIGN KEY (venue_id) REFERENCES Venues(venue_id),
FOREIGN KEY (organizer_id) REFERENCES Organizers(organizer_id)
);

INSERT INTO Events VALUES
(1,'Tech Conference','2025-12-20',1,1,500,300,100),
(2,'Music Fest','2025-12-25',2,2,800,1000,200);

CREATE TABLE Venues (
venue_id INT PRIMARY KEY AUTO_INCREMENT,
venue_name VARCHAR(100),
location VARCHAR(100),
capacity INT
);

INSERT INTO Venues VALUES
(1,'City Hall','Ahmedabad',500),
(2,'Expo Center','Surat',1000);

CREATE TABLE Organizers (
organizer_id INT PRIMARY KEY AUTO_INCREMENT,
organizer_name VARCHAR(100),
contact_email VARCHAR(100),
phone_number VARCHAR(15)
);

INSERT INTO Organizers VALUES
(1,'Tech Group','tech@gmail.com','9999999999'),
(2,'Music Club',NULL,'8888888888');

CREATE TABLE Attendees (
attendee_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(100),
email VARCHAR(100),
phone_number VARCHAR(15)
);

INSERT INTO Attendees VALUES
(1,'Amit','amit@gmail.com','1111111111'),
(2,'Riya','riya@gmail.com','2222222222');

CREATE TABLE Tickets (
ticket_id INT PRIMARY KEY AUTO_INCREMENT,
event_id INT,
attendee_id INT,
booking_date DATE,
status ENUM('Confirmed','Cancelled','Pending'),
UNIQUE(event_id, attendee_id),
FOREIGN KEY (event_id) REFERENCES Events(event_id),
FOREIGN KEY (attendee_id) REFERENCES Attendees(attendee_id)
);

INSERT INTO Tickets VALUES
(1,1,1,'2025-12-01','Confirmed'),
(2,2,2,'2025-12-02','Pending');

CREATE TABLE Payments (
payment_id INT PRIMARY KEY AUTO_INCREMENT,
ticket_id INT,
amount_paid DECIMAL(10,2),
payment_status ENUM('Success','Failed','Pending'),
payment_date DATETIME,
FOREIGN KEY (ticket_id) REFERENCES Tickets(ticket_id)
);

INSERT INTO Payments VALUES
(1,1,500,'Success','2025-12-01 10:30:00'),
(2,2,0,'Pending','2025-12-02 12:00:00');

INSERT INTO Events
(event_name, event_date, venue_id, organizer_id, ticket_price, total_seats, available_seats)
VALUES
('Startup Meet','2025-12-30',1,1,400,200,200);

TASK 1:CRUD OPERATIONS

UPDATE Events
SET ticket_price = 450
WHERE event_name = 'Startup Meet';

DELETE FROM Events
WHERE event_name = 'Startup Meet';

SELECT * FROM Events
WHERE event_name LIKE '%Tech%';

INSERT INTO Venues (venue_name, location, capacity)
VALUES ('Town Hall','Vadodara',600);

UPDATE Venues
SET capacity=700
WHERE venue_name='Town Hall';

DELETE FROM Venues WHERE venue_name='Town Hall';

SELECT * FROM Venues WHERE location='Vadodara';

INSERT INTO Organizers
(organizer_name, contact_email, phone_number)
VALUES ('Edu Group','edu@gmail.com','7777777777');

SELECT * FROM Organizers WHERE organizer_name='Edu Group';

UPDATE Organizers
SET phone_number='6666666666'
WHERE organizer_name='Edu Group';

DELETE FROM Organizers WHERE organizer_name='Edu Group';

INSERT INTO Attendees
(name, email, phone_number)
VALUES ('Rahul','rahul@gmail.com','5555555555');

SELECT * FROM Attendees WHERE name='Rahul';

UPDATE Attendees
SET email='rahul123@gmail.com'
WHERE name='Rahul';

DELETE FROM Attendees WHERE name='Rahul';

INSERT INTO Tickets
(event_id, attendee_id, booking_date, status)
VALUES (1,2,CURDATE(),'Confirmed');

SELECT * FROM Tickets WHERE status='Confirmed';

UPDATE Tickets
SET status='Cancelled'
WHERE ticket_id=1;

DELETE FROM Tickets WHERE ticket_id=1;

INSERT INTO Payments
(ticket_id, amount_paid, payment_status, payment_date)
VALUES (1,650,'Success',NOW());

SELECT * FROM Payments WHERE payment_status='Success';

UPDATE Payments
SET payment_status='Failed'
WHERE payment_id=1;

DELETE FROM Payments WHERE payment_id=1;

TASK 2:SQL CLAUSES

SELECT e.event_name, e.event_date
FROM Events e
JOIN Venues v ON e.venue_id = v.venue_id
WHERE v.location = 'Ahmedabad';

SELECT e.event_name, SUM(p.amount_paid) AS revenue
FROM Events e
JOIN Tickets t 
ON e.event_id=t.event_id
JOIN Payments p 
ON t.ticket_id=p.ticket_id
GROUP BY e.event_name
ORDER BY revenue DESC
LIMIT 5;

SELECT DISTINCT a.name
FROM Attendees a
JOIN Tickets t 
ON a.attendee_id=t.attendee_id
WHERE t.booking_date >= CURDATE() - INTERVAL 7 DAY;

TASK 3:SQL OPERATORS

SELECT event_name
FROM Events
WHERE MONTH(event_date)=12
AND available_seats > total_seats*0.5;


SELECT DISTINCT a.name
FROM Attendees a
JOIN Tickets t 
ON a.attendee_id=t.attendee_id
LEFT JOIN Payments p
ON t.ticket_id=p.ticket_id
WHERE t.ticket_id IS NOT NULL
OR p.payment_status = 'Pending';

SELECT event_name FROM Events
WHERE available_seats <> 0;

TASK 4:SORTING & GROUPING DATA

SELECT event_name, event_date FROM Events
ORDER BY event_date ASC;

SELECT e.event_name, COUNT(t.ticket_id) AS total_attendees FROM Events e
LEFT JOIN Tickets t 
ON e.event_id=t.event_id
GROUP BY e.event_name;

SELECT e.event_name, SUM(p.amount_paid) AS revenue
FROM Events e
JOIN Tickets t 
ON e.event_id=t.event_id
JOIN Payments p 
ON t.ticket_id=p.ticket_id
GROUP BY e.event_name;

TASK 5:AGGREGATE FUNCTIONS

SELECT SUM(amount_paid) AS total_revenue
FROM Payments;

SELECT event_id, COUNT(*) AS cnt
FROM Tickets
GROUP BY event_id
ORDER BY cnt DESC
LIMIT 1;

SELECT AVG(ticket_price) AS avg_price
FROM Events;

TASK 6:PRIMARY & FOREIGN KEY RELATIONSHIPS

UNIQUE(event_id, attendee_id)

FOREIGN KEY (ticket_id) REFERENCES Tickets(ticket_id)

TASK 7:JOINS

SELECT e.event_name, v.venue_name
FROM Events e
INNER JOIN Venues v 
ON e.venue_id=v.venue_id;

SELECT a.name
FROM Attendees a
JOIN Tickets t 
ON a.attendee_id=t.attendee_id
LEFT JOIN Payments p 
ON t.ticket_id=p.ticket_id
WHERE p.payment_status <> 'Success' OR p.payment_status IS NULL;

SELECT e.event_name
FROM Tickets t
RIGHT JOIN Events e 
ON t.event_id=e.event_id
WHERE t.ticket_id IS NULL;

SELECT a.name
FROM Attendees a
LEFT JOIN Tickets t
ON a.attendee_id=t.attendee_id
WHERE t.ticket_id IS NULL;

TASK 8:SUBQUERIES

SELECT event_name
FROM Events
WHERE event_id IN (
SELECT t.event_id
FROM Tickets t
JOIN Payments p 
ON t.ticket_id=p.ticket_id
GROUP BY t.event_id
HAVING SUM(p.amount_paid) >
(SELECT AVG(amount_paid) FROM Payments)
);

SELECT name
FROM Attendees
WHERE attendee_id IN (
SELECT attendee_id
FROM Tickets
GROUP BY attendee_id
HAVING COUNT(DISTINCT event_id) > 1
);

SELECT organizer_name
FROM Organizers
WHERE organizer_id IN (
SELECT organizer_id
FROM Events
GROUP BY organizer_id
HAVING COUNT(event_id) > 3
);

TASK 9:DATE & TIME FUNCTIONS

SELECT event_name, MONTH(event_date) FROM Events;

SELECT DATEDIFF(event_date, CURDATE()) FROM Events;

SELECT DATE_FORMAT(payment_date,'%Y-%m-%d %H:%i:%s') FROM Payments;

TASK 10:STRING MANIPULATION FUNCTIONS

SELECT UPPER(organizer_name) FROM Organizers;

SELECT TRIM(name) FROM Attendees;

SELECT IFNULL(contact_email,'Not Provided') FROM Organizers;

TASK 11:WINDOW FUNCTIONS

SELECT e.event_name,
SUM(p.amount_paid) AS total_revenue,
RANK() OVER (ORDER BY SUM(p.amount_paid) DESC) AS revenue_rank
FROM Events e
JOIN Tickets t 
ON e.event_id = t.event_id
JOIN Payments p 
ON t.ticket_id = p.ticket_id
GROUP BY e.event_id, e.event_name;

SELECT e.event_name,p.payment_date,p.amount_paid,
SUM(p.amount_paid) 
OVER (ORDER BY p.payment_date) AS cumulative_sales
FROM Payments p
JOIN Tickets t 
ON p.ticket_id = t.ticket_id
JOIN Events e 
ON t.event_id = e.event_id;

SELECT e.event_name,t.booking_date,
COUNT(t.ticket_id) 
OVER (PARTITION BY e.event_id ORDER BY t.booking_date) AS running_attendees
FROM Events e
JOIN Tickets t 
ON e.event_id = t.event_id;

TASK 12:SQL CASE EXPRESSIONS

SELECT event_name,total_seats,available_seats,
CASE
WHEN available_seats < total_seats * 0.20
THEN 'High Demand'
WHEN available_seats BETWEEN total_seats * 0.20 
AND total_seats * 0.50
THEN 'Moderate Demand'
ELSE 'Low Demand'
END AS demand_category
FROM Events;

SELECT payment_id,amount_paid,payment_status,
CASE
WHEN payment_status = 'Success' THEN 'Successful'
WHEN payment_status = 'Failed'  THEN 'Failed'
ELSE 'Pending'
END AS payment_result
FROM Payments;


































