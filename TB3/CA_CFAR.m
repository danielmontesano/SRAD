function [MatrizDetecciones] = CA_CFAR(escala, MatrizEntrada, distancias, ejex,Ni)

m = 4;
g = 2;

CA_CFAR_filter = [ones(1,m/2) zeros(1,g/2) 0 zeros(1,g/2) ones(1,m/2)];

Umbral = filter(CA_CFAR_filter,1,MatrizEntrada,[],1);
Umbral = Umbral(7:end,:); %Se recorta 6 muestras iniciales
MatrizEntrada = MatrizEntrada(4:end-3,:); %Se recortan 3 por cada lado

%%
k = 0;
for T=.1:.01:4
   k = k+1;
   Pfa(k) = mean(mean(MatrizEntrada>T*Umbral));
   T_vec(k) = T;
  
end

figure(10)
plot(T_vec,log10(Pfa),'LineWidth',2)
grid
title(['Candelador Simple con N_{i}=' num2str(Ni)]) 
xlabel('Factor de escala')
ylabel('Log1(Pfa)')

% end
MatrizDetecciones = MatrizEntrada>escala*Umbral;
%%
figure(11)
    
imagesc(ejex,distancias,MatrizDetecciones)
set(gca, 'YDir', 'normal');
colormap('jet')
xlabel('Slot')
ylabel('Distancia(m)')
title('CFAR')

grid
shading flat

figure
distan = linspace(0, max(distancias), length(MatrizEntrada(:,1)));
 hold on; 
 plot(distan,20*log10(abs(MatrizEntrada(:,200)))'); 
 plot(distan',20*log10(abs(escala*Umbral(:,200))));
 ylabel('Amplitude (dB)');
 xlabel('Distancia (m)');

end