#/bin/bash
### HW 4

#Set up HPC
#Log into HPC
# ssh mtl15001@login.storrs.hpc.uconn.edu

# 1. Clone container repository to a directory on HPC
# Log into HPC
git clone https://github.com/bircibrain/containers
# 2. Run mk_skel.sh hw 4 to create a skeleton directory at /scratch/mtl15001/hw4
cd containers/example_sbatch/
./mk_skel.sh hw4
# 3. Place your processing script in /scratch/mtl15001/hw4/scripts
cp batch_gpu.sh /scratch/mtl15001/hw4/scripts/batch_hw4_gpu.sh
# 4. Modify batch_gpu.sh to run your SLURM job. 
sbatch batch_hw4_gpu.sh
#within batch_hw4_gpu.sh, run the job script usinb burc_wrapper.sh script.sh