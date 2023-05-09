function save_in_TUM_format(output_folder,filenames,vio_run_data)
    for i = 1:length(filenames)
        filename = filenames(i).name;
        [path,name,ext] = fileparts(filename);
        tum_data = vio_run_data{i};
        filename = strcat(name,'.txt');
        dlmwrite(fullfile(output_folder,filename),tum_data,...
                'delimiter',' ','precision',19);
    end
end