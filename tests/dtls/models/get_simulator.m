function simulator = get_simulator(plant)
    % get_simulator Instantiates the IIS_Simulator based on the plant
    % provided
    %
    % Input arguments:
    % plant (IIS_Plant) = plant model
    %
    % Output arguments:
    % simulator (IIS_Simulator) = simulator object

    arguments
        plant IIS_Plant
    end

    arguments (Output)
        simulator IIS_Simulator
    end
    
    N_sim = 100;
    u0 = [-1; 1];
    x0 = repelem(0.33, plant.dx, 1);
    
    % Define the real tracking targets
    x_ref_real = zeros(plant.dx, 1);
    x_ref_real(1:2, 1) = [1.2; 0.8]; 
    
    u_ref_real = zeros(plant.du, 1);
    
    % Instantiate the simulator
    simulator = IIS_Simulator(N_sim, x0, u0, plant.T_sample, ...
                                x_ref_real, u_ref_real);
end