#!/Users/monica/anaconda/bin/python
import re
import sys

### CONSTRUCT TIMING FILE FOR - 
#'landmark stimuli with responses vs. only detection stimuli with responses'

#make blank lists for storing times 
landmark_timing=[]
detection_timing=[]

#Condition names
landmark=['Correct_Task','Incorrect_Task']
detection=['Response_Control']

#Open event file
with open(sys.argv[1], 'r') as text:
		trials=text.read()

#Look for event onset and trial type
n=re.compile(r"^(\d+.\d+)\t\d\t\d.\d\t(\w+)",re.MULTILINE)
matches=n.finditer(trials)

#Match trial type to conditions of interest
for m in matches:
	if m.groups()[1] in landmark:
		landmark_timing.append(m.groups()[0])
	elif m.groups()[1] in detection:
		detection_timing.append(m.groups()[0])

#Convert list into tab-delimited string
landmark_timing = '\t'.join(landmark_timing)
detection_timing = '\t'.join(detection_timing)

#Write landmark timing file
l = open('landmark_times.1D','w+')
l.write(landmark_timing)
l.close()

#Write detection timing file
d = open('detection_times.1D','w+')
d.write(detection_timing)
d.close()