% TRABALHO PRÁTICO 2 - TEORIA DA INFORMAÇÃO - COMPRESSÃO
% Grupo:
% João Manuel Amaral Antunes, Nº2018287319
% Bruno André Fernandes Baptista, Nº2018278008
% Simão Pedro Vitório Vazão, Nº2018289426


%Leitura do ficheiro da imagem
imagem = imread("cromenco_c10.bmp");
imagem = rgb2gray(imagem);
imagem = uint8(imagem);
imagem = double(imagem);

%Leitura do ficheiro de texto
fileID=fopen("war_and_peace.txt",'r');
texto=fscanf(fileID,'%c');
fclose(fileID);
clear fileID;
%16 bits -> 8 bits (1 byte)
texto = uint16(texto);
texto = typecast(texto,'uint8');
texto = double(texto);

%Entropias originais
ENTROPIA_IMG = entropia(imagem);
ENTROPIA_TXT = entropia(texto);

%Converter os dados para vetores
imagem_vec = compression_init(imagem,0);
texto_vec = compression_init(texto,0);
        

% %AUMENTO DA REDUNDANCIA / DIMINUIÇÃO DA ENTROPIA (ETAPA 1)
% 
% %TEXTO
% %METODO A: BWT > MTF > RLE, BLOCOS DE 9KB
% [comp_txt_A,entropia_txt_A,racio_txt_A] = block_compression_txt_A(texto_vec,0,9);
% 
% %METODO B: BWT > MTF > DELTA ENCODING > RLE, BLOCOS DE 9KB
% [comp_txt_B,entropia_txt_B,racio_txt_B] = block_compression_txt_B(texto_vec,0,9);
% 
% %METODO C: DELTA ENCODING, APLICADO AO TEXTO NA SUA TOTALIDADE
% txt_C = delta_encoding(texto_vec,0);
% entropia_txt_C = entropia(txt_C);
% 
% %IMAGEM
% %METODO A: CODIFICAÇAO DOS ERROS DO PREDITOR DO JPEG-LS, APLICADO A IMAGEM
% %NA SUA TOTALIDADE
% img_A = preditor_LOCO_I(imagem,0);
% entropia_img_A = entropia(img_A);
% 
% %METODO B: DELTA ENCODING, APLICADO A IMAGEM NA SUA TOTALIDADE
% img_B = delta_encoding(imagem_vec,0);
% entropia_img_B = entropia(img_B);


% %CODIFICAÇÃO (ETAPA 2)
% 
% %TEXTO 
% %METODO X: BWT > MTF > RLE > HUFF
% [comp_txt_X,racio_txt_X] = codificacao_txt_X(texto_vec,0,9);
% 
% %METODO Y: BWT > MTF > RLE > ARIT
% [comp_txt_Y,racio_txt_Y] = codificacao_txt_Y(texto_vec,0,9);
%
% %METODO Z: BWT > MTF > RLE > LZW
% [comp_txt_Z,racio_txt_Z] = codificacao_txt_Z(texto_vec,0,9);
% 
% %METODO W: BWT > MTF > RLE > LZW > HUFF
% [comp_txt_W,racio_txt_W] = codificacao_txt_W(texto_vec,0,9);
% 
% %METODO K: BWT > MTF > RLE > LZW > ARIT
% [comp_txt_K,racio_txt_K] = codificacao_txt_K(texto_vec,0,9);



% %IMAGEM
% erros_img = preditor_LOCO_I(imagem,0);
% erros_vec = compression_init(erros_img,0);
%
% %METODO X: ERROS DO PREDITOR DO JPEG-LS > HUFFMAN
% [comp_img_X,racio_img_X] = codificacao_img_X(erros_vec,0,9);
% 
% %METODO Y: ERROS DO PREDITOR DO JPEG-LS > ARITMETICA
% [comp_img_Y,racio_img_Y] = codificacao_img_Y(erros_vec,0,9);
% 
% %METODO Z: ERROS DO PREDITOR DO JPEG-LS > HUFFMAN > ARIT
% [comp_img_Z,racio_img_Z] = codificacao_img_Z(erros_vec,0,9);
% 
% %METODO W: ERROS DO PREDITOR DO JPEG-LS > ARITMETICA > HUFFMAN
% [comp_img_W,racio_img_W] = codificacao_img_W(erros_vec,0,9);

% %TESTE EXTRA: ERROS DO PREDITOR DO JPEG-LS > HUFFMAN NA TOTALIDADE
% (IMAGEM)
% [comp_img_extra,info] = norm2huff(erros_vec);
% racio = (length(imagem_vec) - 3) / ( 2 + length(info.huffcodes) + length(info.length) );
% rest = huff2norm(comp_img_extra,info);
% rest = compression_init(rest,1);
% rest = preditor_LOCO_I(rest,1);

% %TESTE EXTRA: ERROS DO PREDITOR DO JPEG-LS > ARITMETICA NA TOTALIDADE
% %(IMAGEM)
% [comp_img_extra,Counts,Table] = Arith_Code(erros_vec);
% racio = (length(imagem_vec) - 3) / ( length(comp_img_extra) + length(Counts) + length(Table) );
% rest = Arith_Decode(comp_img_extra,Counts,Table);
% rest = compression_init(rest,1);
% rest = preditor_LOCO_I(rest,1);


% %TESTE EXTRA: BWT > MTF > RLE > ARITMETICA NA TOTALIDADE
% %(TEXTO)
% [comp_img_extra,Counts,Table] = Arith_Code(texto_vec);
% racio = (length(texto_vec) - 1) / ( length(comp_img_extra) + length(Counts) + length(Table) );
% rest = Arith_Decode(comp_img_extra,Counts,Table);
% rest = compression_init(rest,1);







% %REWRITE DO TEXTO
% texto = uint8(texto);
% texto = typecast(texto,'uint16');
% fileID=fopen("restaurado.txt",'w');
% fprintf(fileID,"%c",texto);
% fclose(fileID);
% clear fileID;

% %REWRITE DA IMAGEM
% imagem = uint8(imagem);
% imwrite(imagem,'restaurada.bmp');

