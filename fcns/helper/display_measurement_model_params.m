function display_measurement_model_params(testIMU)
    disp('IMU measurement model parameters')
    disp('Sigma White');
    disp(testIMU.SigmaWhite);
    
    disp('Sigma Brown:');
    disp(testIMU.SigmaBrown);
    
    disp('Sigma Pink:');
    disp(testIMU.SigmaPink);
    
    disp('tau:');
    disp(testIMU.tau);
    
    disp('b_on:');
    disp(testIMU.b_on);
    
    disp('Press any key to continue')
    pause(.5);
end