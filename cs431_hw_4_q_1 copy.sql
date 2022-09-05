/*Name: Lorenzo Miro San Diego
Filename: cs431_hw_4_q_1.sql
Assignment #, Question #: Assignment 4, Question 1 
*/

-- This is a script that lists the movies whose artists (on screen and offscreen) athat are older than 40.
CREATE OR REPLACE VIEW movies_legendary_technicians AS
	SELECT DISTINCT movie_list.title AS movie,
    CONCAT(ar.first_name, ' ', ar.last_name) AS Techs, 
    YEAR(CURRENT_TIMESTAMP()) - YEAR(ar.birth_date) AS age
FROM movies movie_list
	JOIN movie_cast cast ON movie_list.movie_id = cast.movie_id
    JOIN artists ar ON cast.person_id = ar.artist_id
WHERE YEAR(CURRENT_TIMESTAMP()) - YEAR(ar.birth_date) > 40 -- Get artists older than 40
ORDER BY age, movie DESC;

-- Print the movies_legendary_technicians view
SELECT * FROM movies_legendary_technicians;