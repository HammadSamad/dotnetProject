-- =========================
-- USERS & LOGIN MANAGEMENT
-- =========================
CREATE TABLE Users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) CHECK (role IN ('admin','staff')) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);

-- =========================
-- EMPLOYEES
-- =========================
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT UNIQUE,
    emp_code VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    address NVARCHAR(255),
    contact_number VARCHAR(20),
    qualification VARCHAR(100),
    department VARCHAR(50),
    role VARCHAR(50),
    grade VARCHAR(20),
    achievements NVARCHAR(MAX),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- =========================
-- SERVICES
-- =========================
CREATE TABLE Services (
    service_id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100) NOT NULL,
    description NVARCHAR(MAX)
);

-- =========================
-- CLIENTS
-- =========================
CREATE TABLE Clients (
    client_id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    contact_number VARCHAR(20),
    address NVARCHAR(255)
);

-- =========================
-- CLIENT-SERVICES RELATION
-- =========================
CREATE TABLE ClientServices (
    client_id INT,
    service_id INT,
    PRIMARY KEY (client_id, service_id),
    FOREIGN KEY (client_id) REFERENCES Clients(client_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES Services(service_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- =========================
-- STAFF ASSIGNED TO CLIENTS
-- =========================
CREATE TABLE ClientEmployees (
    client_id INT,
    emp_id INT,
    PRIMARY KEY (client_id, emp_id),
    FOREIGN KEY (client_id) REFERENCES Clients(client_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- =========================
-- CAREERS (VACANCIES)
-- =========================
CREATE TABLE Vacancies (
    vacancy_id INT PRIMARY KEY IDENTITY(1,1),
    title VARCHAR(100),
    description NVARCHAR(MAX),
    department VARCHAR(50),
    status VARCHAR(10) CHECK (status IN ('open','filled')) DEFAULT 'open'
);

-- =========================
-- NETWORK (BRANCHES)
-- =========================
CREATE TABLE Branches (
    branch_id INT PRIMARY KEY IDENTITY(1,1),
    region VARCHAR(10) CHECK (region IN ('North','South','East','West')),
    address NVARCHAR(255),
    contact_person VARCHAR(100),
    contact_number VARCHAR(20)
);

-- =========================
-- TESTIMONIALS
-- =========================
CREATE TABLE Testimonials (
    testimonial_id INT PRIMARY KEY IDENTITY(1,1),
    client_id INT NULL,
    message NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (client_id) REFERENCES Clients(client_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

-- =========================
-- AUDIT LOGS
-- =========================
CREATE TABLE AuditLogs (
    log_id INT PRIMARY KEY IDENTITY(1,1),
    action_type VARCHAR(50),
    table_name VARCHAR(50),
    record_id INT,
    old_value NVARCHAR(MAX),
    new_value NVARCHAR(MAX),
    changed_at DATETIME DEFAULT GETDATE()
);
