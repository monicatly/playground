#!/Users/monica/anaconda/bin/python
import re
import sys

### CONSTRUCT TIMING FILE FOR - 
#'landmark stimuli with responses vs. only detection stimuli with responses'

#make blank lists for storing times 
landmark_timing_c=[]
landmark_timing_ic=[]
detection_timing=[]
nr_control_timing=[]
nr_task_timing=[]

#Condition names
landmark_c=['Correct_Task']
landmark_ic=['Incorrect_Task']
detection=['Response_Control']
nr_control=['No_Response_Control']
nr_task=['No_Response_Task']


#Open event file
with open(sys.argv[1], 'r') as text:
		trials=text.read()

#Look for event onset and trial type
n=re.compile(r"^(\d+.\d+)\t\d\t\d.\d\t(\w+)",re.MULTILINE)
matches=n.finditer(trials)

#Match trial type to conditions of interest
for m in matches:
	if m.groups()[1] in landmark_c:
		landmark_timing_c.append(m.groups()[0])
	elif m.groups()[1] in landmark_ic:
		landmark_timing_ic.append(m.groups()[0])
	elif m.groups()[1] in detection:
		detection_timing.append(m.groups()[0])
	elif m.groups()[1] in nr_control:
		nr_control_timing.append(m.groups()[0])
	elif m.groups()[1] in nr_task:
		nr_task_timing.append(m.groups()[0])

#Convert list into tab-delimited string
landmark_timing_c = '\t'.join(landmark_timing_c)
landmark_timing_ic = '\t'.join(landmark_timing_ic)
detection_timing = '\t'.join(detection_timing)
nr_control_timing = '\t'.join(nr_control_timing)
nr_task_timing = '\t'.join(nr_task_timing)

#Write landmark timing file
l = open('landmark_correct_times.1D','w+')
l.write(landmark_timing_c)
l.close()

l2 = open('landmark_incorrect_times.1D','w+')
l2.write(landmark_timing_ic)
l2.close()

#Write detection timing file
d = open('detection_times.1D','w+')
d.write(detection_timing)
d.close()

n = open('nr_control_times.1D','w+')
n.write(nr_control_timing)
n.close()

n2 = open('nr_task_times.1D','w+')
n2.write(nr_task_timing)
n2.close()