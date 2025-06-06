USE Airports;

CREATE TABLE cities (
cities_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
[name] NVARCHAR (MAX) NOT NULL
);

CREATE TABLE passengers (
passengers_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
first_name VARCHAR(100) NOT NULL,
last_name VARCHAR(100) NOT NULL,
);

CREATE TABLE airports (
airports_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
airport_code VARCHAR(10) NOT NULL UNIQUE, 
[name] NVARCHAR (MAX) NOT NULL,
cities_id INT NOT NULL,

FOREIGN KEY (cities_id) REFERENCES cities(cities_id)
);

CREATE TABLE flights (
flights_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
flight_number VARCHAR(20) NOT NULL,
departure_airport VARCHAR(10) NOT NULL,
departure_city VARCHAR(100) NOT NULL,
destination_airport VARCHAR(10) NOT NULL,
destination_city VARCHAR(100) NOT NULL,
departure_time DATETIME NOT NULL,
arrival_time DATETIME NOT NULL,
);

CREATE TABLE seat (
seat_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
seat NVARCHAR (MAX) NOT NULL,
class NVARCHAR(10) NOT NULL,

CONSTRAINT CHK_ClassType CHECK (class IN ('business', 'economy'))
);

CREATE TABLE tickets (
tickets_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
seat_id INT NOT NULL,
passengers_id INT NOT NULL,

FOREIGN KEY (seat_id) REFERENCES seat (seat_id),
FOREIGN KEY (passengers_id) REFERENCES passengers (passengers_id)
);

CREATE TABLE aircraft(
flights_aircraft INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
model VARCHAR(100) NOT NULL,
)

-- Adding cities
INSERT INTO cities ([name]) VALUES
('Москва'),
('Санкт-Петербург'),
('Новосибирск'),
('Сочи'),
('Екатеринбург');
-- Adding passengers
INSERT INTO passengers (first_name, last_name) VALUES
('Иван', 'Иванов'),
('Петр', 'Петров'),
('Сергей', 'Сергеев'),
('Андрей', 'Андреев'),
('Михаил', 'Михайлов');
-- Adding airports
INSERT INTO airports (airport_code, [name], cities_id) VALUES
('SVO', 'Шереметьево', 1),
('DME', 'Домодедово', 1),
('LED', 'Пулково', 2),
('OVB', 'Толмачево', 3),
('AER', 'Сочи', 4),
('SVX', 'Кольцово', 5);
-- Adding flights
INSERT INTO flights (flight_number, departure_airport, departure_city, destination_airport, destination_city,departure_time,arrival_time ) VALUES
('SU 100', 'SVO', 'Москва', 'LED', 'Санкт-Петербург', '2025-06-15 08:00:00', '2025-06-15 09:30:00'),
('SU 300', 'SVX', 'Екатеринбург', 'AER', 'Сочи', '2025-06-15 12:00:00', '2025-06-15 18:00:00'),
('SU 400', 'OVB', 'Новосибирск', 'LED', 'Санкт-Петербург', '2025-06-15 14:00:00', '2025-06-15 15:30:00'),
('SU 500', 'LED', 'Санкт-Петербург', 'SVO', 'Москва', '2025-06-16 09:00:00', '2025-06-16 12:00:00'),
('SU 600', 'AER', 'Сочи', 'DME', 'Москва', '2025-06-16 11:00:00', '2025-06-16 13:30:00');
-- Adding places
INSERT INTO seat (seat, class) VALUES
('1A', 'business'),
('1B', 'business'),
('2A', 'economy'),
('2B', 'economy'),
('2C', 'economy');
-- Adding tickets
INSERT INTO tickets (seat_id, passengers_id) VALUES
(1,1),
(2,2),
(3,3),
(4,4),
(5,5);
-- Adding planes
INSERT INTO aircraft (model) VALUES
('SU 100'),
('SU 300'),
('SU 400'),
('SU 500'),
('SU 600');







