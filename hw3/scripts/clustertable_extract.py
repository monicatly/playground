#!/Users/monica/anaconda/bin/python
import argparse
import pandas as pd

parser=argparse.ArgumentParser()
parser.add_argument('--clusterfile',action='store',type=str,help='Cluster Report file')
args=parser.parse_args()

#read in output of 3dclust
raw=pd.read_table(args.clusterfile,skiprows=10,sep='\s{2,}')
#keep only rows with data
data=raw.drop(raw.index[[0,3,4]])
#keep only columsn of interest
table=data[['#Volume','Max Int','MI RL','MI AP','MI IS']]
#rename first column head
table=table.rename(columns={'#Volume':'k (Voxels)', 'Max Int':'Z','MI RL':'x', 'MI AP':'y', 'MI IS':'z'})
table.append

table.to_csv('results_table.txt',sep='\t')
with open('results_table.txt','a+') as f:
	f.write('Z is z-score of peak voxel. XYZ Coordinates are for peak voxel, in TLRC space (in mm)')
