script_paths;
data_folder_path = '/media/jagatpreet/Data/datasets/imu_modeling_paper/allan_dev_data';
TUM_datafolder = 'TUM_dataset-calib-imu-static_10hr_sets';
TUM_filenames = dir(fullfile(data_folder_path,TUM_datafolder));
TUM_filenames = TUM_filenames(3:end);
EUROC_filename = 'imu_visensor.mat';
output_dir_name = fullfile(data_folder_path,strcat(TUM_datafolder,'_','std_struct'));
[folder,name,ext] = fileparts(EUROC_filename);
if (~exist(output_dir_name,'dir'))
    mkdir(output_dir_name);
end

fprintf('\n ----- EUROC dataset conversion------')
EUROC_struct = load(fullfile(data_folder_path,EUROC_filename));
EUROC = convert_EUROC_to_std_struct(EUROC_struct.data_imu);
save(fullfile(data_folder_path,strcat(name,'_std_struct',ext)),'EUROC');

fprintf("\n---- TUM dataset conversion ----\n")
for i = 1:length(TUM_filenames)
    fprintf('\t')
    fprintf(num2str(i))
    TUM_npy_struct = load(fullfile(data_folder_path,TUM_datafolder,TUM_filenames(i).name));
    TUM = convert_TUM_to_std_struct(TUM_npy_struct);
    save(fullfile(output_dir_name,TUM_filenames(i).name),'TUM');
end


