function euler_angle = to_euler(quaternion_mat)
    % quaternion order - qw,qx,qy,qz
    euler_angle_unwrapped = quat2eul(quaternion_mat,'XYZ');
    %euler_angle = rad2deg(wrapTo2Pi(euler_angle_unwrapped));
    %euler_angle = selective_wrap2pi(euler_angle_unwrapped);
    euler_angle = rad2deg(unwrap(euler_angle_unwrapped));
    %euler_angle = rad2deg(wrapTo2Pi(euler_angle_unwrapped));
end