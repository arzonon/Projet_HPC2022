#! /bin/bash
#cd "$(dirname "$0")"

echo 'Team 4 Seguineau Pauline Zonon Aristides(Universite Clermont Auvergne, Mesocentre)'
echo 'Date: Fall Master course 2022 '
echo 'Object: Sample case of ATACseq workflow showing job execution and dependen
cy handling.'
echo 'Inputs: paths to scripts qc, trim and bowtie2,picard , deeptools npz files'
echo 'Outputs: trimmed fastq files, QC HTML files and BAM files, BED files, .npz files, .tab files, .png files,'

# Handling errors
#set -x # debug mode on
set -o errexit # ensure script will stop in case of ignored error
set -o nounset # force variable initialisation
#set -o verbose

IFS=$'\n\t'

echo "Launching Atac-seq Workflow"
# first job - no dependencies
# Initial QC
jid1=$(sbatch --parsable atacseq/scripts/atac_qc_init.slurm)
echo "$jid1 : Initial quality control"

# Trimming
jid2=$(sbatch --parsable --dependency=afterok:$jid1 atacseq/scripts/atac_trim.slurm)
echo "$jid2 : Trimming with Trimmomatic tool"

# Post QC
jid3=$(sbatch --parsable --dependency=afterok:$jid2 atacseq/scripts/atac_qc_post.slurm)
echo "$jid3 : Post quality control"


# Bowtie2 Alignment
jid4=$(sbatch --parsable --dependency=afterok:$jid3 atacseq/scripts/atac_bowtie2.slurm)
echo "$jid4 : Sequence Alignment Using Bowtie2 "

# Cleaning Alignments
jid5=$(sbatch --parsable --dependency=afterok:$jid4 atacseq/scripts/atac_picard.slurm)
echo "$jid5 : Cleaning alignments Using Picard Tools"


#  Data Exploration
jid6=$(sbatch --parsable --dependency=afterok:$jid5 atacseq/scripts/deeptool_multisum.slurm)
echo "$jid6 : Generating NPZ file"

jid6_1=$(sbatch --parsable --dependency=afterok:$jid6 atacseq/scripts/deeptools_correlation.slurm)
echo "$jid6_1 : Ploting Correlation"

jid6_2=$(sbatch --parsable --dependency=afterok:$jid6_1 atacseq/scripts/deeptools_coverage.slurm)
echo "$jid6_2 : Plotting Coverage"

#  Identification of dna accessibility sites
jid7=$(sbatch --parsable --dependency=afterok:$jid6_2 atacseq/scripts/macs2.slurm)
echo "$jid7 : Identification of dna accessibility sites using MACS2"

#  Identification of common and unique accessibility sites
jid8=$(sbatch --parsable --dependency=afterok:$jid7 atacseq/scripts/bedtools_intersect.slurm)
echo "$jid8 : Identification of common and unique accessibility sites using BedTools"


# show dependencies in squeue output:
squeue -u $USER -o "%.8A %.4C %.10m %.20E"

echo "Stop job : "`date` >&2
