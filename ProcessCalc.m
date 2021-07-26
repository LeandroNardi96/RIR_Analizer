function ProcessCalc(~,~)
    global handles;
  
    %en caso de que no exista, se crea la estructura que guarda los
    %resultados estereo y mono en la estructura "results" que, a su vez,
    %esta dentro de la estructura global "handles"
    if isfield(handles.results,'resultsSTEREO')==0 
        resultsSTEREO=struct;
        handles.results.resultsSTEREO=resultsSTEREO;
    end

    if isfield(handles.results,'resultsMONO')==0
        resultsMONO=struct;
        handles.results.resultsMONO=resultsMONO;
    end
    
    %"medgraph" y "hilbgraph" son las estructuras donde se guardan los
    %datos de la salida del filtro de mediana movil y de hilbert para
    %levantarlos desde la funcion "Graphx"

    if isfield(handles.audio_data.MONO,'medgraph')==0
        medgraph=struct;
        handles.audio_data.MONO.medgraph=medgraph;
    end
     
    if isfield(handles.audio_data.MONO,'hilbgraph')==0
        hilbgraph=struct;
        handles.audio_data.MONO.hilbgraph=hilbgraph;
    end


    if handles.gui.kind.Value == 1 % definicion de kind  como oct o thrd, segun la seleccion del usuario
        kind_value = 'oct';
        kind_op = 'thrdoct';
        
        %se definen los nombres de las columnas de la tabla de la gui
        if handles.audio_data.fs == 44100
            column_names = {'31,5 Hz','63 Hz','125 Hz','250 Hz','500 Hz','1000 Hz','2000 Hz','4000 Hz','8000 Hz'};
            z=9;
        else
            column_names = {'31,5 Hz','63 Hz','125 Hz','250 Hz','500 Hz','1000 Hz','2000 Hz','4000 Hz','8000 Hz','16000 Hz'};
            z=10;
        end
      
        table_position = [20 20 790 150];
  
    else
        kind_value = 'thrdoct';
        kind_op = 'oct';
        
        
        if handles.audio_data.fs == 44100
            column_names = {'25 Hz','31,5 Hz','40 Hz','50 Hz','63 Hz','80 Hz','100 Hz',...
            '125 Hz','160 Hz','200 Hz','250 Hz','315 Hz','400 Hz','500 Hz',...
            '630 Hz','800 Hz','1000 Hz','1250 Hz','1600 Hz','2000 Hz',...
            '2500 Hz','3150 Hz','4000 Hz','5000 Hz','6300 Hz','8000 Hz',...
            '10000 Hz','12500 Hz','16000 Hz'};
            z=29;
        else
            column_names = {'25 Hz','31,5 Hz','40 Hz','50 Hz','63 Hz','80 Hz','100 Hz',...
            '125 Hz','160 Hz','200 Hz','250 Hz','315 Hz','400 Hz','500 Hz',...
            '630 Hz','800 Hz','1000 Hz','1250 Hz','1600 Hz','2000 Hz',...
            '2500 Hz','3150 Hz','4000 Hz','5000 Hz','6300 Hz','8000 Hz',...
            '10000 Hz','12500 Hz','16000 Hz','20000 Hz'};
            z=30;
        end
        table_position = [20 20 790 150];    
    end

        
      
    

    if handles.gui.rb2_window.Value==1 && isempty(handles.gui.edit_window.String)==1
        uiwait(msgbox('Debe seleccionar una ventana para el filtro de mediana movil'));
    end
    

    if isvalid(handles.gui.waitbar3)==0
        waitbar3 = waitbar(0,'Procesando...');
        waitbar(0.2,waitbar3,'Procesando...');
    else
        waitbar3 = handles.gui.waitbar3;
    end


    waitbar(0.4,waitbar3,'Procesando...');


    if handles.gui.btn_load_audio.Value==1 || (isfield(handles.results.resultsMONO,kind_op)==1 && isfield(handles.results.resultsMONO,kind_value)==0) || (isfield(handles.results.resultsMONO,kind_value)==1 && handles.gui.WindowChange==1) 

        %si se ingresan audios monoaurales, si los audios ya se ingresaron
        %pero con una seleccion de filtro de octavas diferente (por ejemplo
        %se habia ingresado con tercios y ahora se quiere por octavas), o
        %si ya se tienen los resultados pero se cambia el valor de la
        %ventana del filtro de mediana movil, se ejecuta lo siguiente:
        
        FilterIR(kind_value);

        Smoothen();

        waitbar(0.6,waitbar3,'Procesando...');

        ParamCalc();

        C50_C80_D50();

        waitbar(0.8,waitbar3,'Procesando...');
        
        Tt();
        EDTt();
    
        %se levantan todos los resultados de la estructura "handles"
        results1 = [handles.results.TR;handles.results.D50;handles.results.C50;handles.results.C80;handles.results.EDTt;handles.results.Tt];

        %se guardan los resultados obtenidos en las estructuras
        %correspondientes a los audios mono
        handles.results.resultsMONO = setfield(handles.results.resultsMONO,kind_value,results1);
        handles.audio_data.MONO.medgraph = setfield(handles.audio_data.MONO.medgraph,kind_value,handles.audio_data.MONO.med);
        handles.audio_data.MONO.hilbgraph = setfield(handles.audio_data.MONO.hilbgraph,kind_value,handles.audio_data.MONO.hilb);

    
    end

    if handles.gui.btn_load_audioST.Value==1 || (isfield(handles.results.resultsSTEREO,kind_op)==1 && isfield(handles.results.resultsSTEREO,kind_value)==0)

        %si se carga audios binaurales, o si los audios ya se ingresaron
        %pero con una seleccion de filtro de octavas diferente (por ejemplo
        %se habia ingresado con tercios y ahora se quiere por octavas), se ejecuta los siguiente:  
        FilterIR_LR(kind_value);

        IACCearly();

        results1 = [handles.results.IACC];
        
        %se guardan los resultados obtenidos en las estructuras
        %correspondientes a los audios estereo
        handles.results.resultsSTEREO = setfield(handles.results.resultsSTEREO,kind_value,results1);

    end


    close(waitbar3);
    
    %si se realizo el procesamiento, se levantan los resultados de handles, 
    %y se plasman en la tabla y los graficos

    if isfield(handles.results.resultsMONO,kind_value)==1      
        
        table_resultsMONO = getfield(handles.results.resultsMONO,kind_value);
        medFINAL = getfield(handles.audio_data.MONO.medgraph,kind_value);
        hilbFINAL = getfield(handles.audio_data.MONO.hilbgraph,kind_value);
 
    end
    
    if isfield(handles.results.resultsSTEREO,kind_value)==1
        table_resultsSTEREO = getfield(handles.results.resultsSTEREO,kind_value);
    end      

    if isfield(handles.results.resultsSTEREO,kind_value)==1 && isfield(handles.results.resultsMONO,kind_value)==1
        set(handles.gui.table_results,'Data',[table_resultsMONO;table_resultsSTEREO]);   
    elseif isfield(handles.results.resultsSTEREO,kind_value)==1 && isfield(handles.results.resultsMONO,kind_value)==0
        set(handles.gui.table_results,'Data',[zeros(9,z);table_resultsSTEREO]);
    elseif isfield(handles.results.resultsSTEREO,kind_value)==0 && isfield(handles.results.resultsMONO,kind_value)==1
        set(handles.gui.table_results,'Data',[table_resultsMONO;zeros(1,z)]);     
    end

    %si se cambian el tipo de filtrado, se reinicia el valor de la
    %frecuencia del grafico
    if handles.gui.KindChange==1
        set(handles.gui.band_selection,'Value',1);
    end

    %se grafica, solo si se han ingresado audio/s mono
    if exist('medFINAL','var')==1 && exist('hilbFINAL','var')==1 && (handles.gui.WindowChange==1 || handles.gui.btn_load_audio.Value==1 || handles.gui.KindChange==1)
        handles.audio_data.MONO.medgraph = setfield(handles.audio_data.MONO.medgraph,kind_value,medFINAL);
        handles.audio_data.MONO.hilbgraph = setfield(handles.audio_data.MONO.hilbgraph,kind_value,hilbFINAL);
        set(handles.gui.band_selection,'String',column_names);
        set(handles.gui.band_selection, 'Enable', 'on');
        Graphx();
    end
    
        set(handles.gui.table_results,'ColumnName',column_names);
        set(handles.gui.table_results,'Position',table_position);
        set(handles.gui.btn_Export,'Enable','on');

        %si se produce un cambio de ventana y existian resultados para el
        %tipo de filtrado opuesto al seleccionado, se borran, para que al
        %cambiar el tipo de filtrado vuelva a recalcular con la ventana
        %nueva y no muestre los resultados viejos
    if handles.gui.WindowChange==1 && isfield(handles.results.resultsMONO,kind_op)==1
        handles.results.resultsMONO=rmfield(handles.results.resultsMONO,kind_op);
    end

    %Se resetean las variables que indican cambio de ventana del filtro de
    %mediana movil o cambio de tipo de filtro por oct/tercios
    handles.gui.WindowChange=0;
    handles.gui.KindChange=0;
    %Se habilita el boton de "borrar todo"
    set(handles.gui.btn_refresh,'Enable','on');
    
end
 