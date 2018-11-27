# This script allows you to set all parameters for CoGAPS, and also allows
# you to set certain parameters to be looped over in multiple runs.
#
# Individual parameters have instructions that are specific to them.
#
# When setting parameters to be looped over (these parameters are marked by
# RANGED PARAMETER) you un-comment the "variable_range <- c(...)" line and
# instead comment the "variable <- value" line. Set the parameters in this
# range to whatever you want - a new run will be set off for each value. Note
# that you can only loop over one variable at a time.

############################# CHANGE THIS SECTION ##############################

#### STANDARD PARAMETERS - only change values, not names of the variables

# name of your simulation (used in name of save file)
simulationName <- "example_name"

# data can be any format CoGAPS accepts (see vignette/reference manual)
# this should be an absolute path
data <- "/path/to/data.mtx"

# RANGED PARAMETER
# number of patterns CoGAPS will run over
#nPatterns_range <- c(10, 20, 30)
nPatterns <- 55

# RANGED PARAMETER
# number of iterations to run CoGAPS for
#nIterations_range <- c(30000, 40000, 50000)
nIterations <- 50000

# RANGED PARAMETER
# random seed for reproducibility
#seed_range <- c(12, 1234, 123456)
seed <- 42

# set to true if running on single-cell data
singleCell <- FALSE

# set to true if data is greater than 80% sparse
sparseOptimization <- FALSE

# number of threads to run CoGAPS on (only when using standard CoGAPS)
nThreads <- 1 # set --cpus-per-task equal to this

# how often (in number of iterations) to print status messages
outputFrequency <- 1000

# option for transposing your data if samples are in the rows
transposeData <- FALSE

#### DISTRIBUTED PARAMETERS - set these if you're running GWCoGAPS or scCoGAPS

# set to true if running genome-wide CoGAPS
use_GWCoGAPS <- FALSE

# set to true if running single-cell CoGAPS
use_scCoGAPS <- FALSE

# RANGED PARAMETER
# number of subsets to break your data into, set --ntasks-per-node equal to this
# nSets_range <- c(4, 8, 12)
nSets <- 24

########################## DO NOT CHANGE THIS SECTION ##########################

# check version 0f CoGAPS
if (packageVersion("CoGAPS") < "3.2.0")
    stop("CoGAPS version needs to be >= 3.2.0")

# check path to data
if (substring(data, 1, 1) != "/")
    stop("Must provide an absolute path to data")

# check if we can read the input file
canRead <- function(path)
{
    return(all(file.access(path, 4) == 0))
}
if (!canRead(data))
    stop("Can't read data file")

# check parameter values
if (use_GWCoGAPS & use_scCoGAPS)
    stop("Can't run both GWCoGAPS and scCOGAPS")
if (nThreads > 1 & (use_GWCoGAPS | use_scCoGAPS))
    stop("Can only run on one thread when using GWCoGAPS or scCOGAPS")

# check we're only using one range
valid_ranges <- c(
    "nPatterns_range",
    "nIterations_range",
    "seed_range",
    "nSets_range"
)
if (sum(sapply(valid_ranges, exists)) > 1)
    stop("specifying more than one variable range")

if (sum(sapply(valid_ranges, exists)) == 0)
    warning("not using any variable ranges - only setting off one run")

range_index <- which(unname(sapply(valid_ranges, exists)))
range <- get(valid_ranges[range_index])

args <- commandArgs(TRUE)
arrayNum <- as.integer(args[1])
returnSize <- as.integer(args[2])

if (!is.na(returnSize)) {
    cat(as.numeric(length(range)))
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

    if (range_index == 1) {
        nPatterns <- nPatterns_range[arrayNum]
        print(paste("nPatterns = ", nPatterns))
    } else if (range_index == 2) {
        nIterations <- nIterations_range[arrayNum]
        print(paste("nIterations = ", nIterations))
    } else if (range_index == 3) {
        seed <- seed_range[arrayNum]
        print(paste("seed = ", seed))
    } else if (range_index == 4) {
        nSets <- nSets_range[arrayNum]
        print(paste("nSets = ", nSets))
    }
    
    params <- new("CogapsParams")
    params <- setParam(params, "nPatterns", nPatterns)
    params <- setParam(params, "nIterations", nIterations)
    params <- setParam(params, "seed", seed)
    params <- setParam(params, "singleCell", singleCell)
    params <- setParam(params, "distributed", distributed)
    params <- setParam(params, "sparseOptimization", sparseOptimization)

    params <- setDistributedParams(params, nSets=nSets)

    gapsResult <- CoGAPS(data=data, params=params,
        nThreads=nThreads,
        outputFrequency=outputFrequency,
        transposeData=transposeData
    )

    save(gapsResult, file=paste(simulationName, "_result.RData", sep=""))
}

################################################################################