const express = require('express');
const path = require('path');
const app = express();
const { Client } = require('pg');
require('dotenv').config();
const { option1, option2, option3, option4a, option4b, option5 } = require('./queries')

// Set up connection
const client = new Client({
    connectionString: process.env.URL,
    ssl: {
        rejectUnauthorized: false
    }
})
client.connect();

// Middleware
app.use(express.static(path.join(__dirname, '../static')));
app.use(express.json())

// Queries
app.get('/query-option1', async (req, res)=> {
    try {
        const result = await client.query(option1);
        res.json(result.rows)
    }
    catch(e) {
        console.log(e);
    }
})

app.get('/query-option2', async (req, res)=> {
    try {
        const result = await client.query(option2);
        res.json(result.rows)
    }
    catch(e) {
        console.log(e);
    }
})

app.get('/query-option3', async (req, res)=> {
    try {
        const result = await client.query(option3);
        res.json(result.rows)
    }
    catch(e) {
        console.log(e);
    }
})

app.get('/query-option4a', async (req, res)=> {
    try {
        const result = await client.query(option4a);
        res.json(result.rows)
    }
    catch(e) {
        console.log(e);
    }
})

app.get('/query-option4b', async (req, res)=> {
    try {
        const result = await client.query(option4b);
        res.json(result.rows)
    }
    catch(e) {
        console.log(e);
    }
})

app.get('/query-option5', async (req, res)=> {
    try {
        const { email } = req.query;
        const result = await client.query(option5, [email]);
        res.json(result.rows)
    }
    catch(e) {
        console.log(e);
    }
})

app.get('/query-projects', async (req, res)=> {
    try {
        const result = await client.query(`SELECT link AS Project_key FROM Projects;`);
        res.json(result.rows)
    }
    catch(e) {
        console.log(e);
    }
})

app.get('/query-participants', async (req, res)=> {
    try {
        const result = await client.query(`SELECT email AS Participant_key FROM Participants;`);
        res.json(result.rows)
    }
    catch(e) {
        console.log(e);
    }
})

app.get('/query-project', async (req, res)=> {
    try {
        const { link } = req.query;
        const result = await client.query(`SELECT email FROM WorkedOn WHERE link=$1;`, [link]);
        res.json(result.rows)
    }
    catch(e) {
        console.log(e);
    }
})

app.get('/query-removed-participants', async (req, res)=> {
    try {
        const { condition } = req.query;
        const sql = `SELECT email AS removed_participant FROM Participants WHERE ${condition};`;
        const result = await client.query(sql);
        res.json(result.rows)
    }
    catch(e) {
        console.log(e);
    }
})

app.get('/query-removed-projects', async (req, res)=> {
    try {
        const { people } = req.query;

        const sql = `
            WITH Formatted AS (
                SELECT string_agg(email, ',' ORDER BY email) AS people, link
                    FROM WorkedOn
                    GROUP BY link
            )
            SELECT link AS removed_project
                FROM Formatted
                WHERE people = '${people}';
        `

        const result = await client.query(sql);
        res.json(result.rows)
    }
    catch(e) {
        console.log(e);
    }
})

// Default route (html)
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, '../static', 'index.html'));
  });


const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});


