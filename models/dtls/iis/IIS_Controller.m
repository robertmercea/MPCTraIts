classdef IIS_Controller < MPCTAbstractController
    % IIS_Controller Implicit Invariant Sets controller

    properties
        M_tilde (1,1) double {mustBeInteger, mustBePositive} = 1 % Extended horizon value
        M_theta (:,:) double {mustBeReal} % Null-space matrix for [A - In, B] (parameterizes x_s and u_s)
        O (:,:) double {mustBeSquare} % Offset cost weighting matrix
        P (:,:) double % Terminal state weighting matrix
        lambda (1,1) double {mustBePositive, mustBeLessThan(lambda, 1)} = 0.99 % Theta scaling factor
        X_aug_t Polyhedron % Constraints for terminal augmented dynamics
    end
    
    methods
        function obj = IIS_Controller(Q, R, W, N, O, lambda)
            % IIS_Controller constructor
            %
            % Input arguments:
            % Q (n,n) = state weighting matrix
            % R (m,m) = control weighting matrix
            % W = 
            % N (int) = the size of the prediction horizon
            % O (n,n) = offset cost weighting matrix
            % lambda (int) = Theta scaling factor
            

            obj@MPCTAbstractController(Q, R, W, N);
            obj.O = O;
            obj.lambda = lambda;
        end

        function calculate_KP(obj, plant)
            % calculate_KP calculates the feedback-gain matrix K and the
            % terminal state weighting matrix P and stores them in the
            % current controller object
            %
            % Input arguments:
            % plant (MPCTAbstractPlant) = plant model

            [K_dlqr, P, ~] = dlqr(plant.A, plant.B, obj.Q, obj.R);

            obj.K = -K_dlqr;
            obj.P = P;
        end

        function calculate_X_aug_t(obj, plant)
            % calculate_X_aug_t Computes the polygon for the constraints
            % for the terminal augmented dynamics
            %
            % Input arguments:
            % obj (IIS_Controller) = this object
            % plant (MPCTAbstractPlant) = plant model

            arguments (Input)
                obj IIS_Controller
                plant MPCTAbstractPlant
            end

            % controller-related variables
            M_theta_x = obj.M_theta(1:plant.dx, :);
            M_theta_u = obj.M_theta(plant.dx + 1 : end, :);
            L = M_theta_u - obj.K * M_theta_x;
                
            % bounding matrices/vectors
            Fx = plant.X.A;
            bx = plant.X.b;
            Fu = plant.U.A;
            bu = plant.U.b;
            
            % x in X <=> Fx * x <= bx
            % u in U <=> Fu * u <= bu
            % 8) u = K * x + L * theta
            % => Fu * K * x + Fu * L * x <= bu
            % 12) theta in lambda * Theta
            % 11) x_aug in lambda * X => Fx * M_theta_x * theta <= lambda * bx
            % 11) u_aug in lambda * U => Fu * M_theta_u * theta <= lambda * bu
        
            m = size(obj.M_theta, 2);
            qx = size(Fx, 1);
            qu = size(Fu, 1);
        
            A_constr = [
                Fx, zeros(qx, m);
                Fu * obj.K, Fu * L;
                zeros(qx, plant.dx), Fx * M_theta_x;
                zeros(qu, plant.dx), Fu * M_theta_u
            ];
        
            b_constr = [
                bx;
                bu;
                obj.lambda * bx;
                obj.lambda * bu;
            ];
        
            % A_constr * [x; u] <= b_constr
            obj.X_aug_t = Polyhedron('A', A_constr, 'b', b_constr);
        end

        function calculate_M_theta(obj, plant)
            % calculate_M_theta calculates the null-space of [A - In, B]
            % which parameterizes [x_s, u_s] and stores it in the current
            % controller object
            %
            % Input_arguments:
            % plant (MPCTAbstractPlant) = plant model

            steady_state_matrix = [plant.A - eye(size(plant.A, 1)), plant.B];
            obj.M_theta = null(steady_state_matrix);
        end

        function calculate_M_tilde(obj, plant)
            % calculate_M_tilde Calculates the value of the extended
            % prediction horizon by solving LPs
            %
            % Input arguments:
            % plant (MPCTAbstractPlant) = plant model

            arguments (Input)
                obj IIS_Controller
                plant MPCTAbstractPlant
            end

            M_theta_x = obj.M_theta(1:plant.dx, :);
            M_theta_u = obj.M_theta(plant.dx + 1 : end, :);
            L = M_theta_u - obj.K * M_theta_x;

            % as per 22) and 23)
            G_tilde = obj.X_aug_t.A ./ obj.X_aug_t.b;
            
            % as per the note under 24)
            p_tilde = size(G_tilde, 1);

            M_tilde = 1;
            found = false;

            M_theta_size = size(obj.M_theta, 2);
            
            % as per 7)
            A_aug = [
                plant.A + plant.B * obj.K, plant.B * L;
                zeros(M_theta_size, plant.dx), eye(M_theta_size)
            ];

            A_pow = A_aug * A_aug; % A_pow = A_aug ^ (M_tilde + 1)
            epsilon = 1e-5;

            % solve p_tilde LPs and increase M_tilde until all results
            % are less than one
            % as per 29)
            while ~found
                found = true;

                for i = 1 : p_tilde
                    X_aug_t_i = G_tilde(i, :);

                    val = obj.X_aug_t.support((X_aug_t_i * A_pow)');

                    if val > 1 + epsilon
                        found = false;
                        break;
                    end
                end

                A_pow = A_pow * A_aug;
                M_tilde = M_tilde + 1;
            end

            obj.M_tilde = M_tilde;
        end
    end
end

function mustBeSquare(M)
    if size(M, 1) ~= size(M, 2)
        error('Plant:NotSquare', 'Matrix must be square.');
    end
end