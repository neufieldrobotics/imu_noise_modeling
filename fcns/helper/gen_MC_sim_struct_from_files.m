function monte_carlo_sim = gen_MC_sim_struct_from_files(folder_path,cell_array_filenames)
%GEN_MC_STRUCT_FROM_FILES Summary of this function goes here
%   Detailed explanation goes here
    

    load(fullfile(folder_path,cell_array_filenames(1)),'mc_sim_run_data');
    %Preallocate the struct runData : MxNxP, MxN - single run, P - number
    %of runs
    [M,N] = size(mc_sim_run_data.runData);
    runs = length(cell_array_filenames);
    %monte_carlo_sim.runData = zeros(M,N,runs);
    monte_carlo_sim.t = mc_sim_run_data.t;
    p = 1;
    for i = 1:runs
        load(fullfile(folder_path,cell_array_filenames(i)),...
            'mc_sim_run_data');
        [m,n] = size(mc_sim_run_data.runData);
        M
        N
        m
        n
        if (M == m) && (N == n)
            monte_carlo_sim.runData(:,:,p) = mc_sim_run_data.runData;
            p = p+1;
        else
            disp("size not equal: run = ")
            disp(i);
        end
    end      
end

