USE iplauction;

-- To read data -- 
SELECT * FROM auction;

-- 1.Which player was the most expensive buy in the IPL 2023 auction --

SELECT * FROM auction WHERE Cost_In_Crore IN(  
SELECT MAX(cost_in_crore)AS maxval FROM auction 
ORDER BY maxval DESC); 

-- 2.Find the top 10 most expensive players bought by the team --

SELECT playersName,team, MAX(cost_in_crore)AS maxval FROM auction 
GROUP BY playersname ,team 
ORDER BY maxval DESC 
LIMIT 10 ;

-- 3.Which team spent the most money in the IPL 2023 auction --

SELECT team,ROUND(SUM(cost_in_crore))AS highest FROM auction 
GROUP BY team ORDER BY highest 
DESC LIMIT 1;

-- 4.how many players are Sold and unSold --

SELECT Result,COUNT(result)AS ttl FROM auction 
GROUP BY result ;

-- 5.Total players sold by type category --

SELECT type ,COUNT(type)AS ttl FROM auction 
WHERE result = 'Sold' 
GROUP BY type ;

-- 6.Total number of players bought by each team --

SELECT team,COUNT(playersname)AS totalplayers FROM auction 
WHERE result = 'Sold' 
GROUP BY team ORDER BY totalplayers ASC;

-- 7.Total Players retain and bought by teams --

SELECT team,Retention ,COUNT(playersname)AS totalplayers 
FROM auction 
GROUP BY team,Retention ;

-- 8.list the players whose previous team is different from their sold team --

SELECT playersname,Prev_Team,team FROM auction 
WHERE prev_team ='DNP' AND result = 'Sold';

-- 9.find the players whose cost is greater than the average cost in rupees --

SELECT a.playersname FROM auction a JOIN (
SELECT AVG(cost_in_crore) AS avg_cost FROM auction) AS avg_table
ON a.cost_in_crore > avg_table.avg_cost;

-- 10. list the players who are retained --

SELECT playersname,type,team FROM auction 
WHERE base_price = 'retained';

-- 11.How many players of each type are there in each team --

SELECT team,type, COUNT(playersname)AS playername 
FROM auction 
GROUP BY team,type; 

-- 12.Which players participated in the previous year's IPL but remained unsold in the subsequent auction --

SELECT playersname,Prev_Team FROM auction 
WHERE Prev_Team != 'DNP' AND team = 'UnSold'; 

-- 13.Find all players bought by sunrises hyderabad that spent more than 30 crore in total --

WITH TeamTotal AS (
	SELECT team, SUM(cost_in_crore) AS total_spent
	FROM auction
	GROUP BY team
	HAVING total_spent > 30
   )
SELECT pa.playersname, pa.cost_in_crore
FROM auction pa
JOIN TeamTotal tt ON pa.team = tt.team  ORDER BY cost_in_crore DESC LIMIT 11;
