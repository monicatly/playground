#/bin/bash

#If doing this in hpc
cd /bind/data_in
for direction in LR RL
do
	dwi=100206_3T_DWI_dir95_$direction
	#Cut off the top of the head volume to make the z dimension even
	fslroi ${dwi}.nii.gz /bind/data/${dwi}_even.nii.gz 0 -1 0 -1 0 110 0 -1
	#echo $dwi
	for index in 0 16 32 48 64 80
	do
		#echo b0_${direction}_${index}.nii.gz
		fslroi /bind/data/${dwi}_even.nii.gz /bind/data/b0_${direction}_${index}.nii.gz $index 1
	done
	fslmerge -t /bind/data/b0merged_${direction} /bind/data/b0_${direction}_*.nii.gz
done
fslmerge -t /bind/data/b0_all /bind/data/b0merged_*.nii.gz

#If doing this on local computer
#run from hw4 directory
# cd data_in
# for direction in LR RL
# do
# 	dwi=100206_3T_DWI_dir95_$direction.nii.gz
# 	#Cut off the top of the head volume to make the z dimension even
# 	fslroi ${dwi}.nii.gz ../preproc/${dwi}_even.nii.gz 0 -1 0 -1 0 110 0 -1
# 	#echo $dwi
# 	for index in 0 16 32 48 64 80
# 	do
# 		#echo b0_${direction}_${index}.nii.gz
# 		fslroi ../preproc/${dwi}_even.nii.gz ../preproc/b0_${direction}_${index}.nii.gz $index 1
# 	done
# 	fslmerge -t ../preproc/b0merged_${direction} ../preproc/b0_${direction}_*.nii.gz
# done
# fslmerge -t ../preproc/b0_all ../preproc/b0merged_*.nii.gz
