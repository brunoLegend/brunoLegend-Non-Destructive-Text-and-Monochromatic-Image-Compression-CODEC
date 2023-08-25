function result = rle(x, encode_or_d)

    if encode_or_d == 0 %encoding

        if size(x,1) > size(x,2), x = x'; end % if x is a column vector, transpose
        i = [ find(x(1:end-1) ~= x(2:end)) length(x) ];
        data{2} = diff([ 0 i ]);
        data{1} = x(i);

        result = zeros(1,length(data{1})*2);
        result(1:2:end-1) = data{1};
        result(2:2:end)   = data{2};

    elseif encode_or_d == 1 %decoding

        val = x(1:2:end);
        len = x(2:2:end);

        i = cumsum([ 1 len ]);
        j = zeros(1, i(end)-1);
        j(i(1:end-1)) = 1;
        result = val(cumsum(j));

    end

end