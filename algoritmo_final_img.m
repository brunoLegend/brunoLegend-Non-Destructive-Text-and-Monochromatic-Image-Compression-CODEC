function output = algoritmo_final_img(input, encode_or_d)
    
    %ALGORITMO: CODIFICAÇÃO ERROS DO PREDITOR DO JPEG-LS > CODIFICAÇÃO ARITMETICA NA TOTALIDADE

    input = double(input);
    if encode_or_d == 0 %encoding
        
        erros_img = preditor_LOCO_I(input,0);
        erros_vec = compression_init(erros_img,0);
        
        [compressed,Counts,Table] = Arith_Code(erros_vec);
        
        len_counts = length(Counts);
        mult = len_counts/255;
        mult = floor(mult);
        resto = len_counts - (mult*255);
        
        output = [mult,resto,Counts,length(Table)-1,Table,compressed];
        
        %Escrita para ficheiro
        towrite = uint8(output);
        fileID=fopen("compressed_img.jzip",'w');
        fwrite(fileID,towrite,'uint8');
        fclose(fileID);
        clear fileID;
        
        
    elseif encode_or_d == 1 %decoding
        
        len_counts = 255*input(1)+input(2);
        offset=2;
        Counts = input(3:len_counts+offset);
        Counts = uint8(Counts);
        
        len_table = input(len_counts+3) + 1;
        offset = offset + len_counts + 1;
        Table = input(len_counts+4:len_table+offset);
        
        offset = offset + len_table + 1;
        compressed = input(offset:end);
        
        output = Arith_Decode(compressed,Counts,Table);
        output = compression_init(output,1);
        output = preditor_LOCO_I(output,1);
        output = uint8(output);
        
        %Escrita para ficheiro
        imwrite(output,"restaurada.bmp");

    end



end