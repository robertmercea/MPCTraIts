function plot_state_evolution(x0, x_r, states, X, Psi, Psi_aug)
  % plot_state_evolution Plots the evolution of the state of the system along
  %
  % Input arguments:
  % x0 (plant.dx.1) = initial state
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

  % TODO: actually plot the data
  plot(states);

  hold off;

end
