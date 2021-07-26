function SineSweep(hObject,~,TO,fiO,fsO,nameO,dO,nO,~)
    global folder;
    global audiointerface;
    aiID = audiointerface - 1;

    %T es la duracion del sinesweep en segundos, fi la frecuencia inferior y fs la
    %frecuencia superior, en Hz.
    T = str2double(TO.String);
    d = str2double(dO.String);
    fi = str2double(fiO.String);
    fs = str2double(fsO.String);
    name = nameO.String;
    n = str2double(nO.String);

    if(isempty(name))
        msgbox('Es necesario ingresar un nombre para guardar el archivo grabado','ERROR');
    else
        if(isnan(T) || isnan(fi) || isnan(fs))
            msgbox('Faltan completar campos','ERROR');
        else
            if(fi == fs)
                msgbox('Las frecuencias iniciales y finales son iguales!','ALERT!');
            else
                if(fi > fs)
                    msgbox('La frecuencia inicial es mayor a la frecuencia final!','ALERT!');
                else
                    if(isnan(d))
                        msgbox('El tiempo de delay debe ser un numero entero','ERROR');
                    else
                        if(isnan(n) || n == 0)
                            msgbox('Se debe ingresar un numero entero mayor a 0','ERROR');
                        else
                            w1 = 2*pi*fi; %frecuencia angular inferior
                            w2 = 2*pi*fs; %frencuencia angular superior
                            K = (T*w1)/log(w2/w1);
                            t = 0:1/48000:T;
                            L = T/log(w2/w1);

                            x = sin(K*(exp(t/L) - 1)); %sine sweep
                            x = x/max(x);

                            %  filtro inverso
                            w = (K/L)*exp(t/L); %frecuencia instantanea. La amplitud cambia en funcion de la frecuencia.
                            m = w1./(2*pi*w); %modulacion
                            k = m.*(fliplr(x)); %filtro inverso
                            k1 = k/max(k); %normalizacion de amplitud

                            % Guardado de filtro Inverso .wav
                            root = cd;
                            cd(folder);
                            cd('raw_files');

                            if(~exist('raw_sinesweep.wav', 'file'))
                               audiowrite('raw_sinesweep.wav',x,48000);
                               audiowrite('waw_inversefilter.wav',k1,48000);
                            end

                            cd(root);
                            
                            % Reproduccion y grabacion de sine sweeps
                            waitbar1 = waitbar(0,'Grabando...'); % barra de ilustracion de carga

                            for i = 1:n  % n cantidad de sines a reproducir y grabar      
                                a = audiorecorder(48000,16,1,aiID);
                                hObject.Enable = 'off';
                                pause(d);

                                rectStart = tic; 
                                record(a);
                                ElapsedTimerec = toc(rectStart);

                                soundtStart=tic;
                                sound(x,48000);
                                ElapsedTimesound = toc(soundtStart);


                                pause(T+ElapsedTimerec+ElapsedTimesound);
                                stop(a);


                                hObject.Enable = 'on';
                                audiorecorded_for_transpose = getaudiodata(a); % grabacion a una variable como vector vertical
                                audiorecorded = audiorecorded_for_transpose'; % transposicion y horizontalizacion del vector
                                audiodata_size = size(audiorecorded); % dimensiones del vector
                                h = audiodata_size(2); %h tengo la cantidad de muestras (largo del vector)
                                audiodata(i,(1:h)) = audiorecorded/max(audiorecorded); % audiodata es el array que almacena TODAS las grabaciones del ciclo
                                waitbar(i/n);
                            end
                            close(waitbar1);

                            % Graficos de convolucion de las mediciones
                            ejes = get(0, 'ScreenSize');
                            ancho = ejes(3);
                            alto = ejes(4);
                            waitbar2 = waitbar(0,'Procesando...');
                            figure('Name','Convoluciones sinesweep y filtro inverso',...;
                                'toolbar','none',...;
                                'position',[(ancho/2)-(n*300/2) (alto/2)-150 n*300 300]);

                            k1size = size(k1); % adquisicion de largo del filtro
                            k1length = k1size(2); % largo del vector del filtro
                            filtro_zeros = [zeros(1,h-k1length) k1]; % agregado de ceros para tamaños iguales

                            for i = 1:n
                                x = audiodata(i,(1:h)); % grabacion i
                                y = conv(x,filtro_zeros); % convolucion entre grabacion y filtro con iguales dimensiones

                                subplot(1,n,i);
                                plot(y);
                                title(i);
                                xlabel('Tiempo [s]');
                                ylabel('Amplitud');

                                %guardado del wav de la RIR
                                final_name1 = strcat(name,' RI ',num2str(i),'.wav');
                                audiotowrite1 = y/max(y); % cargar a una variable SOLO el vector fila de audio del sine nro i
                                cd(folder);
                                cd('recorded');

                                if(~exist(final_name1, 'file'))
                                    audiowrite(final_name1,audiotowrite1,48000);
                                    cd(root);
                                end

                                waitbar(i/n);
                            end
                            close(waitbar2);

                            % Guardado de archivos .WAV
                            choice = questdlg('¿Guardar grabaciones en .wav?', ...
                                'Atencion!', ...
                                'Guardar','Descartar','Descartar');
                            choicestr = strcmp(choice,'Guardar'); % decision de guardar o no

                            if(choicestr == 1) % guardar o no los archivos
                                for i= 1:n
                                    final_name = strcat(name,'_',num2str(i),'.wav');
                                    audiotowrite = audiodata(i,(1:h)); % cargar a una variable SOLO el vector fila de audio del sine nro i
                                    cd(folder);
                                    cd('recorded');
                                    if(~exist(final_name, 'file'))
                                        audiowrite(final_name,audiotowrite,48000);
                                        cd(root);
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end       
    end
end

     