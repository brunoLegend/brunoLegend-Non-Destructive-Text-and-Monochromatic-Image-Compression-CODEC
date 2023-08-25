function vector = huff2norm(zipped,info)
%HUFF2NORM   Huffman codification (decoder)
%   For vectors, HUFF2NORM(X,INFO) returns a decoded vector from a Huffman coded version X
%   with code words given by INFO.
%   For matrices, X(:) is used as input.
%
%   Input X must be of uint8 type, while the output is a uint8 array.
%
%   For more details about how is INFO structured, see NORM2HUFF help.
%
%   See also NORM2HUFF
%   $Author: Giuseppe Ridino' $
%   $Revision: 1.0 $  $Date: 10-May-2004 15:03:04 $

info.huffcodes = typecast(info.huffcodes,'double');
info.length = typecast(info.length, 'double');


% ensure to handle uint8 input vector
zipped = uint8(zipped);

% create the 01 sequence
len = length(zipped);
string = repmat(uint8(0),1,len.*8);
bitindex = 1:8;
for index = 1:len
	string(bitindex+8.*(index-1)) = uint8(bitget(zipped(index),bitindex));
end
	
% adjust string
string = logical(string(:)'); % make a row of it
len = length(string);
string((len-info.pad+1):end) = []; % remove 0 padding
len = length(string);
% build output
vector = repmat(uint8(0),1,info.length);
vectorindex = 1;
codeindex = 1;
code = 0;
for index = 1:len
	code = bitset(code,codeindex,string(index));
	codeindex = codeindex+1;
	byte = decode(bitset(code,codeindex),info);
	if byte>0 % a code has been found
		vector(vectorindex) = byte-1;
		codeindex = 1;
		code = 0;
		vectorindex = vectorindex+1;
	end
end

vector = double(vector);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function byte = decode(code,info)
byte = info.huffcodes(code);
