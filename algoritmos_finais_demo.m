%DEMONSTRAÇÃO DOS ALGORITMOS FINAIS EM FUNCIONAMENTO

% %ALGORITMO FINAL - TEXTO
% %BWT > MTF > RLE > CODIFICAÇÃO ARITMÉTICA, BLOCO A BLOCO
% fileID=fopen("sample.txt",'r');
% texto=fscanf(fileID,'%c');
% fclose(fileID);
% clear fileID;
% %16 bits -> 8 bits (1 byte)
% texto = uint16(texto);
% texto = typecast(texto,'uint8');
% texto = double(texto);
% 
% compressed_txt = algoritmo_final_txt(texto,0,9); %9 kBytes
% 
% fileID=fopen("compressed_txt.jzip",'r');
% txt_file=fread(fileID,'uint8');
% txt_file = txt_file.'; %to row vector
% fclose(fileID);
% clear fileID;
% 
% original_txt = algoritmo_final_txt(txt_file,1);

%ALGORITMO FINAL - IMAGEM 
%ERROS DO PREDITOR DO JPEG-LS > ARITMETICA NA TOTALIDADE
imagem = imread("dog.bmp");
imagem = double(imagem);

compressed_img = algoritmo_final_img(imagem,0);

fileID=fopen("compressed_img.jzip",'r');
img_file=fread(fileID,'uint8');
img_file = img_file.'; %to row vector
fclose(fileID);
clear fileID;

original_img = algoritmo_final_img(img_file,1);



