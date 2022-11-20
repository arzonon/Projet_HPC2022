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
###
## II.Mapping
## III.Exploration des données
## IV.Identification of accessibility sites
## V. Identification of unique and common accessibility





### Collect adapters for read cleaning 

https://github.com/timflutre/trimmomatic/tree/master/adapters/NexteraPE-PE.fa

2015-03-5

v0.33

# Nextera R1

>Trans2_rc

CTGTCTCTTATACACATCTCCGAGCCCACGAGAC

# Nextera R2

>Trans1_rc

CTGTCTCTTATACACATCTGACGCTGCCGACGA


## Reference genome used 

mm10 is likely UCSC version of the genome. GRCm38 is from Genome Reference Consortium (NCBI)

GRCm38.p6 Release date: September 15, 2017
