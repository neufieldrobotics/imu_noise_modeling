classdef MathFunctions
    %MATHFUNCTIONS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property1
    end
    
    methods(Static)
        function h = skew_mat(x)
            %MATHFUNCTIONS Construct an instance of this class
            %   compute skew matrix from an 3x1 input vector
            h = [0 -x(3) x(2) ;...
                x(3) 0 -x(1) ;...
                -x(2) x(1) 0 ];
        end
        
        function q_dot = eul_to_quat_rate(w,q)
        %   compute quaternion rate from euler angle rate.
        %   INPUT:
        %   q = [q1;q2;q3;q4]; % current quaternion pose
        %   w = [w1;w2;w3]; angular rate in euler angles
        
        %   OUTPUT:
        %   q_dot = [q_dot1;...;q_dot_4]; 4x1 vector- quaternion rate
        
            q_dot = 0.5*[0, w(3), -w(2), w(1);
                        -w(3), 0, w(1), w(2);
                        w(2), -w(1), 0, w(3);
                        -w(1), -w(2), -w(3),0]*q
            
        end
    end
end

