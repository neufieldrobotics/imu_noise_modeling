function createImuYaml()
VN100_data = load('VN100.mat');
Fs = 400;
gyrox = VN100_data.data.gyro.x;
accelx = VN100_data.data.accel.x;

VN100 = struct();

[tau, adev] = AD_Curves(accelx, Fs);
[accel_N, tauN, lineN, accel_K, tauK, lineK, accel_B, tauB, lineB] = noiseParams(adev, tau);
VN100.Accelerometer.MeasurementRange = 160;
VN100.Accelerometer.Resolution = 0.0049;
VN100.Accelerometer.ConstantBias = 0;
VN100.Accelerometer.AxesMisalignment = 0;
VN100.Accelerometer.NoiseDensity = accel_N;
VN100.Accelerometer.BiasInstability = accel_B; 
VN100.Accelerometer.RandomWalk = accel_K;
VN100.Accelerometer.TemperatureBias = 0;
VN100.Accelerometer.TemperatureScaleFactor = 0;

[tau, adev] = AD_Curves(gyrox, Fs);
[gyro_N, tauN, lineN, gyro_K, tauK, lineK, gyro_B, tauB, lineB] = noiseParams(adev, tau);
VN100.Gyroscope.MeasurementRange = 34.9066;
VN100.Gyroscope.Resolution = 0.0011;
VN100.Gyroscope.ConstantBias = 0;
VN100.Gyroscope.AxesMisalignment = 0;
VN100.Gyroscope.NoiseDensity = gyro_N;
VN100.Gyroscope.BiasInstability = gyro_B; 
VN100.Gyroscope.RandomWalk = gyro_K;
VN100.Gyroscope.TemperatureBias = 0;
VN100.Gyroscope.TemperatureScaleFactor = 0;

YAML.write('../IMU_params/VN100_Params.yaml', VN100);

end
