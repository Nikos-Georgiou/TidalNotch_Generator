% Define the source folder and get a list of txt files
source_folder = '';
files = dir(fullfile(source_folder, '*.txt'));

% Define the destination folders for the different slope conditions
positive_slope_folder = fullfile(source_folder, 'Positive_Slope');
negative_slope_folder = fullfile(source_folder, 'Negative_Slope');
zero_slope_folder = fullfile(source_folder, 'Zero_Slope');

% Create the folders if they don't exist
if ~exist(positive_slope_folder, 'dir')
    mkdir(positive_slope_folder);
end
if ~exist(negative_slope_folder, 'dir')
    mkdir(negative_slope_folder);
end
if ~exist(zero_slope_folder, 'dir')
    mkdir(zero_slope_folder);
end

% Loop through each file and process
for k = 1:length(files)
    % Read the file
    data = load(fullfile(source_folder, files(k).name));
   
    slope = data(1,15);
        
    % Determine the target folder based on slope value
    if slope > 0
        target_folder = positive_slope_folder;
    elseif slope < 0
        target_folder = negative_slope_folder;
    else
        target_folder = zero_slope_folder;
    end

    % Copy the file to the appropriate folder
    copyfile(fullfile(source_folder, files(k).name), target_folder);
end
