function [ smoothMask contoursImg ] = smoothShadowMask( I, mask )

s = size(mask,1) * size(mask,2);
%morphological close operation is a dilation followed by an erosion, using the same structuring element for both operations.
smoothMask = imclose(mask, strel('disk',5));
smallObjectsSizePercents = 2;
P = round(s*smallObjectsSizePercents/100);
%removes all connected components that have fewer than P pixels from the binary image,
%producing another binary image.
mask = bwareaopen(mask, P);
%computes the complement of the image
mask = imcomplement(mask);
mask = bwareaopen(mask, P);
mask = imcomplement(mask);
smoothMask = imclose(mask, strel('disk',5));

contoursImg = I;
 %Calculate boundaries of regions in smoothMask
B = bwboundaries(smoothMask,8,'holes');
for i=1:length(B)
   for j=1:length(B{i})
       contoursImg(B{i}(j,1),B{i}(j,2),1) = 255;
       contoursImg(B{i}(j,1),B{i}(j,2),2) = 0;
       contoursImg(B{i}(j,1),B{i}(j,2),3) = 0;
   end
end

end

