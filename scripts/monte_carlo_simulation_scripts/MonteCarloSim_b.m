clear
global total_runs
script_paths;
config_MC_sim_b;

for run=1:total_runs
    disp(' Accelerometer Run number = ');
    disp(run);
    mc_sim_run_data = dead_reckoning_noise_model(VN100_params{1},sim_params);
    mc_sim_run_data.comment = strcat("Accelerometer - ",...
                                    "brown noise simulation",...
                                    " Run - ",num2str(run));
    mc_sim_run_data.doc.order = "x y z";
    mc_sim_run_data.doc.noise_params = VN100_params{1};
    append_header_to_MC_data;
    save(strcat(filepath.save_path.acc,'_',num2str(run),'.mat'),'mc_sim_run_data');
end


for run=1:total_runs
    disp(' Gyroscope Run number = ');
    disp(run);
    mc_sim_run_data = dead_reckoning_noise_model(VN100_params{2},sim_params);
    mc_sim_run_data.comment = strcat("Gyroscope - ",...
                                      "brown noise simulation",...
                                      " Run - ",num2str(run));
    mc_sim_run_data.doc.order = "x y z";
    mc_sim_run_data.doc.noise_params = VN100_params{2};
    append_header_to_MC_data;
    save(strcat(filepath.save_path.gyro,'_',num2str(run),'.mat'),'mc_sim_run_data');
end



