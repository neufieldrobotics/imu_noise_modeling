clear
global total_runs
script_paths;
config_MC_sim_inflated_wb_ag;
for run=1:total_runs
    disp(' Run number = ');
    disp(run);
    mc_sim_run_data = dead_reckoning_noise_model(imu_params{1},sim_params);
    mc_sim_run_data.doc.comment = strcat("Accelerometer - ",...
                            "inflated white brown accelerometer gyro noise simulation"," Run - ",num2str(run));
    mc_sim_run_data.doc.order = "x y z";
    mc_sim_run_data.doc.noise_params = imu_params{1};
    append_header_to_MC_data;
    save(strcat(filepath.save_path,'_',num2str(run),'.mat'),'mc_sim_run_data');
end


