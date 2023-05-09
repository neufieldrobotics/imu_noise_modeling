clear 
close all
clc
load('/media/jagatpreet/Data/datasets/imu_modeling_paper/allan_dev_data/zed_2i.mat')
load('/media/jagatpreet/Data/datasets/imu_modeling_paper/allan_dev_data/XSENSE_data.mat')
XSENSE.Data = robot.imu_data;
load('/media/jagatpreet/Data/datasets/imu_modeling_paper/allan_dev_data/PX4_data.mat')
PX4.Data = PX4_data.Data;
load('/media/jagatpreet/Data/datasets/imu_modeling_paper/allan_dev_data/zed_mini.mat')
icm1000 = load('/media/jagatpreet/Data/datasets/imu_modeling_paper/allan_dev_data/icm42688p_1000hz.mat');
icm200 = load('/media/jagatpreet/Data/datasets/imu_modeling_paper/allan_dev_data/icm42688p_200hz.mat');
load('/media/jagatpreet/Data/datasets/imu_modeling_paper/allan_dev_data/vn100_id4.mat')
%load('/media/jagatpreet/Data/datasets/imu_modeling_paper/allan_dev_data/icm20602.mat')
load('/media/jagatpreet/Data/datasets/imu_modeling_paper/allan_dev_data/voxl_imu0.mat')
load('/media/jagatpreet/Data/datasets/imu_modeling_paper/allan_dev_data/voxl_imu1.mat')
figure
plot(VOXL_IMU1.Data.time, ...
    VOXL_IMU1.Data.angular_velocity_x,'y');
hold on;
plot(VOXL_IMU0.Data.time, ...
    VOXL_IMU0.Data.angular_velocity_x,'k')
hold on;
plot(XSENSE.Data.header_timestamp - XSENSE.Data.header_timestamp(1), ...
    XSENSE.Data.angular_velocity_x,"MarkerFaceColor","#0072BD")
hold on;
plot(icm1000.ICM42688p.Data.time, ...
    icm1000.ICM42688p.Data.angular_velocity_x,'m')
hold on;
plot((0:length(PX4.Data.angular_velocity_x)-1)*(1/250), ...
    PX4.Data.angular_velocity_x,"MarkerFaceColor", "#7E2F8E");
hold on;
plot(ZED_mini.Data.time,ZED_mini.Data.angular_velocity_x,'r');
hold on;
plot(ZED_2i.Data.time,ZED_2i.Data.angular_velocity_x,'g')
hold on;
plot((0:length(VN100_id4.Data.time)-1)*(1/VN100_id4.fs), ...
    VN100_id4.Data.angular_velocity_x,'b')
hold on;
% plot(icm200.ICM42688p.Data.time, ...
%     icm200.ICM42688p.Data.angular_velocity_x,"MarkerFaceColor","#0072BD")
% hold on;


legend('voxl imu1','voxl imu0','XSENSE', 'icm42688p-1000hz', 'px4','zed mini', 'zed 2i','vn100')
title('angular velocity x - rad/s')

figure
plot(VOXL_IMU1.Data.time, ...
    VOXL_IMU1.Data.angular_velocity_y,'y');
hold on;
plot(VOXL_IMU0.Data.time, ...
    VOXL_IMU0.Data.angular_velocity_y,'k');
hold on;
plot(XSENSE.Data.header_timestamp - XSENSE.Data.header_timestamp(1), ...
    XSENSE.Data.angular_velocity_y,"MarkerFaceColor","#0072BD")
hold on;
plot(icm1000.ICM42688p.Data.time, ...
    icm1000.ICM42688p.Data.angular_velocity_y,'m')
hold on;
plot((0:length(PX4.Data.angular_velocity_y)-1)*(1/250), ...
    PX4.Data.angular_velocity_y,"MarkerFaceColor", "#7E2F8E");
hold on;
plot(ZED_mini.Data.time,ZED_mini.Data.angular_velocity_y,'r');
hold on;
plot(ZED_2i.Data.time,ZED_2i.Data.angular_velocity_y,'g')
hold on;
plot((0:length(VN100_id4.Data.time)-1)*(1/VN100_id4.fs), ...
    VN100_id4.Data.angular_velocity_y,'b')
hold on;
% plot(icm200.ICM42688p.Data.time, ...
%     icm200.ICM42688p.Data.angular_velocity_y,"MarkerFaceColor","#0072BD")
% hold on;

legend('voxl imu1','voxl imu0','XSENSE', 'icm42688p-1000hz','px4', 'zed mini', 'zed 2i','vn100')
%legend('zed mini','zed 2i','vn100', 'icm42688p' )
title('angular velocity y - rad/s')


figure
plot(VOXL_IMU1.Data.time, ...
    VOXL_IMU1.Data.angular_velocity_z,'y');
hold on;
plot(VOXL_IMU0.Data.time, ...
    VOXL_IMU0.Data.angular_velocity_z,'k');
hold on;
plot(XSENSE.Data.header_timestamp - XSENSE.Data.header_timestamp(1), ...
    XSENSE.Data.angular_velocity_z,"MarkerFaceColor","#0072BD")
hold on;
plot(icm1000.ICM42688p.Data.time, ...
    icm1000.ICM42688p.Data.angular_velocity_z,'m')
hold on;
plot((0:length(PX4.Data.angular_velocity_z)-1)*(1/250), ...
    PX4.Data.angular_velocity_z,"MarkerFaceColor", "#7E2F8E");
hold on;
plot(ZED_mini.Data.time,ZED_mini.Data.angular_velocity_z,'r');
hold on;
plot(ZED_2i.Data.time,ZED_2i.Data.angular_velocity_z,'g')
hold on;
plot((0:length(VN100_id4.Data.time)-1)*(1/VN100_id4.fs), ...
    VN100_id4.Data.angular_velocity_z,'b');

hold on;
% plot(icm200.ICM42688p.Data.time, ...
%     icm200.ICM42688p.Data.angular_velocity_z,"MarkerFaceColor","#0072BD")
% hold on;


legend('voxl imu1','voxl imu0','XSENSE' ,'icm42688p-1000hz','px4','zed mini','zed 2i','vn100')
%legend('zed mini','zed 2i','vn100', 'icm42688p' )
title('angular velocity z - rad/s')

figure
plot(VOXL_IMU1.Data.time, ...
    VOXL_IMU1.Data.acceleration_x,'y');
hold on;
plot(VOXL_IMU0.Data.time, ...
    VOXL_IMU0.Data.acceleration_x,'k');
hold on;
plot(ZED_mini.Data.time,ZED_mini.Data.acceleration_x,'r');
hold on;
plot(ZED_2i.Data.time,ZED_2i.Data.acceleration_x,'g')
hold on;
plot((0:length(VN100_id4.Data.time)-1)*(1/VN100_id4.fs), ...
    VN100_id4.Data.acceleration_x,'b')
hold on;


% plot(icm200.ICM42688p.Data.time, ...
%     icm200.ICM42688p.Data.acceleration_x,"MarkerFaceColor","#0072BD")
% hold on;
plot(XSENSE.Data.header_timestamp - XSENSE.Data.header_timestamp(1), ...
    XSENSE.Data.acceleration_x,"MarkerFaceColor","#0072BD")
hold on;
plot(icm1000.ICM42688p.Data.time, ...
    icm1000.ICM42688p.Data.acceleration_x,'m')
hold on;
legend('voxl imu1','voxl imu0','zed mini','zed 2i','vn100', 'XSENSE' ,'icm42688p-1000hz')
%legend('zed mini','zed 2i','vn100', 'icm42688p' )
title('acc x - m/s^2')
% 
% figure
% plot(ZED_mini.Data.time,ZED_mini.Data.acceleration_y,'r');
% hold on;
% plot(ZED_2i.Data.time,ZED_2i.Data.acceleration_y,'g')
% hold on;
% plot((0:length(VN100_id4.Data.time)-1)*(1/VN100_id4.fs), ...
%     VN100_id4.Data.acceleration_y,'b')
% hold on;
% % plot(ICM20602.Data.time, ...
% %     ICM20602.Data.angular_velocity_z,'k')
% % hold on;
% plot(ICM42688p.Data.time, ...
%     ICM42688p.Data.acceleration_y,'m')
% legend('zed mini','zed 2i','vn100', 'icm42688p' )
% title('acc y - m/s^2')
% 
% figure
% plot(ZED_mini.Data.time,ZED_mini.Data.acceleration_z,'r');
% hold on;
% plot(ZED_2i.Data.time,ZED_2i.Data.acceleration_z,'g')
% hold on;
% plot((0:length(VN100_id4.Data.time)-1)*(1/VN100_id4.fs), ...
%     VN100_id4.Data.acceleration_z,'b')
% hold on;
% % plot(ICM20602.Data.time, ...
% %     ICM20602.Data.angular_velocity_z,'k')
% % hold on;
% plot(ICM42688p.Data.time, ...
%     ICM42688p.Data.acceleration_z,'m')
% legend('zed mini','zed 2i','vn100', 'icm42688p' )
% title('acc z - m/s^2')
%%%%%%%%%%%%%%%%%%%

figure;
subplot(3,1,1);
plot((0:length(VN100_id4.Data.time)-1)*(1/VN100_id4.fs), ...
    VN100_id4.Data.angular_velocity_x,'b')
hold on;
plot((0:length(PX4.Data.angular_velocity_x)-1)*(1/250), ...
    PX4.Data.angular_velocity_x,"MarkerFaceColor", "#7E2F8E");
hold on;
legend("vn100", "px4")
title("angular_velocity-x")

subplot(3,1,2);
plot((0:length(VN100_id4.Data.time)-1)*(1/VN100_id4.fs), ...
    VN100_id4.Data.angular_velocity_y,'b')
hold on;
plot((0:length(PX4.Data.angular_velocity_y)-1)*(1/250), ...
    PX4.Data.angular_velocity_y,"MarkerFaceColor", "#7E2F8E");
hold on;
legend("vn100", "px4")
title("angular_velocity-y")

subplot(3,1,3);
plot((0:length(VN100_id4.Data.time)-1)*(1/VN100_id4.fs), ...
    VN100_id4.Data.angular_velocity_y,'b')
hold on;
plot((0:length(PX4.Data.angular_velocity_z)-1)*(1/250), ...
    PX4.Data.angular_velocity_z,"MarkerFaceColor", "#7E2F8E");
hold on;
legend("vn100", "px4")
title("angular_velocity-z")


%%%%%%%%%%%%%%%%%%%%%
figure;
subplot(3,1,1);
plot(icm200.ICM42688p.Data.time, ...
    icm200.ICM42688p.Data.angular_velocity_x,"MarkerFaceColor","#0072BD")
hold on;
plot(icm1000.ICM42688p.Data.time, ...
    icm1000.ICM42688p.Data.angular_velocity_x,'m')
hold on;
legend("200hz", "1000hz")
title("angular_velocity-x")




subplot(3,1,2);
plot(icm200.ICM42688p.Data.time, ...
    icm200.ICM42688p.Data.angular_velocity_y,"MarkerFaceColor","#0072BD")
hold on;

plot(icm1000.ICM42688p.Data.time, ...
    icm1000.ICM42688p.Data.angular_velocity_y,'m')
hold on;

legend("200hz", "1000hz")
title("angular_velocity-x")

subplot(3,1,3);
% plot(icm200.ICM42688p.Data.time, ...
%     icm200.ICM42688p.Data.angular_velocity_z,"MarkerFaceColor","#0072BD")
% hold on;

plot(icm1000.ICM42688p.Data.time, ...
    icm1000.ICM42688p.Data.angular_velocity_z,'m')
hold on;

legend("200hz", "1000hz")
title("angular_velocity-x")

figure;
title("Acceleration - x, y and z")

subplot(3,1,1);
plot(icm200.ICM42688p.Data.time, ...
    icm200.ICM42688p.Data.acceleration_x,"MarkerFaceColor","#0072BD")
hold on;
plot(icm1000.ICM42688p.Data.time, ...
    icm1000.ICM42688p.Data.acceleration_x,'m')
hold on;


subplot(3,1,2)
plot(icm200.ICM42688p.Data.time, ...
    icm200.ICM42688p.Data.acceleration_y,"MarkerFaceColor","#0072BD")
hold on;
plot(icm1000.ICM42688p.Data.time, ...
    icm1000.ICM42688p.Data.acceleration_y,'m')
hold on;


subplot(3,1,3)
plot(icm200.ICM42688p.Data.time, ...
    icm200.ICM42688p.Data.acceleration_z,"MarkerFaceColor","#0072BD")
hold on;
plot(icm1000.ICM42688p.Data.time, ...
    icm1000.ICM42688p.Data.acceleration_z,'m')
hold on;
legend("200hz", "1000hz")
