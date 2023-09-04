clear
global total_runs
script_paths;
config_MC_sim_mean_parameters;
simulation_cases_num = run_id;
for i = 1:simulation_cases_num
    
    for run=1:total_runs
        disp(' Run number = ');
        disp(run);
        mc_sim_run_data = dead_reckoning_noise_model(imu_params{i}{1},sim_params);
        mc_sim_run_data.doc.comment = strcat(run_fields{i}," Run - ",num2str(run));
        mc_sim_run_data.doc.order = "x y z";
        mc_sim_run_data.doc.noise_params = imu_params{i}{1};
        append_header_to_MC_data;
        save(strcat(filepath.save_path{i},'_',num2str(run),'.mat'),'mc_sim_run_data');
    end

end
