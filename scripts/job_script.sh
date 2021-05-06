#!/bin/bash -l

# When running standard CoGAPS with the nThreads argument,
# --cpus-per-task should be equal to nThreads, otherwise set it to 1
#
# When running GWCoGAPS or scCoGAPS, --ntasks-per-node should be
# equal to nSets, otherwise set it to 1
#
# Make sure you set your time limit to something reasonable, you can set it
# to a small value and run it once to see what CoGAPS was estimating for the
# total run time of the dataset. Note you must double the estimated runtime
# for GWCoGAPS since it runs in two passes

############################# CHANGE THIS SECTION ##############################

#SBATCH
#SBATCH --job-name=BM_RETINA
#SBATCH --time=50:0:0
#SBATCH --partition=parallel
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=24
#SBATCH --exclusive

# load all modules you need for this job
# Ensure that gcc is the module loaded NOT intel
# This will ensure that you can install CoGAPS and dependencies
module load gcc/5.0.0
# User can specify version of R
# ie R/4.0.2
module load R

########################## DO NOT CHANGE THIS SECTION ##########################

# verify that an R script wasa passed
if [ ! -f $1 ]; then
    "internal error: R Script not found"
    exit 1
fi
R_SCRIPT=$1

# verify that an output directory was passed
if [ ! -d $2 ]; then
    "internal error: output directory not found"
    exit 1
fi
OUTPUT_DIR=$2

# verify that R script is an absolute path
if [ ! "${R_SCRIPT:0:1}" == "/" ]; then
    "internal error: relative path passed in script name"
    exit 1
fi

# verify that output directory is an absolute path
if [ ! "${OUTPUT_DIR:0:1}" == "/" ]; then
    "internal error: relative path passed in output directory"
    exit 1
fi

# create output directory for this job within the array
mkdir -p $OUTPUT_DIR/result_$SLURM_ARRAY_TASK_ID

# change directories so output gets put in the right place
cd $OUTPUT_DIR/result_$SLURM_ARRAY_TASK_ID

# run r script
time Rscript $R_SCRIPT $SLURM_ARRAY_TASK_ID

################################################################################
