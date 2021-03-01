clc;
close all;
clear ;
figuras{1,1}=0;  %Arreglo de todas las figuras leidas

leer=0;
fig=[];  %Variable para concatenar todas las imagenes
a=dir('C:\Users\carma_000\Desktop\feature_extraction\Reconocedor\*.bmp');
a(9).bytes=172030;
j=1;
k=1;
l=1;
for i=1:9
    leer=imread(a(i).name);
    
    leer=double(leer);
    %fig(i)=leer;
    fig=horzcat(fig,leer); 
    
    if i<=3 
       
       figuras{1,j}=reshape(leer,221*259*3,1); 
       j=j+1;
    elseif i<=6
       if k==1 
        j=1;
        k=2;
       end
       figuras{2,j}=reshape(leer,221*259*3,1); 
       j=j+1;
    elseif i<=9
       if l==1 
        j=1;
        l=2;
       end
       figuras{3,j}=reshape(leer,221*259*3,1); 
       j=j+1; 
    end
    
    
    
    
%     figuras2=reshape(fig,259*442*3,1);
   
%     for j=1:3
%         leer=imread(strcat('C:\Users\carma_000\Desktop\feature_extraction\Reconocedor'),int2str(i),'-',int2str(j),'.bmp');
%         leer=double(imresize(leer,0.25));
%         fig=horzcat(fig,leer);
%         figuras{i,j}=reshape(leer,16384,1);
%     end
end

% cuenta=1
% for i=1:3
%     for j=1:3
%         figuras{i,j}=reshape(fig,16384,1);
%         cuenta=cuenta+1;
%     end
%     
% end



%imshow(imresize(fig,0.75));
inputs=figuras{1,1};

for i=1:3
    for j=1:3
        if (i~=1) || (j~=1)
            
            inputs=horzcat(inputs,figuras{i,j});
            
        end
    end
end


%Targets
targets=[eye(3) eye(3) eye(3)];
targets=targets*0.9+0.05;
  
%Cracion de la rede neuronal 
%Perceptron mlp,2 capas ocultas, 1ra 30 neuronas, 2do de 15, Se definen 3
%en la capa de salida

net=newff(minmax(inputs),[30 12 3],{'tansig','tansig','tansig'},'traingdx');
%30 15 3
%Entrenamiento de la red
%net.trainParam.epochs=3000;
net.trainParam.goal=0.0001;
net.trainParam.show=100;
net=train(net,inputs,targets);


%Prueba con las mismas imagenes usadas en el entrenamiento

prueba=figuras{1,1};

for i=1:3
    for j=1:3
        if (i~=1) || (j~=1)
            prueba=horzcat(prueba,figuras{i,j});
        end
    end
end

%Simulacion de la red   
resultados=sim(net,prueba);

recog=[];
for i=1:9
    recog=[recog find(resultados(1:3,i)==max(resultados(1:3,i)))];
end


for i=1:9
    if recog(i)==1
        fprintf('circulo');
    end
    
    if recog(i)==2
        fprintf('cuadro')
    end
    
    if recog(i)==3
        fprintf('triangulo')
    end
    
end

        

        

        