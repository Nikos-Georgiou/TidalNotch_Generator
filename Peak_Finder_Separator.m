% Define the source folder and get a list of txt files
source_folder = ''; 
files = dir(fullfile(source_folder, '*.txt'));

% Define the destination folders based on the number of peaks
folders = {'0_Peaks','1_Peak','2_Peaks','3_Peaks','Greater_Than_Three_Peaks'};

% Create the folders if they don't exist
for i = 1:length(folders)
    if ~exist(fullfile(source_folder, folders{i}), 'dir')
        mkdir(fullfile(source_folder, folders{i}));
    end
end

% Loop through each file, find peaks, replace values, and copy to appropriate folder
for k = 1:length(files)
    % Read the file
    data = load(fullfile(source_folder, files(k).name));
    
    % Extract x and y
    x = data(1:151, 1);
    y = data(1:151, 2);
    
    % Find peaks
    [peaks, locations] = findpeaks(y, x,'MinPeakProminence', 0.5);
    num_peaks = length(peaks);
    
    % Store all peak values in columns 16 and 17
for idx = 1:num_peaks
    data(idx, 16) = locations(idx);
    data(idx, 17) = peaks(idx);
end

    % Determine the target folder based on number of peaks
    if num_peaks == 0
        target_folder = fullfile(source_folder, '0_Peaks');
    elseif num_peaks == 1
        target_folder = fullfile(source_folder, '1_Peak');
    elseif num_peaks == 2
        target_folder = fullfile(source_folder, '2_Peaks');
    elseif num_peaks == 3
        target_folder = fullfile(source_folder, '3_Peaks');
    else
        target_folder = fullfile(source_folder, 'Greater_Than_Three_Peaks');
    end

    % Write the updated data to the target folder
    dlmwrite(fullfile(target_folder, files(k).name), data, 'delimiter', '\t');
end
