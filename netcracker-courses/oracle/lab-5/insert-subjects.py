with open('list-of-subjects.md') as f:
    for line in f:
        if line[:-1] != '' and line[0] != '#': 
            print(f'INSERT INTO subjects (name) VALUES (\'{line[:-1]}\');')
    # print(f.readlines())
