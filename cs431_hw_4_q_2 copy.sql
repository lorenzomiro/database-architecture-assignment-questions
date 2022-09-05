/*Name: Lorenzo Miro San Diego
Filename: cs431_hw_4_q_2.sql
Assignment #, Question #: Assignment 4, Question 2 
*/

-- This is a script that creates and calls a stored procedure named must_watch_movies.

DROP PROCEDURE IF EXISTS must_watch_movies;

DELIMITER //
CREATE PROCEDURE must_watch_movies()
BEGIN
	-- initialize necessary variables
    DECLARE movie_name VARCHAR(100);
    DECLARE distributor VARCHAR(100);
    DECLARE release_year YEAR;
    DECLARE movies_to_watch VARCHAR(1000) DEFAULT ""; -- create empty string for movies to be watched
	DECLARE recorded INT DEFAULT FALSE; -- bool that will be used when loop is ran to add movies
    
    -- create cursor find_high_gross to find movies w/2 million+ gross
    DECLARE find_high_gross CURSOR FOR 
		SELECT title, Distributor, YEAR(release_date)
		FROM movies
		WHERE gross > 2.00
		ORDER BY title;
    
    -- create an error handler if the movie cursor runs into an invalid row, where recorded boolean will be set to true to include incomplete entries
    DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET recorded = TRUE;
	OPEN find_high_gross;
    
    -- search through movies in a while loop
    WHILE recorded = FALSE
		-- get column values from each row using fetch, and store them in movie_name, distributor, and release_year
		DO FETCH find_high_gross INTO movie_name, distributor, release_year;
		-- combine all data into one string
		SET movies_to_watch = CONCAT(movies_to_watch, QUOTE(movie_name), ",", QUOTE(distributor),",", QUOTE(release_year), "|");
		END WHILE;
	CLOSE find_high_gross;
    -- print out output of movies_to_watch
    SELECT movies_to_watch AS "Must Watch Movies";
    
END //
DELIMITER ;

-- Run must_watch_movies function
CALL must_watch_movies();

-- SELECT * FROM movies;