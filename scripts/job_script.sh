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
#SBATCH --job-name=BM_RETINA
#SBATCH --time=2:0:0
#SBATCH --partition=shared
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=24
#SBATCH --exclusive

# load all modules you need for this job
module load R

########################## DO NOT CHANGE THIS SECTION ##########################

# verify that an R script wasa passed
if [ ! -f $1 ]; then
    "internal error: R Script not found"
fi
R_SCRIPT=$1

# verify that an output directory was passed
if [ ! -f $2 ]; then
    "internal error: output directory not found"
fi
OUTPUT_DIR=$2

# verify that R script is an absolute path
if [ "${R_SCRIPT:0:1}" -ne "/" ]; then
    "internal error: relative path passed in script name"
fi

# verify that output directory is an absolute path
if [ "${OUTPUT_DIR:0:1}" -ne "/" ]; then
    "internal error: relative path passed in output directory"
fi

# create output directory for this job within the array
mkdir -p $OUTPUT_DIR/result_$SLURM_ARRAY_TASK_ID

# change directories so output gets put in the right place
cd $OUTPUT_DIR/result_$SLURM_ARRAY_TASK_ID

# run r script
time Rscript $R_SCRIPT $SLURM_ARRAY_TASK_ID

################################################################################
