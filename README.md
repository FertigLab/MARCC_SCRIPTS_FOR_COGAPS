# MARCC project manager for submitting CoGAPS runs

This repository contains a template for running multiple CoGAPS jobs on MARCC.

## Setup

1) clone repository (change `project_name` to your project name)

```
git clone https://github.com/FertigLab/MARCC_SCRIPTS_FOR_COGAPS.git
mv MARCC_SCRIPTS_FOR_COGAPS project_name
cd project_name
chmod +x run
```

2) delete `.git` - you no longer need access to this repository

`rm -rf .git`

3) (optional) Create a new git repository to push your result to

```
git init
git add -A
git commit -m "first commit message"
git remote add origin https://github.com/username/new_repo
git push origin master
```

Your directory structure should now look like this (if you have `tree` installed you can see this with `tree ..`)

```
..
└── project_name
    ├── README.md
    ├── run
    └── scripts
        ├── job_script.sh
        └── R_script.R
```

## Usage

Now that you have the directory structure set up, you can use the run script to submit jobs as follows:

1) modify the parameter values `R_script.R` for your specific case
2) modify the job parameters (i.e. #SBATCH ...) in `job_script.sh`
3) execute `./run run_name run_id`

This will copy over the scripts and run everything in a new directory called `run_name/run_id`. With these scripts you can quickly fire off multiple runs and all information (including log files) will be stored in a separate, well-structured directory.

Inside `R_script.R` and `job_script.sh` you can find instructions on how to modify those files.

For more information use `./run --help`

## Example

After modifying `R_script.R` and `job_script.sh` you might set off a few runs like this:

`./run MySingleCellAnalysis 1`

modify parameters again

`./run MySingleCellAnalysis 2`

and the result will be a directory like this:

```
├── MySingleCellAnalysis
│   ├── run_1
│   │   ├── logs
│   │   │   ├── slurm-31515407_1.out
│   │   │   ├── slurm-31515407_2.out
│   │   │   └── slurm-31515407_3.out
│   │   ├── result_1
│   │   │   └── sc_analysis_result.RData
│   │   ├── result_2
│   │   │   └── sc_analysis_result.RData
│   │   ├── result_3
│   │   │   └── sc_analysis_result.RData
│   │   └── scripts
│   │       ├── job_script.sh
│   │       └── R_script.R
│   └── run_2
│       ├── logs
│       │   ├── slurm-31558492_1.out
│       │   ├── slurm-31558492_2.out
│       ├── result_1
│       │   └── sc_analysis_result.RData
│       ├── result_2
│       │   └── sc_analysis_result.RData
│       └── scripts
│           ├── job_script.sh
│           └── R_script.R
```

The SLURM log files are sent to `run_id/logs` and the scripts used to set off the run are sent to `run_id/scripts`. All results are sent to `run_id/result_id` where the
`CogapsResult` object is saved to an `RData` file. The number of results is determined by how many parameters are being looped over in `R_script.R`.

# Bugs/Suggestions

Please let me know on Slack or at tomsherman159@gmail.com if there are any bugs in these scripts or if there any features you'd like to see added

