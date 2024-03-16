/*
PROJECT GROUP: PATH-12

DATE: 12/10/2023

AUTHOR:AYMAN SHAAWI

INPUT:
	@FROM_NODE_NAME, String of node name 
	@TO_NODE_NAME, String of node name

FUNCTIONALITY:
	Deletes just the edge between both nodes

EXAMPLE:
	EXEC DeleteEdge @FROM_NODE_NAME, @TO_NODE_NAME;
	or
	EXEC DeleteEdge 'A', 'B';

*/



--STORED PROCEDURE FOR DELETING EDGES
USE GraphDemo;
GO

CREATE PROCEDURE DeleteEdge
	@FROM_NODE VARCHAR(MAX),
	@TO_NODE VARCHAR(MAX)
AS

--FIND THE IDS
DECLARE @FROM_ID INT;
DECLARE @TO_ID INT;

SET @FROM_ID = (SELECT JSON_VALUE($node_id, '$.id') FROM NodeTable WHERE name = @FROM_NODE);
SET @TO_ID = (SELECT JSON_VALUE($node_id, '$.id') FROM NodeTable WHERE name = @TO_NODE);

--DELETE EDGE 
DELETE FROM EdgeTable WHERE (JSON_VALUE($from_id, '$.id') = @FROM_ID AND JSON_VALUE($to_id, '$.id') = @TO_ID);

