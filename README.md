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

NPM can be used to build locally
-npm install
-set up .env variables (DATABASE_URL)
-npm start

However, the interface is hosted:
-HEROKU LINK: https://hackathon-db-app-cffcc58e38a3.herokuapp.com/

