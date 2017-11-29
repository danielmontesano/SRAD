clear all
close all
% [DatosPlotsI, directorio] = uigetfile('*mat', 'Escoja el fichero I');
% load (cat(2, directorio, DatosPlotsI)); % los datos de plots
load('G_C/TB2_PRG_9_I_C');



I=src1.Data;
I=double(I);
I=I-mean(I);

% [DatosPlotsI, directorio] = uigetfile('*mat', 'Escoja el fichero Q');
% load (cat(2, directorio, DatosPlotsI)); % los datos de plots
load('G_C/TB2_PRG_9_Q_C');


Q=src1.Data;
Q=double(Q);
Q=Q-mean(Q);

% fc=input('Frecuencia de la portadora (GHz)=') 
fc = 9;
fc=fc*1e9;

%Se almacenan los datos en la Matriz A y se elimina la continua de los
%datos, valor medio

fs=src1.SampleFrequency;
% frecuencia de muestreo
N=max(size(I));
% n?mero de muestras
np=256;
% n?mero de muestras de STFT
zp=np*10;
% n?mero de muestras de la FFT, entre np y zp se rellenan con ceros
% Zero-Padding
paso=32;
M=N/paso;
% n?mero de medidas (sin solapamiento si paso=np), 
% n?mero de slots


fdop=linspace(-fs,fs,zp);
% eje de frecuencias de la FFT

t=(0:(N-1))/fs;
%eje de tiempos


A = I + j.*Q;
pintar  = input('Desea video de la FFT? (0 o 1)');
cont=0;
for k=1:paso:floor(N-1.5*np)
    cont=cont+1;
    Yfft=fft(A(1,1+(k-1):np+(k-1)),zp);
    Yfft = circshift(Yfft, length(Yfft)/2);
    %FFT en el slot k

    
    Matriz(cont,:)=Yfft;
    %Construyendo Matriz temporal de FFTs
    %Espectrograma o STFT
    
    if (pintar == 1 ) 
       figure(2)
       subplot(211)
       plot((0:(np-1))/fs,A(1,1+(k-1):np+(k-1)),'-o')
       title(['Muestras utilizadas en el slot   '  num2str(cont) ])
       xlabel('tiempo (sg)')
       grid 
       ylabel('V')
       subplot(212)
       plot(fdop,20*log10(abs(Yfft)),'-o')
       grid
       xlabel('Frecuencia (Hz)')
       ylabel('dB')
       title('FFT')
       axis([-50 50 max(20*log10(abs(Yfft)))-80 max(20*log10(abs(Yfft)))])


     pause(0.06);

    end
   
    
   [Amax(cont), Imax(cont)] = max(Yfft);
   %fmed(cont)=(find(abs(Yfft)==Amax(cont), 1 )-1)*fs/zp;
   
  %El proceso de medida consiste en calcular el valor m?ximo de la FFT
  %Se utiliza la como resultado final el primero de las dos posible
  %soluciones
  %No se tiene informaci?n de signo
  

end

%Dibujamos la velocidad a lo largo del tiempo teniendo en cuenta el tiempo
%de esta
figure; plot(abs(Amax).*sign(Imax-mean(Imax)));
