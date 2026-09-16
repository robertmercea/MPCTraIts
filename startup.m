config_filename = '.config';

% 1. Check if the configuration file exists.
if isfile(config_filename)
    % Read the directories from the configuration file.
    file_id = fopen(config_filename, 'r');
    casadi_path = fgetl(file_id);
    tbx_path = fgetl(file_id);
    fclose(file_id);
    disp('MATLAB loaded the directories from the .config file.');
else
    % 2. Get the directories from the user.
    casadi_path = input('Enter the full path to your CasADi directory: ', 's');
    tbx_path = input('Enter the full path to your tbxmanager directory: ', 's');
    
    % 3. Write the directories to the configuration file.
    file_id = fopen(config_filename, 'w');
    fprintf(file_id, '%s\n', casadi_path);
    fprintf(file_id, '%s\n', tbx_path);
    fclose(file_id);
    disp('MATLAB saved the directories to the .config file.');
end

% 4. Add CasADi to the MATLAB path.
if isfolder(casadi_path)
    addpath(casadi_path);
    disp('CasADi is in the MATLAB path.');
else
    disp('Error: The CasADi directory is not correct.');
end

% 5. Add tbxmanager to the MATLAB path.
if isfolder(tbx_path)
    addpath(tbx_path);
    
    % 6. Execute the tbxmanager command.
    try
        tbxmanager restorepath;
        disp('The tbxmanager restorepath command is complete.');
    catch
        disp('Error: The tbxmanager command did not execute.');
    end
else
    disp('Error: The tbxmanager directory is not correct.');
end

% 7. Add the current directory and subdirectories to the MATLAB path.
addpath(genpath(pwd));