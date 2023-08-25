function output = algoritmo_final_txt(input, encode_or_d, kBytes)
    
    %ALGORITMO: BWT > MTF > RLE > CODIFICAÇÃO ARITMÉTICA, BLOCO A BLOCO

    
    input = double(input);

    if encode_or_d == 0 %encoding
        
        input = compression_init(input,0);
        
        bytes = kBytes * 1000;
        
        %DEBUG----------------------------------
        %bytes=10;
        numBlocos = length(input)/bytes;
        div = floor(numBlocos);
        if numBlocos > div
            numBlocos = div + 1;
        end
        
        tic;
        fprintf("INITIALIZING COMPRESSION IN BLOCKS OF %d KBYTES...\n",kBytes);
        fprintf("NUMBER OF BLOCKS: %d\n",numBlocos); 
        block_count=0; 
        %DEBUG----------------------------------
        
        processed_bytes = 0;
        block = zeros(1,bytes);
        len = length(input);
        output = [];
        for i=1:bytes:len
            
            max = i+bytes-1;
            
            if processed_bytes + bytes - len >= 0 % se no ultimo bloco
                max = i+len-processed_bytes-1;
                block = zeros(1,len-processed_bytes);
            end
            
            index=1;
            for j=i:max
               block(index) = input(j);
               index = index + 1;
            end
            
            %COMPRESSÃO DO BLOCO -----------------------
            [to_compress, bwt_index] = bwt(block,0);
            
            mult_bwtindex = bwt_index/255;
            mult_bwtindex = floor(mult_bwtindex);
            resto_bwtindex = bwt_index - (mult_bwtindex*255);
            
            to_compress = mtf(to_compress,0);
            to_compress = new_rle(to_compress,0);
            to_compress = rle_byte_fix(to_compress);
            
            [compressed,Counts,Table] = Arith_Code(to_compress);
        
            len_counts = length(Counts);
            mult = len_counts/255;
            mult = floor(mult);
            resto = len_counts - (mult*255);

            compressed_block = [mult_bwtindex,resto_bwtindex,mult,resto,Counts,length(Table)-1,Table,compressed];
            %COMPRESSÃO DO BLOCO -----------------------
            
            %é necessario registar o tamanho de cada bloco
            len_comprimido = length(compressed_block);
            mult_tamBloco = len_comprimido/255;
            mult_tamBloco = floor(mult_tamBloco);
            resto_tamBloco = len_comprimido - (mult_tamBloco*255);

            new = [mult_tamBloco,resto_tamBloco,compressed_block];
            output = cat(2,output,new); %concatenaçao do bloco comprimido ao total
            
            processed_bytes = processed_bytes + bytes;
            
            %DEBUG
            block_count = block_count+1; 
            fprintf("COMPRESSED BLOCK %d/%d\n",block_count,numBlocos);
        end
        
        %Escrita para ficheiro
        towrite = uint8(output);
        fileID=fopen("compressed_txt.jzip",'w');
        fwrite(fileID,towrite,'uint8');
        fclose(fileID);
        clear fileID;
        
        fprintf("SUCCESSFULLY COMPRESSED.");
        toc;
        
        
    elseif encode_or_d == 1 %decoding
        
        block_count=0; %DEBUG
        
        i=1;
        processed_bytes = 0;
        len = length(input);
        output = [];
        
        tic;
        while processed_bytes < len
            compressedBlockSize = 255*input(i) + input(i+1);
            i = i + 2;
            
            compressed_block = zeros(1,compressedBlockSize);
            index = 1;
            for j=i:i+compressedBlockSize-1
                compressed_block(index) = input(j);
                index = index + 1;
            end
            i=j+1;
            block_count = block_count+1; 
            %DESCOMPRESSÃO DO BLOCO -----------------------
            bwt_index = 255*compressed_block(1)+compressed_block(2);
            to_decompress = compressed_block(3:end);
            
            len_counts = 255*to_decompress(1)+to_decompress(2);
            offset=2;
            Counts = to_decompress(3:len_counts+offset);
            Counts = uint8(Counts);

            len_table = to_decompress(len_counts+3) + 1;
            offset = offset + len_counts + 1;
            Table = to_decompress(len_counts+4:len_table+offset);

            offset = offset + len_table + 1;
            to_decompress = to_decompress(offset:end);

            to_decompress = Arith_Decode(to_decompress,Counts,Table);
            
            to_decompress = new_rle(to_decompress,1);
            to_decompress = mtf(to_decompress,1);
            to_decompress = double(to_decompress);
            original_block = bwt(to_decompress,1,bwt_index);
            %DESCOMPRESSÃO DO BLOCO -----------------------
            
            output = cat(2,output,original_block); %concatenacao ao original
            processed_bytes = processed_bytes + compressedBlockSize + 2;
            
            %DEBUG
            
            fprintf("DECOMPRESSED BLOCK %d\n",block_count);
        end
        output = compression_init(output,1);
        
        %Escrita para ficheiro
        towrite = uint8(output);
        towrite = typecast(towrite,'uint16');
        fileID=fopen("restaurado.txt",'w');
        fprintf(fileID,"%c",towrite);
        fclose(fileID);
        clear fileID;
        
        fprintf("SUCCESSFULLY DECOMPRESSED.");
        toc;
        
    end



end