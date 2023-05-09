close all
clear

script_paths;
config_experimental_AD_curves;

disp(selected_IMUs)

%% Load data

data_folder_path = AD_config.data.('root_folder_path');
fprintf("data folder path:%s \n",data_folder_path)

for i = 1:length(selected_IMUs)
    
    if selected_IMUs{i} == "TUM"
        TUM_data_folder_path = AD_config.data.TUM_datafolder;
        filename = AD_config.data.filenames.TUM(AD_config.tum_num).name;
        load(fullfile(data_folder_path,TUM_data_folder_path,filename));
    else
        filename = AD_config.data.filenames.(selected_IMUs{i});
        load(fullfile(data_folder_path,filename));
    end
    
    % load file 
    
    if selected_IMUs{i} == "PX4"
        PX4.Data = PX4.PX4_data.Data;
        PX4 = rmfield(PX4,'PX4_data'); 
    elseif selected_IMUs{i} == "VN100"
        VN100.Data = robot.vn100_imu;
        clear 'robot';
    elseif selected_IMUs{i} == "XSENSE"
        XSENSE.Data = robot.imu_data;
        clear robot;
    end   
end
 % Plot Allan dev and compute Noise params
 
 fields = {'angular_velocity_x',...
            'angular_velocity_y',...
            'angular_velocity_z',...
            'acceleration_x',...
             'acceleration_y',...
             'acceleration_z'};
 tau = struct(); adev = struct(); avar = struct();
 adev_upper_bound = struct(); adev_lower_bound = struct();
 N = struct(); tauN = struct(); lineN = struct();
 tauK = struct(); lineK = struct(); B = struct();
 tauB = struct(); lineB = struct();
 fig = [];
 for j = 1:numel(fields)
    comment = "N(white) K(brown) B(pink)";
    units_SI_a = "m/s^2/sqrt(hz) m/s^3/sqrt(hz) m/s^2";
    units_SI_g = "rad/s/sqrt(hz) rad/s^2/sqrt(hz) rad/s";
    
    NoiseParams.comment = comment;
    NoiseParams.units_SI_a = units_SI_a;
    NoiseParams.units_SI_g = units_SI_g;
    
    for i=1:length(selected_IMUs)
        
        %Initialize
        tau = setfield(tau,selected_IMUs{i},{});
        adev = setfield(adev,selected_IMUs{i},{});
        avar = setfield(avar,selected_IMUs{i},{});
        adev_upper_bound = setfield(adev_upper_bound,selected_IMUs{i},{});
        adev_lower_bound = setfield(adev_lower_bound,selected_IMUs{i},{});
        tauK = setfield(tauK,selected_IMUs{i},{}); 
        lineK = setfield(lineK,selected_IMUs{i},{}); 
        B = setfield(B,selected_IMUs{i},{});
        tauB = setfield(tauB,selected_IMUs{i},{});
        lineB = setfield(lineB,selected_IMUs{i},{});
        NoiseParams = setfield(NoiseParams,selected_IMUs{i},{});
        
        %Calculate allan deviation
        fprintf("Computing allan deviation parameters for %s, measurement: %s \n",selected_IMUs{i},fields{j})
        [tau.(selected_IMUs{i}), adev.(selected_IMUs{i}), avar.(selected_IMUs{i}),...
        adev_upperbound.(selected_IMUs{i}),adev_lowerbound.(selected_IMUs{i}),...
        numSamples.(selected_IMUs{i})] = ...
                                        compute_experimental_AD_curves(eval(selected_IMUs{i}+".Data.(fields{j})"),AD_config.Fs.(selected_IMUs{i}));
        try
            [N.(selected_IMUs{i}),tauN.(selected_IMUs{i}),...
                lineN.(selected_IMUs{i}), K.(selected_IMUs{i}), ...
                tauK.(selected_IMUs{i}), lineK.(selected_IMUs{i}),...
                B.(selected_IMUs{i}), tauB.(selected_IMUs{i}), ...
                lineB.(selected_IMUs{i})] = compute_noise_parameters_from_AD(adev.(selected_IMUs{i}), tau.(selected_IMUs{i}));
        catch
            warning("problem computing the allan deviation parameters for %s axis",fields{j});
            N.(selected_IMUs{i}) = nan;
            tauN.(selected_IMUs{i}) = nan;
            lineN.(selected_IMUs{i}) = nan;
            lineK.(selected_IMUs{i}) = nan;
            lineB.(selected_IMUs{i}) = nan;
            K.(selected_IMUs{i}) = nan;
            B.(selected_IMUs{i}) = nan;
            tauB.(selected_IMUs{i}) = nan;
            tauK.(selected_IMUs{i}) = nan;
        end

        NoiseParams.(selected_IMUs{i}).datafile = AD_config.data.filenames.(selected_IMUs{i});
        NoiseParams.(selected_IMUs{i}).comment = comment;
        NoiseParams.(selected_IMUs{i}).(fields{j}) = [N.(selected_IMUs{i}),...
                                                      K.(selected_IMUs{i}),...
                                                      B.(selected_IMUs{i})];
        fig = figure(j);
    
        %VN-100
        h = loglog(tau.(selected_IMUs{i}),...
                       adev.(selected_IMUs{i}),...
                       string(colors(index(i))),...
                       'LineWidth',3,...
                       'DisplayName',selected_IMUs{i});
        hold on
        axis auto
        ylim([10e-6 10e-2]);
        xlabel('\tau (sec)','FontSize',16)
        ylabel('\sigma(\tau)','FontSize',16)
        legend('FontSize',16,...
                'Interpreter','none',...
                'Location','bestoutside')
        legend('boxoff')
        title(sprintf('Allan Deviation: \n %s', fields{j}),...
            'FontSize',16, 'Interpreter','none')
    end
    grid on
    grid minor
    if save_flag
        %set(fig,'color','none');
        saveas(fig,...
               fullfile(output_plot_image_folder,...
               strcat("AD_experimental-",...
               fields{j},'.pdf')));
           
        write_AD_params_to_file(output_parameter_folder,...
                            selected_IMUs,...
                            fields{j},...
                            N,...
                            K,...
                            B,...
                            tauB)
        fprintf("Axis %s complete \n\n",fields{j})
        save(fullfile(output_parameter_folder,...
            noise_parameter_file),...
            "NoiseParams");
    if i == 1
     mark_parameters_AD_curve(tauB.(selected_IMUs{i}),...
                              B.(selected_IMUs{i}),...
                              tauN.(selected_IMUs{i}),...
                              N.(selected_IMUs{i}),...
                              tauK.(selected_IMUs{i}),...
                              K.(selected_IMUs{i}),...
                              tau.(selected_IMUs{i}),...
                              lineB.(selected_IMUs{i}),...
                              lineK.(selected_IMUs{i}),...
                              lineN.(selected_IMUs{i}))
    end

    end
end 


