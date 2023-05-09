function [N, tauN, lineN, K, tauK, lineK, B, tauB, lineB] = compute_noise_parameters_from_AD(adev, tau)
    %% Angle Random Walk
    % Find the index where the slope of the log-scaled Allan deviation is equal
    % to the slope specified.
    slopeN = -0.5;
    logtauN = log10(tau);
    logadev = log10(adev);
    dlogadev = diff(logadev) ./ diff(logtauN);
    [~, N_i] = min(abs(dlogadev - slopeN));

    % Find the y-intercept of the line.
    b = logadev(N_i) - slopeN*logtauN(N_i);

    % Determine the angle random walk coefficient from the line.
    logN = slopeN*log(1) + b;
    N = 10^logN;

    %% Bias Instability
    [M, B_i] = min(adev);
    scfB = sqrt(2*log(2)/pi);
    B = M/scfB;
    %% Rate Random Walk 
    % Find the index where the slope of the log-scaled Allan deviation is equal
    % to the slope specified.
    slopeK = 0.5;
    
    % only consider section with tau greater than tauB
    K_i_list = B_i:length(adev); 
    
    logtauK = log10(tau(K_i_list));
    logadev = log10(adev(K_i_list));
    dlogadev = diff(logadev) ./ diff(logtauK);
    [~, K_i] = min(abs(dlogadev - slopeK));
    
    % Find the y-intercept of the line.
    b = logadev(K_i) - slopeK*logtauK(K_i);

    % Determine the rate random walk coefficient from the line.
    logK = slopeK*log10(3) + b;
    K = 10^logK;


    %% Bias Instability 
    % Find the index where the slope of the log-scaled Allan deviation is equal
    % to the slope specified.
    %slopeB = 0;
    %logtauB = log10(tau);
    %logadev = log10(adev);
    
    %dlogadev = diff(logadev) ./ diff(logtauB);
    %[~, i] = min(abs(dlogadev - slopeB));

    % Find the y-intercept of the line.
    %b = logadev(i) - slopeB*logtauB(i);

    % Determine the bias instability coefficient from the line.
    %logB = b - log10(scfB);
    %B = 10^logB

%% Compute tau values

    tauN = 1;
    lineN = N ./ sqrt(tau);

    tauK = 3;
    lineK = K .* sqrt(tau/3);

    tauB = tau(B_i);
    lineB = B * scfB .* ones(size(tau));
end

