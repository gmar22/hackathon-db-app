/* Entities */
CREATE TABLE Participants (
    email CHAR(30) PRIMARY KEY,
    name CHAR(30) NOT NULL,
    major CHAR(30), --Participant not necessarily a student
    classification CHAR(10)
);

CREATE TABLE Judges(
    id INT PRIMARY KEY,
    name CHAR(30),
    field CHAR(50)
);

CREATE TABLE Events(
    id INT PRIMARY KEY,
    name CHAR(50) NOT NULL,
    host CHAR(50) NOT NULL,
    event_date date NOT NULL,
    duration int NOT NULL --hours 
        CHECK (duration >= 0)
);

CREATE TABLE Prizes(
    id INT PRIMARY KEY,
    placement int NOT NULL
        CHECK (placement > 0),
    amount int
        DEFAULT 0
        CHECK(amount >= 0), --dollars
    sponsor CHAR(50)
);

CREATE TABLE Projects (
    link CHAR(50) PRIMARY KEY,
    name CHAR(50), --Not all attributes would necessarily be required by an event for submission
    field CHAR(50),
    description CHAR(200),
    event_id INT NOT NULL REFERENCES Events(id)
);

CREATE TABLE Workshops(
    id INT PRIMARY KEY,
    name CHAR(50),
    host CHAR(30),
    field CHAR(50) NOT NULL, 
    event_id INT NOT NULL REFERENCES Events(id)
);

/* Relationships */
-- Participants to Projects (many to many)
CREATE TABLE WorkedOn( 
    email CHAR(30),
    link CHAR(50),
    PRIMARY KEY(email, link),
    FOREIGN KEY(email) 
        REFERENCES Participants(email)
        ON DELETE CASCADE,
    FOREIGN KEY(link) 
        REFERENCES Projects(link)

);

-- Participants to Workshops (many to many)
CREATE TABLE Visited(
    email CHAR(30),
    workshop_id INT,
    PRIMARY KEY(email, workshop_id),
    FOREIGN KEY(email) 
        REFERENCES Participants(email)
        ON DELETE CASCADE,
    FOREIGN KEY(workshop_id) REFERENCES Workshops(id)
);

-- Projects to Judges (many to many)
CREATE TABLE Reviewed(
    link CHAR(50),
    judge_id INT,
    score INT NOT NULL,
    PRIMARY KEY(link, judge_id),
    FOREIGN KEY(link) 
        REFERENCES Projects(link)
        ON DELETE CASCADE,
    FOREIGN KEY(judge_id) REFERENCES Judges(id)
);

-- Prizes to Events (many to many)
CREATE TABLE AwardedAt(
    prize_id INT,
    event_id INT,
    PRIMARY KEY(prize_id, event_id),
    FOREIGN KEY(prize_id) REFERENCES Prizes(id),
    FOREIGN KEY(event_id) REFERENCES Events(id)
);

/* Views */
CREATE VIEW Scores AS 
    SELECT Projects.link AS link, name, field, description, event_id, AVG(score) AS score
        FROM 
            Projects, 
            Reviewed
        WHERE Projects.link = Reviewed.link
        GROUP BY Projects.link;

CREATE VIEW Placements AS
        SELECT * FROM (
            SELECT event_id, link, name, field, description,
                RANK() OVER (
                        PARTITION BY event_id 
                        ORDER BY 
                            event_id, 
                            SCORE DESC
                        ) AS placement
                FROM Scores
        )
        WHERE placement <= 5;

/* Triggers */
CREATE FUNCTION delete_project() RETURNS TRIGGER AS $$
BEGIN

    IF NOT EXISTS (SELECT link FROM WorkedOn WHERE OLD.link = link) THEN
        DELETE FROM Projects WHERE link=OLD.link;
    END IF;

    RETURN OLD; -- Necessary but meaningless

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER no_valid_participants
    AFTER DELETE ON WorkedOn
    FOR EACH ROW       
    EXECUTE FUNCTION delete_project();