create table tool (
    serial_number varchar(50) NOT NULL, -- Assuming alpha-numeric serial number
    condition varchar(200) NOT NULL,
    is_available bit NOT NULL, -- 0 or 1 for boolean
    maintanence_status varchar(500) NOT NULL -- Assuming this is a descriptive field?
    branch_id int NOT NULL,
    tool_type_id int NOT NULL,

    primary key (serial_number),
    foreign key (tool_type_id) references branch
);

create table for_tool (
    invoice int NOT NULL AUTO_INCREMENT, -- Assuming invoice number is just a number e.g. 87, maybe it need to be varchar?
    serial_number varchar(50) NOT NULL, -- Assuming alpha-numeric serial number
    return_date date NOT NULL,

    primary key (invoice, serial_number),
    foreign key (invoice) references hire_record,
    foreign key (serial_number) references tool
);

create table hire_record (
    invoice int NOT NULL AUTO_INCREMENT, 
    hire_date date NOT NULL,
    due_date date NOT NULL,
    cust_id int NOT NULL,

    primary key (invoice),
    foreign key (cust_id) references customer
);

create table customer (
    cust_id int NOT NULL AUTO_INCREMENT,
    phone varchar(10) NOT NULL, -- Phone numbers in NZ are max 10 digits long
    street_number varchar(5) NOT NULL,
    street_name varchar(50) NOT NULL,
    city varchar(50) NOT NULL,
    email varchar(50) NOT NULL, -- Could this be optional?
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL, 

    primary key (cust_id)
);


create TABLE tool_type (
    tool_type_id int NOT NULL AUTO_INCREMENT,
    price int NOT NULL,
    name varchar (50) NOT NULL,
    maintanence_period varchar (30) NOT NULL, -- e.g. Monthly, Annually
    specification varchar(500),
    safety_recommendations varchar(500),
    description varchar(500),

    primary key(tool_type_id)
);

create table belongs_to_category (
    tool_type_id int NOT NULL AUTO_INCREMENT,
    category_name varchar(50) NOT NULL,

    primary key (tool_type_id, category_name),
    foreign key (tool_type_id) references tool_type,
    foreign key (category_name) references category
);

create table category (
    category_name varchar(50) NOT NULL, 
    description varchar(500),
    parent_category varchar(50),

    primary key (category_name),
    foreign key(parent_category) references category(parent_category)
);

create table maintenance_record(
    maintenance_id int NOT NULL AUTO_INCREMENT, 
    date date NOT NULL, 
    notes varchar(500), 
    serial_number varchar(50) NOT NULL, 
    staff_id int, 
    service_name varchar(50),

    primary key (maintenance_id),
    foreign key (staff_id) references staff,
    foreign key (service_name) references service_company
);

-- SerialNumber is a foreign key for the Tool relation, referencing the primary key of the Tool entity. Staff_ID is a foreign key for the staff relation, referencing the primary key of the Staff entity. ServiceName is a foreign key for the ServiceCompany relation, referencing the primary key of the ServiceCompany entity. 

create table service_company(
    service_name varchar(50) NOT NULL, 
    phone varchar(10) NOT NULL, 
    -- price -- is price required?

    primary key (service_name)
);

create table staff(
    staff_id int NOT NULL AUTO_INCREMENT, 
    firstname varchar(50) NOT NULL, 
    lastname varchar(50) NOT NULL, 
    position varchar(30) NOT NULL, -- Could be is_manager instead?
    dob date NOT NULL, 
    branch_id int,

    primary key (staff_id)
    foreign key (branch_id) references branch
);

create table branch(
    branch_id int NOT NULL AUTO_INCREMENT,
    name varchar(50) NOT NULL, 
    street_number varchar(5) NOT NULL,
    street_name varchar(50) NOT NULL,
    city varchar(50) NOT NULL,
    opening_hours, 
    phone varchar(10) NOT NULL, -- Phone numbers in NZ are max 10 digits long

    primary key (branch_id)
) 

