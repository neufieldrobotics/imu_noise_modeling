close all
clear all

config_MC_sim_p_senstivity

duration = 5; % hours
sampling_rate = 200; % hz
time_sec = duration*60*60;
num_samples = time_sec*sampling_rate;
sigma_max_actual = 10;
tau_max_actual = 2;


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
loglog(tau, sqrt(sigma_var))
hold on
loglog(calculated_tau, allan_sigma_max, "*r", 'MarkerSize', 16)
loglog(tau(1:i), allan_sigma_max*ones(i),'--r');
text(calculated_tau, allan_sigma_max, num2str(allan_sigma_max));
xlabel("\tau / T_c")
ylabel("\sigma")

grid on
legend("first order approximation", "power spectral density")
%saveas(h, fullfile("./plot_images/", 'ar1_process.png'));

f = linspace(0, 2, 1000);

power_spectral_density1 = ((Q*T_c)^2)./(1 + (2*pi*f*T_c).^2);
power_spectral_density2 = ((2*Q*T_c)^2)./(1 + (2*pi*f*T_c).^2);
figure(2)
plot(f, power_spectral_density1 + power_spectral_density2);
