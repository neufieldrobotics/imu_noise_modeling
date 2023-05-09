function success = write_AD_params_to_file(output_folder,selected_IMUs,field_name,N,K,B,tauB)
    
    dir_path = fullfile(output_folder,sprintf("AD_params_%d_imus",length(selected_IMUs)));
    if ~exist(fullfile(output_folder,dir_path),"dir")
        mkdir(dir_path);
    end
    
    filename = sprintf("ad_params_%s.csv",field_name);
    [f_id,message] = fopen(fullfile(dir_path,filename),'w');
    fprintf(f_id,"ID,IMU name,N,K,B,tau_b \r\n");
    for i=1:length(selected_IMUs)
       fprintf(f_id,"%d,%s,%f,%f,%f,%f \r\n",i,...
                                        selected_IMUs{i},...
                                        N.(selected_IMUs{i}),...
                                        K.(selected_IMUs{i}),...
                                        B.(selected_IMUs{i}),...
                                        tauB.(selected_IMUs{i}));
                        
    end
    fclose(f_id);
    success=1;
end
