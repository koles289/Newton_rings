% Projekt FABO 26.04.2019

% Automatické urèení vlnové délky svìtla

% Realizujte program pro automatické urèení vlnové délky svìtla z 
% mikroskopických snímkù Newtonových  kroužkù.  Navržený  algoritmus  otestujte  
% na  množinì  obrazù  získaných  s rùznými optickými filtry a s rùzným zvìtšením. 
% Vypoètené hodnoty vlnových délek porovnejte s tabulkovými hodnotami filtrù.

% Vystupom projektu su premenne lambda2 a lamda1 vypocitane z dvoch roznych
% metod.
%
% Spolupracovali:
% Kristína Olešová, Barbora Pleskáèová a Alena Skoupilová


clc; clear all; close all
% Nacitanie obrayov a deklaracia pouzivanych prememnnych
imname='D:\škola\8.semester\FABO projekt\FABO\indigo_10x_3.tif';
obrazok=imread(imname);
zvacsenie=str2double(imname(length(imname)-7));
ref=im2double(imread('Kruznice.png'));
C=im2double(rgb2gray(obrazok));
%% nacteni referencnich obrazku pro vypocet meritka a jejich uprava
ref4=im2double(rgb2gray(imread('D:\škola\8.semester\FABO projekt\FABO\ref_4x.tif')));
ref10=im2double(rgb2gray(imread('D:\škola\8.semester\FABO projekt\FABO\ref_10x.tif')));

ref4=im2bw(ref4,0.5);
ref10=im2bw(ref10,0.5);

%jasovy profil ref. obrazku
f4=improfile(ref4,[280,1280],[750,750]);
f10=improfile(ref10,[85,1595],[550,550]);

%transpozice jasoveho profilu
f4=f4';
f10=f10';

%nalezeni vrcholu
[piky4,locy4] = findpeaks(f4);
[piky10,locy10] = findpeaks(f10);

%zprumerovani vzdalenosti mezi piky=>vysledny pocet pixelu pro 0.01mm
pixs4=round(mean(diff(locy4)));
pixs10=round(mean(diff(locy10)));

%prirazeni meritka pro dane zvetseni
if zvacsenie==0
    meritko=pixs10;
elseif zvacsenie==4
    meritko=pixs4;
end
%% Uprava obrazov
SUM= Color_Saliency(im2double(obrazok)); % Najdenie sumu v obraze
obr_G = adapthisteq(medfilt2(C,[3,3])); %Uprava kontrastu obrazu
obr_G= wtdenoise(obr_G); % filtrovanie obrazu vlnkovou transformaciou
imshow(obr_G)
%% Inpaiting - rekonstrukcia vyrazne poskodenych pixlov 
Pom=obr_G;
Pom(SUM==1)=nan;% Funkcia vyzaduje nan hodnoty
B=inpaint_nans(Pom,4);
clear Pom
%% Binarizace obrazu
figure
imshowpair(C,B,'montage')
title('Uspesnost inpaint')

% Adaptivna segmentacia obrazu - Bradley local image thresholding
[Vysledok] = averagefilter(B);

 % Morfologicke upravy a odstranenie drobneho sumu v bielych aj sedotonovych obrazoch
 Vysledok2=imclose(Vysledok,strel('disk',2)); 
 Vysledok2=imcomplement(imclose(imcomplement(Vysledok2),strel('disk',2)));
 Vysledok3=imopen(Vysledok2,strel('disk',3)); 
 Vysledok3=imcomplement(imopen(imcomplement(Vysledok3),strel('disk',3))); 
 
 P=600; % 
 CC1 = bwconncomp(Vysledok3); 
 S1=regionprops(CC1,'Area');      
 L1=labelmatrix(CC1);             
 Vysledok4=ismember(L1,find([S1.Area]>=P));
 
 CC2 = bwconncomp(imcomplement(Vysledok4));
 S2=regionprops(CC2,'Area');
 L2=labelmatrix(CC2);
 Vysledok4=imcomplement(ismember(L2,find([S2.Area]>P)));

 %% Symetria obrazu - najdenie stredu obrazu
[ center ] = find_symetry(Vysledok4,zvacsenie);
%% Hranova detekcia a uprava hranovej detekcie
BW=edge(Vysledok4,'Canny');
N=2;
kernel = ones(N, N, N) / N^3;
blurryImage = convn(BW, kernel, 'same');
ims = blurryImage > 0.15; % Rozmazanie hran aby sa nam spojili
BW=bwareaopen(BW,250); % nechceme prilis male hrany
%% Prva metoda
% Rozmeriavanie kruznic na zaklade hranovej detekcie
[polomer] = HT3_for_CC(BW,center,zvacsenie);
[ lambda2 ] = vlndelka2( polomer,meritko );
figure
imshow(BW,[])
viscircles(repmat([center(2),center(1)],length(polomer),1),polomer);
hold on
plot(center(2,1), center(1,1), 'r*', 'LineWidth', 2, 'MarkerSize', 15);

% Rozdelenie polomerov na biele a cierne a kontrola hodnot
diff(polomer)

%% Druha metoda
grayImage=Vysledok;
[averageRadialProfile] = averageRProfile(grayImage,center);

%%VYHLAZENI SIGNALU
% 
if zvacsenie==4
    windowSize =15;
    minV=15;
  
else
    windowSize =25;
    b = (1/windowSize)*ones(1,windowSize);
    a = 1;
    yps = filter(b,a,averageRadialProfile);
    figure
    plot(yps)
    averageRadialProfile=yps;
    minV=25;
 end


% Urceni prahu pro detekci piku
prah=median(averageRadialProfile);
% Detekce maxim - bile krouzky
[pks,locs]=findpeaks(averageRadialProfile,'MinPeakHeight',prah,'MinPeakDistance',minV,'MinPeakProminence',0.1,'WidthReference','halfheight');
% Koeficient pro centrovani kruznic, vymazani kruznic mensich jako 100 pixelu
locs2=0.96*locs;
locs2=locs2(find(locs2>100));

figure
imshow(grayImage,[])
viscircles(repmat([center(2),center(1)],length(locs2),1),locs2);
hold on
plot(center(2,1), center(1,1), 'r*', 'LineWidth', 2, 'MarkerSize', 15);
title('Detekce kruznic -2. metoda')


[lambda1] = vlndelka1( locs2,meritko);

disp(lambda1); disp(lambda2);