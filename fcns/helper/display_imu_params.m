function display_imu_params(imu_params)
    disp(" VN 100 parameters");
    disp("Accelerometer");
    disp(imu_params.Accelerometer);

    disp("Gyroscope");
    disp(imu_params.Gyroscope);

    disp('Press enter to proceed. and ctrl c to terminate')
    pause(.5);
end
