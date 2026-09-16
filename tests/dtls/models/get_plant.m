function plant = get_plant(data)
    % get_plant Instantiates the IIS_Plant based on the data provided
    %
    % Input arguments:
    % data (struct) = plant data
    %
    % Output arguments:
    % plant (IIS_Plant) = plant object

    arguments
        data struct
    end

    arguments (Output)
        plant IIS_Plant
    end
    
    % Create MPT3 Polyhedrons for state and input bounds
    X = Polyhedron('lb', data.lb_x, 'ub', data.ub_x);
    U = Polyhedron('lb', data.lb_u, 'ub', data.ub_u);

    X_sym = X;
    U_sym = U;
    
    % Instantiate the plant
    plant = IIS_Plant(data.A, data.B, data.C, data.D, data.ux0, ...
                      X, U, X_sym, U_sym, data.T_sample);
end