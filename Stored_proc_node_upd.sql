/*
PROJECT GROUP: PATH-12

DATE: 12/10/2023

AUTHOR:AYMAN SHAAWI

INPUT:
	@NODE_NAME, String of node name 
	@NEW_COST, Int of new edge cost
	@CLASSIFICATION, Int value, if number is 0 then node will be source
								if number is 1 then node will be destination
								else node will be neither 
	@USAGE, Boolean to say if node is functional, if bit is 0 then it is not in use
												  if bit is 1 then it is in use


FUNCTIONALITY:
	Updates the cost of node if it exists.
	If it does not exist, create new node with new value.

EXAMPLE:
	EXEC UpdateNode @NODE_NAME, @NEW_COST, @CLASSIFICATION, @USAGE;
	EXEC UpdateNode 'A', 4, 0, 0;

*/


--STORED PROCEDURE TO UPDATE NODE COSTS
USE GraphDemo;
GO

CREATE PROCEDURE UpdateNode
	@NODE VARCHAR(MAX),
	@NEW_COST INT,
	@CLASSIFICATION INT,
	@USAGE BIT
AS

DECLARE	@NODE_ID INT;
DECLARE @CONDITION INT;

--FIND THE ID FOR THE NODE
SET @NODE_ID = (SELECT JSON_VALUE($node_id, '$.id') FROM NodeTable WHERE name = @NODE);
SET @CONDITION = (SELECT node_cost FROM NodeTable WHERE JSON_VALUE($node_id, '$.id') = @NODE_ID);

--CHECK IF THE NODE EXISTS
IF @CONDITION IS NULL
	
	IF @CLASSIFICATION = 0
		INSERT INTO NodeTable VALUES(
			@NODE, @NEW_COST, 1, 0, @USAGE
		);
	ELSE IF @CLASSIFICATION = 1
		INSERT INTO NodeTable VALUES(
			@NODE, @NEW_COST, 0, 1, @USAGE
		);
	ELSE
		INSERT INTO NodeTable VALUES(
			@NODE, @NEW_COST, 0, 0, @USAGE
		);
ELSE
	UPDATE NodeTable SET node_cost = @NEW_COST WHERE JSON_VALUE($node_id, '$.id') = @NODE_ID;
	UPDATE NodeTable SET inUseNode = @USAGE WHERE JSON_VALUE($node_id, '$.id') = @NODE_ID;
	
	IF @CLASSIFICATION = 0
		UPDATE NodeTable 
			SET isSource = 1, isDest = 0 WHERE JSON_VALUE($node_id, '$.id') = @NODE_ID;
	ELSE IF @CLASSIFICATION = 1
		UPDATE NodeTable SET isDest = 1, isSource = 0 WHERE JSON_VALUE($node_id, '$.id') = @NODE_ID;
	ELSE
		UPDATE NodeTable SET isSource = 0, isDest = 0 WHERE JSON_VALUE($node_id, '$.id') = @NODE_ID;

--UPDATE USAGE STATUS IN EDGE TABLE
UPDATE EdgeTable SET inUseEdge = @USAGE WHERE (JSON_VALUE($from_id, '$.id') = @NODE_ID OR JSON_VALUE($to_id, '$.id') = @NODE_ID);