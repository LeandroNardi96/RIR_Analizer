function ProcessMain(~,~)
    global handles;

    %mensajes de error al intentar cargar audios mono sin seleccionar
    %ventana para el filtro de mediana movil
    if handles.gui.btn_load_audio.Value==1 && handles.gui.rb1_window.Value==0 && handles.gui.rb2_window.Value==0
        uiwait(msgbox('Debe seleccionar una ventana para el filtro de mediana movil'));

    else
        
        if handles.gui.btn_load_audio.Value==1 && handles.gui.rb2_window.Value==1 && (isempty(handles.gui.edit_window.String)==1 || sum(isspace(handles.gui.edit_window.String))>=1)
            uiwait(msgbox('Debe seleccionar una ventana para el filtro de mediana movil'));
        elseif handles.gui.btn_load_audio.Value==1 && handles.gui.rb2_window.Value==1 && isnan(str2double(handles.gui.edit_window.String))==1
            msgbox('Error: seleccione el tamaño de la ventana con un numero');   
            

        else
            
            %si se selecciono correctamente una ventana, o si se cargan
            %audios binaurales, se efectuan los calculos
            
            %si no existe, se crea la estructura que guarda los resultados,
            %y se la guarda dentro de la estructura global "handles".
            if isfield(handles,'results')==0
                results=struct;
                handles.results=results;
            end
            
            [file] = FileLoad(handles); % Carga de archivos
   
            %si no existen, se crean las estructuras que guardan los audios 
            %mono y estereo en crudo, y se las guarda dentro de la 
            %estructura "audio_data" que esta a su vez dentro de la 
            %estructura global "handles".
            
            if isfield(handles.audio_data,'MONO')==0
                 MONO=struct;
                 handles.audio_data.MONO=MONO;
            end

            if isfield(handles.audio_data,'ST')==0
                 ST=struct;
                 handles.audio_data.ST=ST;
            end
                  
            
            if iscell(file)==0 && ischar(file)==0 && file==0              
                % si no se carga ningun archivo, termina el proceso
            else                 
                audio_vector=cell(1,handles.audio_data.number_files);

                for i = 1:handles.audio_data.number_files %Leer todos los archivos seleccionados
                    [audio_vector{i},fs] = audioread(handles.audio_data.file_char(i,1:end));
                end
                
                handles.audio_data.fs = fs; %se guarda fs en "handles"
                
                si=zeros(1,handles.audio_data.number_files);
                
                for i = 1:handles.audio_data.number_files
                    si(i)=size(audio_vector{i},2); %se mide la cantidad de 
                    %columnas de audio_vector para saber si es mono o estereo
                end
           
                if length(unique(si))==1
                    
                        
                    if handles.gui.btn_load_audio.Value==1 && si(1)>1
                    %si se intenta cargar audios binaurales al haber seleccionado el boton de
                    %audios mono
                        uiwait(msgbox('Debe cargar RIRs monoaurales'));


                    elseif handles.gui.btn_load_audioST.Value==1 && si(1)==1
                        %si se intenta cargar audios mono al haber seleccionado el boton de
                        %audios binaurales

                        uiwait(msgbox('Debe cargar RIRs binaurales'));
                        
                    elseif handles.gui.btn_load_audio.Value==1 && isfield(handles.audio_data.ST,'fs')==1 && handles.audio_data.ST.fs ~= fs
                        
                        %si se intenta cargar audios de distintas fs

                        uiwait(msgbox('Debe cargar RIRs monoaurales con la misma frecuencia de sampleo que las RIRs binaurales'));

                        
                    elseif handles.gui.btn_load_audioST.Value==1 && isfield(handles.audio_data.MONO,'fs')==1 && handles.audio_data.MONO.fs ~= fs
                        %si se intenta cargar audios de distintas fs
        
                        uiwait(msgbox('Debe cargar RIRs binaurales con la misma frecuencia de sampleo que las RIRs monoaurales'));
                        
                    else
                        
                        %si se cargan bien los archivos, se crean las
                        %estructuras que guardaran los resultados mono y
                        %estereo, por separado, en "handles"
                        
                        if handles.gui.btn_load_audio.Value==1
                            if isfield(handles.results,'resultsMONO')==1
                                 handles.results = rmfield(handles.results,'resultsMONO'); 
                            end
                        elseif handles.gui.btn_load_audioST.Value==1                         
                            if isfield(handles.results,'resultsSTEREO')==1 
                                 handles.results = rmfield(handles.results,'resultsSTEREO');        
                            end
                        end
                        
                    waitbar3 = waitbar(0,'Procesando...');
                    AudioCut(audio_vector); %se recortan los audios de su valor de amplitud maximo al final
                    waitbar(0.2,waitbar3,'Procesando...');
                    handles.gui.waitbar3 = waitbar3; 
                    handles.audio_data.audio=audio_vector; %se guarda el vector de audio/s en crudo
                    ProcessCalc(0,0);  
                    
                    end
                else
                    %por si se intenta cargar audios mono y estereo
                    %mezclados
                    uiwait(msgbox('Error al cargar los archivos, debe cargar solo archivos mono o solo archivos estereo'));

                end                  
            end
        end
    end
end