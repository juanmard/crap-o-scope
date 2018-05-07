x = (0:1:599);
fx = round((sin(x/32)+1.25)*256*5);

% Save wave.
file_name = 'wave.list';
fileID = fopen(file_name,'w');
fbin = dec2bin(fx,8);
new = cellstr(fbin);
fprintf(fileID,'// Generado por "wave.m" a las %s\n',datestr(now,'HH:MM:SS.FFF'));
fprintf(fileID,'%s\n',new{:});
fclose(fileID);