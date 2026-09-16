classdef IIS_Plant < MPCTAbstractPlant
    % IIS_Plant Implicit Invariant Sets plant

    methods
        function obj = IIS_Plant(A, B, C, D, ux0, X, U, X_sym, U_sym, T_sample)
            % IIS_Plant constructor
            %
            % Input arguments:
            % A (n,n) = state matrix
            % B (n,m) = input matrix
            % C
            % D
            % ux0 (int) =
            % X = state space
            % U = input space
            % X_sym = symbolic state space
            % U_sym = symbolic input space
            % T_sample (int) = sample time

            obj@MPCTAbstractPlant(A, B, C, D, ux0, X, U, X_sym, U_sym, T_sample);
        end
    end
end

function mustBeSquare(M)
    if size(M, 1) ~= size(M, 2)
        error('Plant:NotSquare', 'Matrix must be square.');
    end
end