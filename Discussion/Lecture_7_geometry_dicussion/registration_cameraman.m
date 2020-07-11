close all; 
clear all; 
clc; 

original = imread('cameraman.tif'); 
imshow(original); 
title('Base image'); 

distorted = imresize(original,0.7); 
distorted = imrotate(distorted,31); 

figure; 
imshow(distorted); 
title('Transformed image'); 
% Extract surf key points
ptsOriginal = detectSURFFeatures(original); 
ptsDistorted = detectSURFFeatures(distorted); 
figure;imshow(original); hold on;
plot(ptsOriginal.selectStrongest(50));
figure;imshow(distorted); hold on;
plot(ptsOriginal.selectStrongest(50));
% Generate descriptive features
[featuresOriginal,validPtsOriginal] = extractFeatures(original,ptsOriginal); 
[featuresDistorted,validPtsDistorted] = extractFeatures(distorted,ptsDistorted);
% Descriptive feature matching
index_pairs = matchFeatures(featuresOriginal,featuresDistorted); 

% Matched key points
matchedPtsOriginal = validPtsOriginal(index_pairs(:,1)); 
matchedPtsDistorted = validPtsDistorted(index_pairs(:,2)); 

%Show matching points
figure;
showMatchedFeatures(original,distorted,matchedPtsOriginal,matchedPtsDistorted);
title('Matched SURF points, including outliers'); 

%Estimate geographic transform matrix
[tform,inlierPtsDistorted,inlierPtsOriginal] = estimateGeometricTransform(matchedPtsDistorted,matchedPtsOriginal,'similarity'); 
figure;
showMatchedFeatures(original,distorted,inlierPtsOriginal,inlierPtsDistorted); 
title('Matched inlier points'); 

%·´±ä»»Í¼Ïñ 
outputView = imref2d(size(original)); 
Ir = imwarp(distorted,tform,'OutputView',outputView); 
figure; 
imshow(Ir); 
title('Recovered image'); 