function [u_out, theta_out] = mpc_tracking_implicit_invariant_sets(...
                                x_k, x_ref, plant, controller)
    % mpc_tracking_implicit_invariant_sets cost function for the MPC for
    % tracking with implicit invariant sets
    %
    % Input arguments:
    % x_k (plant.dx, 1) = current state
    % x_ref (plant.dx, 1) = reference state
    % plant (IIS_Plant) = plant model
    % controller (IIS_Controller) = controller model
    %
    % Output arguments:
    % u_out (plant.du, 1) = next input
    % theta_out = next augmented theta value

    arguments
        x_k (:, 1) double {mustBeReal}
        x_ref (:, 1) double {mustBeReal}
        plant IIS_Plant
        controller IIS_Controller
    end
    
    %% Variables
    import casadi.*;
    solver = casadi.Opti();
    
    % Total horizon
    N_total = controller.N + controller.M_tilde;
    
    M_theta_x = controller.M_theta(1:plant.dx, :);
    M_theta_u = controller.M_theta(plant.dx + 1 : end, :);
    L = M_theta_u - controller.K * M_theta_x;

    % Plant state-space and input-space
    Fx = plant.X.A;
    bx = plant.X.b;
    Fu = plant.U.A;
    bu = plant.U.b;

    %% Solver setup
    x = solver.variable(plant.dx, N_total + 1);
    u = solver.variable(plant.du, N_total);
    theta_a = solver.variable(size(controller.M_theta, 2), 1);

    % Augmented variables
    x_ref_aug = M_theta_x * theta_a;
    u_ref_aug = M_theta_u * theta_a;
    
    % Initial position
    solver.subject_to(x(:, 1) == x_k);

    % Theta validity
    solver.subject_to(Fx * M_theta_x * theta_a <= controller.lambda * bx);
    solver.subject_to(Fu * M_theta_u * theta_a <= controller.lambda * bu);

    for j = 1 : N_total
       % Dynamics
       solver.subject_to(x(:, j + 1) == plant.A * x(:, j) + plant.B * u(:, j));
       
       % Ensuring the state and input stay within bounds
       solver.subject_to(Fx * x(:, j) <= bx);
       solver.subject_to(Fu * u(:, j) <= bu);
    end

    % Ensure final step is within bounds
    solver.subject_to(Fx * x(:, N_total + 1) <= bx);

    for j = controller.N + 1 : N_total
        solver.subject_to(u(:, j) == controller.K * x(:, j) + L * theta_a);
    end

    objective = 0;

    %% Cost function
    for j = 1 : controller.N
        state_error = x(:, j) - x_ref_aug;
        input_error = u(:, j) - u_ref_aug;
        
        objective = objective + state_error' * controller.Q * state_error;
        objective = objective + input_error' * controller.R * input_error;
    end

    % End of prediction horizon
    end_state_err = x(:, controller.N + 1) - x_ref_aug;
    objective = objective + end_state_err' * controller.P * end_state_err;

    aug_state_err = x_ref_aug - x_ref;
    objective = objective + aug_state_err' * controller.O * aug_state_err;

    %% Solver options
    solver.minimize(objective);
    
    p_opts = struct('print_time', false);
    s_opts = struct('print_level', 0);
    solver.solver("ipopt", p_opts, s_opts);
    
    result = solver.solve();
    
    u_out = result.value(u(:, 1));
    theta_out = result.value(theta_a);
end
