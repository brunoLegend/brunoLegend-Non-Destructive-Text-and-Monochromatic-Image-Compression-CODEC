function output = rle_byte_fix(input)

    %writes lengths bigger than 255 to two bytes
    
    for j=1:length(input)
       
        if input(j) > 255
           
            left_side = input(1:j-1);
            right_side = input(j+1:end);
            
            len = input(j);
            mult = len/255;
            mult = floor(mult);
            resto = len - (mult*255);
            
            input=[left_side,0,mult,resto,right_side];
            
        end
        
    end
    
    output=input;
    
end