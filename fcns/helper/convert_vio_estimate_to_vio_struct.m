function vio_struct = convert_vio_estimate_to_vio_struct(vio_data_matrix,name,type)
    NANOSEC_TO_SEC = 1e-9;
    
    
    vio_struct.name = name;
    vio_struct.comment = " v - [vx,vy,vz], b - [bx,by,bz], g - [gx,gy,gz]";
    if strcmp(type,'vinsmono')
        vio_struct.time = vio_data_matrix(:,1)*NANOSEC_TO_SEC;
    elseif strcmp(type,"mvvislam")
        vio_struct.time = vio_data_matrix(:,1);
    end
    vio_struct.p_x = vio_data_matrix(:,2);
    vio_struct.p_y = vio_data_matrix(:,3);
    vio_struct.p_z = vio_data_matrix(:,4);
    if strcmp(type,'vinsmono')
        vio_struct.q_x = vio_data_matrix(:,6);
        vio_struct.q_y = vio_data_matrix(:,7);
        vio_struct.q_z = vio_data_matrix(:,8);
        vio_struct.q_w = vio_data_matrix(:,5);
    elseif strcmp(type,"mvvislam")
        vio_struct.q_x = vio_data_matrix(:,5);
        vio_struct.q_y = vio_data_matrix(:,6);
        vio_struct.q_z = vio_data_matrix(:,7);
        vio_struct.q_w = vio_data_matrix(:,8);
    end
    vio_struct.v = vio_data_matrix(:,9:11);
    vio_struct.b_a = vio_data_matrix(:,12:14);
    vio_struct.b_g = vio_data_matrix(:,15:17);
    vio_struct.g = vio_data_matrix(:,18:20);
end