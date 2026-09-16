function controller = get_controller(plant)
    % get_controller Instantiates the IIS_Controller and calculates its K,
    % P and M_theta values
    %
    % Input arguments:
    % plant (IIS_Plant) = plant model
    %
    % Output arguments:
    % controller (IIS_Controller) = controller object
    
    arguments
        plant IIS_Plant
    end

    arguments (Output)
        controller IIS_Controller
    end
    
    % Define objective matrices
    Q = eye(plant.dx);
    R = eye(plant.du);
    W = eye(plant.dx) * 10000; 
    O = eye(plant.dx); % TODO: figure out what to set as default value
    
    % Define horizon
    N_pred = 10;
    
    % Instantiate the controller
    controller = IIS_Controller(Q, R, W, N_pred, O, 0.99);
    controller.calculate_KP(plant);
    controller.calculate_M_theta(plant);
    controller.calculate_X_aug_t(plant);
    controller.calculate_M_tilde(plant);
end