function IACCearly()
    global handles;
    
    filter_freq = handles.audio_data.ST.filtered_dataLR.filter.validfreq;
    h = cell(length(filter_freq),1);
    n = handles.audio_data.ST.number_files;
    lengths = zeros(1,n);
    
    hampLR = struct;

    handles.audio_data.ST.hampLR = hampLR;

    for i=1:length(filter_freq)     
        for j=1:n      
            y_L = getfield(handles.audio_data.ST.filtered_dataLR,strcat('f',num2str(round(filter_freq(i))),'_',num2str(j),'L')); %obtención data filtrada L
            y_R = getfield(handles.audio_data.ST.filtered_dataLR,strcat('f',num2str(round(filter_freq(i))),'_',num2str(j),'R')); %obtención data filtrada R
          
            H1_L{i}{j} = movmean(y_L,200); %suavizado (aproxima mejor el resultado)
            H1_R{i}{j} = movmean(y_R,200); %suavizado (aproxima mejor el resultado)
       
            lengths(j)=length(H1_L{i}{j});
        end

        c=min(lengths);

        for j=1:n
            H1_L{i}{j}=H1_L{i}{j}(1:c);
            H1_R{i}{j}=H1_R{i}{j}(1:c);
        end

        h1_L=cell2mat(H1_L{i});
        h1_R=cell2mat(H1_R{i});
        
        h1_L=mean(h1_L,2); %promediado de envolventes
        h1_R=mean(h1_R,2); %promediado de envolventes

    
        T = length(y_L)/handles.audio_data.fs;
        t = 0:1/handles.audio_data.fs:T-1/handles.audio_data.fs;
        [~,y1] = max(h1_L);
        [~,y2] = max(h1_R);
        H_L = h1_L(y1:end); %recorte de la senal a partir de su valor maximo (0dBFS)
        H_R = h1_R(y2:end); %recorte de la senal a partir de su valor maximo (0dBFS)
     %Zero padding    
        LHL=length(H_L);
        LHR=length(H_R);
       
        if LHL<LHR
            H_R = H_R(1:LHL);
        else
            H_L = H_L(1:LHR);
        end
     %-------------------   
        t1 = t(y1:end);
        t2 = t(y2:end);
        [~,t0_1] = min(abs(t1 - 0));
        [~,t0_2] = min(abs(t2 - 0));%Obtencion del Index para t, cuando t = 0.
        a1 = t1(t0_1);  %extremos de integracion 0
        b1 = a1 + 0.08; %extremos de integracion 80 ms
    
        a2 = t2(t0_2);  %extremos de integracion 0
        b2 = a2 + 0.08;
        [~,t1_1] = min(abs(t1 - b1));
        [~,t1_2] = min(abs(t2 - b2));%indice de t = 80 ms
        
        h_L = H_L;
        h_R = H_R;
      
        y1_L = h_L(t0_1:t1_1);
        y1_R = h_R(t0_2:t1_2);
       
        IACF = xcorr(y1_L,y1_R,'coeff'); 
        IACC(i) = max(abs(IACF));
        
        
        handles.audio_data.ST.hampLR = setfield(handles.audio_data.ST.hampLR,strcat('hL',num2str(round(filter_freq(i)))),h1_L);
        handles.audio_data.ST.hampLR = setfield(handles.audio_data.ST.hampLR,strcat('hR',num2str(round(filter_freq(i)))),h1_R);
     
    end
    
    handles.results.IACC = IACC;
end