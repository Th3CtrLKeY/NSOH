function A_j_i = get_inf_coeff(r, n, area, r_mod)
    % This function calculates the coefficient A_j_i for each point j in the domain
    % with respect to each reference point i.
    % Inputs:
    %   r:      n x n x 3 matrix (jth point, ith reference, [x, y, z] components)
    %   n:      n x n x 3 matrix (normal vector components [x, y, z])
    %   area:   n-element vector containing areas of n panels
    %   r_mod:  n x n matrix containing the mod values of r vectors
    % Outputs:
    %   A_j_i:  n x n matrix of coefficients
    
    % Get the dimensions of the input matrix
    [n_points, n_refs, ~] = size(r);
    
    % Initialize the output matrix
    A_j_i = zeros(n_points, n_refs);
    
    % Loop over each reference point and each domain point
    for i = 1:n_refs
        for j = 1:n_points
            % Extract r_j_i vector (r(j,i,:)) and n_i vector (n(j,i,:))
            r_j_i = squeeze(r(j,i,:));  % [r_x, r_y, r_z]
            n_i = squeeze(n(j,i,:));    % [n_x, n_y, n_z]
            
            % Calculate the dot product of r_j_i and n_i
            dotProduct = dot(r_j_i, n_i);
            
            % Calculate the coefficient A_j_i
            A_j_i(j,i) = (dotProduct / r_mod(j,i)^3) * area(i);
        end
    end
end


% Example dimensions
n = 3;

% Example r matrix (n x n x 3)
r = rand(10, 10, 3);

% Example n matrix (n x n x 3)
n = rand(10, 10, 3);

% Example area vector
area = rand(1, 3);

% Example r_mod matrix (n x n)
r_mod = sqrt(sum(r.^2, 3));  % This is one way to calculate the modulus

% Calculate A_j_i
A_j_i = get_inf_coeff(r, n, area, r_mod);

% Display the result
disp(A_j_i);