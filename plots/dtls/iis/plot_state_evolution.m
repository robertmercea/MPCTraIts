function plot_state_evolution(x0, x_r, states, X, Psi, Psi_aug)
    % plot_state_evolution Plots the evolution of the system state.
    %
    % Input arguments:
    % x0 (plant.dx,1) = initial state
    % x_r (plant.dx, :) = real state reference points
    % states (plant.dx,:) = matrix of all intermediary states
    % X (Polyhedron) = state space
    % Psi (Polyhedron) = invariant set
    % Psi_aug (Polyhedron) = augmented invariant set
    
    arguments
        x0 (:,1) double
        x_r (:,:) double
        states (:,:) double
        X Polyhedron
        Psi Polyhedron
        Psi_aug Polyhedron
    end
    
    figure;
    hold on;
    grid on;
    
    % Project polyhedrons onto the first two dimensions
    X_2D = X.projection(1:2);
    Psi_2D = Psi.projection(1:2);
    Psi_aug_2D = Psi_aug.projection(1:2);
    
    % Plot the polyhedrons
    X_2D.plot('color', 'white', 'alpha', 1.0);
    Psi_aug_2D.plot('color', 'lightgray', 'alpha', 0.5);
    Psi_2D.plot('color', 'red', 'alpha', 0.5);
    
    % Plot the trajectory and the points
    plot(states(1, :), states(2, :), 'b.-', 'LineWidth', 1.5);
    plot(x0(1), x0(2), 'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'r');
    plot(x_r(1, :), x_r(2, :), 'g*', 'MarkerSize', 8);
    
    % Create graphic handles for the legend
    h1 = patch(NaN, NaN, 'white', 'FaceAlpha', 1.0, 'EdgeColor', 'k');
    h2 = patch(NaN, NaN, [0.83 0.83 0.83], 'FaceAlpha', 0.5, 'EdgeColor', 'k');
    h3 = patch(NaN, NaN, 'red', 'FaceAlpha', 0.5, 'EdgeColor', 'k');
    h4 = plot(NaN, NaN, 'b.-', 'LineWidth', 1.5);
    h5 = plot(NaN, NaN, 'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'r');
    h6 = plot(NaN, NaN, 'g*', 'MarkerSize', 8);
    
    % Apply the legend to the graphic handles
    legend([h1, h2, h3, h4, h5, h6], ...
           {'Constraint set \mathcal{X}', ...
           'Proj. of augm. invariant set \Psi_{f,\lambda}^{tr}', ...
           'Invariant set \Psi_f (regulation)', ...
           'State evolution', 'Initial state', 'Real setpoints'}, ...
           'Location', 'best');
           
    xlabel('x^1');
    ylabel('x^2');
    hold off;
end