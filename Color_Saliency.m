function [SUM] = Color_Saliency( RGB_image )
% Tato funkcia nam v obraze najde vyrazne sumove pixle a vytvoru masku,
% ktora by mala sluzit na ich odstranenie. 
[r1,s1,d]=size(RGB_image);
pixle=r1*s1;

%% Vypocet kanalovej informacie
r=RGB_image(:,:,1)-(RGB_image(:,:,2)+RGB_image(:,:,3))/2;
g=RGB_image(:,:,2)-(RGB_image(:,:,1)+RGB_image(:,:,3))/2;
b=RGB_image(:,:,3)-(RGB_image(:,:,2)+RGB_image(:,:,1))/2;

SR=(r-(sum(sum(r))/(r1*s1))).^2;   
SG=(g-(sum(sum(g))/(r1*s1))).^2;
SB=(b-(sum(sum(b))/(r1*s1))).^2;

% vypocet color saliency
Gray_image=SR+SG+SB;

SUM=zeros(r1,s1);
prah=0.05;
SUM(Gray_image>prah)=1;
see = strel('disk',3);
SUM=imdilate(SUM,see);
pom=sum(sum(SUM)); %pocet poskodenych pixlov

while pom/pixle>0.05 % v ziadnom pripade nechceme, sumova maska pokryvala viac ako 5 % obrazu
    SUM=zeros(r1,s1);
    prah=prah+0.01;
    SUM(Gray_image>prah)=1;
    SUM=imdilate(SUM,see);
   pom=sum(sum(SUM)); 
end



end

