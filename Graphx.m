function Graphx(~,~)
    global handles;
    
    waitbar1=waitbar(0,'Preparando grafico...');
    
    %se levanta el valor seleccionado del filtro de oct/tercios
    kind_value = handles.gui.kind.Value;

    if kind_value==1 %se levantan los datos para graficar
        k='oct';
        med_mat = handles.audio_data.MONO.medgraph.oct;
        hil_mat = handles.audio_data.MONO.hilbgraph.oct;
    else
        k='thrdoct';
        med_mat = handles.audio_data.MONO.medgraph.thrdoct;
        hil_mat = handles.audio_data.MONO.hilbgraph.thrdoct;
    end
    
    freq_cent = getfield(handles.audio_data.MONO.freq_graph,k); %se levanta el vector de frecuencias centrales
    waitbar(0.2,waitbar1,'Preparando grafico...');

    waitbar(0.4,waitbar1,'Preparando grafico...');
    
    band_selection = handles.gui.band_selection.Value; % me dice que numero de banda graficar
    number_bands = size(handles.gui.band_selection.String,1);

    band_name = handles.gui.band_selection.String(band_selection);

    waitbar(0.6,waitbar1,'Preparando grafico...');
    
    med_vector = getfield(med_mat,strcat('m',string(round(freq_cent(band_selection))))); %levanto la info por banda
    hil_vector = getfield(hil_mat,strcat('h',string(round(freq_cent(band_selection)))));

    y = hil_vector';
    T = length(y)/handles.audio_data.fs; 
    t = 0:1/handles.audio_data.fs:T-1/handles.audio_data.fs; %vector de tiempo
      
    waitbar(0.8,waitbar1,'Preparando grafico...');

    if number_bands == 1
        return
    else
        close(waitbar1);
           
        cla
        p1=plot(t,med_vector);
        hold on;
        p2=plot(t,hil_vector);
        p2.Color(4) = 0.3;
        xlabel('Tiempo [s]')
        ylabel('Nivel [dB]')
        title (strcat(band_name))
        legend('Mediana movil','Hilbert')
        grid on
        axis([0 max(t) -100 0]);
        
    end  
end