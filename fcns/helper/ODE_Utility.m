classdef ODE_Utility
    %ODE_UTILITY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property1
    end
    
    methods(Static)
        function [R] =  form_rotation_mat(state_vector)
         % INPUT:
         % state_vector - 15x1 column vector, stores R,t

         % OUTPUT:
         % R - Rotation matrix
             R = zeros(3,3);
             R(1,:) = state_vector(1:3)';
             R(2,:) = state_vector(4:6)';
             R(3,:) = state_vector(7:9)';
        end

        function X = form_state_vector(rot_mat)
            X = zeros(9,1);
            X(1:3) = rot_mat(1,:)';
            X(4:6) = rot_mat(2,:)';
            X(7:9) = rot_mat(3,:)';
        end
        
        function print_progress()
        end
    end
end

