 function [polomer] = HT3_for_CC(BW,cnt,zvacsenie)
% Vypocet polomeru sustredenych kruznic, pokial pozname stred kruznic.
% BW je hranoca detekcia z daneho obrazu, cnt su vypocitane stredy a
% zvacsenie je parameter zvacsenia kruhov, dolezity pre stanovenia delta a
% rozdielu polomerov
% Princip funkcie
% Vypocita sa vzdialenost kazdeho hranobeho pixlu ku suradniciam stredu (polomer),
% usporiadaju sa od najmensieho polomeru po najvacsi. Postupne pridávame
% hodnoty polomeru do zhluku a základe rozdielu vypocitanej priemernej vzdialenosti
% pixlov a novo priadenho pixlu j (parameter delta), na zaklade
% vzdialenosti min-max v ramci zhluku (2*delta) a schopnosti pixlov tvorit
% kruh o danom polomery - parameter T. 


% Nastavenie premennych
BW=im2double(BW);
[r0,s0]=size(BW);
[X,Y]=find(BW==1);
center=zeros(2,2); %pomocna premenna na stred
center(1,1)=cnt(1);  center(1,2)=cnt(2); 
 % pomer obvodu kruhu ku poctu pixlov, ktore ho tvoria

%%%%%%%%%%%%% Vyber kruhov %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Na zaklade yvacsenia  a farby si potrebujem vybrat najmensi mozny kruh
switch zvacsenie
    case 4
        delta=8; %vzdialenost min-max v zhluku predtym 6
        rozdiel=15; % Minimalna vzdialenost polomerov pocas behu kodu sa zmensuje
        min_pol=40;
        z=2;
        T=0.75;
    case 0
        delta=20;
         rozdiel=60;
         z=7;
         min_pol=100; % minimalny polomer
         T=0.8; %green 10_4 skusanie to bolo 0.75
    otherwise
        disp('Nespravne urcene rozlisenie. Vybratie z hodnot 4 alebo 10')
        return
        end

                   
%% Vypocet poctu kruhov a polomer
dp=zeros(1,length(X)); % polomer

% Vypocet vydialenosti hranovych pixlov od centra
for i=1:1:length(X)
dp(i)=sqrt(((X(i)-center(1,1))^2)+((Y(i)-center(1,2))^2));
end

%1. Take distance as key, and sort A to make an ascending array B by using the
% heapsort algorithm.
[d]=sort(dp);

% Deklaracia pomocnych premennych
j=2;  i=1; poc=2; polomer=[0];

   while j<length(d);
        r=mean(d(i):d(j));
        if abs(r-d(j))> delta || abs(d(j)-d(i))> 2*delta
            s=j-i;  % Pocet pixlov ktore tvoria kruh
            R=s/(2*pi*r); % Vypocet obvodu kruhu
            clear s;
            
            % nemam dostatok pixlov na vztvorenie kruhu o danom polomery
            if R<=T || (r-polomer(poc-1))<rozdiel
                i=j;
                j=j+1; % Tvor novy kruh
                
            else % Uloz polomer kruhu a zmensi prahove premenne
                polomer(poc)=r;
          poc=poc+1;   i=j;  delta=delta -(delta/30); rozdiel=rozdiel-z;
                
            end
        end
        j=j+1;
   end
% Odstranenie prvej nuly, ktoru sme tam museli vlozit pre porovnavanie   
polomer=polomer(polomer>min_pol);

