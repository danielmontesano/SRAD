
% Programa para la formaci?n de Matrices Radar para el Radar FMCW Coherente
% MUIT 2017/18 TB3
% Sistemas Radar
% SSR
% Grupo de Microondas y Radar


clear all
close all

% [DatosPlots, directorio] = uigetfile('*mat', 'Escoja el fichero de datos la moduladora');
load ('G_C/CANAL1_2GHZ_FM_5.mat'); Yoffset = 182; % los datos de plots


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
% [DatosPlots, directorio] = uigetfile('*mat', 'Escoja el fichero de datos de la se?al de batido');
load ('G_C/CANAL2_2GHZ_FM_5.mat');

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
  
      Moduladora(k,:)=A(Do(k)-Nfft/2+1:Do(k)+Nfft/2); %Quitamos muestras iniciales y finales de CW
      MatrizRadar(k,:)=B(Do(k)-Nfft/2+1:Do(k)+Nfft/2);
      MatrizRadarfft(k,:)=fft((MatrizRadar(k,:)),4*Nfft); %fft con mas puntos para meter zero padding
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
    
 pause(.01)
   
end

% Se han  calculado los perfiles de distancia sin ventana pero con interpolaci?n
% Este proceso lo tiene que modificar seg?n enunciado del trabajo TB3

MatrizRadar=[];
MatrizRadar=MatrizRadarfft(:,1:4*Nfft/2);
MatrizRadar=MatrizRadar';

%% Cancelador + enventanado

wh_mat= hamming(size(MatrizRadar,1));

for i=1:size(MatrizRadar,2)
    MatrizRadar_hamm(:,i)= ifft(MatrizRadar(:,i)).*wh_mat;
%     MatrizCancelada(:,i)= cancelador(1,MatrizRadar_hann(:,i));
%     MatrizRadar_h_fft(:,i)=(fft(MatrizRadar_hann(:,i)));
%     MatrizRadar_h_fft(:,i)=(abs(fft(MatrizRadar_hann(:,i))).^2)/((sum(wh_mat)^2)/sum(wh_mat.^2));
end

MatrizCancelada=cancelador(2,MatrizRadar_hamm);
MatrizRadar_h_fft= fft(MatrizCancelada);

%% Integrador

MatrizIntegrada= integrador(2,2,MatrizRadar_h_fft,19);


%% Representación Matriz recibida (en crudo)
BW = 2e9;
Rmax = fs*Tm1*3e8/(BW*2);
distancias = linspace(0,Rmax,size(MatrizRadar,1));
puerta = find(distancias>8.15);
puerta = puerta(1);
MatrizRadar = circshift(MatrizRadar,-round(Yoffset),1);

figure(2)
colormap jet
pcolor(((abs(filter([1 0 ],1,MatrizRadar)))))
title('VENTANA RECTANGULAR')
colorbar
ylabel('tiempo rapido')
xlabel('tiempo lento')
grid
shading flat 

%% Representación Matriz Cancelada
figure(3)
colormap jet
pcolor((abs(MatrizRadar_h_fft)))
title('Matriz con enventanado Hamming + cancelador')
colorbar
ylabel('tiempo r?pido')
xlabel('tiempo lento')
grid
shading flat 

% figure(4)
% for k=1:size(MatrizCancelada,2)
%   
%   subplot(211), plot((abs(MatrizRadar(:,k))))
%     xlabel('muestras')
%     ylabel('V')
%     axis([1 Nfft*2 0 30 ])
%     
%     subplot(212),plot((abs(MatrizRadar_h_fft(:,k))))
%     grid
%     xlabel('muestras')
%     ylabel('V')
%     axis([1 Nfft*2 0 30 ])
%     
%  pause(.01)
% end
%% Representación Cancelador + Integrador

figure(5)
colormap jet
pcolor((abs(MatrizIntegrada)))
title('Matriz con enventanado Hamming + cancelador+ integrador')
colorbar
ylabel('tiempo r?pido')
xlabel('tiempo lento')
grid
shading flat 

figure(6)
for k=1:size(MatrizIntegrada,2)
  
  subplot(211), plot((abs(MatrizIntegrada(:,k))))
    grid
    title('Matriz integrada')
    xlabel('muestras')
    ylabel('V')
    axis([1 Nfft*2 0 10 ])
    
    subplot(212),plot((abs(MatrizRadar_h_fft(:,k))))
    grid
     title('Matriz cancelada')
    xlabel('muestras')
    ylabel('V')
    axis([1 Nfft*2 0 10 ])
    
 pause(.01)
end