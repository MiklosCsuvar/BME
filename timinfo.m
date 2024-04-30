%TIMINFO
% Timinfo a TIM fajl feldolgozasahoz szukseges informaciokat adja meg a
% fajl tordelesehez. Ezek az adatok a kovetkezok:
% N : csatornaszam
% L:  a header hossza
% kezdet : az elso, meresi adatot tartalmazo byte pozicioja
% veg : az utolso, meresi adatot tartalmazo byte pozicioja
% osszes : a meresi pontok szama a csatornakban
% Alkalmazas:
%                          timinfo(timfile);
% 
% timfile: A feldolgozando timfile neve teljes eleresi utvonallal.
%
function timinfo(timfile);
fid = fopen(timfile);             
fseek(fid, 128, 'bof');      % A header hosszat tartalmazo cimre ugrik
L = fread(fid, 1, 'int16');  % Beolvassa a header hosszat;
fseek(fid, 134, 'bof');      % A csatornak szamat tartalmazo cimre ugrik
N = fread(fid, 1, 'int16' ); % Beolvassa a csatornak szamat
fseek(fid, 0, 'eof');           % A fajl vegere ugrik
veg = ftell(fid);                 % Beolvassa az aktualis poziciot
osszes = (veg - L)/(N*2); % Kiszamolja a meresi pontok szamat int16 formatumot feltetelezve
kezdet = L + 1;                % Az elso, meresi adatot tartalmazo byte poziciojat szamitja ki
fprintf('A header hossza                                                 : %u \n', L);
fprintf('A csatornak szama                                              : %u \n', N);
fprintf('Az elso, meresi adatot tartalmazo byte pozicioja  : %u \n', kezdet);
fprintf('Az utolso meresi adatot tartalmazo byte pozicioja: %u \n', veg);
fprintf('A meresi pontok szama egy csatornaban            : %u \n', osszes);