/*
PROJECT GROUP: PATH-12

DATE: 18/10/2023

AUTHOR:GURVIR SINGH, AYMAN SHAAWI, ADAM REBES

INPUT:
	NONE
	REQUIRES NodeTable and EdgeTable to be defined

FUNCTIONALITY:
	RETURNS 5 SHORTEST PATHS FROM TABLE BASED ON THE NODETABLE AND EDGETABLES
	

*/



USE GraphDemo;
GO

SELECT $edge_id, N1.name AS fromName, N2.name AS toName, edge_cost, N1.node_cost AS fromNodeCost, N1.isSource, N1.isDest, inUseEdge 
INTO TempTable FROM (EdgeTable INNER JOIN NodeTable AS N1 ON $from_id = N1.$node_id INNER JOIN NodeTable AS N2 ON $to_id = N2.$node_id);

ALTER TABLE TempTable
ADD ExitCheck INT

UPDATE TempTable
SET ExitCheck = 0

--SELECT * FROM TempTable;

DECLARE @strt AS VARCHAR(30) = 'SOURCE_6';
DECLARE @end AS VARCHAR(30) = 'DEST_LOAD';
UPDATE TempTable SET ExitCheck=1 WHERE toName = @end;
UPDATE TempTable SET ExitCheck=1 WHERE toName = ANY (SELECT fromName FROM TempTable WHERE ExitCheck=1)

DECLARE @Counter INT
SET @Counter=1
WHILE (@Counter<=1)
BEGIN
UPDATE TempTable SET ExitCheck=1 WHERE ExitCheck=0 AND toName = ANY(SELECT fromName FROM TempTable WHERE ExitCheck=1)
IF @@ROWCOUNT = 0
	SET @Counter=2
END;

WITH TemporaryTable AS (SELECT toName,
      CAST (fromName + '->' + toName AS VARCHAR (MAX)) FullPath,
      edge_cost TotalDistance
      FROM TempTable
      WHERE (fromName = @strt)
      UNION ALL
      SELECT a.toName,
         FullPath=c.FullPath + '->' + a.toName,
         TotalDistance=TotalDistance + a.edge_cost + a.fromNodeCost
      FROM TempTable a, TemporaryTable c
      WHERE a.fromName = c.toName
	  AND a.inUseEdge=0
	  AND a.ExitCheck=1
	  AND LEN(c.FullPath)<CHARINDEX(a.fromName,c.FullPath)+LEN(a.fromName)
      )
	  
	  Select DISTINCT TOP 5 FullPath, TotalDistance FROM TemporaryTable
	  WHERE CHARINDEX(@end,FullPath)>0
	  AND LEN(FullPath)<CHARINDEX(@end,FullPath)+LEN(@END)
	  --AND CHARINDEX(@avoid,FullPath)<=0
	  ORDER BY TotalDistance
	  OPTION (MAXRECURSION 1000)

DROP TABLE TempTable