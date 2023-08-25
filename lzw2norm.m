function [output,table] = lzw2norm (vector, maxTableSize, restartTable)


vector = uint8(vector);
vector = typecast(vector,'uint16');

vector = vector(:)';

if (nargin < 2)
	maxTableSize = 4096;
	restartTable = 0;
end
if (nargin < 3)
	restartTable = 0;
end


	function [] = addCode(lastCode, c)
		% Add a new code to the table

		e.c = c;	% NB using variable in parent to avoid allocation cost
		e.lastCode = lastCode;
		e.prefix = [];
		e.codeLength = table.codes(lastCode).codeLength + 1;
		table.codes(table.nextCode) = e;
		table.codes(lastCode).prefix = [table.codes(lastCode).prefix table.nextCode];
		table.nextCode = table.nextCode + 1;

		% if (isempty(lastCode))
		% 	fprintf('addCode   : ---- + %02x = %04x\n', c, table.nextCode-1);
		% else
		% 	fprintf('addCode   : %04x + %02x = %04x\n', lastCode, c, table.nextCode-1);
		% end;
	end

	function str = getCode(code)
		% Output the string for a code

		l = table.codes(code).codeLength;
		str = zeros(1, l);
		for ii = l:-1:1
			str(ii) = table.codes(code).c;
			code = table.codes(code).lastCode;
        end
	end

	function [] = newTable
		% Build the initial table consisting of all codes of length 1. The strings
		% are stored as prefixCode + character, so that testing is very quick. To
		% speed up searching, we store a list of codes that each code is the prefix
		% for.
		e.c = 0;
		e.lastCode = -1;
		e.prefix = [];
		e.codeLength = 1;
		table.nextCode = 2;
		if (~isinf(maxTableSize))
			table.codes(1:maxTableSize) = e; % Pre-allocate for speed
		else
			table.codes(1:65536) = e; % Pre-allocate for speed
        end
        
		for c = 1:255
			e.c = c;
			e.lastCode = -1;
			e.prefix = [];
			e.codeLength = 1;
			table.codes(table.nextCode) = e;
			table.nextCode = table.nextCode + 1;
        end
        
	end
%
% Main loop
%
e.c = 0;
e.lastCode = -1;
e.prefix = [];
e.codeLength = 1;
newTable;
output = zeros(1, 3*length(vector), 'uint8'); % assume compression of 33%
outputIndex = 1;
lastCode = vector(1);
output(outputIndex) = table.codes(vector(1)).c;
outputIndex = outputIndex + 1;
character = table.codes(vector(1)).c;
tic;
for vectorIndex=2:length(vector)
	% 	if mod(vectorIndex, 1000) == 0
	% 		fprintf('Index: %5d, Time %.1fs, Table Length %4d, Complete %.1f%%\n', outputIndex, toc, table.nextCode-1, vectorIndex/length(vector)*100); %*ceil(log2(size(table, 2)))/8);
	% 		tic;
	% 	end;

	element = vector(vectorIndex);
	if (element >= table.nextCode)
		% add codes not in table, a special case.
		str = [getCode(lastCode) character];
    else
		str = getCode(element);
	end
	output(outputIndex + (0:length(str)-1)) = str;
	outputIndex = outputIndex + length(str);
	if ((length(output)-outputIndex) < 1.5*(length(vector)-vectorIndex))
		output = [output zeros(1, 3*(length(vector)-vectorIndex), 'uint8')];
    end
	if (length(str) < 1)
		keyboard;
    end
	character = str(1);
	if (table.nextCode <= maxTableSize)
		addCode(lastCode, character);
		if (restartTable && table.nextCode == maxTableSize+1)
			% fprintf('New table\n');
			newTable;
        end

    end
	lastCode = element;
end

output = output(1:outputIndex-1);
output = double(output);

table.codes = table.codes(1:table.nextCode-1);

end