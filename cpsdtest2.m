load('L:\Uni\Diploma\Adat\Kesz\20040405\20040512IMPRCCF\UZEM1.MAT');
% IDOSOR2CSDCOHPHA tipusu szamitas
TIMTEMP = zeros(sorszam, oszlopszam);
k = 32;
for j = 1:oszlopszam
    for i = ((j-1)*k+1):sorszam
        i-(j-1)*k
        TIMTEMP(i, j) = TIM(i-(j-1)*k, 1);
    end
end
TIM =TIMTEMP;
clear TIMTEMP;
save('L:\Uni\Diploma\Adat\Kesz\20040405\20040512IMPRCCF\UZEM1PROBA.MAT', 'TIM', 'IDO', 'sorszam', 'oszlopszam', 'fmint', 'dt', 'timarg');
keretcsuvimasatlag('L:\Uni\Diploma\Adat\Kesz\20040405\20040512IMPRCCF\', 'UZEM1PROBA', 131072, 2000, RECTWIN(131072), 'RECTWIN(131072)', 0, '');
cpsdfilter2imprrun('L:\Uni\Diploma\Adat\Kesz\20040405\20040512IMPRCCF\', 'UZEM1PROBA', '', '', '');
% CSD tukrozes jellegu szamitas
fprintf(['CSD tukrozeses szamitas kezdodik\n']);
x = TIM((1:131072), 1);
y = zeros(131072, 1);
for i = 1:k
    y(i, 1) = 0;
end
for i = k+1:131072
    y(i, 1) = x(i-k, 1);
end
fprintf(['CSD tukrozeses szamitas vege-----\n']);
% PHA, CCF es IMPR kiszamitasa a definiciok alapjan - FFT-k szorzasaval
fprintf(['FFT alapu szamitas kezdodik-------\n']);
X = fft(x);                                                                                      % A valtozok Fourier-transzformalasa
Y = fft(y);
CPSD = zeros(131072, 1);                                                           % A memoria lefoglalasa 
APSD = zeros(131072, 1);
APSDCPSD = zeros(131072, 1);
IDO = zeros(131072, 1);
F = zeros(131072, 1);
for i = 1:131072                                                                           % Spektrumok, ido, frekvencia kiszamitasa 
    CPSD(i, 1) = conj(X(i, 1))*Y(i, 1);
    APSD(i, 1) = conj(X(i, 1))*X(i, 1);
    IDO(i, 1) = (i-65536)/2000;
    APSDCPSD(i, 1) = CPSD(i, 1)/APSD(i, 1);
    F(i, 1) =  2*(i-65536)*(2000/(2*131072));
end
PHA = angle(CPSD);
CCF=fftshift(ifft(CPSD));
IMPR = fftshift(ifft(APSDCPSD));
fprintf(['FFT alapu szamitas vege-----------\n']);
% PHA, CCF es IMPR kiszamitasa a Matlab CSD függvénye alapjan 
fprintf(['A CSD alapu szamitas kezdodik-----\n']);
[PXY,FCSD] = CSD(x,y,131072,2000,RECTWIN(131072),0);
[PXX,FCSD] = CSD(x,x,131072,2000,RECTWIN(131072),0);
s = length(PXY);
IMPRPSD = zeros(s, 1);
for i = 1:s
    IMPRPSD(i, 1) = PXY(i, 1)/PXX(i, 1);
end
IMPRCSD = fftshift(ifft(IMPRPSD));
CCFCSD = fftshift(ifft(PXY));
PHACSD = angle(PXY);
b = length(IMPRCSD);
 if rem(b, 2)
    hatar = (b+1)/2;
else
    hatar = (b/2)+1;
end
hatar
dfcsd = F(2, 1) - F(1, 1);
dtcsd = 2*1/(2*b*dfcsd);
IDOCSD = zeros(b, 1);
for i = 1:b
    IDOCSD(i, 1) = (i-hatar)*dtcsd;
end
fprintf(['A CSD alapu szamitas vege---------\n']);
% PHA, CCF es IMPR kiszamitasa a CSD alapjan kepzett spektrum konjugalasos tukrozesevel
fprintf(['A CSD tukrozeses szamitas kezdodik\n']);
[PXYM,FM] = CSD(x,y,131072,2000,RECTWIN(131072),0);
[PXXM,FM] = CSD(x,x,131072,2000,RECTWIN(131072),0);
sorszam = length(PXYM);
CPSDM = zeros(2*sorszam-1, 1);                                                      % Tukrozi a CSD elemeit a negativ tengelyre es konjugalja oket
APSDM = zeros(2*sorszam-1, 1);
FMN = zeros(2*sorszam-1, 1);
IDOM = zeros(2*sorszam-1, 1);
dfm = FM(2, 1)-FM(1, 1);
dtm = 1/((2*sorszam-1)*dfm);
for i = 1:sorszam
    v = i-1;
    w = sorszam+v;
    z = sorszam-v;
    APSDM(w, 1) = PXXM(i, 1);
    APSDM(z, 1) = conj(PXXM(i, 1));
    CPSDM(w, 1) = PXYM(i, 1);
    CPSDM(z, 1) = conj(PXYM(i, 1));
    FMN(w, 1) = FM(i, 1);
    FMN(z, 1) = -FM(i, 1);
    IDOM(w, 1) = v*dtm;
    IDOM(z, 1) = -v*dtm;
end
IMPRPSDM = zeros(2*sorszam-1, 1);
for i = 1:(2*sorszam-1)
   IMPRPSDM(i, 1) = CPSDM(i, 1)/APSDM(i, 1);
end
CCFM = fftshift(ifft(CPSDM));
IMPRM = fftshift(ifft(IMPRPSDM));
PHAM = angle(CPSDM);
fprintf(['A CSD tukrozeses szamitas vege----\n']);
% % Eredmenyek abrazolasa
% Definicio alapjan
figure
plot(IDO, abs(CCF)); xlabel('t (s)'); ylabel('CCF MAG'); title('CCF definíció alapján');
figure
semilogy(IDO, abs(IMPR)); xlabel('t (s)'); ylabel('IMPR MAG'); title('IMPR definíció alapján');
figure
plot(F, PHA); xlabel('f (Hz)'); ylabel('PHA (rad)'); title('PHA definíció alapján');
% % CSD alapjan
figure
plot(IDOCSD, abs(CCFCSD)); xlabel('t (s)'); ylabel('CCF MAG'); title('CCF CSD alapján');
figure
semilogy(IDOCSD, abs(IMPRCSD)); xlabel('t (s)'); ylabel('IMPR MAG'); title('IMPR CSD alapján');
figure
plot(FCSD, PHACSD); xlabel('f (Hz)'); ylabel('PHA (rad)'); title('PHA CSD alapján');
% % CSD tukrozessel
figure
plot(IDOM, abs(CCFM)); xlabel('t (s)'); ylabel('CCF MAG'); title('CCF tukrozessel');
figure
semilogy(IDOM, abs(IMPRM)); xlabel('t (s)'); ylabel('CCF MAG'); title('IMPR tukrozessel');
figure
plot(FMN, PHAM); xlabel('f (Hz)'); ylabel('PHA (rad)'); title('PHA tukrozessel');
fprintf(['A mentes kezdodik\n']);
save('L:\Uni\Diploma\Adat\Kesz\20040405\20040512IMPRCCF\UZEM1REF.MAT', 'x', 'y', 'X', 'Y', 'CCF', 'PHA', 'IMPR', 'IDO', 'F', 'IMPRCSD', 'CCFCSD', 'IMPRCSD', 'FCSD', 'IDOCSD', 'IMPRM', 'CCFM', 'PHAM', 'IDOM', 'FMN');