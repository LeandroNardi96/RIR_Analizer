function AudioCut(audio)
    global handles;

    cut_audioLR = cell(1,handles.audio_data.number_files); %se inicializan las cells vacias 
    cut_audio = cell(1,handles.audio_data.number_files);
    
    for i=1:handles.audio_data.number_files
        
        if size(audio{i},2)==2 %si el audio es estereo
            xL = audio{i}(:,1)'; %se seleccionan y recortan los canales por separado
            xR = audio{i}(:,2)';
            [~,xmaxindexL] = max(xL);
            [~,xmaxindexR] = max(xR);
            xL = xL(xmaxindexL:end);
            xR = xR(xmaxindexR:end);
            cut_audioL = xL';
            cut_audioR = xR';
            lL=length(cut_audioL);
            lR=length(cut_audioR);
            
            if lL>lR %se completa con ceros el mas corto para obtener la misma longitud que el mas largo
                c=lL-lR;
                cut_audioR = [cut_audioR;zeros(c,1)];
            else
                c=lR-lL;
                cut_audioL = [cut_audioL;zeros(c,1)];
            end
            
            cut_audioLR{i} = {cut_audioL,cut_audioR}; %se guardan ambos en un vector de mx2
            
        else
            
        x=audio{i}'; %para audios mono
        
        [~,xmaxindex] = max(x);

        x = x(xmaxindex:end);
        cut_audio{i} = x';
        end
    end
    
    if size(audio{i},2)==2 %se guardan los audios cortados en las estructuras correspondientes
        handles.audio_data.ST.cut_audioLR=cut_audioLR;
        handles.audio_data.ST.number_files=handles.audio_data.number_files;
        handles.audio_data.ST.fs=handles.audio_data.fs;
    else
        handles.audio_data.MONO.cut_audio=cut_audio;
        handles.audio_data.MONO.number_files=handles.audio_data.number_files;
        handles.audio_data.MONO.fs=handles.audio_data.fs;
    end
end