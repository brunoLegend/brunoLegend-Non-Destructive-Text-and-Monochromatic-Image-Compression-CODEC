function result = mtf(input, encode_or_d) %encode_or_d: 0 - encoding, 1 - decoding
    
    
    symTable = 0:255;
    
    if encode_or_d == 0 %encoding
        
        n = length(input);
        result = zeros(1, n);
        for k = 1:n
            result(k) = find(input(k) == symTable, 1);
            symTable = [symTable(result(k)) symTable(1:result(k)-1) symTable(result(k)+1:end)];
        end
        result = result-1;
        
    elseif encode_or_d == 1 %decoding
        
        input = input+1;
        n = length(input);
        result = char(zeros(1, n));
        for k = 1:n
            result(k) = symTable(input(k));
            symTable = [symTable(input(k)) symTable(1:input(k)-1) symTable(input(k)+1:end)];
        end
        
    end


end
