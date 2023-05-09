function plot_sampled_data(sampled_acc,sampled_gyro,b)
    global sampled_t n_arg
    disp('Standard deviation acceleration measurements (X,Y,Z):');
    disp(std(sampled_acc));
    
    disp('Standard deviation gyroscope measurements (X,Y,Z):');
    disp(std(sampled_gyro));
    
    disp('Press any key to continue');
    pause(.5);
    
    disp('Plotting sampled measurements');
    figure
    subplot(2,2,1);
    s1 = stackedplot(sampled_t,sampled_acc);
    s1.DisplayLabels = {'X (m/s^2)','Y(m/s^2)','Z(m/s^2)'};
    s1.GridVisible ='on';
    xlabel('time(s)');
    title('Sampled accelerations vs time');
    
    subplot(2,2,3);
    s2 = stackedplot(sampled_t,sampled_gyro);
    s2.DisplayLabels = {'omega_X (rad/s)','omega_Y(rad/s)','omega_Z (rad/s)'};
    s2.GridVisible ='on';
    xlabel('time(s)');
    title('Sampled angular velocities vs time');
    
    
    if n_arg ~= 2
        subplot(2,2,2); 
        s2 = stackedplot(sampled_t,b.acc);
        s2.DisplayLabels = {'bias_X (m/s^2)','bias_Y(m/s^2)','bias_Z(m/s^2)'};
        s2.GridVisible ='on';
        xlabel('time(s)');
        title('Bias accelerometer vs time');

        subplot(2,2,4);
        s2 = stackedplot(sampled_t,b.gyro);
        s2.DisplayLabels = {'bias_X (rad/s)','bias_Y(rad/s)','bias_Z (rad/s)'};
        s2.GridVisible ='on';
        xlabel('time(s)');
        title('Bias gyroscope vs time');
    end
    
    disp('Press enter to proceed. and ctrl c to terminate')
    pause(.5);
end