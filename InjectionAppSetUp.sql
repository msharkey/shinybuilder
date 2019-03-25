
USe Cab_Demo
GO

DROP Table IF Exists dbo.Persons


CREATE TABLE dbo.Persons (
	email Varchar(100) NOT NULL PRIMARY KEY,
	jobtitle Varchar(50)
	)

	INSERT INTO dbo.Persons
	VALUES ('msharkey3434@gmail.com','Data Engineer'),
	       ('q2474554@nwytg.net','Analyst')

	Select * From dbo.Persons

	DELETE FROM Dbo.Persons Where email = 'q2474554@nwytg.net'

	UPDATE dbo.Persons 
	SET jobtitle = 'Analyst'
	WHERE email = 'msharkey3434@gmail.com'