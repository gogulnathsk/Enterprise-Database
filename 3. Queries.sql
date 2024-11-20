-- 1.	Retrieve the top 10 highest-grossing movies with their directors and main cast.
SELECT 
    m.Title AS "Movie Title",
    m.RevenueGenerated AS "Revenue Generated",
    CONCAT(d.FirstName, ' ', d.LastName) AS "Director Name",
    CONCAT(maleProtag.FirstName, ' ', maleProtag.LastName) AS                     
"Male Protagonist Name",
    CONCAT(femaleProtag.FirstName, ' ', femaleProtag.LastName) AS "Female Protagonist Name",
    CONCAT(antagonist.FirstName, ' ', antagonist.LastName) AS "Antagonist Name",
    a.AwardName AS "Award Name",
    a.Category AS "Award Category",
    ma.AwardDate AS "Award Date"
FROM 
    Movie m
JOIN 
    Director d ON m.DirectorID = d.DirectorID
JOIN 
    Actor maleProtag ON m.MaleProtagonist = maleProtag.ActorID
JOIN 
    Actor femaleProtag ON m.FemaleProtagonist = femaleProtag.ActorID
JOIN 
    Actor antagonist ON m.Antagonist = antagonist.ActorID
LEFT JOIN 
    Movie_Awards ma ON m.MovieID = ma.MovieID
LEFT JOIN 
    Award a ON ma.AwardID = a.AwardID
ORDER BY 
    m.RevenueGenerated DESC
LIMIT 10;


-- 2.	List all movies with awards won, including the award category and date.
SELECT 
    m.Title AS "Movie Title",
    CONCAT(d.FirstName, ' ', d.LastName) AS "Director Name",
    CONCAT(maleProtag.FirstName, ' ', maleProtag.LastName) AS "Male Protagonist Name",
    CONCAT(femaleProtag.FirstName, ' ', femaleProtag.LastName) AS "Female Protagonist Name",
    CONCAT(antagonist.FirstName, ' ', antagonist.LastName) AS "Antagonist Name",
    a.AwardName AS "Award Name",
    a.Category AS "Award Category",
    ma.AwardDate AS "Award Date"
FROM 
    Movie m
JOIN 
    Director d ON m.DirectorID = d.DirectorID
JOIN 
    Actor maleProtag ON m.MaleProtagonist = maleProtag.ActorID
JOIN 
    Actor femaleProtag ON m.FemaleProtagonist = femaleProtag.ActorID
JOIN 
    Actor antagonist ON m.Antagonist = antagonist.ActorID
JOIN 
    Movie_Awards ma ON m.MovieID = ma.MovieID
JOIN 
    Award a ON ma.AwardID = a.AwardID
ORDER BY 
    ma.AwardDate DESC;
    
-- 3.	Find actors who starred in movies across at least three different genres.
SELECT 
    CONCAT(a.FirstName, ' ', a.LastName) AS "Actor Name",
    COUNT(DISTINCT m.Genre) AS "Genre Count"
FROM 
    Actor a
JOIN 
    Movie m ON a.ActorID = m.MaleProtagonist 
            OR a.ActorID = m.FemaleProtagonist 
            OR a.ActorID = m.Antagonist
GROUP BY 
    a.ActorID, a.FirstName, a.LastName
HAVING 
    COUNT(DISTINCT m.Genre) >= 3;
    
-- 4.	Identify directors who have directed movies in multiple languages.
SELECT 
    CONCAT(d.FirstName, ' ', d.LastName) AS "Director Name",
    COUNT(DISTINCT m.LanguagesReleased) AS "Languages Count"
FROM 
    Director d
JOIN 
    Movie m ON d.DirectorID = m.DirectorID
GROUP BY 
    d.DirectorID, d.FirstName, d.LastName
HAVING 
    COUNT(DISTINCT m.LanguagesReleased) > 1;

-- 5.	List movies that feature both a male and female protagonist, along with their genres.
SELECT 
    m.Title AS "Movie Title",
    m.Genre AS "Genre",
    CONCAT(maleProtag.FirstName, ' ', maleProtag.LastName) AS "Male Protagonist Name",
    CONCAT(femaleProtag.FirstName, ' ', femaleProtag.LastName) AS "Female Protagonist Name"
FROM 
    Movie m
JOIN 
    Actor maleProtag ON m.MaleProtagonist = maleProtag.ActorID
JOIN 
    Actor femaleProtag ON m.FemaleProtagonist = femaleProtag.ActorID
WHERE 
    m.MaleProtagonist IS NOT NULL 
    AND m.FemaleProtagonist IS NOT NULL;
-- 6.	Retrieve movies with production costs exceeding $60 million and their revenue generated.
SELECT 
    m.Title AS "Movie Title",
    m.ProductionCost AS "Production Cost",
    m.RevenueGenerated AS "Revenue Generated"
FROM 
    Movie m
WHERE 
    m.ProductionCost > 60000000
ORDER BY 
    m.RevenueGenerated DESC;


-- 7.	Find all movies reviewed by a specific reviewer, including review ratings and comments. Using first name (here “Peter”)
SELECT 
    m.Title AS "Movie Title",
    r.ReviewerRating AS "Reviewer Rating",
    r.ReviewerDescription AS "Review Comment"
FROM 
    Movie m
JOIN 
    Review r ON m.MovieID = r.MovieID
JOIN 
    Reviewer rev ON r.ReviewerID = rev.ReviewerID
WHERE 
    rev.ReviewerFirstName = 'Peter';  


-- 8.	Show actors who have worked with the same director more than 2 movies.
SELECT 
    CONCAT(a.FirstName, ' ', a.LastName) AS "Actor Name",
    CONCAT(d.FirstName, ' ', d.LastName) AS "Director Name",
    COUNT(m.MovieID) AS "Movies Together"
FROM 
    Actor a
JOIN 
    Movie m ON a.ActorID = m.MaleProtagonist 
            OR a.ActorID = m.FemaleProtagonist 
            OR a.ActorID = m.Antagonist
JOIN 
    Director d ON m.DirectorID = d.DirectorID
GROUP BY 
    a.ActorID, d.DirectorID, a.FirstName, a.LastName, d.FirstName, d.LastName
HAVING 
    COUNT(m.MovieID) > 2;


-- 9.	List movies where the antagonist's nationality differs from the protagonists.
SELECT 
    m.Title AS "Movie Title",
    CONCAT(maleProtag.FirstName, ' ', maleProtag.LastName) AS "Male Protagonist",
    maleProtag.Nationality AS "Male Protagonist Nationality",
    CONCAT(femaleProtag.FirstName, ' ', femaleProtag.LastName) AS "Female Protagonist",
    femaleProtag.Nationality AS "Female Protagonist Nationality",
    CONCAT(antagonist.FirstName, ' ', antagonist.LastName) AS "Antagonist",
    antagonist.Nationality AS "Antagonist Nationality"
FROM 
    Movie m
JOIN 
    Actor maleProtag ON m.MaleProtagonist = maleProtag.ActorID
JOIN 
    Actor femaleProtag ON m.FemaleProtagonist = femaleProtag.ActorID
JOIN 
    Actor antagonist ON m.Antagonist = antagonist.ActorID
WHERE 
    (maleProtag.Nationality <> antagonist.Nationality)
    OR (femaleProtag.Nationality <> antagonist.Nationality);



-- 10.	Retrieve the total revenue generated by each genre, sorted by highest revenue.
SELECT 
    m.Genre AS "Genre",
    SUM(m.RevenueGenerated) AS "Total Revenue"
FROM 
    Movie m
GROUP BY 
    m.Genre
ORDER BY 
    "Total Revenue" DESC;


-- 11.	Find producers who produced more than one movie in the same genre.
SELECT 
    CONCAT(p.FirstName, ' ', p.LastName) AS "Producer Name",
    m.Genre AS "Genre",
    COUNT(m.MovieID) AS "Movies Produced"
FROM 
    Producer p
JOIN 
    Movie m ON p.ProducerID = m.ProducerID
GROUP BY 
    p.ProducerID, p.FirstName, p.LastName, m.Genre
HAVING 

    COUNT(m.MovieID) > 1;





-- 12.	Show movies that received an award in the "Best Director" category.
SELECT 
    m.Title AS "Movie Title",
    a.AwardName AS "Award Name",
    a.Category AS "Award Category",
    ma.AwardDate AS "Award Date",
    CONCAT(d.FirstName, ' ', d.LastName) AS "Director Name"
FROM 
    Movie m
JOIN 
    Movie_Awards ma ON m.MovieID = ma.MovieID
JOIN 
    Award a ON ma.AwardID = a.AwardID
JOIN 
    Director d ON m.DirectorID = d.DirectorID
WHERE 
    a.Category = 'Best Director'
ORDER BY 
    ma.AwardDate DESC;

-- 13.	List directors who have worked with the same assistant director on multiple movies.
SELECT 
    CONCAT(d.FirstName, ' ', d.LastName) AS "Director Name",
    CONCAT(ad.FirstName, ' ', ad.LastName) AS "Assistant Director Name",
    COUNT(m.MovieID) AS "Movies Together"
FROM 
    Movie m
JOIN 
    Director d ON m.DirectorID = d.DirectorID
JOIN 
    Director ad ON m.AssistantDirectorID = ad.DirectorID
GROUP BY 
    d.DirectorID, ad.DirectorID, d.FirstName, d.LastName, ad.FirstName, ad.LastName
HAVING 
    COUNT(m.MovieID) > 1;

-- 14.	Retrieve movies where the main protagonist has won at least one acting award.
SELECT 
    m.Title AS "Movie Title",
    CONCAT(maleProtag.FirstName, ' ', maleProtag.LastName) AS "Male Protagonist",
    CONCAT(femaleProtag.FirstName, ' ', femaleProtag.LastName) AS "Female Protagonist",
    a.AwardName AS "Award Name",
    a.Category AS "Award Category",
    ma.AwardDate AS "Award Date"
FROM 
    Movie m
LEFT JOIN 
    Actor maleProtag ON m.MaleProtagonist = maleProtag.ActorID
LEFT JOIN 
    Actor femaleProtag ON m.FemaleProtagonist = femaleProtag.ActorID
JOIN 
    Movie_Awards ma ON m.MovieID = ma.MovieID
JOIN 
    Award a ON ma.AwardID = a.AwardID
WHERE 
    (a.Category = 'Best Actor' AND maleProtag.ActorID IS NOT NULL)
    OR (a.Category = 'Best Actress' AND femaleProtag.ActorID IS NOT NULL)
ORDER BY 
    ma.AwardDate DESC;


-- 15.	Show actors whose age at the time of the movie release was under 30.
SELECT 
    CONCAT(a.FirstName, ' ', a.LastName) AS "Actor Name",
    m.Title AS "Movie Title",
    m.ReleaseDate AS "Release Date",
    a.BirthDate AS "Actor Birth Date",
    TIMESTAMPDIFF(YEAR, a.BirthDate, m.ReleaseDate) AS "Age at Release"
FROM 
    Actor a
JOIN 
    Movie m ON a.ActorID = m.MaleProtagonist 
            OR a.ActorID = m.FemaleProtagonist 
            OR a.ActorID = m.Antagonist
WHERE 
    TIMESTAMPDIFF(YEAR, a.BirthDate, m.ReleaseDate) < 30;



-- 16.	Find all female actors who have worked with at least three different directors.
SELECT 
    CONCAT(a.FirstName, ' ', a.LastName) AS "Actor Name",
    COUNT(DISTINCT m.DirectorID) AS "Different Directors"
FROM 
    Actor a
JOIN 
    Movie m ON a.ActorID = m.FemaleProtagonist
WHERE 
    a.Gender = 'Female'
GROUP BY 
    a.ActorID, a.FirstName, a.LastName
HAVING 
    COUNT(DISTINCT m.DirectorID) >= 3;
 

-- 17.	Retrieve movies with more than five crew members listed in the Crew_Linking table.
SELECT 
    m.Title AS "Movie Title",
    COUNT(cl.CrewID) AS "Crew Members Count"
FROM 
    Movie m
JOIN 
    Crew_Linking cl ON m.MovieID = cl.MovieID
GROUP BY 
    m.MovieID, m.Title
HAVING 
    COUNT(cl.CrewID) > 5;
 
-- 18.	List all movies with awards, grouped by movie and sorted by award date.
SELECT 
    m.Title AS "Movie Title",
    a.AwardName AS "Award Name",
    a.Category AS "Award Category",
    ma.AwardDate AS "Award Date"
FROM 
    Movie m
JOIN 
    Movie_Awards ma ON m.MovieID = ma.MovieID
JOIN 
    Award a ON ma.AwardID = a.AwardID
ORDER BY 
    m.Title, ma.AwardDate;

-- 19.	List the top 5 longest movies with their duration and director names.
SELECT 
    m.Title AS "Movie Title",
    m.Duration AS "Duration (minutes)",
    CONCAT(d.FirstName, ' ', d.LastName) AS "Director Name"
FROM 
    Movie m
JOIN 
    Director d ON m.DirectorID = d.DirectorID
ORDER BY 
    m.Duration DESC
LIMIT 5;
 
-- 20.	Find movies released in the same year as their director's birthday month.
SELECT 
    m.Title AS "Movie Title",
    m.ReleaseDate AS "Release Date",
    CONCAT(d.FirstName, ' ', d.LastName) AS "Director Name",
    d.BirthDate AS "Director Birth Date"
FROM 
    Movie m
JOIN 
    Director d ON m.DirectorID = d.DirectorID
WHERE 
    MONTH(m.ReleaseDate) = MONTH(d.BirthDate);

-- 21.	List all reviews with ratings, filtered by movies with revenue over $400 million.
SELECT 
    r.MovieID AS "Movie ID",
    m.Title AS "Movie Title",
    r.ReviewerRating AS "Reviewer Rating",
    r.ReviewerDescription AS "Review Comment"
FROM 
    Review r
JOIN 
    Movie m ON r.MovieID = m.MovieID
WHERE 
    m.RevenueGenerated > 400000000;

-- 22.	Show movies where the male protagonist and antagonist are of the same nationality.
SELECT 
    m.Title AS "Movie Title",
    CONCAT(maleProtag.FirstName, ' ', maleProtag.LastName) AS "Male Protagonist",
    CONCAT(antagonist.FirstName, ' ', antagonist.LastName) AS "Antagonist",
    maleProtag.Nationality AS "Nationality"
FROM 
    Movie m
JOIN 
    Actor maleProtag ON m.MaleProtagonist = maleProtag.ActorID
JOIN 
    Actor antagonist ON m.Antagonist = antagonist.ActorID
WHERE 
    maleProtag.Nationality = antagonist.Nationality;

-- 23.	List directors who have worked with at least two producers on different movies.
SELECT 
    CONCAT(d.FirstName, ' ', d.LastName) AS "Director Name",
    COUNT(DISTINCT m.ProducerID) AS "Different Producers"
FROM 
    Director d
JOIN 
    Movie m ON d.DirectorID = m.DirectorID
GROUP BY 
    d.DirectorID, d.FirstName, d.LastName
HAVING 
    COUNT(DISTINCT m.ProducerID) >= 3;

-- 24.	Retrieve actors who have starred as both protagonist and antagonist in different movies.
SELECT 
    CONCAT(a.FirstName, ' ', a.LastName) AS "Actor Name"
FROM 
    Actor a
JOIN 
    Movie m1 ON a.ActorID = m1.MaleProtagonist 
              OR a.ActorID = m1.FemaleProtagonist
JOIN 
    Movie m2 ON a.ActorID = m2.Antagonist
WHERE 
    m1.MovieID <> m2.MovieID
GROUP BY 
    a.ActorID, a.FirstName, a.LastName;
 
-- 25.	Show all movies released between two specific years with production costs and revenue.
SELECT 
    m.Title AS "Movie Title",
    m.ReleaseDate AS "Release Date",
    m.ProductionCost AS "Production Cost",
    m.RevenueGenerated AS "Revenue Generated"
FROM 
    Movie m
WHERE 
    YEAR(m.ReleaseDate) BETWEEN 2020 AND 2023; 

-- 26.	Find movies where the duration exceeds the average movie duration.
SELECT 
    m.Title AS "Movie Title",
    m.Duration AS "Duration"
FROM 
    Movie m
WHERE 
    m.Duration > (SELECT AVG(Duration) FROM Movie);

-- 27.	Retrieve all movies with both male and female protagonists, ordered by release date.
SELECT 
    m.Title AS "Movie Title",
    m.ReleaseDate AS "Release Date",
    CONCAT(maleProtag.FirstName, ' ', maleProtag.LastName) AS "Male Protagonist",
    CONCAT(femaleProtag.FirstName, ' ', femaleProtag.LastName) AS "Female Protagonist"
FROM 
    Movie m
JOIN 
    Actor maleProtag ON m.MaleProtagonist = maleProtag.ActorID
JOIN 
    Actor femaleProtag ON m.FemaleProtagonist = femaleProtag.ActorID
WHERE 
    m.MaleProtagonist IS NOT NULL 
    AND m.FemaleProtagonist IS NOT NULL
ORDER BY 
    m.ReleaseDate;

-- 28.	TOP 5 Revenue generated by Female antagonists
SELECT 
    m.Title AS "Movie Title",
    CONCAT(a.FirstName, ' ', a.LastName) AS "Female Antagonist",
    m.RevenueGenerated AS "Revenue Generated",
    m.ProductionCost AS "Production Cost"
FROM 
    Movie m
JOIN 
    Actor a ON m.Antagonist = a.ActorID
LEFT JOIN 
    Review r ON m.MovieID = r.MovieID
WHERE 
    a.Gender = 'Female'
GROUP BY 
    m.MovieID, m.Title, a.FirstName, a.LastName, m.RevenueGenerated, m.ProductionCost
ORDER BY
	m.RevenueGenerated DESC

limit 5;

-- 29.	Show movies where antagoninsts got an award
SELECT 
    m.Title AS "Movie Title",
    CONCAT(a.FirstName, ' ', a.LastName) AS "Antagonist Name",
    a.Gender AS "Antagonist Gender",
    aw.AwardName AS "Award Name",
    aw.Category AS "Award Category",
    ma.AwardDate AS "Award Date"
FROM 
    Movie m
JOIN 
    Actor a ON m.Antagonist = a.ActorID
JOIN 
    Movie_Awards ma ON m.MovieID = ma.MovieID
JOIN 
    Award aw ON ma.AwardID = aw.AwardID
WHERE 
    aw.Category LIKE '%Actor%'  -- Adjust if award categories include specific antagonist awards
ORDER BY 
    ma.AwardDate DESC;

-- 30.	Top 10 Award winning movies with highest revenue
SELECT 
    m.Title AS "Movie Title",
    m.RevenueGenerated AS "Revenue Generated",
    m.ProductionCost AS "Production Cost",
    aw.AwardName AS "Award Name",
    aw.Category AS "Award Category",
    ma.AwardDate AS "Award Date"
FROM 
    Movie m
JOIN 
    Movie_Awards ma ON m.MovieID = ma.MovieID
JOIN 
    Award aw ON ma.AwardID = aw.AwardID
ORDER BY 
    m.RevenueGenerated DESC;




