function FilterIR_LR(kind_value)
    global handles;

    %se cargan las estructuras que contienen los filtros por octava o
    %tercios para la fs determinada
    filterfile = strcat(kind_value,'_filters_',num2str(handles.audio_data.fs),'.mat');
    structfile = strcat(kind_value,'_struct_',num2str(handles.audio_data.fs),'.mat');
    load(filterfile);
    load(structfile);
    count = length(H);
    
    n = handles.audio_data.ST.number_files; %cantidad de archivos cargada
    thisfilter=cell(1,n);
    filtered_dataLR = struct; %se crea una estructura para colocar la data filtrada
    filtered_dataLR.filter.validfreq = data.filter.validfreq; %se guarda el vector de frecuencias centrales de los filtros


    for j = 1:n
        for i = 1:count
            
            if count==30 %para tercios
                
                for k=1:length(handles.audio_data.ST.cut_audioLR{j})
                    thisfilter{j}{k} = filter(H(i),flip(handles.audio_data.ST.cut_audioLR{j}{k})); %reversed time analysis
                    thisfilter{j}{k}= flip(thisfilter{j}{k}); %Se vuelve a invertir lo que sale del filtro

                    if k==1 %k==1 es left
                        filtered_dataLR = setfield(filtered_dataLR,strcat('f',num2str(round(data.filter.validfreq(i))),'_',num2str(j),'L'),thisfilter{j}{k});%se guarda la data para esa banda
                    else %k==2 es right
                        filtered_dataLR = setfield(filtered_dataLR,strcat('f',num2str(round(data.filter.validfreq(i))),'_',num2str(j),'R'),thisfilter{j}{k});%se guarda la data para esa banda
                    end
                end
          
            else %para octava

                for k=1:length(handles.audio_data.ST.cut_audioLR{j})
                    thisfilter{j}{k} = filter(H(i),handles.audio_data.ST.cut_audioLR{j}{k});
                    if k==1 %k==1 es left
                        filtered_dataLR = setfield(filtered_dataLR,strcat('f',num2str(round(data.filter.validfreq(i))),'_',num2str(j),'L'),thisfilter{j}{k});%se guarda la data para esa banda
                    else %k==2 es right
                        filtered_dataLR = setfield(filtered_dataLR,strcat('f',num2str(round(data.filter.validfreq(i))),'_',num2str(j),'R'),thisfilter{j}{k});%se guarda la data para esa banda
                    end
                end
            end
        end     
    end
    
    %se guarda la data filtrada en "handles"
    handles.audio_data.ST.filtered_dataLR = filtered_dataLR;

end