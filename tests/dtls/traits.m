%% Initialise data
% Fetch data
data = load_data();

% Sequentially instantiate the architecture components
plant = get_plant(data);
controller = get_controller(plant);
simulator = get_simulator(plant);

% Verify initialization
fprintf('Plant states: %d\n', plant.dx);
fprintf('Controller horizon (N + M_tilde): %d\n', controller.N + controller.M_tilde);
fprintf('Simulation duration: %d seconds\n', simulator.time(end));

%% Run simulation and plot data
% TODO: add caching / saving the results of a simulation
[X_history, U_history, Theta_history] = simulator.run_simulation(plant, controller);

% Calculate Psi and augmented Psi
Psi = get_invariant_set(plant, controller);
Psi_aug = get_augmented_invariant_set(plant, controller);

% Plot data
% TODO: add more plots and actually plot data
plot_state_evolution(simulator.x0, simulator.x_ref_real, ...
                        X_history, plant.X , Psi, Psi_aug);