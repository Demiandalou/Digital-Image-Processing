close all; 
clear all; 
clc; 

original = imread('Notebook1.jpg'); 
imshow(original); 
title('Base image'); 

% distorted = imresize(original,0.7); 
% distorted = imrotate(distorted,31); 
distorted = imread('Notebook2.jpg'); 
figure; 
imshow(distorted); 
title('Transformed image'); 
% Extract surf key points
ptsOriginal = detectSURFFeatures(original); 
ptsDistorted = detectSURFFeatures(distorted); 
figure;imshow(original); hold on;
plot(ptsOriginal);
figure;imshow(distorted); hold on;
plot(ptsOriginal);
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
tform
% tform.Dimensionality
% 2
% tform.T
% [   0.4853   -0.7969         0
%     0.7969    0.4853         0
%   -87.5517  301.3816    1.0000]



% inlierPtsDistorted
%inlierPtsDistorted.Scale
%col vec:[4.2667;4.2667; 2.6667; 6.0000; 11.7333; 1.8667; 2.1333]
% inlierPtsDistorted.SignOfLaplacian
% [-1;-1;1;-1;1;1;1]
% inlierPtsDistorted.Orientation
% [2.8979;2.9714;0.1263;2.9914;1.2557;2.8961;2.9779]
% inlierPtsDistorted.Location
%   [213.8071  404.6144
%    311.3424  223.6629
%    279.1935  275.9780
%    305.7845  227.1145
%    106.9696  403.1396
%    224.9080  409.9477
%    229.0565  390.4977]
% inlierPtsDistorted.Metric
% 1.0e+03 *[6.5192;5.1343;6.3238;5.2421;3.2432;1.8768;1.3427]
% inlierPtsDistorted.Count
% 7
% inlierPtsOriginal
[tform_project,inlierPtsDistorted,inlierPtsOriginal] = estimateGeometricTransform(matchedPtsDistorted,matchedPtsOriginal,'similarity');
figure;
showMatchedFeatures(original,distorted,inlierPtsOriginal,inlierPtsDistorted); 
title('Matched inlier points'); 

%Compute the estimated registration result
outputView = imref2d(size(original)); 
Ir = imwarp(distorted,tform,'OutputView',outputView); 
figure; 
title('Recovered image');
imshow(Ir); 
