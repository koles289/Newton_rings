function [ center ] = find_symetry(BW,zvacsenie)
% Najdenie stredu kruhu na zaklade najdenia symetrie. Symetria sa hlada preklopenim obrazu o 90 a 180 stupnov
% Ocakavame, ze pokial je kruh plne symetricky, vsetky tieto obrazy by mali
% byt rovnake a preto rozdiel povodneho a otoceneho obrazu by mal byt nulovy.
% Stret sa hlada najdenim casti obrazu, kde je suma tychto rozdielov
% najnizsia.
% Nastavovanie parametrov, pre rozne kruhy
% pre zvacsenie 10 musi byt maly krok 5 a male okno 201 (vzdy neparne)
% pre zvacsenie 4 musi byt velky krok (aspon 10) a velke okno minim8lne 400
% 
[r,s]=size(BW);
poc=1; i=100; j=100; % nepredpokladame stred kruhu na kraji obrazu

switch zvacsenie
    case 0
        sym_dl=800; % Dlzka okna
        prah_h=0.7; % Nehchceme abz sme dostavali cisto biele alebo cisto cierne okno
        prah_d=0.3; % Chceme mat v okne zarucene priblizne rovnomerne zastupenie ciernych a bielych pixlov
        krok=5;
    case 4
        sym_dl=350;
         prah_h=0.6;
        prah_d=0.3; 
        krok=3; % potrebujeme vacsiu presnost pre hladanie stredu
    otherwise
        disp('Nevybrate zvacsenie')
        return 
end
    
while i<(r-(sym_dl))  % bolo tu + 200 ked to chodila na zvacseni 10
while j<(s-(sym_dl))
    maska=BW(i:(i+sym_dl),j:(j+sym_dl));
    pomer=sum(sum( maska))/(sym_dl*sym_dl);
% Nechcem mat v obraze prazdne okna
    if pomer>prah_d && pomer<prah_h
        %symetricky otoceny obraz.
    maska_s=imrotate(maska,180);
    maska_k=imrotate(maska,90);
    % 0 je symetricka cast 1 a -1 nesymetricka
    Symetria(1,poc)=sum(sum(abs(maska-maska_s)+abs(maska-maska_k)));
    Symetria(2,poc)=i;
    Symetria(3,poc)=j;
    j=j+krok;
    poc=poc+1;
    else
    j=j+krok;
    end
    clear maska
end
j=1;
i=i+krok;
end
% Chceme co najviac nul, takze co najmensiu sumu.
[~,pozice]=min(Symetria(1,:));           
    center(1,1)=Symetria(2,pozice)+floor(sym_dl/2);
    center(2,1)=Symetria(3,pozice)+floor(sym_dl/2);


