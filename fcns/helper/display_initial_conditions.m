function display_initial_conditions(ic)
    disp('Euler angles')
    disp(rotm2eul(ODE_Utility.form_rotation_mat(ic)));
    
    disp('Initial velocity')
    disp(ic(10:12));
    
    disp('Initial position');
    disp(ic(13:15));
    
    if length(ic) > 15
        disp('Initial gyro bias');
        disp(ic(16:18));
        
        disp('Initial acc bias');
        disp(ic(19:21));
    end
    disp('Press any key to continue');
    pause(.5);

end

