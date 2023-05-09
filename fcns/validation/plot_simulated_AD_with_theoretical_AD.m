function h = plot_simulated_AD_with_theoretical_AD(AD_curve)
%COMPARE_SIMULATION_WITH_THEORETICAL_AD Summary of this function goes here
%   Detailed explanation goes here
    h = figure;
    loglog(AD_curve.theoretical.tau,AD_curve.theoretical.adev,"-g",...
            'LineWidth',3);
    hold on;
    loglog(AD_curve.stochastic_model.tau,AD_curve.stochastic_model.adev,...
        "--b",'LineWidth',3);
    xlabel('\tau (s)','FontSize',13)
    ylabel('\sigma(\tau)','FontSize',13)
    
    grid on;
    grid minor
    if strcmp(AD_curve.comment,'w_acc') || strcmp(AD_curve.comment,'w_gyro')
        ylim([10e-7 10e-1]);
        legend('Theoretical','White noise of modeled IMU','FontSize',13);
        title('Comparison of allan deviation - white noise model only','FontSize',13)
    end
    
    if strcmp(AD_curve.comment,'b_acc') || strcmp(AD_curve.comment,'b_gyro')
        ylim([10e-7 10e-1]);
        legend('Theoretical','Brown noise of modeled IMU','FontSize',13);
        title('Comparison of allan deviation - Brown noise model only','FontSize',13)
    end
    
    if strcmp(AD_curve.comment,'p_acc') || strcmp(AD_curve.comment,'p_gyro') 
        ylim([10e-7 10e-1]);
        legend('Theoretical','Pink noise of modeled IMU','FontSize',13);
        title('Comparison of allan deviation - pink noise model only','FontSize',13)
    end
    if strcmp(AD_curve.comment,'wbp_acc') || strcmp(AD_curve.comment,'wbp_gyro')
        ylim([10e-5 10e-1]);
        legend('Theoretical - all','white-brown-pink additive','FontSize',13,...
            'Interpreter','none');
        title('Comparison of allan deviation complete model',...
            'FontSize',13,...
            'Interpreter','none')
    end
end

% This script plots and compares the results stored for theoretical
% Allan deviation curve, allan deviation curve from MATlab model
% and the Allan deviation curve obtained from our model.
% It compares only white and brown noise model discrepancy. 

% To run this
% script, type on command line 
% >> Compare_models

% Other m-files required: 
% Subfunctions: None
% MAT-files required: simulation_results/sensor_models_ad.mat
% 

% Author: Jagatpreet Nir
% Work address: Northeastern Field Robotics Lab
% email: nir.j@northeastern.edu
% Website: http://www.
% Sept 2020; Last revision: 03-Nov-2020

% clear all
% load('simulation_results/sensor_models_ad.mat');
% style = {'-g','--r','--b'}; 
% % plot white noise model and compare
% value = getfield(simulation_case,f{find(strcmp(f,'w_acc'))});
% if value == 1
%     figure;
%     for i = 1:3
%         loglog(tau{1,i},adev{1,i},style{i},'LineWidth',3);
%         hold on;
%     end
%     
% end
% 
% % plot brown noise model and compare
% value = getfield(simulation_case,f{find(strcmp(f,'b_acc'))});
% if value == 1
%     figure;
%     for i = 1:3
%             loglog(tau{2,i},adev{2,i},style{i},'LineWidth',3);
%             hold on;
%     end
%     xlabel('\tau')
%     ylabel('\sigma(\tau)')
%     legend('Theoretical','brown - our model','brown - matlab model');
%     title('Comparison of allan deviation - brown noise model only')
%     grid on
% end
% 
% % Generate all three curves for Matlab model on same figure:
% figure;
% for i = 1:3
%     loglog(tau{1,3},adev{1,3},'b',...
%            tau{2,3},adev{2,3},'r',...,
%            tau{3,3},adev{3,3},'m',...,
%            'LineWidth',3);  
%     hold on;
% end
% grid on;
% grid minor;
% 
% title('Allan deviation plots of individual noise models for MATLAB IMU model');
% legend('white','brown','pink')