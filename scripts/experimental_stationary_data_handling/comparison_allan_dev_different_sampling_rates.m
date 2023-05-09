close all

load('/media/jagatpreet/Data/datasets/imu_modeling_paper/allan_dev_data/vn100_id4.mat')
icm1000 = load('/media/jagatpreet/Data/datasets/imu_modeling_paper/allan_dev_data/icm42688p_1000hz.mat')
icm200 = load('/media/jagatpreet/Data/datasets/imu_modeling_paper/allan_dev_data/icm42688p_200hz.mat')
load('/media/jagatpreet/Data/datasets/imu_modeling_paper/allan_dev_data/voxl_imu1.mat')
[avar_vn100,tau_vn100] = allanvar(VN100_id4.Data.angular_velocity_x,'octave',VN100_id4.fs);
[avar_icm200,tau_icm200] = allanvar(icm200.ICM42688p.Data.angular_velocity_x,'octave',icm200.ICM42688p.fs);
[avar_icm1000,tau_icm1000] = allanvar(icm1000.ICM42688p.Data.angular_velocity_x,'octave',icm200.ICM42688p.fs);
[avar_voxl,tau_voxl] = allanvar(VOXL_IMU0.Data.angular_velocity_x,'octave',VOXL_IMU0.fs);
figure;
loglog(tau_vn100,avar_vn100,tau_icm200,avar_icm200, tau_icm1000, avar_icm1000,tau_voxl,avar_voxl)
xlabel('\tau')
ylabel('\sigma^2(\tau)')
title('Allan Variance - omega x')
grid on
legend('vn100','icm42688p-200hz','icm42688p-1000hz','voxl')

figure
[avar_vn100,tau_vn100] = allanvar(VN100_id4.Data.acceleration_z,'octave',VN100_id4.fs);
[avar_icm200,tau_icm200] = allanvar(icm200.ICM42688p.Data.acceleration_z,'octave',icm200.ICM42688p.fs);
[avar_icm1000,tau_icm1000] = allanvar(icm1000.ICM42688p.Data.acceleration_z,'octave',icm1000.ICM42688p.fs);
[avar_voxl,tau_voxl] = allanvar(VOXL_IMU0.Data.acceleration_z,'octave',VOXL_IMU0.fs);
loglog(tau_vn100,avar_vn100,tau_icm200,avar_icm200, tau_icm1000, avar_icm1000,tau_voxl,avar_voxl)
xlabel('\tau')
ylabel('\sigma^2(\tau)')
title('Allan Variance - acceleration z')
grid on
legend('vn100','icm42688p-200hz','icm42688p-1000hz','voxl')
