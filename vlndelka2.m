function [ lambda ] = vlndelka2( polomer,meritko )
% funkce pro vypocteni vlnove delky pro metodu 2

%prepocet polomeru na nanometry
polomer=polomer./meritko.*10000;

%prepocet polomeru krivosti na nm
R=30900000;

%vypocet vlnove delky
lambda=mean([((polomer(4))^2-(polomer(2))^2)/R,((polomer(3))^2-(polomer(1))^2)/R]);
end