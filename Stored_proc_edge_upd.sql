/*
PROJECT GROUP: PATH-12

DATE: 11/10/2023

AUTHOR:AYMAN SHAAWI

INPUT:
	@FROM_NODE_NAME, String of node name 
	@TO_NODE_NAME, String of node name
	@NEW_COST, Int of new edge cost
	@USAGE, BIT of usage

FUNCTIONALITY:
	Updates the cost of an edge if it exists.
	If both nodes exist but edge doesn't, creates an edge between the nodes
	If one or more nodes do not exist, does nothing

EXAMPLE:
	EXEC UpdateEdge @FROM_NODE_NAME, @TO_NODE_NAME, @NEW_COST, @USAGE;
	or
	EXEC UpdateEdge 'A', 'B', 5, 0;

*/



--STORED PROCEDURE TO UPDATE EDGE COSTS
USE GraphDemo;
GO

CREATE PROCEDURE UpdateEdge 
	@FROM_NODE VARCHAR(MAX),
	@TO_NODE VARCHAR(MAX),
	@NEW_COST INT,
	@USAGE BIT
AS
--FROM NODE AND TO NODE CONTAIN VALUES FOR THE NAME

--FIND THE ID VALUE FOR FROM AND START NODE
DECLARE @FROM_ID INT;
DECLARE @TO_ID INT;
DECLARE @CONDITION INT;

SET @FROM_ID = (SELECT JSON_VALUE($node_id, '$.id') FROM NodeTable WHERE name = @FROM_NODE);
SET @TO_ID = (SELECT JSON_VALUE($node_id, '$.id') FROM NodeTable WHERE name = @TO_NODE);
SET @CONDITION = (SELECT edge_cost FROM EdgeTable WHERE (JSON_VALUE($from_id, '$.id') = @FROM_ID) AND (JSON_VALUE($to_id, '$.id') = @TO_ID));

--CHECK IF THE CONNECTION EXISTS AND MAKE IF IT DOESNT
IF (@CONDITION IS NULL AND @FROM_ID IS NOT NULL AND @TO_ID IS NOT NULL)
	INSERT INTO EdgeTable VALUES (
	(SELECT $NODE_ID FROM NodeTable WHERE JSON_VALUE($node_id, '$.id') = @FROM_ID), (SELECT $NODE_ID FROM NodeTable WHERE JSON_VALUE($node_id, '$.id') = @TO_ID), (@NEW_COST), (@USAGE)
	);
ELSE
	Update EdgeTable SET edge_cost = @NEW_COST, inUseEdge = @USAGE WHERE (JSON_VALUE($from_id, '$.id') = @FROM_ID) AND (JSON_VALUE($to_id, '$.id') = @TO_ID);



