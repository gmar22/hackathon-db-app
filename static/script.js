const description1 = `Inputs: None,
    Outputs: email, name, amount

    This query finds the highest total dollar amounts won by individual hackers across all events.
`

const description2 = `Inputs: None,
    Outputs: biased_judges, total_judges, avg_same, avg_diff

    This query determines whether judges are biased toward projects within their field: 
        -biased_judges is how many judges have a higher average score when reviewing projects in their field
        -total_judges is how many judges have reviewed a project in their field
        -avg_same is the average score given by a judge when the project is in their field
        -avg_diff is the average score given by a judge when the project is not in their field
`

const description3 = `Inputs: None,
    Outputs: combo, percent_placed, placed, submitted

    This query determines the most effective major combinations across all projects and all hackathons:
        -combo is the set of majors on the relevant projects
        -percent_placed is the percentage of relevant projects that won a prize
        -placed is the number of times the combo has won a prize
        -submitted is the number of times the combo has submitted a project
`
const description4 = `Inputs: Average,
    Outputs: event_id (optional), placed_avg, not_placed_avg

    This query looks the efficacy of visiting workshops.
        -event_id is the event that the visits are averaged across
        -placed_avg is the average number of workshops winning participants visited 
        -not_placed_avg is the average number of workshops non-winning participants visited
        
    -Average sets output to be average of these metrics (removing event_id)
`
const description5 = `Inputs: Removal Type, Key
    Outputs: removed_participant, removed_project (if applicable)

    This query allows for cheaters and their results to be fully removed from the database:
        -Removal Type inputs whether an entire team (project) was cheating or an individual
        -Key controls the participant(s) to be removed (either an email or link)
`

const buttons = document.getElementById('options').childNodes;
const form = document.getElementById('input');
const description = document.getElementById('description');
const output = document.getElementById('output')
const submit = document.getElementById('submit');

let selection = ''

buttons.forEach(button => {
    button.addEventListener('click', async ()=>{
        if (selection === button.textContent) {
            return
        }

        selection = button.textContent;
        form.innerHTML = '';

        if (selection == 'Option1') {
            form.textContent = "No Further Input Needed!";
            description.textContent = description1;
        }
        else if (selection == 'Option2') {
            description.textContent = description2;
            form.textContent = "No Further Input Needed!";
        }
        else if (selection == 'Option3') {
            form.textContent = "No Further Input Needed!";
            description.textContent = description3;

        }
        else if (selection == 'Option4') {
            description.textContent = description4;

            const checkbox_label = document.createElement("label");
            checkbox_label.textContent = 'Average';
            const checkbox = document.createElement("input");
            checkbox.setAttribute('type', 'checkbox');
            checkbox.setAttribute('id', 'input1');
            checkbox_label.appendChild(checkbox);
            form.appendChild(checkbox_label);
        }
        else if (selection == 'Option5') {
            description.textContent = description5;

            const select_label = document.createElement("label");
            select_label.textContent = 'Removal Type: '
            const select = document.createElement("select");
            select.setAttribute('id', 'input1');
            const option1 = document.createElement("option");
            option1.setAttribute('value', 'project');
            option1.textContent = "project";
            select.appendChild(option1);
            const option2 = document.createElement("option");
            option2.setAttribute('value', 'participant');
            option2.textContent = "participant";
            select.appendChild(option2);
            select_label.appendChild(select);
            form.appendChild(select_label);

            form.append(document.createElement('br'));

            const input_label = document.createElement("label");
            input_label.textContent = 'Key: '
            const input = document.createElement("input");
            input.setAttribute('id', 'input2');
            input_label.appendChild(input);
            form.appendChild(input_label);

            form.append(document.createElement('br'));

            const helper = document.createElement("button");
            helper.textContent = 'helper (generates list of options)';
            helper.setAttribute('style', 'margin-left: 1vw');
            form.appendChild(helper);
            helper.addEventListener('click', async ()=> {

                const input1 = document.getElementById('input1').value;

                output.innerHTML = '';
                if (input1 === 'project') {
                    const response = await fetch('/query-projects');
                    const data = await response.json();
                    format_json(data); 
                }
                else if (input1 === 'participant') {
                    const response = await fetch('/query-participants');
                    const data = await response.json();
                    format_json(data); 
                }
 
            });
        }
    });
});

submit.addEventListener('click', async ()=>  {

    submit.disabled = true;

    output.innerHTML = '';
    if (selection == 'Option1') {
        const response = await fetch('/query-option1');
        const data = await response.json();
        format_json(data);
    }
    else if (selection == 'Option2') {
        const response = await fetch('/query-option2');
        const data = await response.json();
        format_json(data);
    }
    else if (selection == 'Option3') {
        const response = await fetch('/query-option3');
        const data = await response.json();
        format_json(data);
    }
    else if (selection == 'Option4') {

        const input1 = document.getElementById('input1').checked;
        if (input1) { // Average
            const response = await fetch('/query-option4b');
            const data = await response.json();
            format_json(data);
        }
        else { // Total
            const response = await fetch('/query-option4a');
            const data = await response.json();
            format_json(data);
        }
    }
    else if (selection == 'Option5')  {

        const input1 = document.getElementById('input1').value;
        const input2 = document.getElementById('input2').value;

        // Check if key filled
        if (input2 === '') {
            description.textContent += '\nPlease input a key\n';

        }
        else {

            if (input1 === 'project') {

                // Get project and check key validity
                let response = await fetch(`/query-project?link=${input2}`);
                let data = await response.json();
                if (data.length == 0) {
                    description.textContent += '\nPlease enter valid key\n';

                }
                else {

                    // Get related participants
                    let rolling = ''
                    let arr = []
                    data.forEach(obj => {
                        rolling += `email='${obj.email.trim()}' OR `
                        arr.push(obj.email.trim());
                    });
                    response = await fetch(`/query-removed-participants?condition=${rolling.substring(0, rolling.length-4)}`);
                    data = await response.json();
                    format_json(data);
                    console.log('here')

                    // Get removed projects
                    arr.sort((a, b) => a.localeCompare(b, "en", { sensitivity: "case" }));                    
                    rolling = '';
                    arr.forEach(email => {
                        rolling += `${email},`
                    });
                    response = await fetch(`/query-removed-projects?people=${rolling.substring(0, rolling.length-1)}`);
                    data = await response.json();
                    format_json(data);
                    console.log('b')
                    // Remove participants and projects
                    arr.forEach(async email => {
                        response = await fetch(`/query-option5?email=${email}`);
                    });
                }
                
            }
            else if (input1 === 'participant') {

                // Get relevant person and check key validity
                let response = await fetch(`/query-removed-participants?condition=${`email='${input2}'`}`);
                let data = await response.json();
                if (data.length == 0) {
                    description.textContent += '\nPlease enter valid key\n';
                }
                else {
                    format_json(data);

                    // Check if projects removed
                    response = await fetch(`/query-removed-projects?people=${input2}`);
                    data = await response.json();
                    if (data.length != 0) {
                        format_json(data);
                    }

                    // Remove participants and projects
                    response = await fetch(`/query-option5?email=${input2}`);
                }
            }
        }
    }
    else {
        description.textContent += '\nPlease select option\n';

    }

    submit.disabled = false;
})

function format_json(data) {
    keys = Object.keys(data[0]);

    // Column Titles
    let row = document.createElement("tr");
    keys.forEach(key => {
        const cell = document.createElement("th");
        cell.textContent = key;
        row.appendChild(cell);
    });
    output.appendChild(row);

    // Data
    data.forEach(obj => {
        row = document.createElement("tr");
        keys.forEach(key => {
            const cell = document.createElement("td");
            cell.textContent = obj[key];
            row.appendChild(cell);
        });   
        output.appendChild(row);
    });
}

