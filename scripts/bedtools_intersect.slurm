#!/bin/bash
#SBATCH --time=0:40:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=12G
#SBATCH --cpus-per-task=6
#SBATCH -o atacseq/log/slurmjob-%A-%a
#SBATCH --job-name=bedtools_intersect
#SBATCH --partition=short
#SBATCH --array=0-2

__author__='Seguineau Pauline Zonon Aristides'
__license__='GPL3'
__status__='Development'
__version__='0.0.1'

echo "Identification les sites d'accessibilité"

# Handling errors
#set -x # debug mode on
set -o errexit # ensure script will stop in case of ignored error
set -o nounset # force variable initialisation
#set -o verbose
#set -euo pipefail
module purge
module load gcc/4.8.4 bedtools/2.27.1

echo "Set up directories ..." >&2
#Set up the temporary directory
SCRATCHDIR=/storage/scratch/"$USER"/"$SLURM_JOB_ID"
OUTPUT="$HOME"/atacseq/results/BedTools
mkdir -p "$OUTPUT"
mkdir -p -m 700 "$SCRATCHDIR"
cd "$SCRATCHDIR"


#Set up data directory
DATA_DIR="$HOME"/atacseq/results/MACS2

echo "Start on $SLURMD_NODENAME: "`date` >&2
tab1=($(ls "$DATA_DIR"/*24h*_mapped_*.bed))
tab2=($(ls "$DATA_DIR"/*0h*_mapped_*.bed))
SHORTNAME1=($(basename "${tab1[$SLURM_ARRAY_TASK_ID]}" .bed  ))
SHORTNAME2=($(basename "${tab2[$SLURM_ARRAY_TASK_ID]}" .bed  ))

#Run the program
# intersect the peaks from both experiments.
# -f 0.50 combined with -r requires 50% reciprocal overlap between the
# peaks from each experiment.

bedtools intersect -a ${tab2[$SLURM_ARRAY_TASK_ID]} \
 -b ${tab1[$SLURM_ARRAY_TASK_ID]} \
 -f 0.50 -r > "$SCRATCHDIR"/"$SHORTNAME2"_both.bed

bedtools intersect -v -a ${tab2[$SLURM_ARRAY_TASK_ID]} \
 -b ${tab1[$SLURM_ARRAY_TASK_ID]} \
 -f 0.50 -r > "$SCRATCHDIR"/"$SHORTNAME2"_0H_Unique.bed

bedtools intersect -v -a ${tab1[$SLURM_ARRAY_TASK_ID]} \
 -b ${tab2[$SLURM_ARRAY_TASK_ID]} \
 -f 0.50 -r > "$SCRATCHDIR"/"$SHORTNAME1"_24H_Unique.bed



echo "List SCRATCHDIR: "
ls "$SCRATCHDIR" >&2
# Move results in one's directory
mv  "$SCRATCHDIR" "$OUTPUT"
echo "Stop job : "`date` >&2
