clear
global total_runs
script_paths;
config_MC_sim_inflated_wb;
for run=1:total_runs
    disp(' Accelerometer Run number = ');
    disp(run);
    mc_sim_run_data = dead_reckoning_noise_model(imu_params{1},sim_params);
    mc_sim_run_data.doc.comment = strcat("Accelerometer - ",...
                            "inflated white-brown noise simulation"," Run - ",num2str(run));
    mc_sim_run_data.doc.order = "x y z";
    mc_sim_run_data.doc.noise_params = imu_params{1};
    append_header_to_MC_data;
    save(strcat(filepath.save_path.acc,'_',num2str(run),'.mat'),'mc_sim_run_data');
end


for run=1:total_runs
    disp(' Gyroscope Run number = ');
    disp(run);
    mc_sim_run_data = dead_reckoning_noise_model(imu_params{2},sim_params);
    mc_sim_run_data.doc.comment = strcat("Gyroscope - ",...
                        "inflated white-brown noise simulation"," Run - ",num2str(run));
    mc_sim_run_data.doc.order = "x y z";
    mc_sim_run_data.doc.noise_params = imu_params{2};
    append_header_to_MC_data;
    save(strcat(filepath.save_path.gyro,'_',num2str(run),'.mat'),'mc_sim_run_data');
end

                                       

