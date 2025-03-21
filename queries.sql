/* Biggest Winner by Cash */
WITH ProjectWinnings AS (
    SELECT link, amount
        FROM AwardedAt
        INNER JOIN Prizes
            ON AwardedAt.prize_id = Prizes.id
        NATURAL JOIN Placements 
)
SELECT email, name, amount
    FROM Participants
    NATURAL JOIN (
        SELECT email, COALESCE(SUM(amount), 0) AS amount
            FROM WorkedOn
            LEFT JOIN ProjectWinnings
                ON WorkedOn.link = ProjectWinnings.link
            GROUP BY email
    )    
    ORDER BY amount DESC;
  
/* Judge Bias */
WITH 
    SameField AS (
        SELECT judge_id, AVG(score) AS score
        FROM 
            Judges,
            Projects,
            Reviewed
        WHERE 
            Judges.id = Reviewed.judge_id and 
            Reviewed.link = Projects.link and 
            Judges.field = Projects.field
        GROUP BY judge_id
    ), 
    DiffField AS (
        SELECT judge_id, AVG(score) AS score
        FROM 
            Judges,
            Projects,
            Reviewed
        WHERE 
            Judges.id = Reviewed.judge_id and 
            Reviewed.link = Projects.link and 
            Judges.field <> Projects.field
        GROUP BY judge_id
    ),
    JudgeBiases AS (
        SELECT SameField.judge_id, SameField.score AS SameFieldScore, DiffField.score AS DiffFieldScore
        FROM 
            SameField, 
            DiffField
        WHERE SameField.judge_id = DiffField.judge_id
    )
SELECT 
    COUNT(
        CASE
            WHEN SameFieldScore > DiffFieldScore THEN 'biased' -- returns NULL otherwise and is not counted
        END
    ) AS biased_judges, 
    COUNT(judge_id) AS total_judges, 
    AVG(SameFieldScore) AS avg_same, 
    AVG(DiffFieldScore) as avg_diff
    FROM JudgeBiases;

/* Major Combinations */
--Average (a)
SELECT combo, cast(placed as float) / cast(submitted as float) * 100 AS percent_placed, placed, submitted
    FROM (SELECT combo, COUNT(placement) AS placed, COUNT(Combos.link) AS submitted
        FROM
            (SELECT string_agg(DISTINCT major, ', ' ORDER BY major) AS combo, WorkedOn.link
                    FROM 
                        Participants,
                        WorkedOn
                    WHERE Participants.email = WorkedOn.email
                    GROUP BY WorkedOn.link
            ) AS Combos 
            LEFT JOIN Placements ON Placements.link = Combos.link
        GROUP BY combo
    )
    ORDER BY percent_placed DESC, placed DESC;

/* Workshop efficacy */ -- TODO add field specific
--a
WITH 
    ExtendedWorkedOn AS (
        SELECT WorkedOn.email, P1.event_id, SUM(placement) AS placement, COUNT(workshop_id) AS visits
            FROM WorkedOn --email, link
                INNER JOIN (SELECT event_id, link FROM Projects) AS P1 ON WorkedOn.link = P1.link --event_id
                LEFT JOIN (SELECT link, placement FROM Placements) AS P2 ON WorkedOn.link = P2.link --placement (May be NULL)
                LEFT JOIN (
                    SELECT email, event_id, Workshops.id AS workshop_id --JOIN on email, event_id, add workshop_id
                    FROM 
                        Visited,
                        Workshops
                    WHERE Visited.workshop_id = Workshops.id
                ) AS P3 ON WorkedOn.email = P3.email AND P1.event_id = P3.event_id
            GROUP BY (WorkedOn.email, P1.event_id)
    )
SELECT Placed.event_id, AVG(Placed.avg_visits) AS placed_avg, AVG(NotPlaced.avg_visits) AS not_placed_avg
    FROM 
        (SELECT event_id, AVG(visits) AS avg_visits
            FROM ExtendedWorkedOn
            WHERE placement IS NOT NULL
            GROUP BY event_id
        ) AS Placed, 
        (SELECT event_id, AVG(visits) AS avg_visits
            FROM ExtendedWorkedOn
            WHERE placement IS NULL
            GROUP BY event_id
        ) AS NotPlaced
        WHERE Placed.event_id = NotPlaced.event_id
    GROUP BY Placed.event_id;

--b
WITH 
    ExtendedWorkedOn AS (
        SELECT WorkedOn.email, P1.event_id, SUM(placement) AS placement, COUNT(workshop_id) AS visits
            FROM WorkedOn --email, link
                INNER JOIN (SELECT event_id, link FROM Projects) AS P1 ON WorkedOn.link = P1.link --event_id
                LEFT JOIN (SELECT link, placement FROM Placements) AS P2 ON WorkedOn.link = P2.link --placement (May be NULL)
                LEFT JOIN (
                    SELECT email, event_id, Workshops.id AS workshop_id --JOIN on email, event_id, add workshop_id
                    FROM 
                        Visited,
                        Workshops
                    WHERE Visited.workshop_id = Workshops.id
                ) AS P3 ON WorkedOn.email = P3.email AND P1.event_id = P3.event_id
            GROUP BY (WorkedOn.email, P1.event_id)
    )
SELECT AVG(placed_avg) AS placed_avg, AVG(not_placed_avg) AS not_placed_avg FROM (
SELECT AVG(Placed.avg_visits) AS placed_avg, AVG(NotPlaced.avg_visits) AS not_placed_avg
    FROM 
        (SELECT event_id, AVG(visits) AS avg_visits
            FROM ExtendedWorkedOn
            WHERE placement IS NOT NULL
            GROUP BY event_id
        ) AS Placed, 
        (SELECT event_id, AVG(visits) AS avg_visits
            FROM ExtendedWorkedOn
            WHERE placement IS NULL
            GROUP BY event_id
        ) AS NotPlaced
        WHERE Placed.event_id = NotPlaced.event_id);
    
/* Remove Cheaters */
--Handled through trigger and cascading deletes
DELETE FROM Participants
    WHERE email=...;
