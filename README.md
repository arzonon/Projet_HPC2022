# Projet presentation 

The project consists of re-analyzing, on a UCA Mesocenter computational cluster, the ATAC-seq data produced in the publication: "STATegra, a comprehensive multi-omics dataset of B-cell differentiation in mouse" David Gomez-Cabrero et al. 2019 https://doi.org/10.1038/s41597-019-0202-7.

One of the goals of this study is to identify regions of the genome accessible to transcription as DNA opens and detaches from the nucleosome complex. For this, the analysis was conducted on a mouse B3 cell line. his cell line from the mouse model the pre-B1 stage. After the nuclear translocation of the transcription factor Ikaros, those cells grow to the pre-BII stage. During this stage, the B cells progenitor are subject to a growth arrest and a differentiation. This B3 cell line was transduced by a retroviral pathway with a vector coding for a fusion protein, Ikaros-REt2, which can control nuclear levels of Ikaros after exposition to the Tamoxifen drug.

# Experimental design

Approximately 50,000 cells were collected per sample. 3 biological replicates per sample were performed: Replicate 1, Replicate 2, and Replicate 3. this replicates was performed for the two cellular stages : 0h and 24h post-treatment with tamoxifen. At the end, we have 6 samples (3 replicates for 0h and 3 replicates for 24h).

Samples were sequenced by an Illumina sequencing with Nextera-based sequencing primers. The sequencing was performed in paired-end.

## Data collection 

Datasets were collected from  European Nucleotide Archive (ENA) https://www.ebi.ac.uk/ena on 2021-07-26 by Nadia Goué with enaDataGet tool https://www.ebi.ac.uk/about/news/service-news/new-tools-download-data-ena included in inhouse script ena_array_atac.slurm

### Raw dataset:

SRR4785152  50k-Rep1-0h-sample.0h   GSM2367179  0.7G

SRR4785153  50k-Rep2-0h-sample.0h   GSM2367180  0.7G

SRR4785154  50k-Rep3-0h-sample.0h   GSM2367181  0.7G


SRR4785341  50k-24h-R1-sample.24h.2 GSM2367368  0.6G

SRR4785342  50k-24h-R2-sample.24h.2 GSM2367369  0.7G

SRR4785343  50k-24h-R3-sample.24h.2 GSM2367370  0.6G

# Workflow
## I.Data pre-processing
### Data quality control
To see the quality of the dataset, we perform a quality control. We use the fastqc function for each sequencing data. This step is achieved by the 'atac_qc_init.slurm' script.

### Trimming
The next step is to eliminate the sequencing primers. We use the trimmomatic function on each sequencing data. This step is achievded by the 'atac_trim.slurm' script.

The adapters used for the sequencing are Nextera-based primers collected here : https://github.com/timflutre/trimmomatic/tree/master/adapters/NexteraPE-PE.fa on 2015-03-5 and  the version is v0.33.

### Quality control 
It's necessary to make a second quality control in order to be sure of the quality of the remaining sequences. We will use the fastqc function on the results from the trimming. And this step is achieved by the 'atac_qc_post.slurm' script.

## II.Mapping

This step is to synchronize the forward and the reverse file of each sample. In order to do this, we do a mapping our sequences on the indexed reference genome (Mus_musculus_GRCm39 from Genome Reference Consortium (NCBI) Release date : June 24, 2020). 
The mapping will be done with the Bowtie2 tool. This step is achieved by the "atac_bowtie2.slurm" script.

### Cleaning of the alignments with the picard tools

At this step, duplicates are removed to avoid bias on the furture analysis. We use the MarkDuplicates function from the picard module.
This step can be achieved by the 'atac_picard.slurm" script.

## III.Exploration des données

This part allows us to obtain some statistics on our data. We use the Deeptools module. We have looked at samples correlation and the coverage of each sample on the genome.
This analysis is achieved by three scripts : deeptool_multisum.slurm who combine all the input BAM files, deeptools_correlation.slurm and deeptools_coverage.slurm

## IV.Identification of accessibility sites

This step is to identify the DNA access sites with the callPeaks function from the MACS2 module. This step can be achieved by the 'macs2.slurm' script.

## V. Identification of unique and common accessibility

This part allows us to see wich access regions are common and unique between the two cellular stage (0h and 24h) after exposition to the Tamoxifen drug. This analyze is performed by the intersect function from the bedtools module. Thanks to this step we will be able to make conclusions about the effect of the Tamoxifen. For exemple if an access site is open at t=0h and closed at t=24h, it means that the Tamoxifen drug open these sites.

This part is achied by the 'bedtools_intersect.slurm' script.

##Launching workflow:
Execute workflow.sh in main directory.
All output will be found in "$HOME"/atacseq/results.







