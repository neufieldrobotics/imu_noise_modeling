function [sorted_files] = sort_filenames_natural_order(log_path,ext)
%SORTED_FILENAMES Summary of this function goes here
%   Detailed explanation goes here

    files_struct_array = dir(fullfile(log_path,strcat("*",ext)));
    files_cell_array = cell(length(files_struct_array),1);

    for i = 1:length(files_struct_array)
        files_cell_array{i} = files_struct_array(i).name;
    end
    sorted_files = natsort(files_cell_array);
end

