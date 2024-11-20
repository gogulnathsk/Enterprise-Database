/* === SP-1 Update Movie Revenue === */
BEGIN
    DELIMITER //
	CREATE PROCEDURE UpdateMovieRevenue(
		IN p_MovieID INT,
		IN p_NewRevenue INT
	)
	BEGIN
		UPDATE Movie 
		SET RevenueGenerated = p_NewRevenue 
		WHERE MovieID = p_MovieID;
	END //
	DELIMITER ;

	-- Example Call
	CALL UpdateMovieRevenue(1, 900000000);
END //

/* === SP-2 Retrieve Movies with High Ratings === */
BEGIN
    DELIMITER //
	CREATE PROCEDURE GetHighRatedMovies(
		IN p_MinRating DECIMAL(3,2)
	)
	BEGIN
		SELECT M.Title, AVG(CAST(R.ReviewerRating AS DECIMAL(3,2))) AS AvgRating
		FROM Movie M
		JOIN Review R ON M.MovieID = R.MovieID
		GROUP BY M.MovieID
		HAVING AvgRating >= p_MinRating;
	END //
	DELIMITER ;

	-- Example Call
	CALL GetHighRatedMovies(4.5);
END //

/* === SP-3 Insert New Movie Record === */
BEGIN
	DELIMITER //
	CREATE PROCEDURE InsertNewMovie(
		IN p_Title VARCHAR(255),
		IN p_Genre VARCHAR(50),
		IN p_StartDate DATE,
		IN p_ReleaseDate DATE,
		IN p_Duration INT,
		IN p_ProductionCost INT,
		IN p_RevenueGenerated INT,
		IN p_LanguagesReleased VARCHAR(255),
		IN p_MaleProtagonist INT,
		IN p_FemaleProtagonist INT,
		IN p_Antagonist INT,
		IN p_DirectorID INT,
		IN p_AssistantDirectorID INT,
		IN p_ProducerID INT,
		IN p_DopID INT
	)
	BEGIN
		INSERT INTO Movie (Title, Genre, StartDate, ReleaseDate, Duration, ProductionCost, RevenueGenerated, LanguagesReleased, MaleProtagonist, FemaleProtagonist, Antagonist, DirectorID, AssistantDirectorID, ProducerID, DopID)
		VALUES (p_Title, p_Genre, p_StartDate, p_ReleaseDate, p_Duration, p_ProductionCost, p_RevenueGenerated, p_LanguagesReleased, p_MaleProtagonist, p_FemaleProtagonist, p_Antagonist, p_DirectorID, p_AssistantDirectorID, p_ProducerID, p_DopID);
	END //
	DELIMITER ;

-- Example Call
CALL InsertNewMovie('Inception', 'Sci-Fi', '2009-01-01', '2010-07-16', 148, 160000000, 829895144, 'English, Japanese, French', 1, 2, 3, 4, 5, 6, 7);
END //

/* === SP-4 Insert New Actor === */	
BEGIN
	DELIMITER //
	CREATE PROCEDURE InsertNewActor(
		IN p_FirstName VARCHAR(50),
		IN p_LastName VARCHAR(50),
		IN p_BirthDate DATE,
		IN p_Nationality VARCHAR(50),
		IN p_Gender VARCHAR(10),
		IN p_AgentCompany VARCHAR(255),
		IN p_AgentContactEmail VARCHAR(255)
	)
	BEGIN
		INSERT INTO Actor (FirstName, LastName, BirthDate, Nationality, Gender, AgentCompany, AgentContactEmail)
		VALUES (p_FirstName, p_LastName, p_BirthDate, p_Nationality, p_Gender, p_AgentCompany, p_AgentContactEmail);
	END //
	DELIMITER ;

	-- Example Call
	CALL InsertNewActor('Leonardo', 'DiCaprio', '1974-11-11', 'American', 'Male', 'Creative Artists Agency', 'leo@caa.com');
END //

/* === SP-5 Get Total Revenue by Genre === */
BEGIN
	DELIMITER //
	CREATE PROCEDURE GetTotalRevenueByGenre(
		IN p_Genre VARCHAR(50)
	)
	BEGIN
		SELECT Genre, SUM(RevenueGenerated) AS TotalRevenue
		FROM Movie
		WHERE Genre = p_Genre
		GROUP BY Genre;
	END //
	DELIMITER ;

	-- Example Call
	CALL GetTotalRevenueByGenre('Sci-Fi');
END //

/* === SP-6 Assign Award to Movie === */
BEGIN
	DELIMITER //
	CREATE PROCEDURE AssignAwardToMovie(
		IN p_MovieID INT,
		IN p_AwardID INT,
		IN p_AwardDate DATE
	)
	BEGIN
		INSERT INTO Movie_Awards (MovieID, AwardID, AwardDate)
		VALUES (p_MovieID, p_AwardID, p_AwardDate);
	END //
	DELIMITER ;

	-- Example Call
	CALL AssignAwardToMovie(1, 5, '2023-03-15');
END //

/* === SP-7 Update Actor Agent Contact === */
BEGIN
    DELIMITER //
	CREATE PROCEDURE UpdateActorAgentContact(
		IN p_ActorID INT,
		IN p_NewAgentEmail VARCHAR(255)
	)
	BEGIN
		UPDATE Actor 
		SET AgentContactEmail = p_NewAgentEmail 
		WHERE ActorID = p_ActorID;
	END //
	DELIMITER ;

	-- Example Call
	CALL UpdateActorAgentContact(3, 'newagent@example.com');
END//

/* === SP-8 Retrieve All Award-Winning Movies === */
BEGIN
	DELIMITER //
	CREATE PROCEDURE GetAwardWinningMovies()
	BEGIN
		SELECT M.Title, A.AwardName, MA.AwardDate
		FROM Movie M
		JOIN Movie_Awards MA ON M.MovieID = MA.MovieID
		JOIN Award A ON MA.AwardID = A.AwardID
		ORDER BY MA.AwardDate DESC;
	END //
	DELIMITER ;

	-- Example Call
	CALL GetAwardWinningMovies();
END //

/* === SP-9 Insert Review for Movie === */
BEGIN
	DELIMITER //
	CREATE PROCEDURE AddMovieReview(
		IN p_MovieID INT,
		IN p_ReviewerID INT,
		IN p_ReviewerRating VARCHAR(50),
		IN p_ReviewerDescription VARCHAR(255)
	)
	BEGIN
		INSERT INTO Review (MovieID, ReviewerID, ReviewerRating, ReviewerDescription)
		VALUES (p_MovieID, p_ReviewerID, p_ReviewerRating, p_ReviewerDescription);
	END //
	DELIMITER ;



	-- Example Call
	CALL AddMovieReview(1, 2, '4.5', 'Amazing movie with great visuals and story!');
END //

/* === SP-10 List Crew Members by Job Role === */
BEGIN
	DELIMITER //
	CREATE PROCEDURE GetCrewByRole(
		IN p_JobRole VARCHAR(255)
	)
	BEGIN
		SELECT CrewID, FirstName, LastName, JobRole
		FROM Crew
		WHERE JobRole = p_JobRole;
	END //
	DELIMITER ;

	-- Example Call
	CALL GetCrewByRole('Director');
END //

/* === TRIGGER- 1 Prevent Negative Revenue on Movie Insert or Update === */
BEGIN
	DELIMITER //
	CREATE TRIGGER PreventNegativeRevenue
	BEFORE INSERT ON Movie
	FOR EACH ROW
	BEGIN
		IF NEW.RevenueGenerated < 0 THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RevenueGenerated cannot be negative.';
		END IF;
	END //
	DELIMITER ;
END //

/* === TRIGGER- 2 Automatically Set Award Date to Today if Not Provided === */
BEGIN
	DELIMITER //
	CREATE TRIGGER SetDefaultAwardDate
	BEFORE INSERT ON Movie_Awards
	FOR EACH ROW
	BEGIN
		IF NEW.AwardDate IS NULL THEN
			SET NEW.AwardDate = CURDATE();
		END IF;
	END //
	DELIMITER ;
END //

/* === TRIGGER- 3 Prevent Duplicate Awards for the Same Movie on the Same Date === */
BEGIN
    DELIMITER //
	CREATE TRIGGER PreventDuplicateAwards
	BEFORE INSERT ON Movie_Awards
	FOR EACH ROW
	BEGIN
		DECLARE duplicate_count INT;
		
		SELECT COUNT(*) INTO duplicate_count
		FROM Movie_Awards
		WHERE MovieID = NEW.MovieID AND AwardID = NEW.AwardID AND AwardDate = NEW.AwardDate;
		
		IF duplicate_count > 0 THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This award has already been assigned to the movie on this date.';
		END IF;
	END //
	DELIMITER ;
END //

/* === TRIGGER- 4 Automatically Insert New Review for Movies with No Review === */
BEGIN
	DELIMITER //
	CREATE TRIGGER InsertDefaultReview
	AFTER INSERT ON Movie
	FOR EACH ROW
	BEGIN
		DECLARE review_count INT;
		
		SELECT COUNT(*) INTO review_count
		FROM Review
		WHERE MovieID = NEW.MovieID;
		
		IF review_count = 0 THEN
			INSERT INTO Review (MovieID, ReviewerID, ReviewerRating, ReviewerDescription)
			VALUES (NEW.MovieID, 1, '0', 'Default review - no user reviews yet.');
		END IF;
	END //
	DELIMITER ;
END //

/* === TRIGGER- 5 Automatically Update LastModified Date on Movie Update === */
BEGIN
	ALTER TABLE Movie ADD COLUMN LastModified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

	DELIMITER //
	CREATE TRIGGER UpdateMovieLastModified
	BEFORE UPDATE ON Movie
	FOR EACH ROW
	BEGIN
		SET NEW.LastModified = NOW();
	END //
	DELIMITER ;
END //

DELIMITER ;

