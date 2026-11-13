clear; clc;
%material: 6061-T6 Aluminum
mu_sigma = 310e6;
sigma_sigma = 10e6;% standard dev of UTS[10 MPa]
%geometry(circular, ASTM E8)
D_nom = 0.5 * 0.0254;% Nominal diameter(m)
delta_D = 0.0005 * 0.0254; %Uncertainty in diameter(m)
%number of Monte Carlo iterations
N = 100000;
%preallocate array for failure loads
F_fail = zeros(N, 1);
%Monte Carlo loop
% for each iteration generate random sigma and D, then compute F.
% using randn() to generate standard normal deviations
for i = 1:N
    sigma_i = mu_sigma + sigma_sigma * randn;
    D_i = D_nom + delta_D * randn;
    % Cross-sectional area of round specimen
    A_i = pi * (D_i^2) / 4;
    F_fail(i) = sigma_i * A_i;
end
%computing Monte Carlo mean
F_mean_MC = mean(F_fail);
F_mean_lbf = F_mean_MC * 0.224809;% convert to lbf
%theoretical deterministic failure load
A_nom = pi * (D_nom^2) / 4;
F_theory = mu_sigma * A_nom;
F_theory_lbf = F_theory * 0.224809;
%display results to command window
fprintf('========== Monte Carlo Simulation Results ==========\n');
fprintf('Number of iterations: %d\n', N);
fprintf('Theoretical failure load (mean sigma, nominal D): %.0f N (%.0f lbf)\n', ...
        F_theory, F_theory_lbf);
fprintf('Monte Carlo mean failure load: %.0f N (%.0f lbf)\n', F_mean_MC, F_mean_lbf);
fprintf('Difference (MC - Theory): %.1f N (%.1f lbf) = %.2f%%\n', ...
        F_mean_MC - F_theory, (F_mean_MC - F_theory)*0.224809, ...
        (F_mean_MC/F_theory - 1)*100);

%plot 
figure;
histogram(F_fail, 50, 'FaceColor', [0.2 0.6 0.8], 'EdgeColor', 'k');
xlabel('Failure Load (N)');
ylabel('Frequency');
title(sprintf('Monte Carlo Distribution of Failure Load (N = %d)', N));
grid on;
hold on;
xline(F_theory, 'r--', 'LineWidth', 1.5, 'Label', 'Theoretical mean');
xline(F_mean_MC, 'g-', 'LineWidth', 1.5, 'Label', 'Monte Carlo mean');
legend;
