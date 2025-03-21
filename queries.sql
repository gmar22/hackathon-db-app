/* Biggest Winner by Cash */ --TODO: simplify
SELECT email, name, amount
    FROM 
        Participants,
        NATURAL JOIN (
            SELECT email, SUM(amount) AS amount
                FROM 
                    WorkedOn,        
                    (SELECT link, amount
                        FROM Placements
                        NATURAL JOIN (
                            SELECT event_id, placement, amount
                                FROM AwardedAt
                                INNER JOIN Prizes 
                                    ON AwardedAt.prize_id = Prizes.id
                        )
                    ) AS Winnings
                WHERE WorkedOn.link = Winnings.link
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
SELECT combo, cast(placed as float) / cast(submitted as float) * 100 AS percent_placed, placed, submitted
    FROM (SELECT combo, COUNT(placement) AS placed, COUNT(Placements.link) AS submitted
        FROM
            (SELECT string_agg(major, ', ' ORDER BY major) AS combo, WorkedOn.link
                    FROM 
                        Participants,
                        WorkedOn
                    WHERE Participants.email = WorkedOn.email
                    GROUP BY WorkedOn.link
            ) AS Combos 
            LEFT JOIN Placements ON Placements.link = Combos.link
        GROUP BY combo
    )
    ORDER BY percent_placed;

/* Workshop efficacy */ -- TODO add field specific
WITH 
    ExtendedWorkedOn AS (
        SELECT email, event_id, placement, COUNT(workshop_id) AS visits
            FROM WorkedOn 
                LEFT JOIN Placements ON WorkedOn.link = Placements.link
                NATURAL JOIN (
                    SELECT email, event_id, Workshops.id AS workshop_id
                    FROM 
                        Visited,
                        Workshops
                    WHERE Visited.workshop_id = Workshops.id
                )
            GROUP BY (email, event_id, placement)
    )
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
        WHERE Placed.event_id = NotPlaced.event_id
    GROUP BY Placed.event_id;

/* Remove Cheaters */
--Handled through trigger and cascading deletes
DELETE FROM Participants
    WHERE email='KJwKXbXAVR@email.com';


/* 
1. Remove cheaters:
-If a project is found to be cheating (outside of the database). That cheaters are removed from the database (and their projects too if there are no other participants attributed to it).

2. Whether judges rate projects within their field higher or lower

3. Biggest winner in terms of placements and/or cash.

4. Most common major combinations or project field on winning teams.

5. Average workshop visits of winning participants vs non winning participants AmwFVXjvvb.com jlDiWUVHsV.com
 */
