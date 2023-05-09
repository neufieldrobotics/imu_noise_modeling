function [cum_pos_x, cum_pos_y, cum_pos_z] = cum_sum_integration(t_ind, end_ind, DataForYPR_deadreckoning)
global sampled_t
t = DataForYPR_deadreckoning.IMU.time(t_ind:end);
cum_vel_x = cumsum(DataForYPR_deadreckoning.IMU.acc_w(t_ind:end,1)) /400;
cum_vel_y = cumsum(DataForYPR_deadreckoning.IMU.acc_w(t_ind:end,2)) /400;
cum_vel_z = cumsum(DataForYPR_deadreckoning.IMU.acc_w(t_ind:end,3) - 9.81) /400;

cum_pos_x = DataForYPR_deadreckoning.gt.position_w(t_ind,1) + cumsum(cum_vel_x) / 400;
cum_pos_y = DataForYPR_deadreckoning.gt.position_w(t_ind,2) + cumsum(cum_vel_y) / 400;
cum_pos_z = DataForYPR_deadreckoning.gt.position_w(t_ind,3) + cumsum(cum_vel_z) / 400;

error_x = cum_pos_x - DataForYPR_deadreckoning.gt.position_w(t_ind:end,1);
error_y = cum_pos_y - DataForYPR_deadreckoning.gt.position_w(t_ind:end,2);
error_z = cum_pos_z - DataForYPR_deadreckoning.gt.position_w(t_ind:end,3);

figure()
subplot(3,1,1)
plot(t, cum_pos_x, 'LineWidth',2)
xlabel('Time (sec)','FontSize',14)
ylabel('X axis (Meters)','FontSize',14)
title('Cumsum Integration','FontSize',14)
grid on
grid minor

subplot(3,1,2)
plot(t, cum_pos_y, 'LineWidth',2)
xlabel('Time (sec)','FontSize',14)
ylabel('Y axis (Meters)','FontSize',14)
grid on
grid minor

subplot(3,1,3)
plot(t, cum_pos_z, 'LineWidth',2)
xlabel('Time (sec)','FontSize',14)
ylabel('Z axis (Meters)','FontSize',14)
grid on
grid minor


figure()
subplot(3,1,1)
plot(t, error_x, 'LineWidth',2)
xlabel('Time (sec)','FontSize',14)
ylabel('X axis (Meters)','FontSize',14)
title('Error: Cumsum vs GT','FontSize',14)
grid on
grid minor

subplot(3,1,2)
plot(t, error_y, 'LineWidth',2)
xlabel('Time (sec)','FontSize',14)
ylabel('Y axis (Meters)','FontSize',14)
grid on
grid minor

subplot(3,1,3)
plot(t, error_z, 'LineWidth',2)
xlabel('Time (sec)','FontSize',14)
ylabel('Z axis (Meters)','FontSize',14)
grid on
grid minor

figure()
subplot(3,1,1)
plot(t, DataForYPR_deadreckoning.gt.position_w(t_ind:end,1), 'LineWidth',2)
hold on
plot(t,cum_pos_x, 'LineWidth',2)
xlabel('Time (sec)','FontSize',14)
ylabel('X axis (Meters)','FontSize',14')
grid on
title('gt vs dead reckoning','FontSize',14)

subplot(3,1,2)
plot(t,DataForYPR_deadreckoning.gt.position_w(t_ind:end,2), 'LineWidth',2)
hold on
plot(t,cum_pos_y, 'LineWidth',2)
xlabel('Time (sec)','FontSize',14)
ylabel('Y axis (Meters)','FontSize',14)
grid on

subplot(3,1,3)
plot(t,DataForYPR_deadreckoning.gt.position_w(t_ind:end,3), 'LineWidth',2)
hold on
plot(t,cum_pos_z, 'LineWidth',2)
xlabel('Time (sec)','FontSize',14)
ylabel('Z axis (Meters)','FontSize',14)
grid on

end

