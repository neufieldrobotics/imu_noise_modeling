# IMU noise modeling
This repository models different stochastic noise sources in an IMU - namely white noise,
brown noise and pink noise. It implements montecarlo simulations to understand
the position errors generated from each of these noise sources for the IMU parameters
obtained from AD curves (stationary data collected greater than 5hrs).
The position error is computed by dead-reckoning using rk method. 

The repository also has verification scripts to confirm the errors of the model 
and check the accuracy in modeling of each noise source.

**Note**: In future we will also add bulk model parameters and their effect on
the overall error growth when an IMU is used. 

Important submodules:
1. config_files (local gitlab instance): Different branches of the config files
store different IMUs' noise values.
2. some public github projects: which have done similar work. 

# Todo:
- [✓] configure the simulation for pink noise senstivity analysis and check the
   parameters being set are right.
- [✓] Delete tau in the configuration files of pink simulation as well as from
   the code.
- [✓] setup new functions in the code for running pink noise simulations.
- [✓] run the senstivity analysis - simulation in parallel in hulk or crunch.
- [] setup simulation configs for each sensor by removing the folder name in the
    config files and editing the mc_sim_config.
    Remove arbitrary functions.
- [] edit the config files for different sensors and check the values with AD
   curves.
- [] Run simulations for different sensors and record their results.
- [] Improve visualization scripts for plotting all sensors together.

# Resources
1. [Github repository with important modeling hints](https://github.com/EVictorson/allan_variance)
2. [IEEE standard on fiber optic gyros - v2](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=494457)
3. [IEEE standard on fibler optic gyros
   - v1](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=660628&tag=1)
# Script usage
A collection of scripts to simulate and validate IMU noise models.

## Running the code
On MATLAB command line, run the following:


## Data to use

## Configs to set

## All Scripts
The groups of scripts are described below

## Scripts for doing all the tasks by selecting the task

> script_paths

> main

### Scripts for AD curves and saving them

> save_public_datasets_to_std_struct

> experimental_AD_curves

> experimental_AD_curves_TUM

### Scripts for comparing and model verification

> inflated_vs_actual_AD_comparison

> theoretical_AD_curves

> sensor_model_verification

### Monte-Carlo Simulation scripts
> process_mc_sim_logs

> MonteCarloSim_w

> MonteCarloSim_wb

> MonteCarloSim_wbp

> MonteCarloSim_wb_ag


## Visualization
> Plots

## Experimental evaluation with ground truth
> dead_reckoning_euroc

## To compute Allan Deviation curves:

### Example setup


### VOXL data processing
VOXL data is stored in the following way:
```
+-- home
   +-- datasets
       +-- vio_calibration_all_setups
           +-- voxl_deck
               +--- imu0_params.yaml
               +--- vn100_params.yaml
               +--- april_grid_params.yaml
               +--- voxl_calibration_flight<id1-id2>.bag
       +-- voxl_m500_logs
          +-- flight1 (has rosbag, gt data and euroc format IMU data)
              +--Optitrack_data
                 +-- take_file_optitrack.csv (from optitrack)
              +--voxl_run_flight1_<date>.bag (obtained during flight log, is modified with a script)
              +--qvio_log_run_flight1.txt (obtained during flight log)
              +--data_imu0.txt (EUROC format style file, after data collect scripts)
              +--data_vn100_modified_time.txt (converted to voxl time, after data collect scripts)

          +-- flight2
          .
          .
          +-- flightN

          +-- vio_results
              +-- flight1
                  +--gt_raw_flight1_<date>.csv (optitrack frame, utc time)
                  +--gt_W_flight1_time_offset.csv (World frame - ROS convention, voxl time)
                  +--vinsmono_flight1_imu0.csv (generated from vinsmono, imu0 parameters)
                  +--vinsmono_result_flight1_vn100.csv (generated from vinsmono, vn100 parameters)
                  +--imu0_euroc.csv
                  +--vn100_euroc.csv
                  +--voxl_run_flight1_<date>.mat (obtained from bag2mat tool and related config file)

              +-- flight2
              .
              .
              +-- flightN
          |
```
### How to obtain each one of these files.

  <img src="https://gitlab.com/neufieldrozbotics/imu_tutorials/raw/master/docs/imu_initial_conditions.svg" alt="IMU circle example" width="1080" align="middle">
