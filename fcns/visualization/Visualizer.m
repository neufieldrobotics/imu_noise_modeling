classdef Visualizer
    %VISUALIZER Collection of methods for plotting IMU simulation data
    %   Detailed explanation goes here
    
    methods(Static)
              
        function fh = plot_state_vector(t,X)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            fh = figure;
            title('Dead reckoning of noisy IMU with ideal model');
            [M,N] = size(X);
            w_R_i = zeros(3,3,M);
            euler_angle = zeros(length(t),3);
            p_w = X(:,13:15);
            v_w = X(:,10:12);
            for i = 1:M
                w_R_i(:,:,i) = ODE_Utility.form_rotation_mat(X(i,:)');
                euler_angle(i,:) = rad2deg(wrapTo2Pi(rotm2eul(w_R_i(:,:,i))));
                a = rad2deg((rotm2eul(w_R_i(:,:,i))));
                euler_angle(i,2) = a(2);
            end
            Visualizer.plot_pose(fh,t,p_w,v_w,euler_angle); 
            if N > 15
                i_b_g = X(:,16:18);
                i_b_a = X(:,19:21);
                Visualizer.plot_bias(fh,t,i_b_g,i_b_a);
            end
            sgtitle('Evolution of state vector of IMU');
        end
        
        function plot_pose(fh,t,p_w,v_w,euler_angle)
            gcf;
            subplot('Position',[.1 .05 .3 .25]);
            s = stackedplot(t,euler_angle);
            s.DisplayLabels = {'theta_z (deg)','theta_y(deg)','theta_x(deg)'};
            s.GridVisible ='on';
%             s.AxesProperties(1).YLimits = [-5e-3 5e-3];
%             s.AxesProperties(2).YLimits = [-5e-3 5e-3];
%             s.AxesProperties(3).YLimits = [-5e-3 5e-3];
            title('Rotation vs time');
            xlabel('Time (s)');
 
            
            subplot('Position',[.1 .4 .3 .25]);
            s = stackedplot(t,v_w);
            s.DisplayLabels = {'v_x (m/s)','v_y(m/s)','v_z(m/s)'};
            s.GridVisible ='on';
            title('Velocity vs time');
            xlabel('Time (s)')

            
            subplot('Position',[.1 .7 .3 .25]);
            s = stackedplot(t,p_w);
            s.DisplayLabels = {'p_x (m)','p_y(m)','p_z(m)'};
            s.GridVisible ='on';
            title('Position vs time');
            xlabel('Time (s)')

             
        end
        
        function plot_bias(fh,t,i_b_g,i_b_a)
            gcf;
            subplot('Position',[.5 .15 .3 .25]);
            s = stackedplot(t,i_b_g);
            s.DisplayLabels = {'b_x (rad/s)','b_y(rad/s)','b_z(rad/s)'};
            s.GridVisible ='on';
            title('Gyro bias vs time');
            xlabel('Time (s)')
            
            subplot('Position',[.5 .5 .3 .25]);
            s = stackedplot(t,i_b_a);
            s.DisplayLabels = {'b_x (rad/s)','b_y(rad/s)','b_z(rad/s)'};
            s.GridVisible ='on';
            title('Acc bias vs time');
            xlabel('Time (s)');
        end
        
%         function plot_monte_carlo_sim_data(MonteCarloSim)
%             Visualizer.plot_position_mc_sim(MonteCarloSim);
%             Visualizer.plot_velocity_mc_sim(MonteCarloSim);
%             Visualizer.plot_orientation_mc_sim(MonteCarloSim);
%         end
%         
%         function plot_position_mc_sim(MonteCarloSim)
%            figure
%            
%            end 
%         end
%         
        function set_plot_properties()
            grid on
            grid minor
        end
               
        function [h1,h2,h3] = stacked_plot(t,data,linespec,use_noise_colors)
            [M,N] = size(data);
            h1 = subplot(3,1,1); 
            plot(t,data(:,1),linespec{1},'MarkerSize',2,'LineWidth',3);
            if use_noise_colors==1
                colororder([0.6350,0.0780,0.1840;...
                            1,0,1;...
                            0,0.4470,0.7410])
            else
                colororder([0.83 0.14 0.14;...
                            1.00 0.54 0.00;...
                            0.47 0.25 0.80;...
                            0.25 0.80 0.54]);
            end
            
            hold on;
            
            h2 = subplot(3,1,2);
            plot(t,data(:,2),linespec{2},'MarkerSize',2,'LineWidth',3);
            if use_noise_colors==1
                colororder([0.6350,0.0780,0.1840;...
                            1,0,1;...
                            0,0.4470,0.7410])
            else
                colororder([0.83 0.14 0.14;...
                            1.00 0.54 0.00;...
                            0.47 0.25 0.80;...
                            0.25 0.80 0.54]);
            end
            
            hold on;
            
            h3 = subplot(3,1,3);
            plot(t,data(:,3),linespec{3},'MarkerSize',2,'LineWidth',3);
            if use_noise_colors==1
                colororder([0.6350,0.0780,0.1840;...
                            1,0,1;...
                            0,0.4470,0.7410])
            else
                colororder([0.83 0.14 0.14;...
                            1.00 0.54 0.00;...
                            0.47 0.25 0.80;...
                            0.25 0.80 0.54]);
            end
            
            hold on;
            
        end
        
        function format_plot(h,plt_fmt,y_limits)
            xlabel(h,plt_fmt.label.x,'FontSize',14);
            ylabel(h,plt_fmt.label.y,'FontSize',14);
            if ~isempty(plt_fmt.title)
                title(h,plt_fmt.title,'Interpreter','latex');
            end
            h.FontSize = 14;
            if ~ isempty(y_limits)
                ylim(h, y_limits);
            else
                axis auto
            end
            if (isfield(plt_fmt,'fields'))
                if ~isempty(plt_fmt.('fields'))
                    l = legend(h,plt_fmt.fields,'Location',...
                              'bestoutside','Box',...
                              'off','FontSize',14);
                     set(l,'Interpreter','latex');
                end
            end
            grid(h,'on');
            grid(h,'minor');
        end
        
        function euler_angles = to_euler_angle(mc_sim_data)
            [M,N,P] = size(mc_sim_data);
            euler_angles = zeros(M,3,P);
            for p = 1:P
                p
                for m = 1:M
                    w_R_i = ODE_Utility.form_rotation_mat(mc_sim_data(m,:,p));
                    euler_angles(m,:,p) = rad2deg(wrapTo2Pi(rotm2eul(w_R_i)));
                    a = rad2deg((rotm2eul(w_R_i)));
                    euler_angles(m,2,p) = a(2);
                end
            end
        end
    end
end

