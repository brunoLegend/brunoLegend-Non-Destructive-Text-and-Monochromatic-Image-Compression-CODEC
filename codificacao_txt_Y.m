function [resultado,racio] = codificacao_txt_Y(input, encode_or_d, kBytes) %compressao em blocos parametrizavel
    
%   Nota: Esta função tem como limitação máxima 65kBytes para cada bloco, já que são utilizados dois bytes
%   guardando um múltiplo de 255 e um resto.
%   Exemplo: 265 = 255 * 1 + 10 -> 256 é representado com os números 1,10 (multiplo e resto, dois bytes).
%   No máximo podemos representar 255*255 = 65025, pelo que o limite é de 65kBytes por bloco
    
    input = double(input);

    if encode_or_d == 0 %encoding
        
        bytes = kBytes * 1000;
        
        %DEBUG----------------------------------
        %bytes=4;
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
        resultado = [];
        extra = 0;
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
            [compressed_block, bwt_index] = bwt(block,0);
            compressed_block = mtf(compressed_block,0);
            compressed_block = rle(compressed_block,0);
            
            [compressed_block,Counts,Table] = Arith_Code(compressed_block);
            extra = extra + length(Counts) + length(Table); 
            
            compressed_block = cat(2,bwt_index,compressed_block);
            %COMPRESSÃO DO BLOCO -----------------------
            
            %é necessario registar o tamanho de cada bloco
            len_comprimido = length(compressed_block);
            mult = len_comprimido/255;
            mult = floor(mult);
            resto = len_comprimido - (mult*255);

            new = [];
            new = cat(2,new,mult);
            new = cat(2,new,resto);
            new = cat(2,new,compressed_block);

            compressed_block = new;
            resultado = cat(2,resultado,compressed_block); %concatenaçao do bloco comprimido ao total
            
            processed_bytes = processed_bytes + bytes;
            
            %DEBUG
            block_count = block_count+1; 
            fprintf("COMPRESSED BLOCK %d/%d\n",block_count,numBlocos);
        end
        fprintf("SUCCESSFULLY COMPRESSED.");
        toc;
        
        racio = ( length(input)-1 ) / ( length(resultado) + extra );
        
    elseif encode_or_d == 1 %decoding
        
        block_count=0; %DEBUG
        
        i=1;
        processed_bytes = 0;
        len = length(input);
        resultado = [];
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
            bwt_index = compressed_block(1);
            compressed_block = compressed_block(2:end);
            original_block = rle(original_block,1);
            original_block = mtf(original_block,1);
            original_block = bwt(original_block,1,bwt_index);
            %DESCOMPRESSÃO DO BLOCO -----------------------
            
            resultado = cat(2,resultado,original_block); %concatenacao ao original
            processed_bytes = processed_bytes + compressedBlockSize + 2;
            
            %DEBUG
            
            fprintf("DECOMPRESSED BLOCK %d\n",block_count);
        end
        
    end


end