--**Info About Developers**

-- 1.
-- Which developer published and developed the most games in-house?
-- Answer: Konami: 295, Capcom: 235, Sega: 149, Ubisoft: 126, Namco: 104
SELECT
	developer,
	publisher,
	COUNT(DISTINCT name) AS num_games
FROM Game_Sales_Data$
WHERE developer = publisher AND
publisher = developer
GROUP BY developer, publisher
ORDER BY num_games DESC

-- 2.
-- Which developer has the highest average user score across their games?
-- Answer: Rockstar San Diego: 10, Rockstar Vancouver/Mad Doc Software: 10, SIE Santa Monica Studio: 10, Capcom Production Studio 1: 9.85, Sega WOW Overworks: 9.8
SELECT
	developer,
	ROUND(AVG(user_score), 2) AS avg_user_score
FROM Game_Sales_Data$
GROUP BY developer
ORDER BY avg_user_score DESC

-- 3.
-- Which developer has the highest average critic score across their games?
-- Answer: Mojang AB: 10, Rockstar Games: 9.75, SIE Santa Monica Studio: 9.7, Flagship Co., Ltd. / Nintendo EAD: 9.6, 2K Australia / 2K Boston: 9.6
SELECT
	developer,
	ROUND(AVG(critic_score), 2) AS avg_critic_score
FROM Game_Sales_Data$
GROUP BY developer
ORDER BY avg_critic_score DESC

-- 4. ***
-- Which developer has the highest average critic and user score and what years were they active?
-- Answer: SIE Santa Monica Studio, Rockstar Leeds/North, 2K Australia / 2K Boston, 2K Boston / 2K Australia / 2K Marin, Bungie Studios
SELECT
	developer,
	ROUND(AVG(critic_score), 2) as avg_critic_score,
	ROUND(AVG(user_score), 2) as avg_user_score,
	ISNULL(
		ISNULL(
			ROUND(AVG(critic_score)+AVG(user_score), 2), ROUND(AVG(critic_score), 2)),
			ROUND(AVG(user_score), 2)) as combined_critic_user_score,
	CONCAT(MIN(year), ' - ', MAX(year)) as active_years,
	MAX(year) - MIN(year) as years_active
FROM Game_Sales_Data$
GROUP BY developer
ORDER BY ROUND(AVG(critic_score)+AVG(user_score), 2) DESC

-- 5.
-- Which developer created the most games?
-- Answer: Konami: 318, Capcom: 249, Bandai Namco Games: 215, Sega: 156, Ubisoft: 130
SELECT
	developer,
	COUNT(DISTINCT name) AS num_games
FROM Game_Sales_Data$
WHERE developer != 'Unknown'
GROUP BY developer
ORDER BY num_games DESC

-- 6. ***
-- Which developer has the highest number of sales?
-- Answer: Nintendo EAD: 677.54, EA Canada: 275.56, Game Freak: 271, Capcom: 205.33, EA Tiburon: 188.4
SELECT
	developer,
	ROUND(SUM(total_shipped), 2) AS developer_sales_count
FROM Game_Sales_Data$
GROUP BY developer
ORDER BY developer_sales_count DESC

--**Info About Platforms**

-- 7. ***
-- Which platform had the most amount of games?
-- Answer: DS: 2247, PS2: 2207, PC: 1910, PS3: 1365, Wii: 1351
SELECT
	platform,
	COUNT(name) AS num_games
FROM Game_Sales_Data$
GROUP BY platform
ORDER BY num_games DESC

-- 8.
-- Which platform had the most amount of developers?
-- Answer: PC: 912, DS: 736, PS2: 675, Wii: 554, Xbox360: 510
-- Conclusion: PC as a platform has the most number developers releasing games.
-- This is no surprise considering games are developed on PC and PC is open source.
SELECT
	platform,
	COUNT(DISTINCT developer) AS num_developer
FROM Game_Sales_Data$
GROUP BY platform
ORDER BY num_developer DESC

-- 9.
-- Which platform has the most number of years active?
-- Answer: PC: 31 years, GB: 14 years, Xbox360: 14 years, 2600: 14 years, Wii: 14 years
-- Conclusion: PC is the oldest platform and is still relevant today. All other gaming consoles have a lifespan between 1 - 14 years.
SELECT
	DISTINCT platform,
	COUNT(DISTINCT year) AS years_active,
	CONCAT(MIN(year), ' - ', MAX(year)) AS active_years
FROM Game_Sales_Data$
GROUP BY platform
ORDER BY years_active DESC

-- 10. ***
-- Which platform had the most sales?
-- Answer: PS2: 1257.71, PC: 1107.02, X360: 982.82, PS3: 965.52, Wii: 897.23
-- Conclusion: Sony (Playstation series), Microsoft (Xbox series and PC), and Nintendo are the biggest companies that create gaming platforms.
--	The top 15 places for most games sold by platform is split between these three companies.
SELECT
	platform,
	ROUND(SUM(total_shipped), 2) as games_shipped_per_platform
FROM Game_Sales_Data$
GROUP BY platform
ORDER BY games_shipped_per_platform DESC

--**Info About Games**

-- 11. ***
-- Which games were the top five best sellers?
-- Answer: Wii Sports, Super Mario Bros., Counter-Strike: Global Offensive, Mario Kart Wii, PLAYERUNKNOWN'S BATTLEGROUNDS
-- Conclusion: Nintendo is a big developer and publisher on the video games market space
SELECT TOP 10 *
FROM Game_Sales_Data$
ORDER BY total_shipped DESC

-- 12. ***
-- Which years had the highest average critic score?
-- Answer: 1984, 1992, 1982, 1994, 1990, 1991, 2020, 1993, 2019, 1989, 1981, 1985
-- Conclusion: Critics showed a preference towards both the 80's and 90's evenly
SELECT
	year,
	ROUND(AVG(critic_score), 2) AS avg_critic_score
FROM Game_Sales_Data$
GROUP BY year
ORDER BY avg_critic_score DESC

-- 13. ***
-- Which years had the highest average user score?
-- Answer: 1993, 1990, 1997, 1999, 1991, 1998, 1987, 1994
-- Conclusion: Users liked the 90's the most
SELECT
	year,
	ROUND(AVG(user_score), 2) AS avg_user_score
FROM Game_Sales_Data$
GROUP BY year
ORDER BY avg_user_score DESC

-- 14. ***
-- Which years had the highest average critic and average user score?
-- Answer: 1990, 1993, 1994, 1992, 1991
-- Conclusion: Both users and critics agree that the early 90's is the Golden Age of Video Games
SELECT
	year,
	ROUND(AVG(critic_score), 2) as avg_critic_score,
	ROUND(AVG(user_score), 2) as avg_user_score,
	ROUND(AVG(critic_score)+AVG(user_score), 2) as combined_critic_user_score
FROM Game_Sales_Data$
GROUP BY year
ORDER BY ROUND(AVG(critic_score)+AVG(user_score), 2) DESC

-- 15. ***
-- Which year had the most amount of games with high critic score (8+) and user score (8+)
-- Answer: 2018: 47, 2017: 46, 2014: 41, 2016: 39, 2013 & 2015: 32
SELECT
	year,
	COUNT(name) as num_games_over_8
FROM Game_Sales_Data$
WHERE user_score >= 8
AND critic_score >= 8
GROUP BY year
ORDER BY num_games_over_8 DESC

-- 16. ***
-- Which years had the highest sales?
-- Answer: 2008, 2009, 2010, 2007, 2011, 2006
-- Conclusion: Sales were the best between 2006-2011
SELECT
	year,
	ROUND(SUM(total_shipped), 2) AS year_total_shipped
FROM Game_Sales_Data$
GROUP BY year
ORDER BY year_total_shipped DESC

-- 17. ***
-- Which years had the highest number of games?
-- Answer: 2009, 2008, 2010, 2011, 2007
-- Conclusion: Late 2000's and early 2010's was the peak of new releases
SELECT
	year,
	COUNT(name) as num_games
FROM Game_Sales_Data$
GROUP BY year
ORDER BY num_games DESC