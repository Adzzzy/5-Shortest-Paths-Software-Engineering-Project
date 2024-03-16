# 5 Shortest Paths Software Engineering Project
A software engineering project working in a team of nine following the Agile Scrum methodology and creating an algorithm which finds the 5 shortest paths between a single source and multiple possible destinations when given a factory layout.
The project uses Microsoft SQL Server as per request of the client company, utilising capabilities of the software, T-SQL, and stored procedures to implement the solution.

Using MSSQL, follow these steps to use the program:
  - Create database called GraphDemo if it does not exist
  - Load csv flat file (see Device_list.csv) into a table and call it MasterTable
  - Generate the Node and Edge tables by executing Gen_Node_Edge.sql
  - Execute all stored procedures (the sql files starting with Stored_proc) to get them in the database as functions
  - Use the stored procedures as desired to make additional modifications to the factory layout
  - Execute Top_5_shortest_paths.sql to return the 5 shortest paths
    
