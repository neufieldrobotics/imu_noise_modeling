clear;
close all;

script_paths;
global type
imu_parameter_folder = 'config_files/IMU_params/VN_100_models/';
sim_parameter_filepath = 'config_files/Sim_params/test_motion/stationary.yaml';
type = 'a';
simulation_case = struct('w_acc',1,... %1
                         'b_acc',1,... %2
                         'p_acc',1,... %3
                         'p_acc_1',0,...
                         'w_gyro',0,...%4
                         'b_gyro',0,...%5
                         'p_gyro',0,...%6
                         'wb_acc',0,...%7
                         'wb_acc_gyro',0,...%8
                         'wbp_acc',0,...%9
                         'wbp_acc_1',0,...
                         'wbp_acc_gyro',0); %10
                     
f = fieldnames(simulation_case);
a = [];
for k = 1:length(f)
    f_ = getfield(simulation_case,f{k});
    if  f_ == 1
        a = [a,f(k)];
    end
end
f = a;

for i = 1:length(f)
    imu_parameter_file = strcat('sim_test_imu_',f(i),'.yaml');
    imu_parameter_filepath{i} = fullfile(imu_parameter_folder,imu_parameter_file{1})
    imu_Params{i} = YAML.read(imu_parameter_filepath{i})
    
    [ad_1{i},t{i}] = compute_theoretical_AD_curve_1(imu_Params{i});
    [ad_2{i},t{i}] = compute_theoretical_AD_curve_2(imu_Params{i});
end
tau_1 = t{1}((find(t{2} == 1)));
tau_3 = t{2}((find(t{2} == 3)));
K = ad_1{2}((find(t{2} == 3)));
N = ad_1{1}((find(t{1} == 1)));

style = {'--b','--r','--m','-c','-g'};
legend_strings = {'White','Brown','Pink','white-brown','white-brown-pink'};
figure;
for i = 1:length(f)
    loglog(t{i},ad_1{i},style{i},'Linewidth',2);
    hold on;
end
legend(legend_strings(1:length(f)),'FontSize',13);
xlabel('\tau(s)','FontSize',13)
ylabel('\sigma(\tau)','FontSize',13)
title('Allan Deviation - theoretical','FontSize',13)
grid on

figure;
for i = 1:length(f)
    loglog(t{i},ad_2{i},style{i},'Linewidth',2);
    hold on;
end
loglog(tau_1,N,'.k',tau_3,K,'.k','MarkerSize',20);
legend(legend_strings(1:length(f)),'FontSize',13);
xlabel('\tau(s)','FontSize',13)
ylabel('\sigma(\tau)','FontSize',13)
title('Allan Deviation - theoretical','FontSize',13)
grid on
