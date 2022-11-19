#!/bin/bash
#SBATCH --time=0:40:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=12G
#SBATCH --cpus-per-task=6
#SBATCH -o atacseq/log/slurmjob-%A-%a
#SBATCH --job-name=MAC2
#SBATCH --partition=short
#SBATCH --array=0-5

# Program configuration
__author__='Seguineau Pauline Zonon Aristides'
__email__='pauline.seguineau@etu.uca.fr aristides.zonon@etu.uca.fr'
__license__='GPL3'
__status__='Development'
__version__='0.0.1'

echo "Identification des sites d'accessibilité"

# Handling errors
#set -x # debug mode on
set -o errexit # ensure script will stop in case of ignored error
set -o nounset # force variable initialisation
#set -o verbose
#set -euo pipefail
module purge
module load gcc/4.8.4 python/2.7.9 numpy/1.9.2 cython/0.25.2 MACS2/2.1.2

echo "Set up directories ..." >&2
#Set up the temporary directory and output directory
SCRATCHDIR=/storage/scratch/"$USER"/"$SLURM_JOB_ID"
OUTPUT="$HOME"/atacseq/results/MACS2
mkdir -p "$OUTPUT"
mkdir -p -m 700 "$SCRATCHDIR"
cd "$SCRATCHDIR"


#Set up data directory
DATA_DIR="$HOME"/atacseq/results/picard
echo "Start on $SLURMD_NODENAME: "`date` >&2
tab=($(ls "$DATA_DIR"/*/*mapped*.bam))
SHORTNAME=($(basename "${tab[$SLURM_ARRAY_TASK_ID]}" .bam))

#Run the program
macs2 callpeak -t ${tab[$SLURM_ARRAY_TASK_ID]}  \
    --tempdir /storage/scratch/"$USER"/"$SLURM_JOB_ID" \
 	-f BAM \
	-n "$SHORTNAME" \
	--outdir "$OUTPUT"

echo "List SCRATCHDIR: "
ls "$SCRATCHDIR" >&2
# Move results in one's directory
mv  "$SCRATCHDIR" "$OUTPUT"
echo "Stop job : "`date` >&2
