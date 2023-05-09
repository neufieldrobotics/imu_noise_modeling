function [x] = simulate_AR1_process(M, sampling_rate, sigma_max, tau)
%SIMULATE_AR1_PROCESS function that simulates an AR1 process.
%   An AR1 process is a random process defined by equation
% dx/dt = -1/T.x + Q.n
% where n is gaussian random variable driving the process.
% this is an exponentially decaying autoregressive term with driver white
% noise term. 
% T = tau/1.89; tau is the correlation period in Allan deviation plot.
% Q = sigma/(0.437*sqrt(T))
% M is the number of samples for the AR1 process.
% 
% returns x : the output AR1 random process. 
del_t = 1/sampling_rate;
n = randn(M, 1); % driven noise
b_0 = 0;

T = tau/1.89;
Q = sigma_max/(0.437*sqrt(T));

% preallocate
x = zeros(M, 1);
% discrete implementation of the differential equation. 
% first order approximation. 
% x(n+1) = x(n) * exp((-1/tau) * dt) + N(mu,sigma) * dt
% For small time periods, it is fair to assume
% exp(-dt/tau) = (1 - dt/tau)
% This can be obtained by Taylor's expansion.
for i = 1:M
    if i == 1
        x(i) = b_0;
    else
        x(i) = x(i-1) - del_t/T*x(i-1) + del_t*Q*n(i);
    end
end
x = x/sqrt(del_t);

% Definition of first order gauss markov process in terms
% autocorrelation function.
% sigma is the entire process variation
% Rxx = (sigma^2) * exp(-beta * tau)

