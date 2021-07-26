# RIR_Analizer
Software deserrollado en MatLab para la calibración, grabación y obtención de la respuesta al impulso de un recinto mediante el método del Log Sines-Sweep y cálculo de sus parámetros acústicos.

Al comienzo pedirá que se elija la interfaz de audio a utilizar y colocar un nombre a la carpeta del proyecto. Esto lo hará cada que se ejecute ya que, en dicha carpeta, guardará los audios que se generen si se produce alguna medición para luego ser o no procesada.

Una vez seleccionada la interfaz de audio y colocado el nombre de la carpeta, se abrirá la interfaz principal donde se podrá acceder al módulo de adquisición de datos y/o el módulo de procesamiento de los datos.

A continuación, se deja una breve descripción de qué hace cada script:

- RIR_Analyzer: $\textbf{Script principal}$, allí se crea la GUI y se realizan todos los callbacks.
- SineSweep : Código de generación del SS. Aquí también se produce el proceso de reproducción, guardado y gráficos de
las RIR grabadas, a modo de chequear si la medición sirve o no.
- PinkNoise: Código de generación del ruido rosa. Se utiliza para una calibración antes de realizar la medición.
- StopSound: Detiene la reproducción del ruido rosa.
- AudioCut: Recorta el audio a partir de su valor máximo de amplitud hasta el final.
- Smoothen: Suavizado de la señal por Hilbert y mediana móvil.
- FileLoad: Función que carga los archivos de RIR a ser analizados.
- ExcelExport: Exporta los resultados de los parámetros acústicos a una planilla de excel.
- FilterIR y FilterIR_LR: Carga los objetos de los filtros, que fueron creados en una función aparte para agilizar
el tiempo de ejecución, y guardados en estructuras. Los filtros generados son de 44.1, 48 y 96 kHz. Si se desea de mayor Fs, se deberán crear los
filtros correspondientes y se tendrá que re-adaptar el código. El código funciona sólo para audios con Fs de 44.1, 48 y 96 kHz.
- Graphx: Realiza los gráficos de la envolvente y el suavizado para octavas y tercios de octavas.
- ParamCalc: Cálculo del EDT, T10, T20 y T30.
- LeastSquares: Función de cuadrados mínimos.
- C50_C80_D50: Cálculo del C50, C80 y D50.
- Tt y EDTt: Cálculo del transition time y EDT time.
- IACCearly: Cálculo del IACC early.
- ProcessCalc: Procesamiento de cálculos para ser visualizados en la tabla de la GUI.
- ProcessMain: Procesamiento y chequeo de errores o warning a la hora de elegir una ventana, cargado de archivos.
- Filter_generator: Crea los filtros por octava o tercios en función de la Fs que se desee.

