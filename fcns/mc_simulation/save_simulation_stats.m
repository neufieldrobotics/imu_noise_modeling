function mc_sim_data = save_simulation_stats(comment,mc_sim_run_data,sim_averages,sim_sigmas)
%SAVE_SIMULATION_STATS Summary of this function goes here
%   Detailed explanation goes here
    mc_sim_data.comment = comment;
    mc_sim_data.stats.sim_averages = sim_averages;
    mc_sim_data.stats.sim_sigma = sim_sigmas;
    mc_sim_data.run_data = mc_sim_run_data;
end

