classdef (Abstract) MPCTAbstractController < handle
    % MPCTAbstractController Abstract class for MPC controllers

    properties
        Q (:,:) double {mustBeSquare, mustBeReal} % State weighting matrix
        R (:,:) double {mustBeSquare, mustBeReal} % Control weighting matrix
        W (:,:) double {mustBeReal}
        N (1,1) double {mustBeInteger, mustBePositive} = 10 % Prediction horizon
        K (:,:) double {mustBeReal} % Feedback-gain matrix
    end
    
    methods
        function obj = MPCTAbstractController(Q, R, W, N)
            % MPCTAbstractController constructor
            %
            % Input arguments:
            % Q (n:n) = state weighting matrix
            % R (m:m) = control weighting matrix
            % W = 
            % N (int) = the size of the prediction horizon

            arguments
                Q (:,:) double {mustBeSquare, mustBeReal}
                R (:,:) double {mustBeSquare, mustBeReal}
                W (:,:) double {mustBeReal}
                N (1,1) double {mustBeInteger, mustBePositive}
            end
            
            obj.Q = Q;
            obj.R = R;
            obj.W = W;
            obj.N = N;
        end
    end
end

function mustBeSquare(M)
    if size(M, 1) ~= size(M, 2)
        error('Plant:NotSquare', 'Matrix must be square.');
    end
end
