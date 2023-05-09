clear all
close all

root_folder = "/home/jagatpreet/datasets/voxl_logs/stationary_imu" 
filename = "data_vn100_static.csv"
save_filename = "vn100_id4.mat"

euroc_vn100 = import_EUROC_imu_data(fullfile(root_folder,filename));
fprintf("file reading complete. Conversion started \n")
VN100_id4 = convert_EUROC_to_std_struct(euroc_vn100,"imu-log-euroc");
fprintf("conversion complete\n")

save_path = fullfile(root_folder,save_filename);
if exist(save_path,'file')
    warning("File already exists. overwriting existing file");
end
save(save_path,'VN100_id4')
fprintf("Save complete at:  %s\n",save_path);
