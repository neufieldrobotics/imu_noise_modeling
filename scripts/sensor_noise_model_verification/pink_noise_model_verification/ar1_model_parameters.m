% This script generates an AR1 process
% with a given set of parameters and plots
% the output in time domain and also
% on the log log scale of Allan deviation plot.
% This plot is to verify that the peak and 
% correlation time obtained have the implemented relationship

close all
clear all
duration = 5; % hours
sampling_rate = 200; % hz
time_sec = duration*60*60;
num_samples = time_sec*sampling_rate;
sigma_max_actual = 10;
tau_max_actual = 2;

% simulation of AR 1 process
t = linspace(0, time_sec, num_samples);
x = simulate_AR1_process(num_samples,...
                         sampling_rate,...
                         sigma_max_actual,...
                         tau_max_actual);
% plot in time domain only a subsample
figure();
plot(t(1:200000), x(1:200000));
xlabel(" Time (s)")
ylabel(" Noise ")
title("AR(1) process in time domain")

% get allan deviation and plot it.

h = figure()
[avar_actual, tau_actual] = allanvar(x, 'octave', sampling_rate);
loglog(tau_actual, sqrt(avar_actual), '--b')
xlabel('Averaging Time (\tau)')
ylabel("\sigma")
grid on 
grid minor

%% Peak of exponentially correlated markov process 
% 
% For tau much longer than the correlation time:
% the relationship is : allan_var(tau) = (Q.Tc)^2/tau
% Take logarithm on both sides get the equation below.
% log (allan_sigma) = log(Q.sqrt(Tc)) - 1/2 . log(tau/Tc)

% For tau much less than the correlation time:
% the relationship is: allan_var = Q^2. tau/3
% taking logarithms on both sides:
% log(allan_sigma) = log(Q.sqrt(Tc)) + 1/2. log(tau/Tc) - log(3)/2 

% treat A = log(Q.sqrt(Tc)) and B = log(tau/Tc).
% Now this is linear system of equations. 
% Because of these equations, we can see 
% the allan deviation

% for a given Q and T_c, what is the value of the peak 
% and what is the (tau/T_c) ratio?
T_c = tau_max_actual/1.89;
Q = sigma_max_actual/(0.437*sqrt(T_c));

N = 500; % fine grained so we can be as near to the maximum value.
tau = logspace(-2, 3, N);
sigma_var = zeros(N, 1);
for i=1:length(tau)
    expn1 = exp(-tau(i)/T_c);
    expn2 = exp(-2*tau(i)/T_c);
    sigma_var(i) = (Q*T_c)^2/tau(i)*(1 - T_c/(2*tau(i))*(3 - 4*expn1 + expn2)); 
end

[M, i] = max(sigma_var);
allan_sigma_max = sqrt(M);
calculated_tau = tau(i);

hold on
loglog(tau, sqrt(sigma_var))
ytickformat('%g M')
hold on
loglog(calculated_tau, allan_sigma_max, "*r", 'MarkerSize', 16)
loglog(tau(1:i), allan_sigma_max*ones(i),'--r');
text(calculated_tau, allan_sigma_max, num2str(allan_sigma_max));
xlabel("\tau / T_c")
ylabel("\sigma")
ylim([.01, 100])
grid on
legend("first order approximation", "power spectral density")
saveas(h, fullfile("./plot_images/", 'ar1_process.png'));
