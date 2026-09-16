classdef (Abstract) MPCTAbstractSimulator < handle
    % MPCTAbstractSimulator Abstract class for MPC simulators

    properties
        N_sim (1,1) double {mustBeInteger, mustBePositive} = 1 % number of simulations
        u0 (:,1) double {mustBeReal} % initial input value
        x0 (:,1) double {mustBeReal} % initial state value
        time (1,1) double {mustBeNonnegative}
        N_ref (1,1) double {mustBeInteger, mustBePositive} = 1
        coef_time (1,1) double {mustBeInteger, mustBePositive} = 1
        T_sample (1,1) double {mustBePositive} = 1 % sample time
    end
    
    methods
        function obj = MPCTAbstractSimulator(N_sim, x0, u0, T_sample)
            % MPCTAbstractSimulator constructor
            %
            % Input arguments:
            % N_sim (int) = 
            % x0 (m,1) = initial state value
            % u0 (n,1) = initial input value
            % T_sample (int) = sampling time

            arguments
                N_sim (1,1) double {mustBeInteger, mustBePositive}
                x0 (:,1) double {mustBeReal}
                u0 (:,1) double {mustBeReal}
                T_sample (1,1) double {mustBePositive}
            end
            
            obj.N_sim = N_sim;
            obj.x0 = x0;
            obj.u0 = u0;
            obj.T_sample = T_sample;
            
            obj.time = N_sim * T_sample;
        end
    end
end

function mustBeSquare(M)
    if size(M, 1) ~= size(M, 2)
        error('Plant:NotSquare', 'Matrix must be square.');
    end
end