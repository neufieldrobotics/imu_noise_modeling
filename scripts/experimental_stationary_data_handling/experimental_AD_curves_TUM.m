close all
clear

script_paths;

data_folder_path = '/media/jagatpreet/Data/datasets/imu_modeling_paper/allan_dev_data';
PX4_filename = 'PX4_data_250hz.mat';
TUM_datafolder = "TUM_dataset-calib-imu-static_10hr_sets_std_struct";
TUM_filenames = dir(fullfile(data_folder_path,TUM_datafolder));
TUM_filenames = TUM_filenames(3:end);

TUM_Fs = 199;

load(fullfile(data_folder_path,PX4_filename));
PX4.Data = PX4.PX4_data.Data;

fields = fieldnames(PX4.Data);
for i = 1:numel(fields)
    comment = "N(white) K(brown) B(pink)";
    units_SI_a = "m/s^2/sqrt(hz) m/s^3/sqrt(hz) m/s^2";
    units_SI_g = "rad/s/sqrt(hz) rad/s^2/sqrt(hz) rad/s";
    fig = figure();
    offset = 0;
    count = 1;
    for name_index = 1:11
        if name_index ~= 5
            load(fullfile(data_folder_path,TUM_datafolder,TUM_filenames(name_index).name));        
            [T_tau, T_adev, T_avar, T_adev_upperbound,T_adev_lowerbound, T_numSamples] = compute_experimental_AD_curves(TUM.Data.(fields{i}),TUM_Fs);
            [T_N, T_tauN, T_lineN, T_K, T_tauK, T_lineK, T_B, T_tauB, T_lineB] = compute_noise_parameters_from_AD(T_adev, T_tau);
            NoiseParams_TUM(count).datafile = TUM_filenames(name_index).name;
            NoiseParams_TUM(count).comment = comment;
            NoiseParams_TUM(count).(fields{i}) = [T_N, T_K, T_B];
            h(count) = loglog(T_tau,T_avar.^0.5,'LineWidth',3);
            hold on
            grid on
            count = count + 1;
        end
    end
        axis auto
        axis square
        ylim([10e-6 10e-2]);
        xlabel('\tau (sec)','FontSize',13)
        ylabel('\sigma(\tau)','FontSize',13)
%         legend(h,...
%             'FontSize',13,...
%             'Location','North')
        title(strcat('Allan Deviation: TUM data -', fields{i}), 'FontSize',13, 'Interpreter','none')
        saveas(fig,fullfile("plot_images",strcat("AD_experimental-TUM",fields{i},'.jpeg')));
end