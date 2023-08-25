function result = new_rle(x, encode_or_d)

    if encode_or_d == 0 %encoding

        if size(x,1) > size(x,2), x = x'; end % if x is a column vector, transpose
        i = [ find(x(1:end-1) ~= x(2:end)) length(x) ];
        data{2} = diff([ 0 i ]);
        data{1} = x(i);

        result = zeros(1,length(data{1})*2);
        result(1:2:end-1) = data{1};
        result(2:2:end)   = data{2};

    elseif encode_or_d == 1 %decoding
        
        
        j=1;
        result = [];
        while j<=length(x)
            value = x(j);
            if x(j+1) == 0 %3 bytes para a length
                
                len = 255*x(j+2)+x(j+3);
                to_add = zeros(1,len);
                to_add = to_add + value;
                result = cat(2,result,to_add);
                
                j = j+4;
            else %1 byte para a length
                len = x(j+1);
                to_add = zeros(1,len);
                to_add = to_add + value;
                result = cat(2,result,to_add);
            
                j = j+2;
            end
        end
        

    end

end