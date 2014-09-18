import csv
d = []
with open('train/X_train.txt') as csvfile:
  reader = csv.reader(csvfile, delimiter=' ')
  d2 = csvfile.readlines()
  d3 = [r.split(' ') for r in d2]
  d = [row for row in reader]

print(d)

