#!/bin/bash
#SBATCH --time=5:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=12G
#SBATCH --cpus-per-task=6
#SBATCH -o atacseq/log/slurmjob-%A-%a
#SBATCH --job-name=correlation
#SBATCH --partition=short
#SBATCH --array=0-5

# Program configuration
__author__='Seguineau Pauline Zonon Aristides'
__email__='pauline.seguineau@etu.uca.fr aristides.zonon@etu.uca.fr'
__credits__=['Seguineau Pauline Zonon Aristides']
__license__='GPL3'
__maintainer__='Seguineau Pauline Zonon Aristides'
__status__='Development'
__version__='0.0.1'

echo 'Exploration des données'

# Handling errors
#set -x # debug mode on
set -o errexit # ensure script will stop in case of ignored error
set -o nounset # force variable initialisation
#set -o verbose
#set -euo pipefail
module purge
module load gcc/4.8.4 python/2.7.9 numpy/1.9.2 samtools/1.3 deepTools/3.1.2


echo "Set up directories ..." >&2
#Set up the temporary directory
SCRATCHDIR=/storage/scratch/"$USER"/"$SLURM_JOB_ID"
OUTPUT="$HOME"/atacseq/results/correlation
mkdir -p "$OUTPUT"
mkdir -p -m 700 "$SCRATCHDIR"
cd "$SCRATCHDIR"

#Set up data directory
NPZ="$HOME"/atacseq/results/deeptools

#Run the program

plotPCA -in "$NPZ"/cov.npz \
        -o "$OUTPUT"/PCAplot_readCounts.png \
        -T "PCA of Sequencing Depth Normalized Read Counts"

#Heatmap correlation Pearson
plotCorrelation \
 -in "$NPZ"/cov.npz \
 --corMethod pearson --skipZeros \
 --plotTitle "Pearson Correlation of Average Scores Per Transcript" \
 --whatToPlot heatmap \
 -o "$OUTPUT"/heatmap_PearsonCorr_readCounts.png   \
 --outFileCorMatrix "$OUTPUT"/PearsonCorr_bigwigScores.tab

#Heatmap corrélation Spearman
plotCorrelation \
    -in "$NPZ"/cov.npz \
    --corMethod spearman --skipZeros \
    --plotTitle "Spearman Correlation of Read Counts" \
    --whatToPlot heatmap --colorMap RdYlBu --plotNumbers \
    -o "$OUTPUT"/heatmap_SpearmanCorr_readCounts.png   \
    --outFileCorMatrix "$OUTPUT"/SpearmanCorr_readCounts.tab

plotCorrelation -in "$NPZ"/cov.npz \
 -c pearson \
 -p scatterplot \
 -o "$OUTPUT"/scatterplot_pearson.pdf 

plotCorrelation -in "$NPZ"/cov.npz \
 -c spearman \
 -p scatterplot \
 -o "$OUTPUT"/scatterplot_spearman.pdf

echo "List SCRATCHDIR: "
ls "$SCRATCHDIR" >&2
# Move results in one's directory
mv  "$SCRATCHDIR" "$OUTPUT"
echo "Stop job : "`date` >&2

