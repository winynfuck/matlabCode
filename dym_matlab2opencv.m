function dym_matlab2opencv(variable, fileName, flag, varClass)
%此函数用于将matlab内的变量转换伟yml数据库文件，然后可以在opencv中读取yml数据库文件。运行环境是matlba.即先转换后调用文件。
% varClass: the variable class waiting for write:
%           'i': for int
%           'f': for float
% flag    : Write mode
%           'w': for write
%           'a': for append
 
[rows, cols] = size(variable);
 
% Beware of Matlab's linear indexing
variable = variable';
 
% Write mode as default
if ( ~exist('flag','var') )
    flag = 'w';
end
 
% float as default
if ( ~exist('varClass','var') )
    if isfloat(variable)
        varClass = 'f';
    else isinteger(variable)
        varClass = 'i';
    end
end
 
if ( ~exist(fileName,'file') || flag == 'w' )
    % New file or write mode specified
    file = fopen( fileName, 'w');
    fprintf( file, '%%YAML:1.0\n');
else
    % Append mode
    file = fopen( fileName, 'a');
end
 
% Write variable header
 
fprintf( file,  '    %s: !!opencv-matrix\n', inputname(1));
fprintf( file,  '        rows: %d\n', rows);
fprintf( file,  '        cols: %d\n', cols);
fprintf( file, ['        dt: ' varClass '\n']);
fprintf( file,  '        data: [ ');
 
% Write variable data
for i=1:rows*cols
    fprintf( file, ['%' varClass], variable(i));
    if (i == rows*cols), break, end
    fprintf( file, ', ');
    if mod(i+1,8) == 0
        fprintf( file, '\n            ');
    end
end
 
fprintf( file, ']\n');
 
fclose(file);
