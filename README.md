# hackathon-db-app


https://help.heroku.com/KTXB2SJT/how-do-i-copy-a-csv-file-into-a-postgres-table  
Generated data is copied into database:  
\copy Participants FROM resources/Participants.csv WITH (FORMAT CSV);  
\copy Judges FROM resources/Judges.csv WITH (FORMAT CSV);  
\copy Events FROM resources/Events.csv WITH (FORMAT CSV);  
\copy Prizes FROM resources/Prizes.csv WITH (FORMAT CSV);  
\copy Projects FROM resources/Projects.csv WITH (FORMAT CSV);  
\copy Workshops FROM resources/Workshops.csv WITH (FORMAT CSV);  
\copy WorkedOn FROM resources/WorkedOn.csv WITH (FORMAT CSV);  
\copy Visited FROM resources/Visited.csv WITH (FORMAT CSV);  
\copy Reviewed FROM resources/Reviewed.csv WITH (FORMAT CSV);  
\copy AwardedAt FROM resources/AwardedAt.csv WITH (FORMAT CSV);    

Note:
TRUNCATE awardedat, events, judges, participants, prizes, projects, reviewed, visited, workedon, workshops;  
can be used if data is refreshed.

\copy Participants FROM C:\Users\Gage\Desktop\csv/Participants.csv WITH (FORMAT CSV);  
\copy Judges FROM C:\Users\Gage\Desktop\csv/Judges.csv WITH (FORMAT CSV);  
\copy Events FROM C:\Users\Gage\Desktop\csv/Events.csv WITH (FORMAT CSV);  
\copy Prizes FROM C:\Users\Gage\Desktop\csv/Prizes.csv WITH (FORMAT CSV);  
\copy Projects FROM C:\Users\Gage\Desktop\csv/Projects.csv WITH (FORMAT CSV);  
\copy Workshops FROM C:\Users\Gage\Desktop\csv/Workshops.csv WITH (FORMAT CSV);  
\copy WorkedOn FROM C:\Users\Gage\Desktop\csv/WorkedOn.csv WITH (FORMAT CSV);  
\copy Visited FROM C:\Users\Gage\Desktop\csv/Visited.csv WITH (FORMAT CSV);  
\copy Reviewed FROM C:\Users\Gage\Desktop\csv/Reviewed.csv WITH (FORMAT CSV);  
\copy AwardedAt FROM C:\Users\Gage\Desktop\csv/AwardedAt.csv WITH (FORMAT CSV);    


