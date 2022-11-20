MetaData for each scripts of each subparts of the project and results files.

QUALITY CONTROL :
Authors : Goué Nadia Origin : Nadia Goué shared scripts for the project, copy from the server to the server several times between October 25 and November 18 on 2022

Scripts :

scripts/atac_qc_init.slurm : Initial quality control
scripts/atac_trim.slurm : Trimming of each 12 samples
scripts/atac_qc_post.slurm : Post trimming quality control

MAPPING :
Authors : Goué Nadia Origin : Nadia Goué shared scripts for the project, copy from the server to the server several times between October 25 and November 18 on 2022

Scripts :

scripts/atac_bowtie2.slurm : 6 paired and already trimmed samples aligned on Mus musculus GRCm39 reference genome Version : Bowtie2/2.3.4.3, gcc/4.8.4, samtools/1.3

DEEPTOOLS :
Deeptools manual : https://deeptools.readthedocs.io/en/develop/ Authors : Seguineau Pauline Zonon Aristides 
Inputs :BAM files produced by Bowtie2

Scripts :

scripts/deeptool_multisum.slurm
scripts/deeptools_coverage.slurm
scripts/deeptools_correlation.slurm

MACS2 :
MACS manual : https://pypi.org/project/MACS2 Authors : Seguineau Pauline Zonon Aristides 

Scripts :

script_macs2.slurm
