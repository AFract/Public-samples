use Graph;

-- Create NODE tables
CREATE TABLE Person (
  Id INTEGER PRIMARY KEY,
  [Name] VARCHAR(100)
) AS NODE;

CREATE TABLE Restaurant (
  Id INTEGER NOT NULL,
  [Name] VARCHAR(100),
  City VARCHAR(100)
) AS NODE;

CREATE TABLE City (
  Id INTEGER PRIMARY KEY,
  [Name] VARCHAR(100),
  StateName VARCHAR(100)
) AS NODE;

-- Create EDGE tables.
CREATE TABLE likes (Rating INTEGER) AS EDGE;
CREATE TABLE friendOf AS EDGE;
CREATE TABLE livesIn AS EDGE;
CREATE TABLE locatedIn AS EDGE;