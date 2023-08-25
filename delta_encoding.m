function resultado = delta_encoding(input, encode_or_d)

    if encode_or_d == 0 %encoding
        
        resultado=zeros(1,length(input));
        resultado(1) = input(1);
        for i=2:length(input)
            resultado(i) = input(i) - input(i-1);
        end
        
        
        for i=2:length(resultado)
            if(resultado(i) < 0)
               resultado(i) = 256 + resultado(i); %codificamos como tam_alfabeto(neste caso 256, que são quantos numeros podemos representar num byte) - valor absoluto do delta
            end
        end
        
    elseif encode_or_d == 1 %decoding
        
        resultado=zeros(1,length(input));
        resultado(1) = input(1);
        for i=2:length(input)
            resultado(i) = mod(resultado(i-1) + input(i), 256);
        end
        
    end


end