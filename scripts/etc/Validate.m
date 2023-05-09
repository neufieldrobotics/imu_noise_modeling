classdef Validate
    properties 
        gyro
        accel
    end
    
    methods 
        function obj = Validate(imu_params)
            obj.accel = struct();
            obj.gyro = struct();
            
            obj.accel.simulation_data = struct();
            obj.accel.theoretical_data = struct();
            obj.accel.N = imu_params.Accelerometer.NoiseDensity;
            obj.accel.K = imu_params.Accelerometer.RandomWalk;
            obj.accel.B = imu_params.Accelerometer.BiasInstability;
            
            obj.gyro.simulation_data = struct();
            obj.gyro.theoretical_data = struct();
            obj.gyro.N = imu_params.Gyroscope.NoiseDensity;
            obj.gyro.K = imu_params.Gyroscope.RandomWalk;
            obj.gyro.B = imu_params.Gyroscope.BiasInstability;
        end
        
        function obj = compute_the_theoretical_AD_curves(obj)
            
            tau = [.1:.1:1000];
            tau = tau'.*ones(length(tau),3);
            sensor = ["accel","gyro"];
            for i = 1:length(sensor)
                obj.(sensor(i)).theoretical_data.adev_white = (obj.(sensor(i)).N.*1./sqrt(tau));

                obj.(sensor(i)).theoretical_data.adev_brown = (obj.(sensor(i)).K.*sqrt(tau/3));

                % Pink
                adev_pink = zeros(length(tau),3);
                %obj.(sensor(i)).theoretical_data.adev_pink = zeros(length(tau),3);
                tau_cutoff = 1;
                for j = 1:3
                    tau_cutoff = 1;
                    ind = find (tau(:,j) < tau_cutoff);
                    adev_pink(ind,j) = tau(ind,j) * 0.664*obj.(sensor(i)).B(j);
                    ind = find(tau(:,j) >= tau_cutoff) ;
                    adev_pink(ind,j) = sqrt(2*log(2)/pi)*obj.(sensor(i)).B(j);  
                end
                obj.(sensor(i)).theoretical_data.adev_pink = adev_pink;
                obj.(sensor(i)).theoretical_data.adev_all = obj.(sensor(i)).theoretical_data.adev_white + obj.(sensor(i)).theoretical_data.adev_brown + obj.(sensor(i)).theoretical_data.adev_pink; 
                obj.(sensor(i)).theoretical_data.tau = tau;
            end
        end
        
        function obj = simulated_AD_curves(obj, sim_params) 
            imu_noise = ["w","p","b","wbp"];
            for i = 1:length(imu_noise)
                imu_params = YAML.read(strcat('IMU_params/VN_100_models/sim_test_imu_',imu_noise(i),'_gyro.yaml'));
                
                [~,accelSamples,gyroSamples,~] = simulate_imu_motion(imu_params,sim_params);
                
                [gyro_sim_avar, gyro_tau] = allanvar(gyroSamples,'decade',sim_params.SamplingRate);
                [accel_sim_avar, accel_tau] = allanvar(accelSamples,'decade',sim_params.SamplingRate);
                
                gyro_sim_adev = gyro_sim_avar.^0.5;
                accel_sim_adev = accel_sim_avar.^0.5;
                if i ==1
                    obj.gyro.simulation_data.adev_white = gyro_sim_adev;
                    obj.accel.simulation_data.adev_white = accel_sim_adev;
                elseif i ==2
                    obj.gyro.simulation_data.adev_pink = gyro_sim_adev;
                    obj.accel.simulation_data.adev_pink = accel_sim_adev;
                elseif i ==3
                    obj.gyro.simulation_data.adev_brown = gyro_sim_adev;
                    obj.accel.simulation_data.adev_brown = accel_sim_adev;
                else
                    obj.gyro.simulation_data.adev_all = gyro_sim_adev;
                    obj.accel.simulation_data.adev_all = accel_sim_adev;
                end      
            end
            obj.gyro.simulation_data.tau = gyro_tau;
            obj.accel.simulation_data.tau = accel_tau;
        end
    end
end