import names
from string import ascii_letters
import random

# https://pynative.com/python-generate-random-string/#h-how-to-create-a-random-string-in-python
def random_string():
    return ''.join(random.choice(ascii_letters) for i in range(10))

def random_date():
    return str(random.randint(1950, 2025)).zfill(4) + '-' + str(random.randint(1, 12)).zfill(2) + '-' + str(random.randint(1, 29)).zfill(2)

# superkeys
emails = {}
links = {}
events = set()
workshops = set()
event2workshop = {}

# Value Options
majors = [
    "Computer Science",
    "Software Engineering",
    "Electrical Engineering",
    "Mechanical Engineering",
    "Civil Engineering",
    "Data Science",
    "Business",
    "Graphic Design",
    "Mathematics",
    "Physics",
    "Biomedical Engineering",
    "Economics",
    "Chemistry",
    "Communications",
    "Philosophy",
    "Statistics",
    "Education",
]
classifications = ['freshman', 'sophomore', 'junior', 'senior']
fields = [
    "Machine Learning",
    "Artificial Intelligence",
    "Computer Vision",
    "Natural Language Processing",
    "Data Science",
    "Blockchain",
    "Cybersecurity",
    "Augmented Reality",
    "Virtual Reality",
    "Web Development",
    "Mobile App Development",
    "Game Development",
    "Robotics",
    "Cloud Computing",
    "FinTech",
    "HealthTech",
    "EdTech",
]
universities = [
    "Texas A&M University",
    "Tulane Univeristy",
    "Harvard University",
    "Stanford University",
    "Massachusetts Institute of Technology",
    "Carnegie Mellon University",
    "University of Cambridge",
    "University of Oxford",
    "California Institute of Technology",
    "Princeton University",
    "University of Chicago",
    "Columbia University",
    "University of Toronto",
    "University of Michigan",
    "Yale University",
    "University of Washington",
    "University of Illinois Urbana-Champaign",
    "Georgia Institute of Technology"
]
durations = [24, 48, 72, 168]
sponsors = [
    "American Airlines",
    "Google",
    "Microsoft",
    "Amazon",
    "Facebook",
    "Apple",
    "IBM",
    "Intel",
    "NVIDIA",
    "Oracle",
    "Spotify",
    "Salesforce",
    "Red Hat",
    "Twitter",
    "Slack",
    "GitHub",
    "Stripe",
    "Atlassian",
    "LinkedIn",
    "Adobe"
]

class Events:
    def __init__(self, id):
        self.id = id
        name = names.get_full_name()
        host = random.choice(universities)
        event_date = random_date()
        key = name + host + event_date

        if (key in events):
            name = names.get_full_name()
            host = random.choice(universities)
            event_date = random_date()       
            key = name + host + event_date
        events.add(key)     

        self.name = names.get_full_name()
        self.host = random.choice(universities)
        self.event_date = random_date()
        self.duration = random.choice(durations)

    def to_string(self):
        return f'{self.id},{self.name},{self.host},"{self.event_date}",{self.duration}\n'

class Participant:
    def __init__(self):
        email = random_string()
        while (email in emails):
            email = random_string()
        emails[email] = []

        self.email = email + '@email.com'
        self.name = names.get_full_name()
        self.major = random.choice(majors)
        self.classification = random.choice(classifications)

    def to_string(self):
        return f'{self.email},{self.name},{self.major},{self.classification}\n'

class Judge:
    def __init__(self, id):
        self.id = id
        self.name = names.get_full_name()
        self.field = random.choice(fields)

    def to_string(self):
        return f'{self.id},{self.name},{self.field}\n'

# Generate all possible prizes. Each placement has set amount regardless of sponsor
placements = 10
def Prizes():

    rolling_str = ''
    id = 0
    for placement in range(1, placements + 1):
        for sponsor in sponsors:
            rolling_str += f'{id},{placement},{1000 // placement},{sponsor}\n' # Possibly very slow
            id += 1

    return rolling_str

class Projects:
    def __init__(self):
        link = random_string()
        while (link in links):
            link = random_string()
        event_id = random.randint(0, len(events)-1)
        links[link] = event_id

        self.link = link + ".com"
        self.field = random.choice(fields)
        self.name = random_string()
        self.description = self.name + ": " + self.field + " Project"
        self.event_id = event_id

    def to_string(self):
        return f'{self.link},{self.name},{self.field},{self.description},{self.event_id}\n'

class WorkShops:
    def __init__(self, id):
        self.id = id

        name = random_string()
        host = names.get_full_name()
        key = name + host
        while (key in workshops):
            name = random_string()
            host = names.get_full_name()       
            key = name + host
        workshops.add(key)
        event_id = random.randint(0, len(events)-1)
        if event_id not in event2workshop:
            event2workshop[event_id] = []
        event2workshop[event_id].append(id)

        self.name = name
        self.host = host
        self.field = random.choice(fields)
        self.event_id = event_id

    def to_string(self):
        return f'{self.id},{self.name},{self.host},{self.field},{self.event_id}\n'

def WorkedOn():
    email_list = list(emails.keys()) # Values are with empty []
    link_list = list(links.keys()) # Values are event_id

    rolling_str = ''
    link_list_index = 0
    for email in email_list:
        num_projects = random.randint(1, 15)

        for _ in range(num_projects):
            link = link_list[link_list_index % len(link_list)]
            event = links[link]
            link_list_index += 1

            if (event in emails[email]):
                break

            else:
                emails[email].append(event)
                rolling_str += f'{email},{link}\n'

    return rolling_str

def Visited():
    rolling_str = ''
    for email in emails.keys(): 
        for event in emails[email]:
            num_workshops = random.randint(0, len(event2workshop[event])-1)

            for workshop in event2workshop[event][:num_workshops]:
                rolling_str += f'{email},{workshop}\n'

    return rolling_str


def Reviewed(num_judges):
    rolling_str = ''
    for link in links.keys():
        num_reviews = random.randint(1, max(num_judges, num_judges // 100))

        judges = set()
        for _ in range(num_reviews):
            judges.add(random.randint(1, num_judges-1))

        for judge in judges:
            rolling_str += f'{link},{judge},{random.randint(0, 100)}\n'

    return rolling_str

def AwardedAt():
    rolling_str = ''
    for event_id in range(len(events)):
        for placement in range(placements):
            prize_id = placement * len(sponsors) + random.randint(0, len(sponsors)-1)
            rolling_str += f'{event_id},{prize_id}\n'

    return rolling_str