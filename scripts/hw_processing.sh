#run to generate afni_proc.py script
./cmd.ap.sub_03

#manually alter proc.sub_03 to correct tshift and others

#run proc.sub_03 for test and retest files

#in each results folder
#1. threshold statistics
3dmerge -1zscore -1thresh 1.96 -1noneg -prefix stat.thresh 'stats.sub_03+tlrc[17]'

#2. calculate mask of intersection
#navigate back out to sub-03 folder
3dmask_tool -input group.*/subj.sub_03/sub_03.results/mask_group+tlrc.HEAD -frac 1.0 -prefix mask

#in each results folder
#3. binarize thresholded images
3dcalc -a ./group.test/subj.sub_03/sub_03.results/stat.thresh+tlrc -prefix stat.test.bin -expr 'astep(a,.1)'
#in retest folder
3dcalc -a ./group.retest/subj.sub_03/sub_03.results/stat.thresh+tlrc -prefix stat.retest.bin -expr 'astep(a,.1)'

#4. calculate dice coefficient
3ddot -mask mask+tlrc -dodice stat.test.bin+tlrc stat.retest.bin+tlrc
#found a Dice coefficient of 0.197834 - not so great

