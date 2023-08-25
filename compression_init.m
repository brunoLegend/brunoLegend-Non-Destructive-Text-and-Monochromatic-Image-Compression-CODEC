function resultado = compression_init(input, encode_or_d) %transforma imagem ou texto num vetor, com um identificador, e se imagem, guarda o numero de colunas
        
    input=double(input);
    if encode_or_d == 0 %encoding
        
        
        nlinhas = size(input,1);
        ncolunas = size(input,2);
        vec = zeros(1,nlinhas*ncolunas);
        index=1;
        for l=1:nlinhas
            for c=1:ncolunas
               vec(index) = input(l,c);
               index = index+1; 
            end
        end
        
        if nlinhas > 1 && ncolunas > 1 %imagem
            
            d=ncolunas/255;
            d=floor(d);
            resto = ncolunas - (d*255);
            
            resultado = [1,d,resto,vec]; %identificador,a multiplicar por 255,resto,vetor
        else %text
            resultado = [0,vec]; %identificador,vetor
        end
        
    elseif encode_or_d == 1 %decoding
           
        if input(1) == 0 %texto
            resultado = input(2:end);
        else %image
            vec=input(4:end);
            ncol = 255*input(2)+input(3);
            resultado = vec2mat(vec,ncol);
        end
    end


end