
SELECT [File_Name] AS DateColumn, SUM(Deaths) AS Death, SUM(Confirmed) AS Confirmed
FROM [BI2020].[dbo].[Covid_USA]
GROUP BY [File_Name]
ORDER BY [File_Name] ASC

-------

/*get the newest data*/

SELECT [File_Name] AS Date, [Province_State] AS Province, [Confirmed] AS Confirmed, [Recovered] AS Recovered, [Active] AS Active, [Deaths] AS Death
FROM (SELECT [File_Name], [Province_State],[Confirmed],[Recovered],[Active],[Deaths],
             row_number() OVER(PARTITION BY [Province_State] ORDER BY [File_Name] DESC) AS rn
      FROM [BI2020].[dbo].[Covid_USA]) AS T
where rn = 1 

-----

SELECT [File_Name] AS DateColumn, SUM(Deaths) AS Death, SUM(Confirmed) AS Confirmed
FROM [BI2020].[dbo].[Covid_USA]
GROUP BY [File_Name]
ORDER BY [File_Name] ASC

/* Daily covid-19 numbers */
CREATE VIEW [DailyData] AS
SELECT [File_Name] AS DateColumn, SUM(Deaths) AS Death, SUM(Confirmed) AS Confirmed, 
(SELECT SUM(Recovered) 
FROM [BI2020].[dbo].[Covid_USA]  
WHERE [File_Name] = DB.[File_Name] AND [Province_State] != 'Recovered') AS Recovered
FROM [BI2020].[dbo].[Covid_USA] DB
GROUP BY [File_Name] 
ORDER BY [File_Name] ASC

/*
IF Province_State is null
then file_ ile group by
sum all recovered values */


/* Region based death rates*/
DECLARE @ParamDate
SET @ParamDate AS SYSDATETIME() 
SELECT

  MAX([File_Name]) AS "MostRecentServiceMonth"
FROM [BI2020].[dbo].[Covid_USA]
GROUP BY [File_Name]
ORDER BY [File_Name]


------------------
/*get the newest data*/
CREATE VIEW [TodaysData] AS
SELECT [File_Name] AS Date, [Province_State] AS Province, [Confirmed] AS Confirmed, [Recovered] AS Recovered, [Active] AS Active, [Deaths] AS Death
FROM (SELECT [File_Name], [Province_State],[Confirmed],[Recovered],[Active],[Deaths],
             row_number() OVER(PARTITION BY [Province_State] ORDER BY [File_Name] DESC) AS rn
      FROM [BI2020].[dbo].[Covid_USA]) AS T
where rn = 1 

---


CREATE VIEW [DiffTable] AS
SELECT [Active],[Death],[Confirmed],[Tested],
	LAG([DateColumn],1) OVER (
		ORDER BY [DateColumn]
	) other_day
FROM [BI2020].[dbo].[April_May_Cov_Data]
WHERE [DateColumn] IS NOT NULL

SELECT a.[other_day], b.[Active]-a.[Active] as Difference FROM [BI2020].[dbo].[April_May_Cov_Data] a
INNER JOIN [BI2020].[dbo].[DiffTable] b
ON a.[DateColumn]=b.[other_day]



---

CREATE VIEW [DiffTableForCovid] AS
SELECT [Active],[Death],[Confirmed],[Tested],
	LAG([DateColumn],1) OVER (
		ORDER BY [DateColumn]
	) other_day
FROM [BI2020].[dbo].[DailysData]
WHERE [DateColumn] IS NOT NULL

CREATE VIEW [DeathTable] AS
SELECT DATEADD(day, 1, b.[other_day]) AS DateAdd, b.[Death]-a.[Death] as Difference FROM [BI2020].[dbo].[DailysData] a
INNER JOIN [BI2020].[dbo].[DiffTableForCovid] b
ON a.[DateColumn]=b.[other_day]

-----

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [FileName], [Country Region], MAX([Confirmed]) AS Confirmed, MAX([Deaths]) AS Death, MAX([Active]) AS Active
  FROM [BI2020].[dbo].[Covid_Data_2]
  WHERE [Country Region] != 'Canada' OR [Country Region] != 'Others'
  GROUP BY [FileName], [Country Region]
  ORDER BY [FileName]

-------
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [FileName], [Country Region], SUM([Confirmed]) AS Confirmed, SUM([Deaths]) AS Death, SUM([Active]) AS Active
  FROM [BI2020].[dbo].[Covid_Data_2]
  WHERE [Country Region] != 'Canada' OR [Country Region] != 'Others'
  GROUP BY [FileName], [Country Region]
  ORDER BY [FileName] ASC
---
/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [EuropeAsiaTotal] AS 
SELECT [FileName], [Country Region], SUM([Confirmed]) AS Confirmed, SUM([Deaths]) AS Death, SUM([Active]) AS Active, SUM(Recovered) AS Recovered
  FROM [BI2020].[dbo].[Covid_Data_2]
  WHERE [Country Region] != 'Canada' AND [Country Region] != 'Others' AND [Country Region] != 'US' 
  GROUP BY [FileName], [Country Region]
  ORDER BY [FileName] ASC


----
/****** First 100 days  ******/
SELECT ROW_NUMBER() OVER( ORDER BY [FileName] ASC) as [Day] ,
 [Country Region],[Confirmed],[Death],[Active],[Recovered]  
 FROM [BI2020].[dbo].[EuropeAsiaTotal]  
 WHERE ([Confirmed] > 100 AND [Country Region] = 'Italy') 

-----


/****** Script for SelectTopNRows command from SSMS  ******/
SELECT SUM([Confirmed]) As Confirmed, [FileName],[Country Region]
  FROM [BI2020].[dbo].[Covid_Data_2]
 GROUP BY [Country Region], [FileName]
 ORDER BY [FileName]
-----
