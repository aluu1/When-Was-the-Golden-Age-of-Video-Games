--1. Explore game_sales and game_reviews
SELECT TOP 10 *
FROM game_sales
ORDER BY Total_Shipped DESC;

SELECT TOP 10 *
FROM game_reviews
ORDER BY Critic_Score DESC, User_Score DESC;

--2. Some metrics have too many decimal places.
--Round Total_Shipped from game_sales to 2 decimal places
--Round Critic_Score and User_Score from game_reviews to 1 decimal place
UPDATE game_sales
SET Total_Shipped = ROUND(Total_Shipped, 2);

UPDATE game_reviews
SET Critic_Score = ROUND(Critic_Score, 1),
User_Score = ROUND(User_Score, 1);

--3. Missing user and critic review scores
SELECT COUNT(*) AS missing_user_score_count
FROM game_sales AS s
LEFT JOIN game_reviews AS r
ON s.name = r.name
WHERE user_score IS NULL
	AND critic_score IS NULL;

--4. Years that video game critics loved
SELECT TOP 10
	year,
	ROUND(AVG(critic_score), 1) AS average_critic_score,
	COUNT(r.name) AS num_games
FROM game_reviews AS r
LEFT JOIN game_sales AS s
ON r.name = s.name
GROUP BY year
ORDER BY average_critic_score DESC;

--5. Was 1982 really that great?
-- Select the top 10 years with the highest average critic score and has more than 4 releases
SELECT TOP 10
	year,
	ROUND(AVG(critic_score), 2) AS average_critic_score,
	COUNT(r.name) AS games_count
FROM game_sales AS s
LEFT JOIN game_reviews AS r
ON s.name = r.name
GROUP BY year
HAVING COUNT(r.name) > 4
ORDER BY average_critic_score DESC;

--6. Import top_critic_scores_more_than_four_games.csv, top_critic_scores.csv, and
--top_user_scores_more_than_four_games.csv
--update both of the table's scores to have only 1 decimal place
UPDATE top_critic_scores_more_than_four_games
SET avg_critic_score = ROUND(avg_critic_score, 1);

UPDATE top_user_scores_more_than_four_games
SET avg_user_score = ROUND(avg_user_score, 1);

UPDATE top_critic_scores
SET avg_critic_score = ROUND(avg_critic_score, 1);

SELECT *
FROM top_critic_scores_more_than_four_games;

SELECT *
FROM top_user_scores_more_than_four_games;

SELECT *
FROM top_critic_scores;

--7. Years that dropped off the critics' favorites list due to having less than 4 games
SELECT
	tcs.year,
	tcs.avg_critic_score
FROM top_critic_scores AS tcs
LEFT JOIN top_critic_scores_more_than_four_games AS csmt
ON tcs.year = csmt.year
WHERE tcs.year NOT IN (
		SELECT year
		FROM top_critic_scores_more_than_four_games)
ORDER BY avg_critic_score DESC;

--8. Years video game players loved
SELECT TOP 10
	year,
	ROUND(AVG(user_score), 2) AS avg_user_score,
	COUNT(year) AS num_games
FROM game_sales AS s
JOIN game_reviews AS r
ON s.name = r.name
GROUP BY year
HAVING COUNT(s.name) > 4
ORDER BY avg_user_score DESC;

--9. Years that both players and critics loved
SELECT csmt.year
FROM top_critic_scores_more_than_four_games AS csmt
INNER JOIN top_user_scores_more_than_four_games AS usmt
ON csmt.year = usmt.year;

--10. Sales in the best video game years
SELECT
	s.year,
	SUM(total_shipped) AS total_games_sold
FROM game_sales AS s
WHERE year IN (
SELECT csmt.year
FROM top_critic_scores_more_than_four_games AS csmt
INNER JOIN top_user_scores_more_than_four_games AS usmt
ON csmt.year = usmt.year)
GROUP BY s.year
ORDER BY total_games_sold DESC;