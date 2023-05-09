function [cum_pos_x, cum_pos_y, cum_pos_z] = cum_sum_integration_general(start_ind, ...
                                                                         end_ind,...
                                                                         acc_mat, ...
                                                                         IC, ...
                                                                         fs)


% INTEGRATE ACCELEROMETER IN WORLD FRAME
                                                                     
cum_vel_x = IC.v_n_x + cumsum(acc_mat(start_ind:end_ind,1) - IC.b_n_x) / fs;
cum_vel_y = IC.v_n_y + cumsum(acc_mat(start_ind:end_ind,2)  - IC.b_n_y) / fs;
cum_vel_z = IC.v_n_z + cumsum(acc_mat(start_ind:end_ind,3)  - IC.b_n_z - 9.81) /fs;

cum_pos_x = IC.p_n_x + cumsum(cum_vel_x) / fs;
cum_pos_y = IC.p_n_y + cumsum(cum_vel_y) / fs;
cum_pos_z = IC.p_n_z + cumsum(cum_vel_z) / fs;

end

