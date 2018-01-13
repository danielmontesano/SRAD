%% Preparacion de datos
opc=input('Seleccione GHz del barrido (1GHz o 2GHz): ');
if(opc==1)
    Y1_asc=load('Canal_1_1GHz_FM_4.mat');
    Y2_asc=load('Canal_2_1GHz_FM_4.mat');
    load('MatrizRadar_FMCW_1GHz_subida_4.mat')
elseif(opc==2)
    Y1_asc=load('Canal_1_2GHz_FM_5.mat');
    Y2_asc=load('Canal_2_2GHz_FM_5.mat');
    load('MatrizRadar_FMCW_2GHz_subida_4.mat')
end
 
fs = Y1_asc.src1.SampleFrequency;
Y1_asc = Y1_asc.src1.Data;
Y2_asc = Y2_asc.src1.Data;
 
%% Activar si se quiere tener ruido como entrada
% Y2_asc= randn(1,length(Y1_asc));
% [x,y]=size(MatrizRadar);
% MatrizRadar(:,:) = randn(x,y);
 
%% Pantalla Tipo A para rampa ascendente
t_rampa = 9.5 * 10^-3; % Podria hacerse con size(MatrizRadar,1)/fs = 10ms
% Pero se han medido unicamente 9.5ms de rampa 
N=single(fs*t_rampa); % Numero de muestras en una rampa

if(opc == 1) % 1GHz --> 15cm de resolucion en distancia
    ZP=72;
elseif(opc==2) %2GHz --> 7.5 cm de resolucion en distancia
    ZP=72;
end
NT=N*ZP; % Numero de muestras para realizar la FFT
t=((0:N-1)/fs)*10^3;
f=(0:NT-1)*fs/NT;
if(opc==1)
    R = ((3*10^8)*f) / (2*(1 / t_rampa)*(1*10^9));
elseif(opc==2)
    R = ((3*10^8)*f) / (2*(1 / t_rampa)*(2*10^9));
end
 
T=2319;
wh=hanning(N);

corr = 0; cont = 0; k=1;
figure
for i=2060:T:length(Y1_asc)-T
    subplot(211)
    plot(t,Y1_asc(i+corr:i+corr+N-1))
    title('Rampa ascendente')
    xlabel('Tiempo (ms)')
    ylabel('V')
    ylim([0 10])
    grid on
 
Y_h= Y2_asc(i+corr:i+corr+N-1).*wh';
    Y_h_zp=fft(Y_h, NT);
    Y_h_zp = abs(Y_h_zp/((sum(wh))^2/sum(wh.^2))); %Quitamos ganancia de fft enventanada
    subplot(212)
    plot(R,Y_h_zp);
    title('Señal de batido tras FFT + Ventana Hanning + Zero Padding')
    xlabel('m')
    ylabel('V')
    grid on
    xlim([0 10])
    %ylim([0 0.4])
    pause(0.05)
    
    if(opc==2)  %Posiciones en 2GHz
        B1(k) = Y_h_zp(1160); % V del Blanco Fijo 1
        B2(k) = Y_h_zp(1579); % V del Blanco Fijo 2
        B3(k) = Y_h_zp(1700); % V del Blanco Fijo 3
        B4(k) = Y_h_zp(1902); % V del Blanco Fijo 4
        B5(k) = Y_h_zp(1995); % V del Blanco Fijo 5
        B6(k) = Y_h_zp(2139); % V del Blanco Fijo 6
        Armario(k) = Y_h_zp(3774); % V del Armario
        Reflector(k) = Y_h_zp(3507); % V del Reflector
        pot_ruido(k) = sqrt((1/480)*sum(Y_h_zp(2401:2881).^2)); % Valor cuadratico medio
        k=k+1;
    end
   % Correccion de la desviacion de la pantalla tipo A
    cont = cont+1;
    if(opc==1 && cont == 10)
        cont = 0;
        corr = corr + 1;
        
    elseif(opc==2 && cont == 20)        
        cont = 0;
        corr = corr + 1;
    end
end
 
%% Pantalla Tipo B para rampa ascendente
MatrizRadar=MatrizRadar(1:950,:);
[x,y]=size(MatrizRadar);
NT_M=x*ZP;
wh_mat= hanning(x);

for i = 1:y
    Matriz_h(:,i)= MatrizRadar(:,i)'.*wh_mat'; % Ventana Hanning
    Matriz_h_fft(:,i)=abs(fft(Matriz_h(:,i),NT_M)/((sum(wh))^2/sum(wh.^2))); % FFT y Zero Padding
end
 
figure
imagesc(1:y, R, Matriz_h_fft)
set(gca, 'YDir', 'normal');
colormap('jet')
c=colorbar;
c.Label.String = 'Amplitud (V)';
c.Label.FontSize = 11;
title('Matriz Radar: Rampa Ascendente')
xlabel('Slot')
ylabel('Distancia (m)')
ylim([0 10])
