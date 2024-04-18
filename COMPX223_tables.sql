create table branch(
    branch_id int NOT NULL IDENTITY(0, 1),
    name varchar(50) NOT NULL, 
    street_number varchar(5) NOT NULL,
    street_name varchar(50) NOT NULL,
    city varchar(50) NOT NULL,
    opening_hours varchar(100) NOT NULL, 
    phone varchar(10) NOT NULL, -- Phone numbers in NZ are max 10 digits long

    primary key (branch_id),
    check (phone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);

create table customer (
    cust_id int NOT NULL IDENTITY(0, 1),
    phone varchar(10) NOT NULL, -- Phone numbers in NZ are max 10 digits long
    street_number varchar(5) NOT NULL,
    street_name varchar(50) NOT NULL,
    city varchar(50) NOT NULL,
    email varchar(50) NOT NULL, -- Could this be optional?
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL, 

    primary key (cust_id),
    check (email LIKE '%@%.%' AND phone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);

create table service_company (
    service_name varchar(50) NOT NULL, 
    phone varchar(10) NOT NULL, 

    primary key (service_name),
    check ( phone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' )
);

create table category (
    category_name varchar(100) NOT NULL, 
    description varchar(500),
    parent_category varchar(100),

    primary key (category_name),
    foreign key(parent_category) references category(category_name)
);

create table tool_type (
    tool_type_id int NOT NULL IDENTITY(0, 1),
    price int NOT NULL,
    name varchar (50) NOT NULL,
    maintanence_period varchar (30) NOT NULL, -- e.g. Monthly, Annually
    specification varchar(500),
    safety_recommendations varchar(500),
    description varchar(500),

    primary key(tool_type_id)
);

create table tool (
    serial_number varchar(8) NOT NULL, -- Assuming alpha-numeric serial number
    condition varchar(200) NOT NULL,
    is_available bit NOT NULL, -- 0 or 1 for boolean
    maintanence_status bit NOT NULL,
    branch_id int NOT NULL,
    tool_type_id int NOT NULL,

    primary key (serial_number),
    foreign key (branch_id) references branch,
    foreign key (tool_type_id) references tool_type,
    check (serial_number LIKE '[A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9]')
);

create table hire_record (
    invoice int NOT NULL IDENTITY(0, 1), 
    hire_date date NOT NULL,
    due_date date NOT NULL,
    cust_id int NOT NULL,

    primary key (invoice),
    foreign key (cust_id) references customer,
    check (hire_date <= due_date AND hire_date >= getdate())
);

create table for_tool (
    invoice int NOT NULL,
    serial_number varchar(8) NOT NULL,
    return_date date NOT NULL,

    primary key (invoice, serial_number),
    foreign key (invoice) references hire_record,
    foreign key (serial_number) references tool,
    check(return_date >= getdate())
);

create table staff(
    staff_id int NOT NULL IDENTITY(0, 1), 
    firstname varchar(50) NOT NULL, 
    lastname varchar(50) NOT NULL, 
    position varchar(30) NOT NULL, 
    dob date NOT NULL, 
    branch_id int,

    primary key (staff_id),
    foreign key (branch_id) references branch,
    check(dob < getdate())
);

create table belongs_to_category (
    tool_type_id int NOT NULL,
    category_name varchar(100) NOT NULL,

    primary key (tool_type_id, category_name),
    foreign key (tool_type_id) references tool_type,
    foreign key (category_name) references category
);

create table maintenance_record(
    maintenance_id int NOT NULL IDENTITY(0, 1), 
    date date NOT NULL, 
    notes varchar(500), 
    serial_number varchar(8) NOT NULL, 
    staff_id int, 
    service_name varchar(50),

    primary key (maintenance_id),
    foreign key (staff_id) references staff,
    foreign key (service_name) references service_company
);

-- Insertion into branch table

insert into branch (name, street_number, street_name, city, opening_hours, phone)
values ('Tauranga', '100', 'Wharf St', 'Tauranga', '7:00am-5:30pm', '0800472930');

insert into branch (name, street_number, street_name, city, opening_hours, phone)
values ('South Hamilton', '200', 'Locke St', 'Hamilton', '7:00am-5:30pm', '0800472931');

insert into branch (name, street_number, street_name, city, opening_hours, phone)
values ('Wellington', '20', 'Cuba St', 'Wellington', '7:00am-5:30pm', '0800472932');

insert into branch (name, street_number, street_name, city, opening_hours, phone)
values ('Christchurch', '20', 'Dacre St', 'Christchurch', '7:00am-5:30pm', '0800472934');

-- Insertion into customer table

insert into customer (phone, street_number, street_name, city, email, first_name, last_name)
values ('0210798712', '101', 'Wharf St', 'Tauranga', 'john.smith@hotmail.com', 'John', 'Smith');

insert into customer (phone, street_number, street_name, city, email, first_name, last_name)
values ('0210564372', '201', 'Locke St', 'Hamilton', 'jane.smith@hotmail.com', 'Jane', 'Smith');

insert into customer (phone, street_number, street_name, city, email, first_name, last_name)
values ('0204679789', '35B', 'Bell St', 'Wellington', 'twenty.huan@gmail.com', 'Jeff', 'Huan');

insert into customer (phone, street_number, street_name, city, email, first_name, last_name)
values ('0204679789', '13C', 'Shirley Rd', 'Christchurch', 'zdangerzone@gmail.com', 'Zach', 'Danger');

-- Insertion into service_company table

insert into service_company(service_name, phone) values ('ToolTech Pros', '0800451794');
insert into service_company(service_name, phone) values ('MasterFix Tools', '0800679593');
insert into service_company(service_name, phone) values ('Precision Tool Care', '0800098190');
insert into service_company(service_name, phone) values ('QuickFix Specialists', '0800159074');

-- Insertion into category table

insert into category (category_name, description) values ('Power Tools', 'A power-driven hand tool or portable power tool');
insert into category (category_name, description, parent_category) values ('Drills', 'A power tool used for making narrow holes', 'Power Tools');
insert into category (category_name, description, parent_category) values ('Sanders', 'Used for smoothing, polishing or cleaning a surface', 'Power Tools');
insert into category (category_name, description, parent_category) values ('Grinders', 'A tool used forremoving material via abrasion', 'Power Tools');

-- Insertion into tool_type

insert into tool_type (price, name, maintanence_period, specification, safety_recommendations, description)
values (28.21, 'Drill Battery 14mm Chuck', 'Annually', '14mm Chuck, 18V Battery', 'Hearing Protection, Eye Protection', 'For drilling a variety of materials including wood and steel where;electricity is not available or convenient.');

insert into tool_type (price, name, maintanence_period, specification, safety_recommendations, description)
values (89.60, 'Floor Edger Sander 175mm', 'Annually', 'Disc Sander, 3000rpm', 'Hearing Protection, Eye Protection, Foot Protection', 'For preparing the timber floors before varnishing or recovering.');

insert into tool_type (price, name, maintanence_period, specification, safety_recommendations, description)
values (35.20, 'Grinder Angle Battery 100 to 125mm', 'Monthly', '21.6V, 125mm Max Disk Size, 14mm Spindle thread', 'Hand Protection, Hearing Protection, Shock Protection', 'Used for the smaller grinding or cutting of metal or masonry.');

insert into tool_type (price, name, maintanence_period, specification, safety_recommendations, description)
values (49.61, 'Belt Sander 100mm', 'Monthly', 'Corded, 610x100mm belt size', 'Hearing Protection, Eye Protection, Hand Protection', 'Belt sander for various applications around the home including;sanding weatherboards, furniture.');

-- Insertion into belongs_to_category

insert into belongs_to_category (tool_type_id, category_name) values (0, 'Drills');
insert into belongs_to_category (tool_type_id, category_name) values (1, 'Sanders');
insert into belongs_to_category (tool_type_id, category_name) values (2, 'Grinders');
insert into belongs_to_category (tool_type_id, category_name) values (3, 'Sanders');

-- Insertion into tool

insert into tool (serial_number, condition, is_available, maintanence_status, branch_id, tool_type_id) values ('XYZ1234', 'Decent', 0, 1, 0, 1);
insert into tool (serial_number, condition, is_available, maintanence_status, branch_id, tool_type_id) values ('YXZ3245', 'Poor', 1, 0, 0, 1);
insert into tool (serial_number, condition, is_available, maintanence_status, branch_id, tool_type_id) values ('NMV8976', 'New', 0, 1, 0, 1);
insert into tool (serial_number, condition, is_available, maintanence_status, branch_id, tool_type_id) values ('PWE2358', 'Slightly Used', 1, 0, 0, 1);

-- Insertion into hire_record

insert into hire_record (hire_date, due_date, cust_id) values ('2024-12-17','2024-12-19', 0);
insert into hire_record (hire_date, due_date, cust_id) values ('2024-10-30', '2024-11-30', 1);
insert into hire_record (hire_date, due_date, cust_id) values ('2024-12-30', '2024-12-30', 3);
insert into hire_record (hire_date, due_date, cust_id) values ('2024-12-30', '2024-12-30', 2);

-- Insertion into for_tool

insert into for_tool (invoice, serial_number, return_date) values (0, 'XYZ1234', '2024-12-30');
insert into for_tool (invoice, serial_number, return_date) values (1, 'XYZ1234', '2024-11-30');
insert into for_tool (invoice, serial_number, return_date) values (2, 'NMV8976', '2024-12-30');
insert into for_tool (invoice, serial_number, return_date) values (3, 'PWE2358', '2024-12-30');

-- insertion into staff

insert into staff(firstname, lastname, position, dob, branch_id) values ('Charles', 'Crossly', 'Manager', '1980-11-30', 0);
insert into staff(firstname, lastname, position, dob, branch_id) values ('Conner', 'Sheifields', 'Manager', '1989-10-30', 1);
insert into staff(firstname, lastname, position, dob, branch_id) values ('Nate', 'Meeker', 'Manager', '1991-12-30', 2);
insert into staff(firstname, lastname, position, dob, branch_id) values ('Nicky', 'Brooke', 'Manager', '1973-09-30', 3);
insert into staff(firstname, lastname, position, dob, branch_id) values ('Paige', 'Brogann', 'Team Member', '2000-01-30', 3);

-- insertion into maintenance_record 
insert into maintenance_record(date, notes, serial_number, staff_id)
values ('2023-06-30', 'Oiled tool components', 'XYZ1234', 0);

insert into maintenance_record(date, notes, serial_number, staff_id)
values ('2022-06-30', 'Minor scuff, replace bearing', 'XYZ1234', 0);

insert into maintenance_record(date, notes, serial_number, staff_id)
values ('2021-06-30', 'Little bit worse than last year', 'XYZ1234', 0);

insert into maintenance_record(date, notes, serial_number, staff_id)
values ('2020-06-30', 'Good as new essentially', 'XYZ1234', 0);
