function [averageRadialProfile] = averageRProfile(ImageG,center)
% Find the average radial profile of an image from a center location specified by the user.
% Pouzito z Mathworks
% Image Analyst
% https://www.mathworks.com/matlabcentral/answers/266546-radial-averaging-of-2-d-tif-image#answer_208541
%% Zacatek funkce
format long g;
format compact;
fontSize = 20;
[rows, columns, numberOfColorChannels] = size(ImageG);
x=center(2,1);
y=center(1,1);

% Find out what the max distance will be by computing the distance to each corner.
distanceToUL = sqrt((1-y)^2 + (1-x)^2)
distanceToUR = sqrt((1-y)^2 + (columns-x)^2)
distanceToLL = sqrt((rows-y)^2 + (1-x)^2)
distanceToLR= sqrt((rows-y)^2 + (columns-x)^2)
maxDistance = ceil(max([distanceToUL, distanceToUR, distanceToLL, distanceToLR]))

% Allocate an array for the profile
profileSums = zeros(1, maxDistance);
profileCounts = zeros(1, maxDistance);
% Scan the original image getting gray level, and scan edtImage getting distance.
% Then add those values to the profile.
for column = 1 : columns
	for row = 1 : rows
		thisDistance = round(sqrt((row-y)^2 + (column-x)^2));
		if thisDistance <= 0
			continue;
		end
		profileSums(thisDistance) = profileSums(thisDistance) + double(ImageG(row, column));
		profileCounts(thisDistance) = profileCounts(thisDistance) + 1;
	end
end
% Divide the sums by the counts at each distance to get the average profile
averageRadialProfile = profileSums ./ profileCounts;
% % Plot it.
% figure
% plot(1:length(averageRadialProfile), averageRadialProfile, 'b-', 'LineWidth', 3);
% grid on;
% title('Average Radial Profile', 'FontSize', fontSize);
% xlabel('Distance from center', 'FontSize', fontSize);
% ylabel('Average Gray Level', 'FontSize', fontSize);

%% Odstraneni Nan hodnot
pom=isnan(averageRadialProfile);
poz=find(pom==1);
averageRadialProfile(poz)=[];
