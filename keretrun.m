%KERETRUN
% 
% Celja a keretcsuvi lefuttatasa a 3 uzemallapotra
% 
% keretcsuvimasatlag('E:\Uni\Diploma\Adat\Kesz\20040405\20040511IMPRCCF\', 'UZEM1', 131072, 2000, HANNING(131072), 'HANNING(131072)', 131072/2, '');
% keretcsuvimasatlag('E:\Uni\Diploma\Adat\Kesz\20040405\20040511IMPRCCF\', 'UZEM2', 131072, 2000, HANNING(131072), 'HANNING(131072)', 131072/2, '');
% keretcsuvimasatlag('E:\Uni\Diploma\Adat\Kesz\20040405\20040511IMPRCCF\', 'UZEM3', 131072/2, 2000, HANNING(131072/2), 'HANNING(131072/2)', 131072/4, '');
% cpsdfilterrun('E:\Uni\Diploma\Adat\Kesz\20040405\20040511IMPRCCF\', 'UZEM1', '', 0.2, 0.8, 'F');
% cpsdfilterrun('E:\Uni\Diploma\Adat\Kesz\20040405\20040511IMPRCCF\', 'UZEM2', '', 0.2, 0.8, 'F');
% cpsdfilterrun('E:\Uni\Diploma\Adat\Kesz\20040405\20040511IMPRCCF\', 'UZEM3', '', 0.2, 0.8, 'F');
% cpsdfilter2imprrun('E:\Uni\Diploma\Adat\Kesz\20040405\20040511IMPRCCF\', 'UZEM1', '', '', '');
% cpsdfilter2imprrun('E:\Uni\Diploma\Adat\Kesz\20040405\20040511IMPRCCF\', 'UZEM2', '', '', '');
% cpsdfilter2imprrun('E:\Uni\Diploma\Adat\Kesz\20040405\20040511IMPRCCF\', 'UZEM3', '', '', '');
% cpsdfilter2imprrun('E:\Uni\Diploma\Adat\Kesz\20040405\20040511IMPRCCF\', 'UZEM1', '', 'F', '');
% cpsdfilter2imprrun('E:\Uni\Diploma\Adat\Kesz\20040405\20040511IMPRCCF\', 'UZEM2', '', 'F', '');
% cpsdfilter2imprrun('E:\Uni\Diploma\Adat\Kesz\20040405\20040511IMPRCCF\', 'UZEM3', '', 'F', '');
% cpsdfilterrun('L:\Uni\Diploma\Adat\Kesz\20040405\20040512IMPRCCF\', 'UZEM1PROBA', '', 0, 0.8, 'F');
% cpsdfilter2imprrun('L:\Uni\Diploma\Adat\Kesz\20040405\20040512IMPRCCF\', 'UZEM1PROBA', '', 'F', 'I');
load('L:\Uni\Diploma\Adat\Kesz\20040405\20040512IMPRCCF\UZEM1PROBACPSD12FIMPRI.MAT');
l = length(IMPRM);
s = length(IMPR);
w = rectwin(l);
z = rectwin(s);
IMPRMW = zeros(l, 1);
for i = 1:l
    IMPRMW(i, 1) = IMPRM(i, 1)/w(i, 1);
end
figure
semilogy(IDOM, abs(IMPRMW)); xlabel('t (s)'); ylabel('IMPR MAG'); title('Normált IMPRM');
IMPRZ = zeros(s, 1);
for i = 1:s
    IMPRZ(i, 1) = IMPR(i, 1)/z(i, 1);
end
figure
semilogy(IDO, abs(IMPRZ)); xlabel('t (s)'); ylabel('IMPR MAG'); title('Normált IMPR');