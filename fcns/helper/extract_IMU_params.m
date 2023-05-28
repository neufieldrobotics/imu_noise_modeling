function params = extract_IMU_params(IMU_params)
    params.SigmaWhite.gyro = IMU_params.Gyroscope.NoiseDensity;
    params.SigmaWhite.acc  = IMU_params.Accelerometer.NoiseDensity;
    
    
    params.SigmaBrown.gyro = IMU_params.Gyroscope.RandomWalk;
    params.SigmaBrown.acc  = IMU_params.Accelerometer.RandomWalk;
    
    
    params.SigmaPink.gyro = IMU_params.Gyroscope.BiasInstability;
    params.SigmaPink.acc  = IMU_params.Accelerometer.BiasInstability;
    
    params.tau1.gyro = IMU_params.Gyroscope.tau1;
    params.tau2.gyro = IMU_params.Gyroscope.tau2;
    
    params.tau1.acc  = IMU_params.Accelerometer.tau1;
    params.tau2.acc  = IMU_params.Accelerometer.tau2;
    
    params.b_on.gyro = IMU_params.Gyroscope.b_on;
    params.b_on.acc = IMU_params.Accelerometer.b_on;
end