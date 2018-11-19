# MARCC project manager for submitting CoGAPS runs

This repository contains a template for running multiple CoGAPS jobs on MARCC. When using for your project, copy the `run` script and the `scripts` folder. Your directory should be set up as:

```
/project_name
    run
    /scripts
        R_script.R
        job_script.sh   
```

From here, you can use the run script to submit jobs as follows:

1) modify the parameter values `R_script.R` for your specific case
2) modify the job parameters (i.e. #SBATCH ...) in `job_script.sh`
3) execute `./run run_name run_id` e.g. `./run my_single_cell_analysis 3`

This will copy over the scripts and run everything in a new directory called `my_single_cell_analysis/run_3`. With these scripts you can quickly fire off multiple runs and all information (including log files) will be stored in a separate, well-structured directory.

For more information use `./run --help`

# Bugs/Suggestions

Please let me know on Slack or at tomsherman159@gmail.com if there are any bugs in these scripts or if there any features you'd like to see added

