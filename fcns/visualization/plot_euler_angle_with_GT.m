function plot_euler_angle_with_GT(dr_imu,opts)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

figure()
time = [];
if strcmp(opts.type,"attitude")
    time = dr_imu.atti_result.t;
    estimated_euler_angle = dr_imu.atti_result.euler_angles_ZYX;
else
    time = dr_imu.result.t;
    estimated_euler_angle = dr_imu.result.euler_angles_DR_ZYX;
end
gt_euler_angle = rad2deg(unwrap(quat2eul(dr_imu.gt.orientation_quat_W,'ZYX')));

labels = {'yaw - z', 'pitch - y', 'roll - x'};
colors = {'r','g','b'};
position_delta = .2;
for i = 1:3
    subplot(3,1,i);
    plot(time,rad2deg(unwrap(estimated_euler_angle(:,i))),strcat(colors{i},'-') ,'LineWidth',2)
    hold on
    plot(dr_imu.gt.time_segment, gt_euler_angle(:,i),'k-', 'LineWidth',2)
    legend(sprintf('%s - %s',opts.sensor_name,opts.type),'GT',...
                'Location','None',...
                'FontSize',14)
    legend('Position',[.9,.95 - position_delta*i,.1,.1]);
    xlabel('time (s)')
    ylabel(sprintf('%s (deg)',labels{i}))
    grid on
    grid minor
end
sgtitle(opts.title)

