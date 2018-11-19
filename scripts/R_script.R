############################# CHANGE THIS SECTION ##############################

## do any pre-processing steps here

#### STANDARD PARAMETERS - only change values, not names of the variables

# name of your simulation (used in name of save file)
simulationName <- "bm_retina"

# data can be any format CoGAPS accepts (see vignette/reference manual)
data <- "~/work/RetinaReruns/RetinaHighVarSubset.mtx" # or some_R_object

# this is the range of pattern CoGAPS will run over
nPatterns <- 80

# number of iterations to run CoGAPS for
nIterations <- 500

# random seed for reproducibility
seed_range <- c(12, 1234, 123456)

# set to true if running on single-cell data
singleCell <- TRUE

# set to true if data is greater than 80% sparse
sparseOptimization <- TRUE

# number of threads to run CoGAPS on (only when using standard CoGAPS)
nThreads <- 1 # set --cpus-per-task equal to this

# how often (in number of iterations) to print status messages
outputFrequency <- 100

#### DISTRIBUTED PARAMETERS - set these if you're running GWCoGAPS or scCoGAPS

# set to true if running genome-wide CoGAPS
use_GWCoGAPS <- FALSE

# set to true if running single-cell CoGAPS
use_scCoGAPS <- TRUE

# number of subsets to break your data into
nSets <- 24 # set --ntasks-per-node equal to this

#### EXTRA PARAMETERS - these are some extra parameters that aren't critical

# option for transposing your data if samples are in the rows
transposeData <- FALSE

# uncertainty is either a matrix or a file name depending on the format of data
# leave it NULL to use the default value for uncertainty (recommended)
uncertainty <- NULL

########################## DO NOT CHANGE THIS SECTION ##########################

# check version 0f CoGAPS
if (packageVersion("CoGAPS") < "3.2.0")
    stop("CoGAPS version needs to be >= 3.2.0")

# check parameter values
if (use_GWCoGAPS & use_scCoGAPS)
    stop("Can't run both GWCoGAPS and scCOGAPS")
if (nThreads > 1 & (use_GWCoGAPS | use_scCoGAPS))
    stop("Can only run on one thread when using GWCoGAPS or scCOGAPS")

args <- commandArgs(TRUE)
arrayNum <- as.integer(args[1])
returnSize <- as.integer(args[2])

if (!is.na(returnSize)) {
    cat(as.numeric(length(seed_range)))
} else {
    library(CoGAPS)
    library(methods)
    print(packageVersion('CoGAPS'))
    cat(CoGAPS::buildReport())

    distributed <- NULL
    if (use_GWCoGAPS)
        distributed <- "genome-wide"
    if (use_scCoGAPS)
        distributed <- "single-cell"

    print(paste("seed = ", seed_range[arrayNum]))

    params <- new("CogapsParams")
    params <- setParam(params, "nPatterns", nPatterns)
    params <- setParam(params, "nIterations", nIterations)
    params <- setParam(params, "seed", seed_range[arrayNum])
    params <- setParam(params, "singleCell", singleCell)
    params <- setParam(params, "distributed", distributed)
    params <- setParam(params, "sparseOptimization", sparseOptimization)

    params <- setDistributedParams(params, nSets=nSets)

    gapsResult <- CoGAPS(data=data, params=params,
        nThreads=nThreads,
        outputFrequency=outputFrequency,
        transposeData=transposeData,
        uncertainty=uncertainty
    )
        
    save(gapsResult, file=paste(simulationName, "_result.RData", sep=""))
}

################################################################################
