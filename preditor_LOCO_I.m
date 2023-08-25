function resultado = preditor_LOCO_I(input, encode_or_d)

     nlinhas = size(input,1);
     ncolunas = size(input,2);

    if encode_or_d == 0 %encoding
        
        prediction_matrix = zeros(nlinhas,ncolunas);

        for l=1:nlinhas
            for c=1:ncolunas

                if l == 1 && c == 1 %top left
                    prediction_matrix(l,c) = 128; 
                elseif l == 1 && c ~= 1 %primeira linha
                    A = input(l,c-1);
                    prediction_matrix(l,c) = A;
                elseif c == 1 && l ~= 1 %primeira coluna
                    B = input(l-1,c);
                    prediction_matrix(l,c) = B;
                else %restantes

                    A = input(l,c-1);
                    B = input(l-1,c);
                    C = input(l-1,c-1);

                    if C >= max(A,B)
                        prediction_matrix(l,c) = min(A,B); 
                    elseif C <= min(A,B)
                        prediction_matrix(l,c) = max(A,B);  
                    else
                        prediction_matrix(l,c) = A + B - C;
                    end

                end

            end
        end
        
        
        %matriz de residuos
        resultado = input - prediction_matrix; 
        resultado(1,1) = input(1,1); %guardamos o valor no top left
        
        for l=1:nlinhas
            for c=1:ncolunas
                if resultado(l,c) < 0
                    resultado(l,c) = 256 + resultado(l,c); %codificamos como tam_alfabeto - valor absoluto do erro
                end
            end
        end
        
        
    elseif encode_or_d == 1 %decoding
        
        resultado = zeros(nlinhas,ncolunas);
        %restauramos a imagem com os erros, partindo do valor no top left
        for l=1:nlinhas
            for c=1:ncolunas

                if l == 1 && c == 1 %top left
                    resultado(l,c) = input(1,1); 
                elseif l == 1 && c ~= 1 %primeira linha
                    A = resultado(l,c-1);
                    resultado(l,c) = mod(A + input(l,c), 256);
                    
                elseif c == 1 && l ~= 1 %primeira coluna
                    B = resultado(l-1,c);
                    resultado(l,c) = mod(B + input(l,c), 256);
                else %restantes

                    A = resultado(l,c-1);
                    B = resultado(l-1,c);
                    C = resultado(l-1,c-1);

                    if C >= max(A,B)
                        resultado(l,c) = mod(min(A,B) + input(l,c), 256); 
                    elseif C <= min(A,B)
                        resultado(l,c) = mod(max(A,B) + input(l,c), 256);  
                    else
                        resultado(l,c) = mod(A + B - C + input(l,c), 256);
                    end

                end

            end
        end

    end




end