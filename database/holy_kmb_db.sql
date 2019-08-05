CREATE TABLE HEADQUARTERS (
  headquarter_id VARCHAR(10),
  headquarter_type VARCHAR(5) NOT NULL,
  headquarter_name VARCHAR(100) NOT NULL,
  headquarter_location VARCHAR(150) NOT NULL,
  PRIMARY KEY (headquarter_id)
);

CREATE TABLE ROUTE (
  route_no VARCHAR(10),
  route_name VARCHAR(50) NOT NULL,
  PRIMARY KEY (route_no)
);

CREATE TABLE STATION (
  station_no VARCHAR(15),
  station_name VARCHAR(30) NOT NULL,
  station_location VARCHAR(150) NOT NULL,
  route_no VARCHAR(10),
  headquarter_id VARCHAR(10),
  PRIMARY KEY (station_no),
  FOREIGN KEY (route_no) REFERENCES ROUTE,
  FOREIGN KEY (headquarter_id) REFERENCES HEADQUARTERS
);

CREATE TABLE TRAIN (
  train_no VARCHAR(10),
  train_model VARCHAR(15) NOT NULL,
  total_seat NUMBER(3),
  manufacturer_name VARCHAR(30) NOT NULL,
  last_maintenance_date DATE ,
  PRIMARY KEY (train_no)
);

CREATE TABLE TRAIN_SCHEDULE (
  schedule_no VARCHAR(15),
  train_schedule_start_time DATE NOT NULL,
  train_schedule_end_time DATE NOT NULL,
  direction VARCHAR(10) NOT NULL,
  train_no VARCHAR(10),
  route_no VARCHAR(10),
  PRIMARY KEY (schedule_no),
  FOREIGN KEY (train_no) REFERENCES TRAIN,
  FOREIGN KEY (route_no) REFERENCES ROUTE
);

CREATE TABLE CUSTOMER (
  customer_id VARCHAR(5),
  customer_username VARCHAR(20) NOT NULL,
  customer_name VARCHAR(50),
  customer_address VARCHAR(100),
  customer_phone VARCHAR(15),
  customer_email VARCHAR(50) NOT NULL,
  customer_pw VARCHAR(20) NOT NULL,
  PRIMARY KEY (customer_id)
);

CREATE TABLE PAYMENT (
  payment_no VARCHAR(15),
  payment_datetime DATE NOT NULL,
  cc_num VARCHAR(16) NOT NULL,
  payment_amount DECIMAL(10,4) NOT NULL,
  customer_id VARCHAR(5),
  PRIMARY KEY (payment_no),
  FOREIGN KEY (customer_id) REFERENCES CUSTOMER
);

CREATE TABLE BOOKING (
  booking_no VARCHAR(20),
  booking_date DATE NOT NULL,
  payment_no VARCHAR(15),
  PRIMARY KEY (booking_no),
  FOREIGN KEY (payment_no) REFERENCES PAYMENT
);

CREATE TABLE SEAT (
  seat_id VARCHAR(10),
  seat_number NUMBER(4) NOT NULL,
  seat_coach NUMBER(3) NOT NULL,
  train_no VARCHAR(10),
  booking_no VARCHAR(20),
  PRIMARY KEY (seat_id),
  FOREIGN KEY (train_no) REFERENCES TRAIN,
  FOREIGN KEY (booking_no) REFERENCES BOOKING
);

CREATE TABLE ARRIVAL (
  station_no VARCHAR(15),
  booking_no VARCHAR(20),
  arrival_status NUMBER(1),
  CONSTRAINT ARRIVAL_PK PRIMARY KEY(station_no,booking_no)
);

CREATE TABLE DEPARTURE (
  station_no VARCHAR(15),
  booking_no VARCHAR(20),
  departure_status NUMBER(1),
  CONSTRAINT DEPARTURE_PK PRIMARY KEY(station_no,booking_no)
);