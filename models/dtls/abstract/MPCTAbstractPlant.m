classdef (Abstract) MPCTAbstractPlant < handle
    % MPCTAbstractPlant Abstract class for MPC plants

    properties (SetAccess = protected)
        dx (1,1) double {mustBeInteger, mustBePositive} = 1 % State dimension
        du (1,1) double {mustBeInteger, mustBePositive} = 1 % Input dimension
        dy (1,1) double {mustBeInteger, mustBePositive} = 1 % Output dimension
    end
    
    properties
        A (:,:) double {mustBeReal} % State matrix
        B (:,:) double {mustBeReal} % Input matrix
        C (:,:) double {mustBeReal} 
        D (:,:) double {mustBeReal}
        ux0 (:,1) double {mustBeReal}
        X Polyhedron % State space polyhedron
        U Polyhedron % Input space polyhedron
        X_sym Polyhedron % Symbolic state space polyhedron
        U_sym Polyhedron % Symbolic input space polyhedron
        T_sample (1,1) double {mustBeReal, mustBePositive} = 1 % Sampling time
    end
    
    methods
        function obj = MPCTAbstractPlant(A, B, C, D, ux0, X, U, X_sym, U_sym, T_sample)
            % MPCTAbstractPlant constructor
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
            
            arguments
                A (:,:) double {mustBeSquare, mustBeReal}
                B (:,:) double {mustBeReal}
                C (:,:) double {mustBeReal}
                D (:,:) double {mustBeReal}
                ux0 (:,1) double {mustBeReal}
                X ConvexSet
                U ConvexSet
                X_sym ConvexSet
                U_sym ConvexSet
                T_sample (1,1) double {mustBeReal, mustBePositive}
            end
            
            n = size(A, 1);
            m = size(B, 2);
            p = size(C, 1);
            
            obj.dx = n;
            obj.du = m;
            obj.dy = p;

            obj.A = A;
            obj.B = B;
            obj.C = C;
            obj.D = D;

            obj.ux0 = ux0;

            obj.X = X;
            obj.U = U;

            obj.X_sym = X_sym;
            obj.U_sym = U_sym;

            obj.T_sample = T_sample;
        end
    end
end

function mustBeSquare(M)
    if size(M, 1) ~= size(M, 2)
        error('Plant:NotSquare', 'Matrix must be square.');
    end
end
