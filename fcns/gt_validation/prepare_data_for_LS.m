function [A, b] = prepare_data_for_LS(DataForYPR_deadreckoning, m, n, v_0)
    % Function Name: prepare_data_for_LS
    %
    % Description: Compose the A and b matrices to solve the Least Squares
    % problem Ax = b, where x is accelerometer bias
    %
    % Inputs:
    %     DataForYPR_deadreckoning - data struct containing aligned,
    %     interpolated, clipped positioning data from optitrack and IMU
    %
    %     m - number of IMU samples per segment
    %
    %     n - number of segments we will use for bias estimation up to
    %     integration start point
    %
    % Author: Ben Deming
    % Date: 12/8/2021
    

    start_ind = 1;
    end_ind = m*(n+1);
    
    [cum_pos_x, cum_pos_y, cum_pos_z] = cum_sum_integration(start_ind, end_ind, DataForYPR_deadreckoning);

    beta = zeros(3*n, 1); % vector containing position from integrated accelerometer. [x1; y1; z1; x2; y2; ...]
    %beta(1:3) = [cum_pos_x(1); cum_pos_y(1); cum_pos_z(1)];
    
    p_gt = zeros(3*n, 1); % vector containing position from ground truth. [x1; y1; z1; x2; y2; ...]
    %p_gt(1:3) = DataForYPR_deadreckoning.gt.position_w(1,:)';

    beta_ind = 1;
     for k = m+1:m:m*(n+1)

         beta(beta_ind:beta_ind+2) = [cum_pos_x(k); cum_pos_y(k); cum_pos_z(k)];  
         p_gt(beta_ind:beta_ind+2) = DataForYPR_deadreckoning.gt.position_w(k,:)';

         beta_ind = beta_ind + 3;

     end


    d_int_R_cum = zeros(3*m*(n+1), 3); % twice integrated (cumulative) R matrix
    int_R_cum = zeros(3*m*(n+1),3); % once integrated (cumulative) R matrix
    
    int_R_cum(1:3,:) = zeros(3,3);%quat2rotm(DataForYPR_deadreckoning.IMU.quaternion_w(1,:)) / 400;
    d_int_R_cum(1:3,:) = int_R_cum(1:3,:);

    quat_ind = 1;

    for j = 4:3:3*m*n+3
         R = quat2rotm(DataForYPR_deadreckoning.IMU.quaternion_w(quat_ind,:));
         
         int_R_cum(j:j+2,:) = int_R_cum(j-3:j-1,:) + R / 400;
         
         d_int_R_cum(j:j+2,:) = d_int_R_cum(j-3:j-1,:) + int_R_cum(j:j+2,:) / 400;

         quat_ind = quat_ind + 1;
     end

     alpha = zeros(3*n, 3); % matrix containing cumulative twice integrated R's between two consecutive k intervals
     %alpha(1:3,:) = d_int_R_cum(1:3,:);
     alpha_ind = 1;

     for k = 3*m+1:3*m:3*m*(n+1)

         alpha(alpha_ind:alpha_ind+2,:) = d_int_R_cum(k:k+2,:);

         alpha_ind = alpha_ind + 3;
     end


     A = zeros(3*n, 3*n);
     A_ind = 1;

     for l = 1:3:3*n
         for p = l:3:3*n
            A(p:p+2,l:l+2) = alpha(A_ind:A_ind+2,:);
         end
         A_ind = A_ind + 3;
     end

     delta_t = DataForYPR_deadreckoning.gt.time(end_ind) - ...
               DataForYPR_deadreckoning.gt.time(start_ind);
           
     b = zeros(3*n, 1);
     for i = 1:3:3*n
         b(i:i+2) = -p_gt(i:i+2) -v_0*delta_t + p_gt(1:3) + beta(i:i+2);
     end
     
end

