cd Documents/ibrain-training/hw2/sub-03/ses-test/func
chmod 755 ../../../playground/scripts/make_timings.py

#run script to make timing files in test sample
../../../playground/scripts/make_timings.py sub-03_ses-test_task-linebisection_events.tsv 
#run timing tool on each file to adjust for dropping the first TR in each run
for f in *.1D
do
	timing_tool.py -timing $f -add_offset -2.5 -write_timing adj_${f}
done

#do the same for the retest sample
cd ../../ses-retest/func
../../../playground/scripts/make_timings.py sub-03_ses-retest_task-linebisection_events.tsv 
for g in *.1D
do
	timing_tool.py -timing $g -add_offset -2.5 -write_timing adj_${g}
done

#run uber_subject.py and set parameters
# change smoothing kernel to 6mm FWHM
# change motion threshold to .5
# check regress motion derivatives
# 
#run to generate afni_proc.py script for test and retest
./cmd.ap.sub_03

#manually alter proc.sub_03 to add -tpattern alt+z to tshift
#-AddEdge -deoblique on -master_tlrc 3 to align
#-bout to stats bucket

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

#for experiment 2, I changed the -1blur_fwhm option in proc.sub_03

