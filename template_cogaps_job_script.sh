#!/bin/bash -l

############################# CHANGE THIS SECTION ##############################

# When running standard CoGAPS with the nThreads argument,
# --cpus-per-task should be equal to nThreads, otherwise set it to 1

# When running GWCoGAPS or scCoGAPS, --ntasks-per-node should be
# equal to nSets, otherwise set it to 1

# Make sure you set your time limit to something reasonable, you can set it
# to a small value and run it once to see what CoGAPS was estimating for the
# total run time of the dataset. Note you must double the estimated runtime
# for GWCoGAPS since it runs in two passes

#SBATCH
#SBATCH --job-name=YOUR_JOB_NAME_HERE
#SBATCH --time=1:0:0
#SBATCH --partition=parallel
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1

# load all modules you need for this job
module load R

########################## DO NOT CHANGE THIS SECTION ##########################

if [ "$2" != "" ]; then
    OUTPUT_DIR=$2
else
    echo missing output directory
    exit 1
fi

mkdir -p $OUTPUT_DIR
mkdir -p $OUTPUT_DIR/run_$SLURM_ARRAY_TASK_ID
cd $OUTPUT_DIR/run_$SLURM_ARRAY_TASK_ID

if [ "$1" != "" ]; then
    FILE=$1
else
    echo missing file name
    exit 1
fi

time Rscript $FILE $SLURM_ARRAY_TASK_ID

################################################################################