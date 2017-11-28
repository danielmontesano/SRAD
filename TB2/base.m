
%
%               SISTEMAS RADAR MUIT  2017/18
%                  GMR  SSR  ETSIT  UPM
%
% Programa b?sico de procesado de un CW-RADAR
% Un solo canal
%
% Datos de entrada: capturas HST5
%
clear all
close all
[DatosPlots, directorio] = uigetfile('*mat', 'Escoja el fichero de datos digitalizados a procesar');
load (cat(2, directorio, DatosPlots)); % los datos de plots

fc=input('Frecuencia de la portadora (GHz)=') 
fc=fc*1e9;

A=src1.Data;
A=double(A);
A=A-mean(A);


%Se almacenan los datos en la Matriz A y se elimina la continua de los
%datos, valor medio

fs=src1.SampleFrequency
% frecuencia de muestreo
N=max(size(A));
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


fdop=(0:(zp-1))*fs/zp;
% eje de frecuencias de la FFT

t=(0:(N-1))/fs;
%eje de tiempos

figure(1)
plot(t,A)
grid
xlabel('tiempo (sg)')
ylabel('V')
title('Datos Digitalizados')
pause

cont=0;
for k=1:paso:floor(N-1.5*np)
    cont=cont+1;
    Yfft=fft(A(1,1+(k-1):np+(k-1)),zp);
    %FFT en el slot k
    
    
    Matriz(cont,:)=Yfft;
    %Construyendo Matriz temporal de FFTs
    %Espectrograma o STFT
    
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
   axis([0 50 max(20*log10(abs(Yfft)))-80 max(20*log10(abs(Yfft)))])
  
   Amax(cont)=max(abs(Yfft));
   fmed(cont)=(find(abs(Yfft)==Amax(cont), 1 )-1)*fs/zp;
   
  %El proceso de medida consiste en calcular el valor m?ximo de la FFT
  %Se utiliza la como resultado final el primero de las dos posible
  %soluciones
  %No se tiene informaci?n de signo
  
  pause(.06)
end

dd=size(Matriz);
X=(1:dd(1))'*ones(1,zp);
Xa=(1:dd(1));
Y=ones(dd(1),1)*fdop;
Ya=fdop;
% ejes para algunas representacioness

MLog=20*log10(abs(Matriz));


% Presentaci?n de Resultados

figure(3)

pcolor(X,Y*3e8/fc/2*100,abs(Matriz))


grid
colorbar
axis('square')
title('Espectrograma')
axis([0 floor(M) 0 50])
xlabel('N?mero de medida')
ylabel('Velocidad (cm/sg)')
shading flat

figure(4)
subplot(111)
mesh(X,Y*3e8/fc/2*100,(MLog))
% legend('-3', '-6', '-10','-30','-50')
title('STFT')

%axis([0 floor(M) 0 50 -50 0])
xlabel('N?mero de medida')
ylabel('Velocidad (cm/sg)')


figure(5)
plot(20*log10(Amax))
grid
title ('Potencia de la medida dB')
xlabel('N?mero de medida slots')
ylabel('dB')

figure(6)
plot(fmed*3e8/fc/2*100);
hold on
grid
title ('Frecuencia Doppler Medida')
xlabel('N?mero de medida')
ylabel('Velocidad (cm/sg) slots')

%% Ejercicio 3

Rmesa=0.9;
Rantena_mesa=2.4;

relacionR=(Rantena_mesa+Rmesa)/Rantena_mesa

if fc==8e9
Pmax= 10^((max(20*log10(Amax))/10));
Pmin = 10^5.87;
Vmax=11.73;
Vmin=6.72;
else
Pmax= 10^((max(20*log10(Amax))/10));
Pmin = 10^5.875; 
Vmax=11.38;
Vmin=6.72;
end

relacionP=Pmax/Pmin;
relacionP_1_4= relacionP^(1/4)
relacionV=Vmax/Vmin;
relacionV_1_2=relacionV^(1/2)

%% Ejercicio 4
%Calculo de secciones radar
%fc=9e9
lambda=3e8/fc;
a=0.2;
b=0.2;
r=0.07;
l=0.2;
resf=0.1;

s_PRG=(4*pi*(a*b)^2)/((lambda)^2);
s_CILcirc=pi*((r)^2);
s_CILtum=(2*pi*r*l)/lambda;
s_ESF=pi*((resf)^2);

% pillar variacion de potencia entre un objeto y otro (distintos ficheros)
% y comparar con la variacion entre sus secciones radar

%relacion entre secciones radar con referencia PRG
As_PRG_CILcir=s_PRG/s_CILcirc;
As_PRG_CILtum=s_PRG/s_CILtum;
As_PRG_ESF=s_PRG/s_ESF;

Pmax=10^((max(20*log10(Amax))/10));