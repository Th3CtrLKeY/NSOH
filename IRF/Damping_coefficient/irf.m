% MATLAB code to calculate damping coefficients B(τ)
clc;
clear;

% Load the input matrix from a CSV file or other source
% Example: Assume 'data.csv' contains the matrix with columns:
% Frequency | b_33 | b_35 | b_53 | b_55
inputMatrix = load('data.csv'); 

% Extract columns from the input matrix
frequency = inputMatrix(:, 1); % First column: frequency (ω)
b_33 = inputMatrix(:, 2);      % Second column: b_33 values
b_35 = inputMatrix(:, 3);      % Third column: b_35 values
b_53 = inputMatrix(:, 4);      % Fourth column: b_53 values
b_55 = inputMatrix(:, 5);      % Fifth column: b_55 values

% Load the τ matrix from a CSV file (assuming it is in a single column)
tau_values = readmatrix('tau_values.csv');  % Adjust file name if necessary

% Initialize variables
N = length(frequency); % Number of frequency rows
num_tau = length(tau_values); % Number of τ values

% Preallocate arrays for storing damping coefficients
B_33 = zeros(num_tau, 1);
B_35 = zeros(num_tau, 1);
B_53 = zeros(num_tau, 1);
B_55 = zeros(num_tau, 1);

% Loop through each τ value
for t = 1:num_tau
    tau = tau_values(t); % Current τ value
    
    % Initialize integrals for this τ
    I_33 = zeros(N, 1);
    I_35 = zeros(N, 1);
    I_53 = zeros(N, 1);
    I_55 = zeros(N, 1);
    
    % Compute integrals for each frequency interval
    for i = 2:N
        omega_prev = frequency(i-1); % Lower bound of frequency interval
        omega_curr = frequency(i);   % Upper bound of frequency interval
        
        % Extract b(ω) values for the current interval
        b33_vals = b_33(i-1:i);
        b35_vals = b_35(i-1:i);
        b53_vals = b_53(i-1:i);
        b55_vals = b_55(i-1:i);
        
        % Calculate the integral for each mode using interpolation
        I_33(i) = integral(@(omega) interp1([omega_prev, omega_curr], b33_vals, omega) .* cos(omega * tau), omega_prev, omega_curr);
        I_35(i) = integral(@(omega) interp1([omega_prev, omega_curr], b35_vals, omega) .* cos(omega * tau), omega_prev, omega_curr);
        I_53(i) = integral(@(omega) interp1([omega_prev, omega_curr], b53_vals, omega) .* cos(omega * tau), omega_prev, omega_curr);
        I_55(i) = integral(@(omega) interp1([omega_prev, omega_curr], b55_vals, omega) .* cos(omega * tau), omega_prev, omega_curr);
    end
    
    % Compute the damping coefficients for the current τ
    B_33(t) = (2 / pi) * sum(abs(I_33));
    B_35(t) = (2 / pi) * sum(abs(I_35));
    B_53(t) = (2 / pi) * sum(abs(I_53));
    B_55(t) = (2 / pi) * sum(abs(I_55));
end

% Combine τ and damping coefficients into a single matrix
result_matrix = [tau_values, B_33, B_35, B_53, B_55];

% Export results to a CSV file
writematrix(result_matrix, 'damping_coefficients.csv'); % Export to 'damping_coefficients.csv'

% Display results
fprintf('Damping Coefficients for each τ:\n');
for t = 1:num_tau
    fprintf('τ = %.2f: B_33 = %.4f, B_35 = %.4f, B_53 = %.4f, B_55 = %.4f\n', ...
        tau_values(t), B_33(t), B_35(t), B_53(t), B_55(t));
end