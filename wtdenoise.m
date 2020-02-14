function [c] = wtdenoise(b)
% image denoising based wavelet transform
% Stiahnute z https://www.mathworks.com/matlabcentral/fileexchange/57493-image-denoising-based-wavelet-transform
% Upravene Kristina Olesova 26.04.2019
th='s';


[a1,b1,c1,d1]=dwt2(b,'bior4.4'); 
imshow(b1)
[a2,b2,c2,d2]=dwt2(a1,'bior4.4');
[a3,b3,c3,d3]=dwt2(a2,'bior4.4');


v1=(median(abs(b3(:)))/0.6745);
b3= wthresh(b3,th,v1);
v2=(median(abs(c3(:)))/0.6745);
c3= wthresh(c3,th,v2);
v3=(median(abs(d3(:)))/0.6745);
d3= wthresh(d3,th,v3);


v1=(median(abs(b2(:)))/0.6745);
b2= wthresh(b2,th,v1);
v2=(median(abs(c2(:)))/0.6745);
c2= wthresh(c2,th,v2);
v3=(median(abs(d2(:)))/0.6745);
d2= wthresh(d2,th,v3);

v1=(median(abs(b1(:)))/0.6745);
b1= wthresh(b1,th,v1);
v2=(median(abs(c1(:)))/0.6745);
c1= wthresh(c1,th,v2);
v3=(median(abs(d1(:)))/0.6745);
d1= wthresh(d1,th,v3);

a2=idwt2(a3,b3,c3,d3,'bior4.4');
a1=idwt2(a2,b2,c2,d2,'bior4.4');
[r,s]=size(b1);
c=idwt2(a1(1:r,1:s),b1,c1,d1,'bior4.4');



figure(1)
imshow(b,[])
figure(2);imshow(c,[])
end
 
 
 
 