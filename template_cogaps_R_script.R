############################# CHANGE THIS SECTION ##############################

## do any pre-processing steps here






#### STANDARD PARAMETERS - only change values, not names of the variables

# name of your simulation (used in name of save file)
simulationName <- "template"

# data can be any format CoGAPS accepts (see vignette/reference manual)
data <- "/path/to/your/data" # or some_R_object

# this is the range of pattern CoGAPS will run over
nPattern_range <- seq(2, 20, 2)

# number of iterations to run CoGAPS for
nIterations <- 50000

# random seed for reproducibility
seed <- 123

# set to true if running on single-cell data
singleCell <- FALSE

# number of threads to run CoGAPS on (only when using standard CoGAPS)
nThreads <- 1 # set --cpus-per-task equal to this

# how often (in number of iterations) to print status messages
outputFrequency <- 1000

#### DISTRIBUTED PARAMETERS - set these if you're running GWCoGAPS or scCoGAPS

# set to true if running genome-wide CoGAPS
use_GWCoGAPS <- FALSE

# set to true if running single-cell CoGAPS
use_scCoGAPS <- FALSE

# number of subsets to break your data into
nSets <- 1 # set --ntasks-per-node equal to this

#### EXTRA PARAMETERS - these are some extra parameters that aren't critical

# option for transposing your data if samples are in the rows
transposeData <- FALSE

# uncertainty is either a matrix or a file name depending on the format of data
# leave it NULL to use the default value for uncertainty (recommended)
uncertainty <- NULL

########################## DO NOT CHANGE THIS SECTION ##########################

# check version 0f CoGAPS
if (packageVersion("CoGAPS") < "3.3.0")
    stop("CoGAPS version needs to be >= 3.3.0")

# check parameter values
if (use_GWCoGAPS & use_scCoGAPS)
    stop("Can't run both GWCoGAPS and scCOGAPS")
if (nThreads > 1 & (use_GWCoGAPS | use_scCoGAPS))
    stop("Can only run on one thread when using GWCoGAPS or scCOGAPS")

args <- commandArgs(TRUE)
arrayNum <- as.integer(args[1])
returnSize <- as.integer(args[2])

if (!is.na(returnSize)) {
    cat(as.numeric(length(nPattern_range)))
} else {
    library(CoGAPS)
    library(methods)
    print(packageVersion('CoGAPS'))
    cat(CoGAPS::buildReport())

    nPatterns <- nPattern_range[arrayNum]
    print(paste("nPatterns = ", nPatterns))

    distributed <- NULL
    if (use_GWCoGAPS)
        distributed <- "genome-wide"
    if (use_scCoGAPS)
        distributed <- "single-cell"

    gapsResult <- CoGAPS(data=data,
        nPatterns=nPatterns,
        nIterations=nIterations,
        seed=seed,
        singleCell=singleCell,
        nThreads=nThreads,
        outputFrequency=outputFrequency,
        distributed=distributed,
        nSets=nSets,
        transposeData=transposeData,
        uncertainty=uncertainty
    )
        
    save(gapsResult, file=paste(simulationName, "_result.RData", sep=""))
}

################################################################################