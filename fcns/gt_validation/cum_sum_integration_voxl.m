function [cum_pos_x, cum_pos_y, cum_pos_z] = cum_sum_integration_voxl(acc_segment_bias_compensated, ...
                                                                      IC,...
                                                                      g,...
                                                                      Fs)


    % INTEGRATE ACCELEROMETER IN WORLD FRAME

    cum_vel_x = IC.v_w_0(1) + cumsum(acc_segment_bias_compensated(:,1) - g(1)) / Fs;
    cum_vel_y = IC.v_w_0(2) + cumsum(acc_segment_bias_compensated(:,2) - g(2)) / Fs;
    cum_vel_z = IC.v_w_0(3) + cumsum(acc_segment_bias_compensated(:,3) - g(3)) / Fs;

    cum_pos_x = IC.p_w_0(1) + cumsum(cum_vel_x) / Fs;
    cum_pos_y = IC.p_w_0(2) + cumsum(cum_vel_y) / Fs;
    cum_pos_z = IC.p_w_0(3) + cumsum(cum_vel_z) / Fs;
end
% t = t_segment;
% figure()
% subplot(3,1,1)
% plot(t, cum_pos_x, 'LineWidth',2)
% xlabel('Time (sec)','FontSize',14)
% ylabel('X axis (Meters)','FontSize',14)
% title('Cumsum Integration','FontSize',14)
% grid on
% grid minor
% 
% subplot(3,1,2)
% plot(t, cum_pos_y, 'LineWidth',2)
% xlabel('Time (sec)','FontSize',14)
% ylabel('Y axis (Meters)','FontSize',14)
% grid on
% grid minor
% 
% subplot(3,1,3)
% plot(t, cum_pos_z, 'LineWidth',2)
% xlabel('Time (sec)','FontSize',14)
% ylabel('Z axis (Meters)','FontSize',14)
% grid on
% grid minor
% 
% 
% figure()
% subplot(3,1,1)
% plot(t, error_x, 'LineWidth',2)
% xlabel('Time (sec)','FontSize',14)
% ylabel('X axis (Meters)','FontSize',14)
% title('Error: Cumsum vs GT','FontSize',14)
% grid on
% grid minor
% 
% subplot(3,1,2)
% plot(t, error_y, 'LineWidth',2)
% xlabel('Time (sec)','FontSize',14)
% ylabel('Y axis (Meters)','FontSize',14)
% grid on
% grid minor
% 
% subplot(3,1,3)
% plot(t, error_z, 'LineWidth',2)
% xlabel('Time (sec)','FontSize',14)
% ylabel('Z axis (Meters)','FontSize',14)
% grid on
% grid minor
% 
% figure()
% subplot(3,1,1)
% plot(t, DataForYPR_deadreckoning.gt.position_w(t_ind:end,1), 'LineWidth',2)
% hold on
% plot(t,cum_pos_x, 'LineWidth',2)
% xlabel('Time (sec)','FontSize',14)
% ylabel('X axis (Meters)','FontSize',14')
% grid on
% title('gt vs dead reckoning','FontSize',14)
% 
% subplot(3,1,2)
% plot(t,DataForYPR_deadreckoning.gt.position_w(t_ind:end,2), 'LineWidth',2)
% hold on
% plot(t,cum_pos_y, 'LineWidth',2)
% xlabel('Time (sec)','FontSize',14)
% ylabel('Y axis (Meters)','FontSize',14)
% grid on
% 
% subplot(3,1,3)
% plot(t,DataForYPR_deadreckoning.gt.position_w(t_ind:end,3), 'LineWidth',2)
% hold on
% plot(t,cum_pos_z, 'LineWidth',2)
% xlabel('Time (sec)','FontSize',14)
% ylabel('Z axis (Meters)','FontSize',14)
% grid on
% 
% end

