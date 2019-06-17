--create the database
CREATE DATABASE RedStrike;

--create login with using SQL Auth
CREATE LOGIN RedStrikeApp WITH PASSWORD = 'RedStrikeApp';

--create the user from the login
Use RedStrike;
CREATE USER RedStrikeApp FOR LOGIN RedStrikeApp;

--To give admin permissions
EXEC sp_addrolemember 'db_owner', 'RedStrikeApp';