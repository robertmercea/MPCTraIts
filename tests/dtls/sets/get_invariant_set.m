function set = get_invariant_set(plant, controller)
    % get_invariant_set Computes the invariant set for the given system
    % using MPT3
    %
    % Input arguments:
    % plant (MPCTAbstractPlant) = plant model
    % controller (MPCTAbstractController) = controller model
    %
    % Output arguments:
    % set (Polyhedron) = invariant set of the system
    
    arguments (Input)
        plant MPCTAbstractPlant
        controller MPCTAbstractController
    end

    arguments (Output)
        set Polyhedron
    end

    system = LTISystem('A', plant.A + plant.B * controller.K);

    % extract state parameters
    Fx = plant.X.A;
    bx = plant.X.b;
    Fu = plant.U.A;
    bu = plant.U.b;

    % combine state parameters to define common state & input space
    A_comb = [Fx; Fu * controller.K];
    b_comb = [bx; bu];

    % define state & input space
    space = Polyhedron('A', A_comb, 'b', b_comb);

    % get MPI
    set = system.invariantSet('X', space);
end