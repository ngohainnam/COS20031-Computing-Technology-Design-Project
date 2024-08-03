DROP TABLE IF EXISTS SystemData;
DROP TABLE IF EXISTS EndData;
DROP TABLE IF EXISTS  RoundData;
DROP TABLE IF EXISTS  Competition;
DROP TABLE IF EXISTS  Category;
DROP TABLE IF EXISTS  ArcherData;
DROP TABLE IF EXISTS  Equipment;
DROP TABLE IF EXISTS  Class;
DROP TABLE IF EXISTS  RangeData;
DROP TABLE IF EXISTS  ChampionShip;
DROP TABLE IF EXISTS  RoundTypeData;


CREATE TABLE ArcherData (
    ArcherID VARCHAR(50) NOT NULL,
    ArcName VARCHAR(50) NOT NULL,
    DOB DATE NOT NULL,
    Gender VARCHAR(50) NOT NULL,
    CONSTRAINT pk_ArcherData PRIMARY KEY (ArcherID)
);


CREATE TABLE Equipment (
    EquipID VARCHAR(4) NOT NULL,
    EquipDesc VARCHAR(50) NOT NULL,
    CONSTRAINT pk_Equipment PRIMARY KEY (EquipID)
);


CREATE TABLE Class (
    ClassID VARCHAR(50) NOT NULL,
    ClassDesc VARCHAR(50) NOT NULL,
    CONSTRAINT pk_Class PRIMARY KEY (ClassID)
);


CREATE TABLE RangeData (
    RangeID VARCHAR(50) NOT NULL,
    Distance INT NOT NULL,
    ArrowNumber INT NOT NULL,
    TargetFace INT NOT NULL,
    CONSTRAINT pk_RangeData PRIMARY KEY (RangeID)
);


CREATE TABLE Category (
    ClassID VARCHAR(50) NOT NULL,
    EquipID VARCHAR(4) NOT NULL,
    CategoryDesc VARCHAR(50) NOT NULL,
    CONSTRAINT pk_Category PRIMARY KEY (ClassID, EquipID),
    CONSTRAINT fk_Category_Class FOREIGN KEY (ClassID) REFERENCES Class(ClassID),
    CONSTRAINT fk_Category_Equipment FOREIGN KEY (EquipID) REFERENCES Equipment(EquipID)
);
CREATE INDEX idx_Category_ClassID ON Category(ClassID);
CREATE INDEX idx_Category_EquipID ON Category(EquipID);


CREATE TABLE ChampionShip (
    ChampionShipID VARCHAR(50) NOT NULL,
    ChampionShipName VARCHAR(50) NOT NULL,
    YearOfChampionShip INT(4) NOT NULL,
    CONSTRAINT pk_ChampionShip PRIMARY KEY (ChampionShipID)
);


CREATE TABLE Competition (
    CompID VARCHAR(50) NOT NULL,
    ChampionShipID VARCHAR(50),
    CompName VARCHAR(50) NOT NULL,
    CompDesc VARCHAR(50) NOT NULL,
    CONSTRAINT pk_Competition PRIMARY KEY (CompID),
    CONSTRAINT fk_Competition_ChampionShip FOREIGN KEY (ChampionShipID) REFERENCES ChampionShip(ChampionShipID)
);
CREATE INDEX idx_Competition_ChampionShipID ON Competition(ChampionShipID);


CREATE TABLE RoundTypeData (
    RoundType VARCHAR(50) NOT NULL,
    RoundTypeDesc VARCHAR(50) NOT NULL,
    CONSTRAINT pk_RoundTypeData PRIMARY KEY (RoundType)
);


CREATE TABLE RoundData (
    RoundID VARCHAR(50) NOT NULL,
    RoundType VARCHAR(50) NOT NULL,
    RangeID VARCHAR(50) NOT NULL,
    CompID VARCHAR(50) NOT NULL,
    RoundName VARCHAR(50) NOT NULL,
    PossibleScore INT NOT NULL,
    CONSTRAINT pk_RoundData PRIMARY KEY (RoundID, RangeID),
    CONSTRAINT fk_RoundData_RangeData FOREIGN KEY (RangeID) REFERENCES RangeData(RangeID),
    CONSTRAINT fk_RoundData_RoundTypeData FOREIGN KEY (RoundType) REFERENCES RoundTypeData(RoundType),
    CONSTRAINT fk_RoundData_Competition FOREIGN KEY (CompID) REFERENCES Competition(CompID)
);
CREATE INDEX idx_RoundData_RoundType ON RoundData(RoundType);
CREATE INDEX idx_RoundData_CompID ON RoundData(CompID);


CREATE TABLE EndData (
    RoundID VARCHAR(50) NOT NULL,
    RangeID VARCHAR(50) NOT NULL,
    EndID VARCHAR(50) NOT NULL,
    Arrow1 INT(2) NOT NULL,
    Arrow2 INT(2) NOT NULL,
    Arrow3 INT(2) NOT NULL,
    Arrow4 INT(2) NOT NULL,
    Arrow5 INT(2) NOT NULL,
    Arrow6 INT(2) NOT NULL,
    Approved BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_EndData PRIMARY KEY (RoundID, RangeID, EndID),
    CONSTRAINT fk_EndData_RoundData FOREIGN KEY (RoundID, RangeID) REFERENCES RoundData (RoundID, RangeID)
);
CREATE INDEX idx_EndData_RoundID ON EndData(RoundID);
CREATE INDEX idx_EndData_RangeID ON EndData(RangeID);


CREATE TABLE SystemData (
    ArcherID VARCHAR(50) NOT NULL,
    ClassID VARCHAR(50) NOT NULL,
    EquipID VARCHAR(4) NOT NULL,
    RoundID VARCHAR(50) NOT NULL,
    RangeID VARCHAR(50) NOT NULL,
    CompID VARCHAR(50),
    EndID VARCHAR(50) NOT NULL,
    DateInfo DATE NOT NULL,
    CONSTRAINT pk_SystemData PRIMARY KEY (ArcherID, ClassID, EquipID, RoundID, RangeID, CompID, EndID),
    CONSTRAINT fk_SystemData_ArcherData FOREIGN KEY (ArcherID) REFERENCES ArcherData(ArcherID),
    CONSTRAINT fk_SystemData_Category FOREIGN KEY (ClassID, EquipID) REFERENCES Category(ClassID, EquipID),
    CONSTRAINT fk_SystemData_EndData FOREIGN KEY (RoundID, RangeID, EndID) REFERENCES EndData(RoundID, RangeID, EndID),
    CONSTRAINT fk_SystemData_Competition FOREIGN KEY (CompID) REFERENCES Competition(CompID)
);
CREATE INDEX idx_SystemData_ArcherID ON SystemData(ArcherID);
CREATE INDEX idx_SystemData_ClassID ON SystemData(ClassID);
CREATE INDEX idx_SystemData_EquipID ON SystemData(EquipID);
CREATE INDEX idx_SystemData_RoundID ON SystemData(RoundID);
CREATE INDEX idx_SystemData_RangeID ON SystemData(RangeID);
CREATE INDEX idx_SystemData_CompID ON SystemData(CompID);
CREATE INDEX idx_SystemData_EndID ON SystemData(EndID);
CREATE INDEX idx_SystemData_DateInfo ON SystemData(DateInfo);


INSERT INTO Equipment (EquipID, EquipDesc) VALUES 
('R','Recurve'),
('C','Compound'),
('RB','Recurve Barebow'),
('B','Compound Barebow'),
('L','Longbow');


INSERT INTO  Class (ClassID, ClassDesc) VALUES 
('FOPEN', 'Female Open'),
('MOPEN', 'Male Open'),
('50+F', '50+ Female'),
('50+M', '50+ Male'),
('60+F', '60+ Female'),
('60+M', '60+ Male'),
('70+F', '70+ Female'),
('70+M', '70+ Male'),
('U21F', 'Under 21 Female'),
('U21M', 'Under 21 Male'),
('U18F', 'Under 18 Female'),
('U18M', 'Under 18 Male'),
('U16F', 'Under 16 Female'),
('U16M', 'Under 16 Male'),
('U14F', 'Under 14 Female'),
('U14M', 'Under 14 Male');


INSERT INTO ChampionShip(ChampionShipID, ChampionShipName, YearOfChampionShip) VALUES 
('WF','World Final ChampionShip', 2024),
('AUS','Australian ChampionShip', 2025);


INSERT INTO Competition(CompID, ChampionShipID, CompName, CompDesc ) VALUES 
('C0', 'WF', 'Deadly Arrow', 'A part of the World Final ChampionShip'),
('C1', NULL, 'Archer Mallow', 'Normal Competition'),
('C2', 'AUS', 'Archer Pillow', 'A part of the Australian ChampionShip'),
('C3', 'WF', 'Arrow Phoenix','A part of the World Final ChampionShip');


INSERT INTO Category (ClassID, EquipID, CategoryDesc) VALUES 
('MOPEN', 'R', 'Male Open Recurve'),
('U21M', 'R', 'Under 21 Male Recurve'),
('U18M','L', 'Under 18 Male Longbow'),
('U18M','C', 'Under 18 Male Compound');



INSERT INTO  RoundTypeData (RoundType, RoundTypeDesc) VALUES 
('Base','Base Round'),
('Junior','Junior Round'),
('Lady','Female Round'),
('Men','Male Round'),
('Pro','Professional Round');
