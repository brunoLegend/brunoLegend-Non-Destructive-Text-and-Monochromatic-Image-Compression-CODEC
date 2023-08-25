function [out_data,primary_index] = bwt(input, encode_or_d, index) %encode_or_d: 0 - encoding, 1 - decoding

    if encode_or_d == 0 %encoding

        b=zeros(1,2*length(input));

        for sort_len=1:length(b)
            if(sort_len>length(input))
                b(sort_len)=input(sort_len-length(input));
            else
                b(sort_len)=input(sort_len);
            end
        end
        input=char(input);
        b=char(b);
        to_sort=zeros(length(input),length(input));
        for row_sort=1:length(input)
            to_sort(row_sort,:)=b(row_sort:length(input)+row_sort-1);
        end
        char(to_sort);
        [lexi_sorted_data,ind]=sortrows(to_sort);
        char(lexi_sorted_data);

        encoded_data=lexi_sorted_data(:,length(input));
        primary_index=find(ind==2);
        out_data=ctranspose(encoded_data);
        

    elseif encode_or_d == 1 %decoding

        encoded_data=input;
        sorted_data=sort(encoded_data);
        vector_flag=ones(1,length(encoded_data))';
        vector=zeros(1,length(encoded_data))';
        %preparing vector table
        for i=1:length(sorted_data)
            for j=1:length(sorted_data)
                if(encoded_data(j)==sorted_data(i) && vector_flag(j))
                    vector_flag(j);
                    vector(i)=j;
                    vector_flag(j)=0;
                    break

                end
            end
        end

        out_data=zeros(1,length(encoded_data));
        %getting original data back
        for i=1:length(encoded_data)
            out_data(i)=encoded_data(index);
            index=vector(index);
        end



    end

end

       