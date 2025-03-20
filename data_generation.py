import os

# Set up resources directory
path = './resources/'
if not os.path.exists(path):
    os.makedirs(path)


num_participants = 10
num_judges = 10
num_events = 10
num_prizes = 10
num_projects = 10
num_workshops = 10

# ?
num_workedOn = 10
num_Visited = 10
num_Reviewed = 10
num_AwardedAt = 10

# Set up Participants relation
with open(path + 'Participants.csv', 'w') as file:
    email = 'email'
    name = 'name'
    major = 'major'
    classification = 'classification'
    file.write(f'{email},{name},{major},{classification}')

# Set up Judges relation
with open(path + 'Judges.csv', 'w') as file:
    id = 0
    name = 'name'
    field = 'field'
    file.write(f'{id},{name},{field}')

# Set up Events relation
with open(path + 'Events.csv', 'w') as file:
    id = 0
    name = 'name'
    host = 'host'
    event_date = '1963-11-22'
    duration = 24
    file.write(f'{id},{name},{host},"{event_date}",{duration}')

# Set up Prizes relation
with open(path + 'Prizes.csv', 'w') as file:
    id = 0
    placement = 1
    amount = 0
    sponsor = 'sponsor'
    file.write(f'{id},{placement},{amount},{sponsor}')

# Set up Projects relation
with open(path + 'Projects.csv', 'w') as file:
    link = 'link'
    name = 'name'
    field = 'field'
    description = 'description'
    file.write(f'{link},{name},{field},{description}',)

# Set up Workshops relation
with open(path + 'Workshops.csv', 'w') as file:
    id = 0
    name = 'name'
    host = 'host'
    field = 'field'
    file.write(f'{id},{name},{host},{field}')

# Set up WorkedOn relation
with open(path + 'WorkedOn.csv', 'w') as file:
    email = 'email'
    link = 'link'
    file.write(f'{email},{link}')

# Set up Visited relation
with open(path + 'Visited.csv', 'w') as file:
    email = 'email'
    workshop_id = 0
    file.write(f'{email},{workshop_id}')

# Set up Reviewed relation
with open(path + 'Review.csv', 'w') as file:
    link = 'link'
    judge_id = 0
    score = 0
    file.write(f'{link},{judge_id},{score}')

# Set up AwardedAt Relation
with open(path + 'AwardedAt.csv', 'w') as file:
    event_id = 0
    prize_id = 0
    file.write(f'{event_id},{prize_id}')
