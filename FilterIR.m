function FilterIR(kind_value)
    global handles;
    
    %se cargan las estructuras que contienen los filtros por octava o
    %tercios para la fs determinada
    filterfile = strcat(kind_value,'_filters_',num2str(handles.audio_data.fs),'.mat');
    structfile = strcat(kind_value,'_struct_',num2str(handles.audio_data.fs),'.mat');
    load(filterfile);
    load(structfile);
    count = length(H);
    
    n = handles.audio_data.MONO.number_files; %cantidad de archivos cargada
    thisfilter=cell(1,n);
    filtered_data = data; %se crea una estructura para colocar la data filtrada
    
    %se crea una estructura para colocar las frecuencias centrales para los
    %graficos
    if isfield(handles.audio_data.MONO,'freq_graph')==0
         freq_graph=struct;
         handles.audio_data.MONO.freq_graph=freq_graph;
    end

    handles.audio_data.MONO.freq_graph = setfield(handles.audio_data.MONO.freq_graph,kind_value,data.filter.validfreq);

    for j = 1:n    
        for i = 1:count

            if count==30 %para tercios
  
                thisfilter{j} = filter(H(i),flip(handles.audio_data.MONO.cut_audio{j})); %reversed time analysis
                thisfilter{j} = flip(thisfilter{j}); %Se vuelve a invertir lo que sale del filtro
                filtered_data = setfield(filtered_data,strcat('f',num2str(round(data.filter.validfreq(i))),'_',num2str(j)),thisfilter{j}); %se guarda la data para esa banda
                
            else %para octava
                
                thisfilter{j} = filter(H(i),handles.audio_data.MONO.cut_audio{j});
                filtered_data = setfield(filtered_data,strcat('f',num2str(round(data.filter.validfreq(i))),'_',num2str(j)),thisfilter{j}); %se guarda la data para esa banda
            end

        end
          
            
    end
    %se guarda la data filtrada en "handles"
    handles.audio_data.MONO.filtered_data=filtered_data;
    
end