function bias = est_bias_at_integration_start(DataForYPR_deadreckoning, m, n, v_0)

[A, b] = prepare_data_for_LS(DataForYPR_deadreckoning, m, n, v_0);

% BIAS IN IMU FRAME
x = inv(A)*b;

% Bias at k=n is the bias at beginning of integration
bias = x(end-2:end)';
end

