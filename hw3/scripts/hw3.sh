#HW 3
#Monica Ly

##########
# Part 1: group statistics
cd masks
# Create group mask
3dmask_tool -input full_mask*+tlrc.HEAD -frac 1.0 -prefix group_mask
cd ../betas
3dinfo -label stats.sub-01_REML+tlrc
3dttest++ -mask ../masks/group_mask+tlrc -prefix words -setA 'stats*+tlrc.HEAD['Words#0_Coef']'
3dcopy ~/abin/MNI_avg152T1+tlrc .
3dAttribute -all words+tlrc > words_output.txt

###########
# Part 2: cluster correction
#Calculate average smoothness
for f in ../blurs/blur*.1D; do
	1d_tool.py -infile $f -select_rows 5 -write - >> ../blurs/blurs.acf.1D
done
1dsum -mean ../blurs/blurs.acf.1D > ../blurs/blurs_mean.1D
#0.823891 4.19962 14.369 10.4995 

#Simulate for number of clusters that would arise randomly
3dClustSim -mask ../masks/group_mask+tlrc -acf `1dcat ../blurs/blurs_mean.1D[0:2]` \
-both \
-pthr .001 \
-athr .05 \
-iter 5000 \
-prefix cluster \
-cmd refit.cmd
#Smallest cluster size: 18 (NN3_2sided)

3dcalc -a words+tlrc -b ../masks/group_mask+tlrc -expr 'a*b' -prefix words_masked
3dmerge -1zscore -prefix words_z words_masked+tlrc
3dclust -1Dformat -prefix words_clustered -savemask words_clustermask -inmask -1noneg -NN3 18 words_z+tlrc >> cluster_report.txt
#-1noneg looking for only positive clusters

#read output of 3dclust (cluster_report.txt) into clustertable_extract.py to get pretty tables
chmod 755 ../scripts/clustertable_extract.py
../scripts/clustertable_extract.py --clusterfile cluster_report.txt
#should output results_table.txt

############
# Part 3: FDR Correction
3dFDR -input words+tlrc[1] -prefix words_FDR
3dcalc -a words_FDR+tlrc -b ../masks/group_mask+tlrc -expr 'a*b' -prefix words_FDR_masked
3dmerge -1zscore -prefix words_FDR_z words_FDR_masked+tlrc
3dclust -1Dformat -prefix words_FDR_clustered -savemask words_FDR_clustermask -inmask -1noneg -NN3 18 words_FDR_z+tlrc >> cluster_FDR_report.txt
../scripts/clustertable_extract.py --clusterfile cluster_FDR_report.txt