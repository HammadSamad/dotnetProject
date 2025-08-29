-- Create Database
CREATE DATABASE StarSecurityDB;
GO

USE StarSecurityDB;
GO

/* ===============================
   1. Roles & Employees
   =============================== */
CREATE TABLE Roles (
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE   -- Admin, Manager, Staff
);

CREATE TABLE Clients (
    ClientID INT IDENTITY(1,1) PRIMARY KEY,
    ClientName NVARCHAR(100) NOT NULL,
    ContactPerson NVARCHAR(100),
    ContactNumber NVARCHAR(20),
    Address NVARCHAR(250)
);

CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeCode NVARCHAR(20) UNIQUE NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    Address NVARCHAR(250),
    ContactNumber NVARCHAR(20),
    Qualification NVARCHAR(100),
    Department NVARCHAR(100),
    RoleID INT NOT NULL,
    Grade NVARCHAR(50),
    ClientID INT NULL,
    Achievements NVARCHAR(MAX),
    Email NVARCHAR(100) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Employees_Roles FOREIGN KEY (RoleID) REFERENCES Roles(RoleID),
    CONSTRAINT FK_Employees_Clients FOREIGN KEY (ClientID) REFERENCES Clients(ClientID)
);
CREATE INDEX IX_Employees_EmployeeCode ON Employees(EmployeeCode);
CREATE INDEX IX_Employees_Email ON Employees(Email);

-- User Login / Authentication
CREATE TABLE UserAccounts (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    Username NVARCHAR(50) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    LastLogin DATETIME,
    IsActive BIT DEFAULT 1,
    CONSTRAINT FK_UserAccounts_Employees FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

 /* ===============================
   2. Services & ClientServices
   =============================== */
CREATE TABLE Services (
    ServiceID INT IDENTITY(1,1) PRIMARY KEY,
    ServiceName NVARCHAR(100) NOT NULL,    -- e.g., Manned Guarding, Cash Services
    Description NVARCHAR(MAX)
);

-- Junction table for Clients ↔ Services (many-to-many)
CREATE TABLE ClientServices (
    ClientServiceID INT IDENTITY(1,1) PRIMARY KEY,
    ClientID INT NOT NULL,
    ServiceID INT NOT NULL,
    AssignedStaff NVARCHAR(250),
    CONSTRAINT FK_ClientServices_Clients FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
    CONSTRAINT FK_ClientServices_Services FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID)
);
CREATE INDEX IX_ClientServices_ClientID ON ClientServices(ClientID);

 /* ===============================
   3. Vacancies & Applications
   =============================== */
CREATE TABLE Vacancies (
    VacancyID INT IDENTITY(1,1) PRIMARY KEY,
    JobTitle NVARCHAR(100) NOT NULL,
    Department NVARCHAR(100),
    Description NVARCHAR(MAX),
    Requirements NVARCHAR(MAX),
    Status NVARCHAR(20) DEFAULT 'Open',  -- Open / Filled
    PostedDate DATETIME DEFAULT GETDATE()
);

CREATE TABLE Applications (
    ApplicationID INT IDENTITY(1,1) PRIMARY KEY,
    VacancyID INT NOT NULL,
    ApplicantName NVARCHAR(100),
    ContactNumber NVARCHAR(20),
    Email NVARCHAR(100),
    ResumeLink NVARCHAR(255),
    Status NVARCHAR(20) DEFAULT 'Pending',  -- Pending / Shortlisted / Rejected / Hired
    AppliedDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Applications_Vacancies FOREIGN KEY (VacancyID) REFERENCES Vacancies(VacancyID)
);
CREATE INDEX IX_Applications_VacancyID ON Applications(VacancyID);

 /* ===============================
   4. Regions & Branches
   =============================== */
CREATE TABLE Regions (
    RegionID INT IDENTITY(1,1) PRIMARY KEY,
    RegionName NVARCHAR(50) UNIQUE NOT NULL   -- North, South, East, West
);

CREATE TABLE Branches (
    BranchID INT IDENTITY(1,1) PRIMARY KEY,
    RegionID INT NOT NULL,
    Address NVARCHAR(250),
    ContactPerson NVARCHAR(100),
    ContactNumber NVARCHAR(20),
    CONSTRAINT FK_Branches_Regions FOREIGN KEY (RegionID) REFERENCES Regions(RegionID)
);
CREATE INDEX IX_Branches_RegionID ON Branches(RegionID);

 /* ===============================
   5. Testimonials
   =============================== */
CREATE TABLE Testimonials (
    TestimonialID INT IDENTITY(1,1) PRIMARY KEY,
    ClientName NVARCHAR(100),
    Feedback NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE()
);

 /* ===============================
   6. About Us (Company Info & Directors)
   =============================== */
CREATE TABLE CompanyInfo (
    InfoID INT IDENTITY(1,1) PRIMARY KEY,
    Section NVARCHAR(50) NOT NULL,   -- History, Chairman, BoardOfDirectors
    Title NVARCHAR(100),
    Content NVARCHAR(MAX)
);

CREATE TABLE Directors (
    DirectorID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Position NVARCHAR(100),
    Profile NVARCHAR(MAX)
);

 /* ===============================
   7. Site Map
   =============================== */
CREATE TABLE SiteMap (
    PageID INT IDENTITY(1,1) PRIMARY KEY,
    PageName NVARCHAR(100) NOT NULL,
    URL NVARCHAR(255) NOT NULL,
    ParentPageID INT NULL,
    CONSTRAINT FK_SiteMap_Parent FOREIGN KEY (ParentPageID) REFERENCES SiteMap(PageID)
);

 /* ===============================
   8. Contact Messages
   =============================== */
CREATE TABLE ContactMessages (
    MessageID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20),
    Subject NVARCHAR(150),
    Message NVARCHAR(MAX),
    SubmittedAt DATETIME DEFAULT GETDATE(),
    IsResolved BIT DEFAULT 0
);
