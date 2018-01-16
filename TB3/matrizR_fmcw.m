
% Programa para la formaci?n de Matrices Radar para el Radar FMCW Coherente
% MUIT 2017/18 TB3
% Sistemas Radar
% SSR
% Grupo de Microondas y Radar


clear all
close all

[DatosPlots, directorio] = uigetfile('*mat', 'Escoja el fichero de datos la moduladora');
load (cat(2, directorio, DatosPlots)); % los datos de plots


A=src1.Data;
A=double(A);
Sincro=diff(filter(ones(1,50),1,(A>5))>10);
% Do=find(Sincro==1);    %rampa ascendente
Do=find(Sincro==-1);     %rampa descendente
if Do(1)<1000
    D1=Do(2:end);
    Do=[];
    Do=D1;
end
% Do=Do;                 %retardo del filtro rampa ascendente   
Do=Do-40;                %retardo del filtro rampa descendente

NPER=max(size(Do))-1;
[DatosPlots, directorio] = uigetfile('*mat', 'Escoja el fichero de datos de la se?al de batido');
load (cat(2, directorio, DatosPlots)); % los datos de plots

B=src1.Data;
B=double(B);

N=max(size(A));                    % N?mero total de muestras del fichero

fs=src1.SampleFrequency
fm=43.1;                          %Medida en el laboratorio de la frecuencia de la moduladora
FG=abs(fft(A));FG(1)=0;
fm=fs/N*(find(FG==max(FG),1)-1);%Frecuencia de la moduladora 
                                %Estimada con los datos, la FFT y tomando como referencia fs
Np=floor(fs/fm)+2;

% Tm1=0.01;                       % Tiempo de barrido, Medida en el Lab, pero se puede extraer de los datos
                                % Rampa Ascendente, este par?metro lo puede
                                % ajustar
Tm1=0.003;                      % Tiempo de barrido, Medida en el Lab, pero se puede extraer de los datos
                                % Rampa Descendente, este par?metro lo puede
                                % ajustar                  
Nfft=round(fs*Tm1);             % N?mero  de muestras en tiempo r?pido


M=round(max(size(A))/Np)-10;   % N?mero de celdas en tiempo lento que se procesan (quito 10)



%   figure(1)
 
 
  NPER=floor(M);
for k=1:NPER
  
      Moduladora(k,:)=A(Do(k)-Nfft/2+1:Do(k)+Nfft/2);
      MatrizRadar(k,:)=B(Do(k)-Nfft/2+1:Do(k)+Nfft/2);
      MatrizRadarfft(k,:)=fft((MatrizRadar(k,:)),4*Nfft);
% figure(1)
%     subplot(211),plot(1:Nfft,Moduladora(k,:),...
%         1:Nfft,(MatrizRadar(k,:)),'k')
%     grid
%   title('Modulo AZUL MODULADORA    NEGRO señal de batido')
%     xlabel('muestras')
%     ylabel('V')
%     axis([1 Nfft -2 12 ])
%     subplot(212),plot(1:Nfft*4,20*log10(abs(MatrizRadarfft(k,1:Nfft*4))))
%     grid
%   title('Perfil de distancias')
%     xlabel('muestras')
%     ylabel('dB')
%     axis([1 Nfft*4 0 40 ])
%     
%  pause(.01)
   
end

% Se han  calculado los perfiles de distancia sin ventana pero con interpolaci?n
% Este proceso lo tiene que modificar seg?n enunciado del trabajo TB3

MatrizRadar=[];
MatrizRadar=MatrizRadarfft(:,1:4*Nfft/2);
wh_mat= hanning(size(MatrizRadar,1));

for i=1:size(MatrizRadar,2)
    MatrizRadar_hann(:,i)= MatrizRadar(:,i).*wh_mat;
    MatrizRadar_h_fft(:,i)=abs(fft(MatrizRadar_hann(:,i)))./((sum(wh_mat))^2/sum(wh_mat.^2));
end

figure(2)
colormap jet
pcolor(20*log10((abs(filter([1 0 ],1,MatrizRadar))))')
title('VENTANA RECTANGULAR')
colorbar
ylabel('tiempo r?pido')
xlabel('tiempo lento')
grid
shading flat 

figure(3)
colormap jet
pcolor(20*log10(abs(MatrizRadar_hann))')
title('VENTANA RECTANGULAR')
colorbar
ylabel('tiempo r?pido')
xlabel('tiempo lento')
grid
shading flat 

 