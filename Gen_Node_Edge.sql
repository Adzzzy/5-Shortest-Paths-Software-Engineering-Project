/*
PROJECT GROUP: PATH-12

DATE: 18/10/2023

AUTHOR:AYMAN SHAAWI, ADAM REBES, MURRAY CAHL

INPUT:
	NONE
	REQUIRES GraphDemo to already be defined

FUNCTIONALITY:
	CREATES NODE AND EDGE TABLES IN THE FOLLOWING FORMAT FROM THE DATABASE CREATED FROM THE CSV FILE

EXAMPLE:
	TABLE STRUCTURE

	NODE TABLE:
	----------------------------------------------------
   | $node_id | name | cost | isSource | isDest | isUse |
   |   ...    | ...  | ...  |    ...   |  ...   |  ...  |

   EDGE TABLE:
    ---------------------------------------------
   | $path_id | $from_id | $to_id | cost | inUse |
   |   ...    |   ...    |  ...   | ...  |  ...  |

	

*/
USE GraphDemo
GO

CREATE TABLE NodeTable (
	name VARCHAR(MAX),
	node_cost INT,
	isSource BIT,
	isDest BIT,
	inUseNode BIT
) AS NODE;

CREATE TABLE EdgeTable (
	edge_cost INT,
	inUseEdge BIT
) AS EDGE;


--GENERATE NODE TABLE
INSERT INTO NodeTable (name, isSource, isDest)
	SELECT DISTINCT Plant_Item, Is_Source, Is_Destination FROM dbo.MasterTable;

UPDATE NodeTable 
	SET node_cost = 1
	WHERE node_cost IS NULL;

UPDATE NodeTable 
	SET inUseNode = 0
	WHERE inUseNode IS NULL;

--GENERATE EDGE TABLE
USE GraphDemo
GO
INSERT INTO EdgeTable ($from_id, $to_id)
	SELECT
		(SELECT $node_id FROM NodeTable WHERE NodeTable.name = M.Connect_from) AS from_id,
		(SELECT $node_id FROM NodeTable WHERE NodeTable.name = M.Plant_Item AND M.Connect_from IS NOT NULL) AS to_id
	FROM MasterTable AS M
	WHERE 
		(SELECT $node_id FROM NodeTable WHERE NodeTable.name = M.Connect_from) IS NOT NULL 
		OR 
		(SELECT $node_id FROM NodeTable WHERE NodeTable.name = M.Plant_Item AND M.Connect_from IS NOT NULL) IS NOT NULL;

--SET COST AND USAGE
UPDATE EdgeTable 
	SET edge_cost = 1
	WHERE edge_cost IS NULL;

UPDATE EdgeTable
	SET inUseEdge = 0
	WHERE inUseEdge IS NULL;
