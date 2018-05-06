x = (0:1:599);
fx = round((sin(x)+1)*127);

% Save wave.
file_name = 'wave.list';
fileID = fopen(file_name,'w');
fbin = dec2bin(fx,8);
new = cellstr(fbin);
fprintf(fileID,'%s\n',new{:});
fclose(fileID);