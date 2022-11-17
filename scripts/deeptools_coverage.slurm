#!/bin/bash
#SBATCH --time=05:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=12G
#SBATCH --cpus-per-task=6
#SBATCH -o atacseq/log/slurmjob-%A-%a
#SBATCH --job-name=Coverage
#SBATCH --partition=short
#SBATCH --array=0-5

# Program configuration
__author__='Seguineau Pauline Zonon Aristides'
__email__='pauline.seguineau@etu.uca.fr zonon.aristides@etu.uca.fr'
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
OUTPUT="$HOME"/atacseq/results/coverage
mkdir -p "$OUTPUT"
mkdir -p -m 700 "$SCRATCHDIR"
cd "$SCRATCHDIR"

#Set up data directory
DATA_DIR="$HOME"/atacseq/results/picard
tab="$DATA_DIR"/*/*mapped*.bam

#Run the program
plotCoverage --bamfiles $tab -p 6 \
    --plotFile "$OUTPUT"/coverage \
    --plotTitle "Coverage" \
    --outRawCounts "$OUTPUT"/coverage.tab \
    --ignoreDuplicates	#If set, reads that have the same orientation and start position will be considered only once.#

echo "List SCRATCHDIR: "
ls "$SCRATCHDIR" >&2
# Move results in one's directory
mv  "$SCRATCHDIR" "$OUTPUT"
echo "Stop job : "`date` >&2

