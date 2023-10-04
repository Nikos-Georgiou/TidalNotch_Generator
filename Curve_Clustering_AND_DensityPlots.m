%% Classification - kmeans
% Specify source folder and get list of .txt files
source_folder = ''; 
files = dir(fullfile(source_folder, '*.txt'));

% Number of clusters for k-means (adjust as needed)
num_clusters = 5;

num_files = length(files);
data_matrix = [];
values_1_7 = []; % Array to store the values at position (1,7)

for k = 1:num_files
    data = load(fullfile(source_folder, files(k).name));
    
    x_values = data(1:151, 1); % extracting x-values
    y_values = data(1:151, 2); % extracting y-values
    
    values_1_7 = [values_1_7; data(1,7)]; % store the value from position (1,7)

    % For clustering purposes, primarily using y-values
    data_matrix = [data_matrix; y_values']; 
end

% Perform k-means clustering
[cluster_idx, ~] = kmeans(data_matrix, num_clusters);


% Plot each cluster in separate subplots
figure;
for i = 1:num_clusters
    % Find average and minimum of values from position (1,7) for this cluster
    cluster_values = values_1_7(cluster_idx == i);
    avg_value = mean(cluster_values);
    min_value = min(cluster_values); % Get the minimum value for this cluster
    
    subplot(num_clusters, 1, i);
    hold on;
    for j = 1:num_files
        if cluster_idx(j) == i
            plot(data_matrix(j, :));
        end
    end
    title(['Cluster ' num2str(i) ', Avg Fit=' num2str((1-avg_value)*100) '%' ', Max SLC Fit=' num2str((1-min_value)*100) '%' ]); % Updated title
    hold off;
end



% Copy each file to a separate folder based on its cluster
for k = 1:num_files
    % Define cluster folder
    cluster_folder = fullfile(source_folder, ['Cluster_' num2str(cluster_idx(k))]);
    
    % Create folder if it doesn't exist
    if ~exist(cluster_folder, 'dir')
        mkdir(cluster_folder);
    end

    % Copy file to the appropriate cluster folder
    copyfile(fullfile(source_folder, files(k).name), cluster_folder);
end

%% Probability density Plot
% Specify the source folder and get the list of .txt files
source_folder = ''; 
files = dir(fullfile(source_folder, '*.txt'));

% Initialize the accumulator for x, y values
all_x = [];
all_y = [];

% Loop through each .txt file
for k = 1:length(files)
    % Load the data from the current file
    data = load(fullfile(source_folder, files(k).name));
    
    % Check the condition for data(1,7)
    if data(1,7) < 0.2
        % Extract and accumulate the x and y values
        all_x = [all_x; data(1:151, 1)];
        all_y = [all_y; data(1:151, 2)];
    end
end

% Create a probability density plot using hist3
figure;
hist3([all_x, all_y], [50 50]); % 50x50 bins, adjust as needed
title('Probability Density Plot');
xlabel('X Values');
ylabel('Y Values');
set(gcf,'renderer','opengl');
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
view(3); % 3D view