import os
from data_classes import *

# Set up resources directory
path = './resources/'
if not os.path.exists(path):
    os.makedirs(path)

# Parameters
test_data = True
if test_data:
    shrinkFactor = 100
else:
    shrinkFactor = 1

num_events = 200 // shrinkFactor # >100 table
num_participants = 4000 // shrinkFactor # >1000 table
num_judges = num_events * 5
num_projects = num_participants // 2 # >1000 table
num_workshops = num_events * 4

# Set up Events relation
with open(path + 'Events.csv', 'w') as file:
    for i in range(num_events):
        file.write(Events(i).to_string())

# Set up Participants relation
with open(path + 'Participants.csv', 'w') as file:
    for _ in range(num_participants):
        file.write(Participant().to_string())

# Set up Judges relation
with open(path + 'Judges.csv', 'w') as file:
    for i in range(num_judges):
        file.write(Judge(i).to_string())

# Set up Prizes relation
with open(path + 'Prizes.csv', 'w') as file:
    file.write(Prizes())

# Set up Projects relation
with open(path + 'Projects.csv', 'w') as file:
    for i in range(num_projects):
        file.write(Projects().to_string())

# Set up Workshops relation
with open(path + 'Workshops.csv', 'w') as file:
    for i in range(num_workshops):
        file.write(WorkShops(i).to_string())

# Set up WorkedOn relation
with open(path + 'WorkedOn.csv', 'w') as file:
    file.write(WorkedOn())

# Set up Visited relation
with open(path + 'Visited.csv', 'w') as file:
    file.write(Visited())

# Set up Reviewed relation
with open(path + 'Reviewed.csv', 'w') as file:
    file.write(Reviewed(num_judges))

# Set up AwardedAt Relation
with open(path + 'AwardedAt.csv', 'w') as file:
    file.write(AwardedAt())
