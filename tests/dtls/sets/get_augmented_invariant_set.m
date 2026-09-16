function set = get_augmented_invariant_set(plant, controller)
    % get_augmented_invariant_set Computes the augmented invariant set
    %
    % Input arguments:
    % plant (MPCTAbstractPlant) = plant model
    % controller (MPCTAbstractController) = controller model
    %
    % Output arguments:
    % set (Polyhedron) = augmented invariant set
    
    arguments (Input)
        plant IIS_Plant
        controller IIS_Controller
    end
    arguments (Output)
        set Polyhedron
    end

    %% Define system
    M_theta_size = size(controller.M_theta, 2);
    M_theta_x = controller.M_theta(1:plant.dx, :);
    M_theta_u = controller.M_theta(plant.dx + 1 : end, :);
    L = M_theta_u - controller.K * M_theta_x;
    
    % taken from 7)
    A_aug = [
        plant.A + plant.B * controller.K, plant.B * L;
        zeros(M_theta_size, plant.dx), eye(M_theta_size)
    ];
    system = LTISystem('A', A_aug);

    set = system.invariantSet('X', controller.X_aug_t);
end