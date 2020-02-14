function [lambda] = vlndelka1( locs4,meritko )
% funkce pro vypocteni vlnove delky

%prepocet polomeru na nanometry
locs4=locs4./meritko.*10000;

%prepocet polomeru krivosti na nm
R=30900000;

%vypocet vice hodnot vlnovych delek z detekovanych polomeru
for i = 1:6
    lambdy(i)=((locs4(i+1))^2-(locs4(i))^2)/R;
end

%zprumerovani vypoctenych hodnot vlnovych delek
%pro brani v uvahu vice nadetekovanych hodnot polomeru
lambda=mean(lambdy);

end

