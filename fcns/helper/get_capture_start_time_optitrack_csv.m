function optitrack_start_time_string = get_capture_start_time_optitrack_csv(filename)
        
         
        file_id = fopen(filename);
        line1 = fgetl(file_id);
        line1_strings = split(line1,',');
        fprintf("File %s has capture start time %s \n",filename,...
                                                    line1_strings{12});
         
        optitrack_start_time_string = line1_strings{12};
end