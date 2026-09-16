classdef IIS_Simulator < MPCTAbstractSimulator
    % IIS_Simulator Implicit Invariant Sets simulator
        
    properties
        x_ref_real (:,:) double {mustBeReal} % real state reference
        u_ref_real (:,:) double {mustBeReal} % real input reference
    end
    
    methods
        function obj = IIS_Simulator(N_sim, x0, u0, T_sample, x_ref_real, u_ref_real)
            % IIS_Simulator constructor
            %
            % Input arguments:
            % N_sim (int) = 
            % x0 (m,1) = initial state value
            % u0 (n,1) = initial input value
            % T_sample (int) = sampling time
            % x_ref_real = real state reference
            % u_ref_real = real input reference

            arguments
                N_sim (1,1) double {mustBeInteger, mustBePositive}
                x0 (:,1) double {mustBeReal}
                u0 (:,1) double {mustBeReal}
                T_sample (1,1) double {mustBePositive}
                x_ref_real (:,:) double {mustBeReal}
                u_ref_real (:,:) double {mustBeReal}
            end
            
            obj@MPCTAbstractSimulator(N_sim, x0, u0, T_sample);
            
            obj.x_ref_real = x_ref_real;
            obj.u_ref_real = u_ref_real;
        end

        function [X_history, U_history, Theta_history] = run_simulation(obj, plant, controller)
            % run_simulation runs the current simulator class for the given
            % plant and controller objects
            %
            % Input arguments:
            % plant (IIS_Simulator) = plant model
            % controller (IIS_Controller) = controller model
            %
            % Output values:
            % X_history (plant.dx, total_steps) = evolution of plant state
            % U_history (plant.du, total_steps) = evolution of input space
            % Theta_history = evolution of augmented theta

            num_iter = obj.coef_time * 100 / obj.T_sample;
            total_steps = num_iter * obj.N_ref;

            % X and U evolution history
            X_history = zeros(plant.dx, total_steps + 1);
            U_history = zeros(plant.du, total_steps);
            Theta_history = zeros(size(controller.M_theta, 2), total_steps);

            % Initial system state.
            x_current = obj.x0;
            X_history(:, 1) = x_current;

            global_step = 1;

            for i = 1 : obj.N_ref
                current_ref = obj.x_ref_real(:, i);

                for k = 1 : num_iter
                    [u_step, theta_step] = mpc_tracking_implicit_invariant_sets(x_current, current_ref, plant, controller);

                    U_history(:, global_step) = u_step;
                    Theta_history(:, global_step) = theta_step;

                    x_current = plant.A * x_current + plant.B * u_step;
                    X_history(:, global_step + 1) = x_current;

                    global_step = global_step + 1;
                end
            end
        end
    end
end

function mustBeSquare(M)
    if size(M, 1) ~= size(M, 2)
        error('Plant:NotSquare', 'Matrix must be square.');
    end
end
