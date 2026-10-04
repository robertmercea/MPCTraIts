function data = load_data()
    % load_data Loads the base system matrices and prepares shared
    % dimensions/bounds
    
    % Load raw matrices from the model file
    raw = load('examples/dtls/limon_system.mat', 'A', 'B', 'C');
    
    data.T_sample = 1;
    
    % Discretize matrices
    data.A = (eye(size(raw.A, 1)) + raw.A) * data.T_sample;
    data.B = raw.B * data.T_sample;
    
    % Modify C and D matrices
    data.C = raw.C;
    data.D = zeros(size(data.C, 1), size(data.B, 2));
    
    % Calculate dimensions
    data.dx = size(data.A, 1);
    data.du = size(data.B, 2);
    data.dy = size(data.C, 1);
    
    % Define constraints
    data.lb_x = repelem(-3, data.dx, 1);
    data.ub_x = repelem(3, data.dx, 1);
    data.lb_u = repelem(-2, data.du, 1);
    data.ub_u = repelem(2, data.du, 1);
    
    % Calculate initial input guess
    data.ux0 = (data.lb_u + data.ub_u) / 2;
end